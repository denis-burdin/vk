//
//  PostTableViewCell.m
//  vk
//
//  Created by Dennis Burdin on 20.07.17.
//  Copyright © 2017 dbulabs. All rights reserved.
//

#import "PostTableViewCell.h"

@implementation PostTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.imageViewPhoto setContentMode:UIViewContentModeScaleAspectFit];
}

@end
