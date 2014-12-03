//
//  GMAPI.h
//  FBAuto
//
//  Created by gaomeng on 14-7-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
#import "GAPIHeader.h"

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

@end
