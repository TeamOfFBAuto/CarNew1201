//
//  DefaultConstant.h
//  FblifeAll
//
//  Created by zhang xinhao on 12-11-9.
//  Copyright (c) 2012年 fblife. All rights reserved.
//

#import <UIKit/UIKit.h>
/*对应全view旋转
 #import <Three20/Three20.h>
 #define ALL_FRAME TTScreenBounds()
 */



//

//app当前版本

#define NOW_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]


#define AUTHKEY [[NSUserDefaults standardUserDefaults] objectForKey:USER_AUTHOD]


// 是否是iphone5
#define IPHONE5_HEIGHT 568
#define IPHONE4_HEIGHT 480
#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


//颜色

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f \
alpha:(a)]

#define iphone5fram 568-20-40-40-49
#define iphone4fram 480-20-40-40-49

//监听键盘的宏定义
#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

#define kSCNavBarImageTag 10
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

//整屏幕的Frame
#define ALL_FRAME [UIScreen mainScreen].applicationFrame

//整屏幕的Frame 宽
#define ALL_FRAME_WIDTH ALL_FRAME.size.width

//整屏幕的Frame 高
#define ALL_FRAME_HEIGHT ALL_FRAME.size.height

//title的高度
#define TITLE_HEIGHT 44
//底部菜单的高度
#define MENU_HEIGHT 49
#define NEWS_HEIGHT 37
//保存用户信息的常量key
#define USER_FACE @"userface"
#define USER_NAME @"username"
#define USER_PW @"userPw"
#define USER_UID @"useruid"
#define USER_IN @"user_in" //0是未登陆  1是已登陆
#define USER_AUTHOD @"user_authod"
#define USER_CHECKUSER @"checkfbuser"
#define TUPIANZHILIANG @"tupianzhiliang"
#define NOTIFICATION_QUXIAOGUANZHU @"quxiaoguanzhu"
#define NOTIFICATION_TIANJIAGUANZHU @"tianjiaguanzhu"

#define NOTIFICATION_LOGIN_SUCCESS @"login_success"//登录成功
///成功退出登录
#define NOTIFICATION_LOGOUT_SUCCESS @"logout_success"
///来网啦
#define NOTIFICATION_HAVE_NETWORK @"haveNetWork"
///没网啦
#define NOTIFICATION_NO_NETWORK @"noNetWork"

#define NOTIFICATION_REPLY @"reply"
#define DEVICETOKEN @"pushdevicetoken"


#pragma mark - 所有接口 -************************************************************

#define BASE_URL @"http://gztest.fblife.com/"

//注册
#define SENDPHONENUMBER @"http://bbs.fblife.com/bbsapinew/register.php?type=phone&step=1&telphone=%@&keycode=e2e3420683&datatype=json"
#define SENDERVerification @"http://bbs.fblife.com/bbsapinew/register.php?type=phone&step=2&telphone=%@&telcode=%@&datatype=json"
#define SENDUSERINFO @"http://bbs.fblife.com/bbsapinew/register.php?type=phone&step=3&telphone=%@&telcode=%@&username=%@&password=%@&email=%@&datatype=json"

#pragma mark - 商家信息相关接口
#pragma mark - 商家列表接口
#define BUSINESS_LIST_URL @"index.php?c=interface&a=getStore&ps=20&page=%d&fbtype=json"
//登录
#define G_LOGIN @"http://gztest.fblife.com/index.php?c=interface&a=dologin&username=%@&password=%@&token=%@&fbtype=json"
//案例

//案例列表
#define ANLI_LIST @"http://gztest.fblife.com/index.php?c=interface&a=getCase&fbtype=json&page=%d&ps=%d"

//案例收藏
#define ANLI_COLLECT @"http://gztest.fblife.com/index.php?c=interface&a=addFavCase&fbtype=json&uid=%@&caseid=%@"




