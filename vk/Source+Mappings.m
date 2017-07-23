//
//  Source+Mappings.m
//  vk
//
//  Created by Dennis Burdin on 22.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import "Source+Mappings.h"

@implementation Source (Mappings)

+ (NSString *)primaryKey {
    return @"id";
}


+ (NSDictionary *)mappings {
    return @{
             @"id"          : [self primaryKey],
             @"name"        : @"name",
             @"source_id"   : @"source_id",
             };
}

@end
