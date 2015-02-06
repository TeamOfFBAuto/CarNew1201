//
//  GGoodsModel.h
//  CustomNewProject
//
//  Created by gaomeng on 14/12/5.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//


//收藏产品的model

#import <Foundation/Foundation.h>

@interface GGoodsModel : NSObject

@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *gtype;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *dateline;
@property(nonatomic,strong)NSString *pichead;
@property(nonatomic,strong)NSString *updatetime;
@property(nonatomic,strong)NSString *com_num;
@property(nonatomic,strong)NSString *id;

@property(nonatomic,strong)NSString *uid;
@property(nonatomic,strong)NSString *storename;

-(id)initWithDictionary:(NSDictionary *)dic;


@end
