//
//  ApiCallViewController.h
//  vk
//
//  Created by Dennis Burdin on 19.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <VKSdk.h>

@interface ApiCallViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *methodName;
@property (weak, nonatomic) IBOutlet UITextView *callResult;
@property(nonatomic, strong) VKRequest *callingRequest;

@end

