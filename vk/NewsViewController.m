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
#import <GCNetworkReachability.h>

@interface NewsViewController ()
{
    NSMutableArray *_posts;   // key = md5Hash
    NSMutableArray *_sources; // key = source_id
}

@end

@implementation NewsViewController

static NSArray *labels = nil;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _posts = [NSMutableArray new];
    _sources = [NSMutableArray new];
    
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
    
    GCNetworkReachability *reachability = [GCNetworkReachability reachabilityForInternetConnection];
    __weak typeof(self) weakSelf = self;
    
    if ([reachability isReachable])
    {
        // do stuff that requires an internet connection…
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
                }
            }];
        }];
        
        // Load initial data
        [self.tableView beginInfiniteScroll:YES];
        [[UIApplication sharedApplication] startNetworkActivity];
    } else {
        // read from db
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Please check your internet connection, you could see cached data only"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];

        NSArray* cashedPosts = [[DataManager sharedManager] getPosts];
        NSArray* cashedSources = [[DataManager sharedManager] getSources];
        [weakSelf handleResponse:cashedPosts andSources:cashedSources error:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleResponse:(NSArray *)posts andSources:(NSArray*)sources error:(NSError *)error {

    // update table view
    NSInteger initialPostsCount = [_posts count];
    for (VKPost *vkPostNew in posts) {
        BOOL presented = NO;
        for (VKPost *vkPostOld in _posts) {
            if ([vkPostNew.md5Hash isEqualToString:vkPostOld.md5Hash]) {
                presented = YES;
                break;
            }
        }
        
        if (!presented) {
            [_posts addObject:vkPostNew];
        }
    }

    for (VKSource *vkSourceNew in sources) {
        BOOL presented = NO;
        for (VKSource *vkSourceOld in _sources) {
            if (fabs(vkSourceNew.source_id) == fabs(vkSourceOld.source_id)) {
                presented = YES;
                break;
            }
        }
        
        if (!presented) {
            [_sources addObject:vkSourceNew];
        }
    }

    if ([[GCNetworkReachability reachabilityForInternetConnection] isReachable]) {
        NSIndexSet *newIndexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(initialPostsCount, _posts.count - initialPostsCount)];
        NSMutableArray *newIndexPaths = [NSMutableArray new];

        [newIndexes enumerateIndexesUsingBlock:^(NSUInteger idx, __unused BOOL *stop) {
            [newIndexPaths addObject:[NSIndexPath indexPathForRow:idx inSection:0]];
        }];

        // update table view
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:newIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    } else {
        [self.tableView reloadData];
    }
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
    VKPost* post = (VKPost*)[_posts objectAtIndex:indexPath.row];
    NSString *content = [post content];
    cell.lblContent.text = content;
    
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
            post.author = source.name;
            
            // avatar
            post.authorImageURL = source.photo_url;
            if (source.photo_url.length) {
                [cell.imageViewAvatar sd_setImageWithURL:[NSURL URLWithString:source.photo_url]
                         placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            } else {
                [cell.imageViewAvatar setImage:[UIImage imageNamed:@"placeholder.png"]];
            }

            break;
        }
    }

    // photo
    if (post.photo_url.length) {
        [cell.imageViewPhoto sd_setImageWithURL:[NSURL URLWithString:post.photo_url]
                           placeholderImage:[UIImage imageNamed:@"placeholder_post.png"]];
    } else {
        [cell.imageViewPhoto setImage:[UIImage imageNamed:@"placeholder_post.png"]];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    VKPost* post = (VKPost*)[_posts objectAtIndex:indexPath.row];
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
