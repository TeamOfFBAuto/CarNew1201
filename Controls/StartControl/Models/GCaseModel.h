//
//  GCaseModel.h
//  CustomNewProject
//
//  Created by gaomeng on 14/12/5.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//



//收藏案例的model

#import <Foundation/Foundation.h>

@interface GCaseModel : NSObject

@property (nonatomic,retain)NSString *id;
@property (nonatomic,retain)NSString *uid;

@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *pichead;
@property(nonatomic,strong)NSString *province;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *brand;
@property(nonatomic,strong)NSString *models;
@property(nonatomic,strong)NSString *dateline;
@property(nonatomic,strong)NSString *sname;
@property(nonatomic,strong)NSString *spichead;
@property(nonatomic,strong)NSString *username;


-(id)initWithDictionary:(NSDictionary *)dic;


@end
