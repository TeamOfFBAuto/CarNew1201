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

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.bigImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, 214)];
        
    }
    return self;
}

//根据实际宽度等比例调整高度
- (CGFloat)height:(CGFloat)oldHeight
{
    return 0;
}

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
    [self.smallImageView sd_setImageWithURL:[NSURL URLWithString:aModel.spichead] placeholderImage:nil];
    
    self.smallImageView.layer.masksToBounds = YES;
    self.smallImageView.layer.cornerRadius = self.smallImageView.width / 2.f;
}

@end
