//
//  DataManager.h
//  vk
//
//  Created by Dennis Burdin on 23.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (instancetype)sharedManager;

- (void)replicatePostsFromArray:(NSArray*)posts;
- (NSArray*)getPosts;

- (void)replicateSourcesFromArray:(NSArray*)sources;
- (NSArray*)getSources;


@end
