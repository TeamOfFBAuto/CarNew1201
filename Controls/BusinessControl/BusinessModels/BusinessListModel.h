//
//  BusinessListModel.h
//  CustomNewProject
//
//  Created by soulnear on 14-12-2.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface BusinessListModel : BaseModel
///商家id
@property(nonatomic,strong)NSString * id;
///商家名字
@property(nonatomic,strong)NSString * storename;
///商家评论数目
@property(nonatomic,strong)NSString * com_num;
///商家标签
@property(nonatomic,strong)NSString * business;
///商家星级
@property(nonatomic,strong)NSString * score;
///商家图片
@property(nonatomic,strong)NSString * pichead;

@end
