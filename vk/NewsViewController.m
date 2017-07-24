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
#import "PostDetailsViewController.h"
#import "DataManager.h"
#import "VKWrapper.h"
#import "VKPost.h"
#import "VKSource.h"
#import <UIImageView+WebCache.h>

@interface NewsViewController ()
{
    NSMutableDictionary *_posts;    // key = md5Hash; value = VKPost instance
    NSMutableDictionary *_sources;  // key = source_id; value = VKSource instance
}

@end

@implementation NewsViewController

static NSArray *labels = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _posts = [NSMutableDictionary new];
    _sources = [NSMutableDictionary new];
    
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
            if (!error) {
                [[DataManager sharedManager] replicatePostsFromArray:posts];
                [[DataManager sharedManager] replicateSourcesFromArray:sources];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf handleResponse:posts andSources:sources error:error];
                    // Finish infinite scroll animations
                    [[UIApplication sharedApplication] stopNetworkActivity];
                    [tableView finishInfiniteScroll];
                });
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:error.description
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                
                // read from db
                NSArray* cashedPosts = [[DataManager sharedManager] getPosts];
                NSArray* cashedSources = [[DataManager sharedManager] getSources];
                [weakSelf handleResponse:cashedPosts andSources:cashedSources error:error];
            }
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

- (void)handleResponse:(NSArray *)posts andSources:(NSArray*)sources error:(NSError *)error {
    // update table view
    for (VKPost *vkPost in posts) {
        [_posts setObject:vkPost forKey:[vkPost md5Hash]];
    }

    for (VKSource *vkSource in sources) {
        [_sources setObject:vkSource forKey:@(fabs(vkSource.source_id))];
    }

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
    return _posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PostTableViewCell *cell = (PostTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"postTableViewCell" forIndexPath:indexPath];
    
    // text
    CGSize szMaxLabel = CGSizeMake (cell.frame.size.width - cell.lblContent.frame.origin.x, 1000);
    VKPost* post = (VKPost*)[[_posts allValues] objectAtIndex:indexPath.row];
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
    for (VKSource* source in [_sources allValues]) {
        if (source.source_id == fabs(post.source_id)) {
            cell.lblAuthor.text = source.name;
            
            // avatar
            [cell.imageViewAvatar sd_setImageWithURL:[NSURL URLWithString:source.photo_url]
                         placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            break;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VKPost* post = (VKPost*)[[_posts allValues] objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"toPostDetails" sender:post];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toPostDetails"]) {
        PostDetailsViewController *details = [segue destinationViewController];
        details.post = (VKPost*)sender;
    }
}

@end
