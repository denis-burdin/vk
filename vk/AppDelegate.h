//
//  AppDelegate.h
//  vk
//
//  Created by Dennis Burdin on 18.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

