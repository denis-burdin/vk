//
//  Post+CoreDataProperties.m
//  vk
//
//  Created by Dennis Burdin on 23.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import "Post+CoreDataProperties.h"

@implementation Post (CoreDataProperties)

+ (NSFetchRequest<Post *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Post"];
}

@dynamic content;
@dynamic date;
@dynamic id;
@dynamic source_id;
@dynamic source;

@end
