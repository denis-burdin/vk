//
//  VKSource.h
//  vk
//
//  Created by Dennis Burdin on 21.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import <Foundation/Foundation.h>

// can be community or user
@interface VKSource : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) double source_id;

@end
