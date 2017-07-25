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

//    CGSize szMaxLabel = CGSizeMake (self.frame.size.width - self.lblContent.frame.origin.x, 1000);
//    CGRect expectedLabelSize = [self.lblContent.text boundingRectWithSize:szMaxLabel options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName:self.lblContent.font } context:nil];
//    [self.lblContent setFrame:CGRectMake(self.lblContent.frame.origin.x, self.lblContent.frame.origin.y, expectedLabelSize.size.width, expectedLabelSize.size.height)];

    [self.imageViewPhoto setContentMode:UIViewContentModeScaleAspectFit];
}

@end
