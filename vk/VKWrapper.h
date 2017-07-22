//
//  VKWrapper.h
//  vk
//
//  Created by Dennis Burdin on 18.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKWrapper : NSObject

+ (instancetype)sharedInstance;
- (void)receivePosts:(void(^)(NSArray *posts, NSArray* sources, NSError *error))completion;

@end
