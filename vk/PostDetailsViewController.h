//
//  PostDetailsViewController.h
//  vk
//
//  Created by Dennis Burdin on 22.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VKPost;

@interface PostDetailsViewController : UIViewController

@property (nonatomic, strong) VKPost* post;
@property (weak, nonatomic) IBOutlet UITextView *textViewContent;

@end
