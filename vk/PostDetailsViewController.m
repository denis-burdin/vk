//
//  PostDetailsViewController.m
//  vk
//
//  Created by Dennis Burdin on 22.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import "PostDetailsViewController.h"
#import "VKPost.h"
#import <ObjectiveRecord.h>
#import "Post+Mappings.h"

@interface PostDetailsViewController ()

@end

@implementation PostDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textViewContent.text = self.post.content;
    
    Post *post = [Post findOrCreate:@{[Post primaryKey] : @(1)}];
    NSLog(@"%@", post.content);
    post.content = @"Hello World!";
    [CoreDataManager.sharedManager saveContext];
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
