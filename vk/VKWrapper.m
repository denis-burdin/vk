//
//  VKWrapper.m
//  vk
//
//  Created by Dennis Burdin on 18.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import "VKWrapper.h"
#import "VKPost.h"
#import "VKSource.h"
#import <VKSdk.h>

static NSString* const APP_ID = @"6118016";

@interface VKWrapper()
{
    NSString* _next_from;
}

@end

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

- (void)receivePosts:(void(^)(NSArray *posts, NSArray* sources, NSError *error))completion {
    VKRequest* request = [VKRequest requestWithMethod:@"newsfeed.get" parameters:@{@"filters" : @"post", @"return_banned" : @0, @"count" : @20, @"start_from" : _next_from ?: @""} modelClass:[VKUsersArray class]];
    request.debugTiming = YES;
    request.requestTimeout = 10;
    
    [request executeWithResultBlock:^(VKResponse *response) {
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        
        _next_from = [[json valueForKey:@"response"] valueForKey:@"next_from"];
        NSArray *items = [[json valueForKey:@"response"] valueForKey:@"items"];
        NSMutableArray *posts = [NSMutableArray new];
        for (NSDictionary* item in items) {
            NSString* content = [item objectForKey:@"text"];
            if (content.length > 0 && [item objectForKey:@"date"]) {
                double dtPost = [[item objectForKey:@"date"] doubleValue];
                VKPost *post = [VKPost new];
                post.date = [NSDate dateWithTimeIntervalSince1970:dtPost];
                post.content = content;
                post.source_id = [[item objectForKey:@"source_id"] doubleValue];
                [posts addObject:post];
            }
        }

        NSMutableArray *sources = [NSMutableArray new];
        NSArray* groups = [[json valueForKey:@"response"] valueForKey:@"groups"];
        for (NSDictionary* group in groups) {
            NSString* name = [group objectForKey:@"name"];
            if (name.length > 0 && [group objectForKey:@"id"]) {
                double source_id = [[group objectForKey:@"id"] doubleValue];
                VKSource *source = [VKSource new];
                source.source_id = source_id;
                source.name = [group objectForKey:@"name"];
                source.photo_url = [group objectForKey:@"photo_200"];
                [sources addObject:source];
            }
        }

        if (posts.count) {
            NSArray *sortedPosts = [posts sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSDate* first = [(VKPost*)obj1 date];
                NSDate* second = [(VKPost*)obj2 date];
                return [first compare:second] == NSOrderedAscending;
            }];
            
            completion(sortedPosts, sources, nil);
        }
    } errorBlock:^(NSError *error) {
        completion(nil, nil, error);
    }];
}

@end
