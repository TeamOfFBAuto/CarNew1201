//
//  GpersonCenterCustomCell.h
//  CustomNewProject
//
//  Created by gaomeng on 14/12/4.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//



//个人中心的tableview自定义cell

#import <UIKit/UIKit.h>
#import "BusinessListModel.h"
#import "GCaseModel.h"
#import "GGoodsModel.h"
#import "GstartView.h"

@interface GpersonCenterCustomCell : UITableViewCell
{
    
    //收藏店铺相关
    UILabel *_business_name_label;
    UILabel *_comment_num_label;
    GstartView *_stars_back_view;
    UIView *_labels_back_view;
    UILabel *_biaoqianLabel;
    
    //收藏产品相关
    UIImageView *_mainImv_chapin;
    UILabel *_price_chanpin;
    UILabel *_title1_chanpin;
    UILabel *_title2_chanpin;
    
    
    
    
    
    //收藏案例相关
    UIImageView *_mainImv;
    UIImageView *_logoImageView;
    UILabel *_titleLabel1;
    UILabel *_titleLabel2;
    
    
}

//根据类型初始化自定义cell  1收藏案例 2收藏产品 3收藏店铺
-(void)loadCustomViewWithType:(int)theType;


//收藏店铺 填充数据
-(void)setdataWithData:(BusinessListModel *)theModel;


//收藏案例
-(void)setAnliDataWithData:(GCaseModel *)theModel;

//收藏产品
-(void)setChanpinWithData:(GGoodsModel *)theModel;

//收藏店铺的图
@property(nonatomic,strong)UIImageView *header_imageView;

@end
