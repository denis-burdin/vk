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
#import "VKSource.h"

@interface NewsViewController ()
{
    NSMutableArray *_tableData;
    NSArray *_sources;
}

@end

@implementation NewsViewController

static NSArray *labels = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableData = [NSMutableArray new];
    [self vk_registerAllNibsWithTableView:self.tableView];

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
    
    // set autolayout
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 88.0;
    
    __weak typeof(self) weakSelf = self;
    // Add infinite scroll handler
    [self.tableView addInfiniteScrollWithHandler:^(UITableView *tableView) {
        [[VKWrapper sharedInstance] receivePosts:^(NSArray *posts, NSArray* sources, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf handleResponse:posts andSources:sources error:error];
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

- (void)handleResponse:(NSArray *)data andSources:(NSArray*)sources error:(NSError *)error {
    // update table view
    [_tableData addObjectsFromArray:data];
    _sources = sources;
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
    
    // text
    CGSize szMaxLabel = CGSizeMake (cell.frame.size.width - cell.lblContent.frame.origin.x, 1000);
    VKPost* post = (VKPost*)[_tableData objectAtIndex:indexPath.row];
    NSString *content = [post content];
    CGRect expectedLabelSize = [content boundingRectWithSize:szMaxLabel options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:cell.lblContent.font } context:nil];
    cell.lblContent.text = content;
    [cell.lblContent setFrame:CGRectMake(cell.lblContent.frame.origin.x, cell.lblContent.frame.origin.y, expectedLabelSize.size.width, expectedLabelSize.size.height)];
    
    // date
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setFormatterBehavior:NSDateFormatterBehavior10_4];
    [f setLocale:[NSLocale currentLocale]];
    [f setDateStyle:NSDateFormatterMediumStyle];
    [f setTimeStyle:NSDateFormatterShortStyle];
    cell.lblDate.text = [f stringFromDate:post.date];

    // author
    for (VKSource* source in _sources) {
        if (source.source_id == fabs(post.source_id)) {
            cell.lblAuthor.text = source.name;
            break;
        }
    }
    
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
