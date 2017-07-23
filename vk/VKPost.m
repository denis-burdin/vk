//
//  VKPost.m
//  vk
//
//  Created by Dennis Burdin on 20.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import "VKPost.h"
#import "NSString+MD5.h"

@implementation VKPost

- (NSString*)md5Hash {
    
    NSDateFormatter* f = [NSDateFormatter new];
    [f setFormatterBehavior:NSDateFormatterBehavior10_4];
    [f setLocale:[NSLocale currentLocale]];
    [f setDateStyle:NSDateFormatterMediumStyle];
    [f setTimeStyle:NSDateFormatterShortStyle];
    NSString* dateString = [f stringFromDate:self.date];
    
    NSString* stringToHash = [NSString stringWithFormat:@"date: %@; content: %@; source_id: %f", dateString, self.content, fabs(self.source_id)];
    
    return [stringToHash MD5String];
}

@end
