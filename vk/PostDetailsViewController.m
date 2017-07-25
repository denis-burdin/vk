//
//  PostDetailsViewController.m
//  vk
//
//  Created by Dennis Burdin on 22.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import "PostDetailsViewController.h"
#import "VKPost.h"
#import <UIImageView+WebCache.h>

@interface PostDetailsViewController ()

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textViewContent.text = self.post.content;

    // date
    NSDateFormatter* f = [[NSDateFormatter alloc] init];
    [f setFormatterBehavior:NSDateFormatterBehavior10_4];
    [f setLocale:[NSLocale currentLocale]];
    [f setDateStyle:NSDateFormatterMediumStyle];
    [f setTimeStyle:NSDateFormatterShortStyle];
    self.lblDate.text = [f stringFromDate:self.post.date];
    
    // author
    self.lblAuthor.text = self.post.author;
    if (self.post.authorImageURL.length) {
        [self.imageViewPhoto sd_setImageWithURL:[NSURL URLWithString:self.post.authorImageURL]
                               placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    } else {
        [self.imageViewPhoto setImage:[UIImage imageNamed:@"placeholder.png"]];
    }

    // photo
    if (self.post.photo_url.length) {
        [self.imageViewPhoto sd_setImageWithURL:[NSURL URLWithString:self.post.photo_url]
                               placeholderImage:[UIImage imageNamed:@"placeholder_post.png"]];
    } else {
        [self.imageViewPhoto setImage:[UIImage imageNamed:@"placeholder_post.png"]];
    }
}

-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self.imageViewPhoto setContentMode:UIViewContentModeScaleAspectFit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@""]) {
    }
}
*/

@end
