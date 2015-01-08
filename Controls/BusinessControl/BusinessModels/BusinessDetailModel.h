//
//  BusinessDetailModel.h
//  CustomNewProject
//
//  Created by soulnear on 14-12-16.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface BusinessDetailModel : BaseModel


@property(nonatomic,strong)NSString * address;
@property(nonatomic,strong)NSString * bunner;
@property(nonatomic,strong)NSString * business;
@property(nonatomic,strong)NSString * case_num;
@property(nonatomic,strong)NSString * city;
@property(nonatomic,strong)NSString * com_num;
///简介
@property(nonatomic,strong)NSString * content;
@property(nonatomic,strong)NSString * contract;
@property(nonatomic,strong)NSString * goods_num;
@property(nonatomic,strong)NSString * id;
@property(nonatomic,strong)NSString * level;
@property(nonatomic,strong)NSString * phone;
///图片
@property(nonatomic,strong)NSString * pichead;
@property(nonatomic,strong)NSString * province;
@property(nonatomic,strong)NSString * storename;
@property(nonatomic,strong)NSString * subname;
@property(nonatomic,strong)NSString * total;

///是否收藏
@property(nonatomic,strong)NSString * isshoucang;
///电话号码
@property(nonatomic,strong)NSString * tel;
///标题
@property(nonatomic,strong)NSString * title;

@end
