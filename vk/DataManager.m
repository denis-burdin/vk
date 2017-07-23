//
//  DataManager.m
//  vk
//
//  Created by Dennis Burdin on 23.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import "DataManager.h"
#import "NSString+MD5.h"
#import "VKPost.h"
#import "Post+Mappings.h"
#import <ObjectiveRecord.h>
#import	<CommonCrypto/CommonDigest.h>

@implementation DataManager

+ (instancetype)sharedManager {
    static DataManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
    });
    return manager;
}

- (void)replicatePostsFromArray:(NSArray*)posts {
    
    for (VKPost* post in posts) {
        NSDateFormatter* f = [NSDateFormatter new];
        [f setFormatterBehavior:NSDateFormatterBehavior10_4];
        [f setLocale:[NSLocale currentLocale]];
        [f setDateStyle:NSDateFormatterMediumStyle];
        [f setTimeStyle:NSDateFormatterShortStyle];
        NSString* dateString = [f stringFromDate:post.date];

        NSString* stringToHash = [NSString stringWithFormat:@"date: %@; content: %@; source_id: %f", dateString, post.content, fabs(post.source_id)];
        NSString* md5Hash = [stringToHash MD5String];

        Post *dbPost = [Post findOrCreate:@{[Post primaryKey] : md5Hash}];
        if (dbPost.content.length == 0) {
            dbPost.content = post.content;
            dbPost.date = post.date;
            dbPost.source_id = post.source_id;
        }
    }
    
    [CoreDataManager.sharedManager saveContext];
}

@end
