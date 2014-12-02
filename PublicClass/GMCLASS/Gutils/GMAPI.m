//
//  GMAPI.m
//  FBAuto
//
//  Created by gaomeng on 14-7-3.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GMAPI.h"

@implementation GMAPI




//获取用户的devicetoken

+(NSString *)getDeviceToken{
    
    NSString *str_devicetoken=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:DEVICETOKEN]];
    return str_devicetoken;
    
    
}

//获取用户名
+(NSString *)getUsername{
    
    NSString *str_devicetoken=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USER_NAME]];
    if ([str_devicetoken isEqualToString:@"(null)"]) {
        str_devicetoken=@"";
    }
    return str_devicetoken;
    
    
}

//获取authkey
+(NSString *)getAuthkey{
    
    NSString *str_authkey=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USER_AUTHOD]];
    return str_authkey;
    
}


//获取用户id
+(NSString *)getUid{
    
    NSString *str_uid=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USER_UID]];
    return str_uid;
    
}


//获取用户密码
+(NSString *)getUserPassWord{
    NSString *str_password = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USER_PW]];
    return str_password;
}


#pragma mark - 弹出提示框
+ (MBProgressHUD *)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 15.f;
    hud.yOffset = 0.0f;
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}



#pragma mark - NSUserDefault缓存

//存
+ (void)cache:(id)dataInfo ForKey:(NSString *)key
{
    
    @try {
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:dataInfo forKey:key];
        [defaults synchronize];
        
    }
    @catch (NSException *exception) {
        
        NSLog(@"exception %@",exception);
        
    }
    @finally {
        
    }
    
}

//取
+ (id)cacheForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}


@end
