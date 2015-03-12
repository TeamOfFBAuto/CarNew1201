//
//  RecordDataClasses.h
//  CustomNewProject
//
//  Created by soulnear on 15-3-12.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//
/*
 大数据，每五分钟发送一次用户行为动作
 */
#import <Foundation/Foundation.h>


///用户行为类型
///跳转
#define USER_ACTION_GOTO @"1"
///评论
#define USER_ACTION_COMMENT @"2"
///聊天
#define USER_ACTION_CHAT @"3"
///位置
#define USER_ACTION_LOCATION @"4"
///分享
#define USER_ACTION_SHARE @"5"
///拨打电话
#define USER_ACTION_DAIL @"6"
///收藏
#define USER_ACTION_COLLECT @"7"
///点小图看大图
#define USER_ACTION_CLICKBIG @"8"
///点+号看说明
#define USER_ACTION_CLICKPLUS @"9"
///退出登录
#define USER_ACTION_EXIT @"10"


@interface RecordDataClasses : NSObject
{
    
}

///记录活动行为
@property(nonatomic,strong)NSString * action_string;

+ (RecordDataClasses *)sharedManager;

-(void)setActionStringWithAction:(NSString *)aAction WithObject:(NSString *)aObject;

@end
