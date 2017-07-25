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
    return @"identificator";
}


+ (NSDictionary *)mappings {
    return @{
             @"identificator" : [self primaryKey],
             @"content"       : @"content",
             @"date"          : @"date",
             @"source_id"     : @"source_id",
             @"photo_url"     : @"photo_url",
             };
}

@end
