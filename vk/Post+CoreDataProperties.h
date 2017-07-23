//
//  Post+CoreDataProperties.h
//  vk
//
//  Created by Dennis Burdin on 23.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import "Post+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Post (CoreDataProperties)

+ (NSFetchRequest<Post *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *content;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nonatomic) int64_t id;
@property (nonatomic) int64_t source_id;
@property (nullable, nonatomic, retain) NSSet<Source *> *source;

@end

@interface Post (CoreDataGeneratedAccessors)

- (void)addSourceObject:(Source *)value;
- (void)removeSourceObject:(Source *)value;
- (void)addSource:(NSSet<Source *> *)values;
- (void)removeSource:(NSSet<Source *> *)values;

@end

NS_ASSUME_NONNULL_END
