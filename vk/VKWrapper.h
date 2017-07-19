//
//  VKWrapper.h
//  vk
//
//  Created by Dennis Burdin on 18.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VKSdk.h>

@interface VKWrapper : NSObject<VKSdkDelegate>

    @property (nonatomic, strong) VKSdk *sdkInstance;

    - (void)initialize;
    + (instancetype)sharedInstance;
    - (void)signIn;
    
@end
