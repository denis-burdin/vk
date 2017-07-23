//
//  Post+Mappings.m
//  vk
//
//  Created by Dennis Burdin on 22.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import "Post+Mappings.h"

@implementation Post (Mappings)

+ (NSString *)primaryKey {
    return @"post_hash";
}


+ (NSDictionary *)mappings {
    return @{
             @"post_hash"   : [self primaryKey],
             @"content"     : @"content",
             @"date"        : @"date",
             @"source_id"   : @"source_id",
             };
}

@end
