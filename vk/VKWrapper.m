//
//  VKWrapper.m
//  vk
//
//  Created by Dennis Burdin on 18.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import "VKWrapper.h"
#import "VKPost.h"
#import <VKSdk.h>

static NSString* const APP_ID = @"6118016";

@interface VKWrapper()
{
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

- (void)receivePosts:(void(^)(NSArray *posts, NSError *error))completion {
    VKRequest* request = [VKRequest requestWithMethod:@"newsfeed.get" parameters:@{@"filters" : @"post", @"return_banned" : @0, @"count" : @20} modelClass:[VKUsersArray class]];
    request.debugTiming = YES;
    request.requestTimeout = 10;
    
    [request executeWithResultBlock:^(VKResponse *response) {
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[response.responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        
        NSArray *items = [[json valueForKey:@"response"] valueForKey:@"items"];
        NSMutableArray *posts = [NSMutableArray new];
        for (NSDictionary* item in items) {
            NSString* content = [item objectForKey:@"text"];
            if (content.length > 0 && [item objectForKey:@"date"]) {
                double dtPost = [[item objectForKey:@"date"] doubleValue];
                VKPost *post = [VKPost new];
                post.date = [NSDate dateWithTimeIntervalSince1970:dtPost];
                post.content = content;
                [posts addObject:post];
            }
        }
        
        if (posts.count) {
            NSArray *sortedPosts = [posts sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                NSDate* first = [(VKPost*)obj1 date];
                NSDate* second = [(VKPost*)obj2 date];
                return [first compare:second] == NSOrderedAscending;
            }];
            
            completion(sortedPosts, nil);
        }
    } errorBlock:^(NSError *error) {
        completion(nil, error);
    }];
}

@end
