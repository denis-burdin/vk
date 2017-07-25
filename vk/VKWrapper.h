//
//  VKWrapper.h
//  vk
//
//  Created by Dennis Burdin on 18.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString* const APP_ID = @"6118016";

@interface VKWrapper : NSObject

+ (instancetype)sharedInstance;
- (void)receivePosts:(void(^)(NSArray *posts, NSArray* sources, NSError *error))completion;

@end
