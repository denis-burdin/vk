//
//  Source+CoreDataProperties.h
//  vk
//
//  Created by Dennis Burdin on 23.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import "Source+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Source (CoreDataProperties)

+ (NSFetchRequest<Source *> *)fetchRequest;

@property (nonatomic) int64_t id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) int64_t source_id;
@property (nullable, nonatomic, retain) Post *sourcePosts;

@end

NS_ASSUME_NONNULL_END
