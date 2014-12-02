//
//  AnliViewCell.m
//  CustomNewProject
//
//  Created by lichaowei on 14/12/1.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "AnliViewCell.h"
#import "AnliModel.h"

@implementation AnliViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellWithModel:(AnliModel *)aModel
{
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:aModel.pichead] placeholderImage:nil];
    self.aTitleLabel.text = aModel.title;
    self.nameLabel.text = aModel.sname;
}

@end
