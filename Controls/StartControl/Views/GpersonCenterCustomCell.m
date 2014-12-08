//
//  GpersonCenterCustomCell.m
//  CustomNewProject
//
//  Created by gaomeng on 14/12/4.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "GpersonCenterCustomCell.h"

@implementation GpersonCenterCustomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)loadCustomViewWithType:(int)theType{
    if (theType == 1) {//收藏案例
        _mainImv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, 220.0/568*ALL_FRAME_HEIGHT)];
//        88 42
        _priceView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 88.0/320*ALL_FRAME_WIDTH, 42.0/568*ALL_FRAME_HEIGHT)];
        _priceLabel = [[UILabel alloc]initWithFrame:_priceView.frame];
        _priceLabel.textColor = RGBCOLOR(252, 161, 51);
        [_priceView addSubview:_priceLabel];
        
        [self.contentView addSubview:_mainImv];
        [self.contentView addSubview:_priceView];
    }else if (theType == 2){//收藏产品
        
        _mainImv1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, 220.0/568*ALL_FRAME_HEIGHT)];
        _logoImv = [[UIImageView alloc]initWithFrame:CGRectMake(20, 265, 42, 42)];
        _titileLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_logoImv.frame)+15, _logoImv.frame.origin.y, ALL_FRAME_WIDTH-CGRectGetMaxX(_logoImv.frame)-15-20, _logoImv.frame.size.height/2)];
        _subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titileLabel.frame.origin.x, CGRectGetMaxY(_titileLabel.frame), _titileLabel.frame.size.width, _titileLabel.frame.size.height)];
        
        
    }else if (theType == 3){//收藏店铺
        //图片
        _header_imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 60.0/320*ALL_FRAME_WIDTH, 60.0/568*ALL_FRAME_HEIGHT)];
        
        //名字
        _business_name_label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_header_imageView.frame)+12, _header_imageView.frame.origin.y, ALL_FRAME_WIDTH-_header_imageView.frame.size.width-12-12-12, 16.0/568*ALL_FRAME_HEIGHT)];
        
        //星星
        _stars_back_view = [[UIView alloc]initWithFrame:CGRectMake(_business_name_label.frame.origin.x, CGRectGetMaxY(_business_name_label.frame)+6, 45, 12)];
        
        //评论
        _comment_num_label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_stars_back_view.frame)+5, _stars_back_view.frame.origin.y, ALL_FRAME_WIDTH-12-_header_imageView.frame.size.width-12-_stars_back_view.frame.size.width-5-5, _stars_back_view.frame.size.height)];
        _comment_num_label.font = [UIFont systemFontOfSize:_comment_num_label.frame.size.height-1];
        _comment_num_label.textColor = RGBCOLOR(253, 163, 72);
        
        //标签
        _labels_back_view = [[UIView alloc]initWithFrame:CGRectMake(_stars_back_view.frame.origin.x, CGRectGetMaxY(_stars_back_view.frame)+9, _stars_back_view.frame.size.width, 16.0/568*ALL_FRAME_HEIGHT)];
        _labels_back_view.backgroundColor = RGBCOLOR(244, 244, 244);
        
        _biaoqianLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _labels_back_view.frame.size.width, _labels_back_view.frame.size.height)];
        _biaoqianLabel.textColor = RGBCOLOR(103, 103, 103);
        _biaoqianLabel.font = [UIFont systemFontOfSize:_biaoqianLabel.frame.size.height-3];
        _biaoqianLabel.textAlignment = NSTextAlignmentCenter;
        [_labels_back_view addSubview:_biaoqianLabel];
        
        
        //视图添加
        [self.contentView addSubview:_header_imageView];
        [self.contentView addSubview:_business_name_label];
        [self.contentView addSubview:_stars_back_view];
        [self.contentView addSubview:_comment_num_label];
        [self.contentView addSubview:_labels_back_view];
        
        
    }
}


//填充数据 店铺
-(void)setdataWithData:(BusinessListModel *)theModel{
    _business_name_label.text = theModel.storename;
    [_header_imageView sd_setImageWithURL:[NSURL URLWithString:theModel.pichead] placeholderImage:nil];
    _comment_num_label.text = [NSString stringWithFormat:@"%@人评论",theModel.com_num];
    
//    CGSize aSize = [ZSNApi stringHeightAndWidthWith:theModel.business WithHeight:MAXFLOAT WithWidth:MAXFLOAT WithFont:11];
//    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,aSize.width+10,16)];
//    label.backgroundColor = RGBCOLOR(244,244,244);
//    label.text = theModel.business;
//    label.textAlignment = NSTextAlignmentCenter;
//    label.font = [UIFont systemFontOfSize:11];
//    label.textColor = RGBCOLOR(153,153,153);
//    [_labels_back_view addSubview:label];
    _biaoqianLabel.text = theModel.business;
    
}




//填充数据 ： 案例
-(void)setAnliDataWithData:(GCaseModel *)theModel{
//    NSString *imageName = theModel.pichead;
//    [_mainImv1 setImage:[UIImage imageNamed:imageName]];
//    
//    _priceLabel1.text = theModel.price;
    
    NSString *imageName = theModel.pichead;
    [_mainImv setImage:[UIImage imageNamed:imageName]];
    
    
    
    
}

//填充数据 ： 产品
-(void)setChanpinWithData:(GGoodsModel *)theModel{
    
    NSString *imageName = theModel.pichead;
    [_mainImv1 setImage:[UIImage imageNamed:imageName]];
    
    
    
    
}


@end
