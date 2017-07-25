//
//  DataManager.m
//  vk
//
//  Created by Dennis Burdin on 23.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import "DataManager.h"
#import "VKPost.h"
#import "VKSource.h"
#import "Post+Mappings.h"
#import "Source+Mappings.h"
#import <ObjectiveRecord.h>

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
    
    for (VKPost* vkPost in posts) {
        Post *dbPost = [Post findOrCreate:@{[Post primaryKey] : [vkPost md5Hash]}];
        if (dbPost.content.length == 0) {
            dbPost.content = vkPost.content;
            dbPost.date = vkPost.date;
            dbPost.source_id = vkPost.source_id;
            dbPost.photo_url = vkPost.photo_url;
        }
    }

    [CoreDataManager.sharedManager saveContext];
}

- (NSArray*)getPosts {
    
    NSMutableArray *posts = [NSMutableArray new];
    for (Post *dbPost in [Post all]) {
        VKPost* vkPost = [VKPost new];
        vkPost.date = dbPost.date;
        vkPost.content = dbPost.content;
        vkPost.source_id = dbPost.source_id;
        vkPost.photo_url = dbPost.photo_url;
        [posts addObject:vkPost];
    }
    
    return posts;
}

- (void)replicateSourcesFromArray:(NSArray*)sources {
    
    for (VKSource* source in sources) {
        Source *dbSource = [Source findOrCreate:@{[Source primaryKey] : @(source.source_id)}];
        dbSource.name = source.name;
        dbSource.photo_url = source.photo_url;
    }

    [CoreDataManager.sharedManager saveContext];
}

- (NSArray*)getSources {
    
    NSMutableArray *sources = [NSMutableArray new];
    for (Source *dbSource in [Source all]) {
        VKSource* vkSource = [VKSource new];
        vkSource.name = dbSource.name;
        vkSource.source_id = dbSource.identificator;
        vkSource.photo_url = dbSource.photo_url;
        [sources addObject:vkSource];
    }
    
    return sources;
}

@end
