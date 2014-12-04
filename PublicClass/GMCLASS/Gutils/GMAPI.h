//
//  GMAPI.h
//  FBAuto
//
//  Created by gaomeng on 14-7-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"



#define IOS7_OR_LATER   ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )


@interface GMAPI : NSObject

+(NSString *)getUsername;


+(NSString *)getDeviceToken;

+(NSString *)getAuthkey;

+(NSString *)getUid;

+(NSString *)getUserPassWord;


+ (MBProgressHUD *)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView;

/**
 *  NSUserDefault 缓存
 */
//存
+ (void)cache:(id)dataInfo ForKey:(NSString *)key;
//取
+ (id)cacheForKey:(NSString *)key;



//写数据=========================

//保存用户banner到本地
+(BOOL)setUserBannerImageWithData:(NSData *)data;

//保存用户头像到本地
+(BOOL)setUserFaceImageWithData:(NSData *)data;



//获取document路径
+ (NSString *)documentFolder;


//读数据=========================

//获取用户bannerImage
+(UIImage *)getUserBannerImage;

//获取用户头像Image
+(UIImage *)getUserFaceImage;

@end
