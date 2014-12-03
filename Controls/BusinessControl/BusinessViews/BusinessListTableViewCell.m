//
//  BusinessListTableViewCell.m
//  CustomNewProject
//
//  Created by soulnear on 14-12-2.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "BusinessListTableViewCell.h"

@implementation BusinessListTableViewCell

- (void)awakeFromNib {
    _header_imageView.layer.borderColor = RGBCOLOR(196,196,196).CGColor;
    _header_imageView.layer.borderWidth = 0.5;
}


-(void)setInfoWithModel:(BusinessListModel *)info
{
    _business_name_label.text = info.storename;
    [_header_imageView sd_setImageWithURL:[NSURL URLWithString:info.pichead] placeholderImage:nil];
    _comment_num_label.text = [NSString stringWithFormat:@"%@人评论",info.com_num];
    
    CGSize aSize = [ZSNApi stringHeightAndWidthWith:info.business WithHeight:MAXFLOAT WithWidth:MAXFLOAT WithFont:11];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,aSize.width+10,16)];
    label.backgroundColor = RGBCOLOR(244,244,244);
    label.text = info.business;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:11];
    label.textColor = RGBCOLOR(153,153,153);
    [_labels_back_view addSubview:label];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
