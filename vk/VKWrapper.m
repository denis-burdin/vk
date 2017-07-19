//
//  VKWrapper.m
//  vk
//
//  Created by Dennis Burdin on 18.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import "VKWrapper.h"

static NSString* const APP_ID = @"6118016";

@implementation VKWrapper

+ (instancetype)sharedInstance
{
    static VKWrapper *vkWrapper = nil;
    static dispatch_once_t predicate = 0;
    if (vkWrapper == nil) {
        dispatch_once(&predicate, ^{
            vkWrapper = [self new];
        });
    }
    return vkWrapper;
}

- (void)initialize {
    self.sdkInstance = [VKSdk initializeWithAppId:APP_ID];
    [self.sdkInstance registerDelegate:self];
}

- (void)signIn {
    NSArray *SCOPE = @[@"friends", @"email"];
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            // Authorized and ready to go
        } else if (error) {
            // Some error happend, but you may try later
            [VKSdk authorize:SCOPE];
        }
    }];
}
    
// VKSdkDelegate
- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    if (result.token) {
        // Пользователь успешно авторизован
    } else if (result.error) {
        // Пользователь отменил авторизацию или произошла ошибка
    }
    
    NSLog(@"");
}

- (void)vkSdkUserAuthorizationFailed {
    NSLog(@"vkSdkUserAuthorizationFailed");
}

@end
