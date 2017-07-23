//
//  Source+CoreDataProperties.m
//  vk
//
//  Created by Dennis Burdin on 23.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import "Source+CoreDataProperties.h"

@implementation Source (CoreDataProperties)

+ (NSFetchRequest<Source *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Source"];
}

@dynamic id;
@dynamic name;
@dynamic source_id;
@dynamic sourcePosts;

@end
