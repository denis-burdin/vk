//
//  UIViewController+Utils.m
//  vk
//
//  Created by Dennis Burdin on 20.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import "UIViewController+Utils.h"

@implementation UIViewController (Utils)

-(void)vk_registerAllNibsWithTableView:(UITableView*)tableView {
    [tableView registerNib:[UINib nibWithNibName:@"PostTableViewCell" bundle:nil] forCellReuseIdentifier:@"postTableViewCell"];
}

@end
