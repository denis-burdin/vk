//
//  NewsViewController.m
//  vk
//
//  Created by Dennis Burdin on 19.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import "NewsViewController.h"
#import "UIViewController+Utils.h"
#import "PostTableViewCell.h"
#import "VKWrapper.h"
#import "VKPost.h"

@interface NewsViewController ()
{
    NSArray *_tableData;
}

@end

@implementation NewsViewController

static NSArray *labels = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self vk_registerAllNibsWithTableView:self.tableView];
    
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Выход" style:UIBarButtonItemStyleDone target:self action:@selector(logout:)];
    self.tableView.tableFooterView = [UIView new];

    [[VKWrapper sharedInstance] receivePosts:^(NSArray *posts, NSError *error) {
        _tableData = posts;
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
