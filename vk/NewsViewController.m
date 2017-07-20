//
//  NewsViewController.m
//  vk
//
//  Created by Dennis Burdin on 19.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import "NewsViewController.h"
#import "UIViewController+Utils.h"
#import "UIScrollView+InfiniteScroll.h"
#import "UIApplication+NetworkIndicator.h"
#import "CustomInfiniteIndicator.h"
#import "PostTableViewCell.h"
#import "VKWrapper.h"
#import "VKPost.h"

#define USE_AUTOSIZING_CELLS 1

@interface NewsViewController ()
{
    NSMutableArray *_tableData;
}

@end

@implementation NewsViewController

static NSArray *labels = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableData = [NSMutableArray new];
    [self vk_registerAllNibsWithTableView:self.tableView];

#if USE_AUTOSIZING_CELLS
    // enable auto-sizing cells on iOS 8
    if([self.tableView respondsToSelector:@selector(layoutMargins)]) {
        self.tableView.estimatedRowHeight = 88.0;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
#endif

    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Выход" style:UIBarButtonItemStyleDone target:self action:@selector(logout:)];
    self.tableView.tableFooterView = [UIView new];

    CGRect indicatorRect;
#if TARGET_OS_TV
    indicatorRect = CGRectMake(0, 0, 64, 64);
#else
    indicatorRect = CGRectMake(0, 0, 24, 24);
#endif

    CustomInfiniteIndicator *indicator = [[CustomInfiniteIndicator alloc] initWithFrame:indicatorRect];
    
    // Set custom indicator
    self.tableView.infiniteScrollIndicatorView = indicator;
    
    // Set custom indicator margin
    self.tableView.infiniteScrollIndicatorMargin = 40;
    
    // Set custom trigger offset
    self.tableView.infiniteScrollTriggerOffset = 500;
    
    __weak typeof(self) weakSelf = self;
    // Add infinite scroll handler
    [self.tableView addInfiniteScrollWithHandler:^(UITableView *tableView) {
        [[VKWrapper sharedInstance] receivePosts:^(NSArray *posts, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf handleResponse:posts error:error];
                // Finish infinite scroll animations
                [[UIApplication sharedApplication] stopNetworkActivity];
                [tableView finishInfiniteScroll];
            });
        }];
    }];
    
    // Load initial data
    [self.tableView beginInfiniteScroll:YES];
    [[UIApplication sharedApplication] startNetworkActivity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleResponse:(NSArray *)data error:(NSError *)error {
    // update table view
    [_tableData addObjectsFromArray:data];
    [self.tableView reloadData];
    
//    [self.tableView beginUpdates];
//    [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
//    [self.tableView endUpdates];
}

- (void)logout:(id)sender {
    [VKSdk forceLogout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostTableViewCell *cell = (PostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"postTableViewCell" forIndexPath:indexPath];
    cell.lblContent.text = [(VKPost*)[_tableData objectAtIndex:indexPath.row] content];

#if USE_AUTOSIZING_CELLS
    // enable auto-sizing cells on iOS 8
    if([tableView respondsToSelector:@selector(layoutMargins)]) {
        cell.lblContent.numberOfLines = 0;
    }
#endif

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
