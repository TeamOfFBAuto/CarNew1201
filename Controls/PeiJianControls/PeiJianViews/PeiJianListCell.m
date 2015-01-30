//
//  PeiJianListCell.m
//  CustomNewProject
//
//  Created by soulnear on 15-1-29.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "PeiJianListCell.h"

@implementation PeiJianListCell

- (void)awakeFromNib {
    // Initialization code
    _line_view.width = DEVICE_WIDTH - 20;
    _line_view.top = 90-0.5;
    
    
    _header_imageView.layer.masksToBounds = YES;
    _header_imageView.layer.borderColor = RGBCOLOR(193,193,193).CGColor;
    _header_imageView.layer.borderWidth = 0.5;
    
    _title_label.numberOfLines = 0;
    _title_label.width = DEVICE_WIDTH-15-_title_label.left;
}



-(void)setInfoWithModel:(PeiJianListModel *)model
{
    [_header_imageView sd_setImageWithURL:[NSURL URLWithString:model.pichead] placeholderImage:[UIImage imageNamed:@"peijian_default_image"]];
    _title_label.text = model.title;
    _price_label.text = [NSString stringWithFormat:@"￥%@",model.price];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
