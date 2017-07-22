//
//  PostTableViewCell.h
//  vk
//
//  Created by Dennis Burdin on 20.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTableViewCell : UITableViewCell <UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblAuthor;

@end
