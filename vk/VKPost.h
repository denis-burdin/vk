//
//  VKPost.h
//  vk
//
//  Created by Dennis Burdin on 20.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKPost : NSObject

@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) double source_id;
@property (nonatomic, strong) NSString *photo_url;

- (NSString*)md5Hash;

@end
