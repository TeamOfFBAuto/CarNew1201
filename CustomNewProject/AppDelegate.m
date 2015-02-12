//
//  AppDelegate.m
//  CustomNewProject
//
//  Created by gaomeng on 14/11/25.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "AppDelegate.h"


#import "SelectedViewController.h"

#import "LeftViewController.h"

#import "RightViewController.h"

#import "PHMenuViewController.h"
#import "PHViewController.h"
#import "LogInViewController.h"
#import "PicViewController.h"

#import "UMSocial.h"
#import "WeiboSDK.h"
#import "MobClick.h"

#import "ZSNApi.h"

#import "RCIM.h"
#import "RCIMClient.h"

#define UMENG_APPKEY @"548a8a05fd98c5318d001273" //mobile
#define WXAPPID @"wxf53513ba14a2e141" //mobile 审核通过 改装志
#define SINAAPPID @"2128173805"//mobile 审核通过
//#define WXAPPID @"wxc007ca608b574af1" //mobile 审核通过 改装志iOS


/**
 *  融合mobile@fblife.com Fblife201314
 */

#define Rong_AppKey_Develope @"e0x9wycfxjyaq"
#define Rong_AppSecret_Develope @"ePqoE3K7SuSgTH"

//百度
#define BAIDU_APPKEY @"APMdmYcmGzQGBs3MUzr086Fk"

#import "BMapKit.h"

@interface AppDelegate ()<MobClickDelegate,WXApiDelegate,RCIMConnectionStatusDelegate,RCConnectDelegate,RCIMReceiveMessageDelegate,RCIMUserInfoFetcherDelegagte,BMKGeneralDelegate,CLLocationManagerDelegate>
{
    CLLocationManager    *location;
}

@property (strong, nonatomic) BMKMapManager *mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    
    NSLog(@"屏幕宽度 %f  %f",ALL_FRAME_WIDTH,ALL_FRAME_HEIGHT);
    
    [UMSocialData setAppKey:UMENG_APPKEY];
    [WXApi registerApp:WXAPPID];
    
    [WeiboSDK registerApp:SINAAPPID];
    [WeiboSDK enableDebugMode:YES ];
    
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:REALTIME channelId:nil];
//    [MobClick setLogSendInterval:60];
    [MobClick setLogEnabled:YES];
    
#pragma mark 地图
    
    location = [[CLLocationManager alloc] init];
    location.delegate= self;
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=8.0)) {
        
        [location requestAlwaysAuthorization];
    }
    
//    //注册百度地图
//    self.mapManager = [[BMKMapManager alloc] init];
//    BOOL ret = [self.mapManager start:BAIDU_APPKEY generalDelegate:self];
//    if (!ret) {
//        NSLog(@"百度地图启动失败");
//    }
    
#pragma mark 融云
    
    [RCIM initWithAppKey:Rong_AppKey_Develope deviceToken:nil];
    
    [[RCIM sharedRCIM]setConnectionStatusDelegate:self];//监控连接状态
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];//接受消息
    [RCIM setUserInfoFetcherWithDelegate:self isCacheUserInfo:YES];
    
    //系统登录成功通知 登录融云
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginToRongCloud) name:@"gdengluchenggong" object:nil];
    
    [self rongCloudDefaultLoginWithToken:[LTools cacheForKey:RONGCLOUD_TOKEN]];
    
#ifdef __IPHONE_8_0
    // 在 iOS 8 下注册苹果推送，申请推送权限。
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert) categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
#else
    // 注册苹果推送，申请推送权限。
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
#endif
    
    
#pragma mark 版本检测
    
    //版本更新
    
    [[LTools shareInstance]versionForAppid:@"950579792" Block:^(BOOL isNewVersion, NSString *updateUrl, NSString *updateContent) {
        
        NSLog(@"updateContent %@ %@",updateUrl,updateContent);
        
    }];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    
    _picVC = [[PicViewController alloc] init];
    _picNavc = [[UINavigationController alloc] initWithRootViewController:_picVC];
    
    [LTools cache:NSStringFromClass([_picVC class]) ForKey:SHOWCONTROLLER];
    
    PHMenuViewController   * menuController = [[PHMenuViewController alloc] initWithRootViewController:_picNavc atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    self.root_menu = menuController;
    
    UINavigationController * menu_nav = [[UINavigationController alloc] initWithRootViewController:menuController];
    self.window.rootViewController = menu_nav;
    
  //  [self NewShowMainVC];
    return YES;
}

#pragma mark - CLLocationDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([location respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [location requestAlwaysAuthorization];
            }
            break;
        default:
            break;
            
            
    } 
}

- (void)showControlView:(ROOTVC_TYPE)type
{
    if (type == Root_home)
    {
        _picVC = [[PicViewController alloc] init];
        _picNavc = [[UINavigationController alloc] initWithRootViewController:_picVC];
        
        PHMenuViewController   * menuController = [[PHMenuViewController alloc] initWithRootViewController:_picNavc atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UINavigationController * menu_nav = [[UINavigationController alloc] initWithRootViewController:menuController];
        self.window.rootViewController = menu_nav;
    }else if (type == Root_login)
    {
//        LogInViewController * logIn = [[LogInViewController alloc] init];//[[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
//        UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:logIn];
//        self.window.rootViewController = navc;
        NewLogInView * loginView = [[NewLogInView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT)];
        loginView.backgroundColor = [UIColor colorWithPatternImage:[ZSNApi screenShot]];
        [[UIApplication sharedApplication].keyWindow addSubview:loginView];
    }
}


-(void)NewShowMainVC{
    
    
    

    
    
    
    
    
    _navigationController = [[UINavigationController alloc] initWithRootViewController:[[SelectedViewController alloc] init]];
    
    
    _navigationController.navigationBarHidden=NO;
    //    UINavigationController *ritht = [[UINavigationController alloc] initWithRootViewController:[[RightViewController alloc] init]];
    
    //
    
    RightViewController * rightVC = [[RightViewController alloc] init];
    
    
    LeftViewController *menuViewController = [[LeftViewController alloc] init];
    
    
    
    _RootVC=[[MMDrawerController alloc]initWithCenterViewController:_navigationController leftDrawerViewController:menuViewController rightDrawerViewController:rightVC];
    
    
    [_RootVC setMaximumRightDrawerWidth:288];
    [_RootVC setMaximumLeftDrawerWidth:287];
    _RootVC.shouldStretchDrawer = NO;
    [_RootVC setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [_RootVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    _RootVC.showsShadow = YES;
    
    
    _root_nav = [[UINavigationController alloc] initWithRootViewController:_RootVC];
    
    
    
    _root_nav.navigationBarHidden = YES;
    self.window.rootViewController = _root_nav;//sideMenuViewController;
    
    
    _pushViewController = [[FansViewController alloc] init];
    
    UINavigationController * pushNav = [[UINavigationController alloc] initWithRootViewController:_pushViewController];
    
    pushNav.view.frame = [[UIScreen mainScreen] bounds];
    
    
    
    //  [self.window.rootViewController.view addSubview:pushNav.view];
    
}



#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    // Register to receive notifications.
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    // Handle the actions.
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif

// 获取苹果推送权限成功。
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // 设置 deviceToken。
    [[RCIM sharedRCIM] setDeviceToken:deviceToken];
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"RegisterForRemote Erro");
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSLog(@" 收到推送消息： %@",[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]);
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[RCIM sharedRCIM] getTotalUnreadCount];
    
    //_picVC
    
    UIViewController *root = self.window.rootViewController;
    
//    if (root isKindOfClass:<#(__unsafe_unretained Class)#>) {
//        <#statements#>
//    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
//    [MobClick setDelegate:self];
//    [MobClick appLaunched];
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH channelId:nil];
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [WXApi handleOpenURL:url delegate:self];
    
    // return  [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
}
#pragma mark-这里处理新浪微博SSO授权进入新浪微博客户端后进入后台，再返回原来应用
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [UMSocialSnsService  applicationDidBecomeActive];
    

    NSLog(@"applicationDidBecomeActive-%@",self.root_menu.currentIndexPath);
    
    int index = self.root_menu.currentIndexPath.row;
    if (index == 0) {
        [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UNREADNUM object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationWillEnterForeground" object:nil];
}






#pragma mark - 个人中心界面 上传的代理回调方法
-(void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"上传完成");
    
    if (request.tag == 122)//上传用户banner
    {
        
        NSLog(@"走了request.tag = %d    122:用户banner",request.tag);
        
        NSDictionary * dic = [[NSDictionary alloc] initWithDictionary:[request.responseData objectFromJSONData]];
        
        NSLog(@"tupiandic==%@",dic);
        
        if ([[dic objectForKey:@"errcode"]intValue] == 0) {
            NSLog(@"上传成功");
            NSString *str = @"no";
            [ZSNApi showAutoHiddenMBProgressWithText:@"更改成功" addToView:self.window];
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"gIsUpBanner"];
            
        }else{
            NSString *str = @"yes";
            [ZSNApi showAutoHiddenMBProgressWithText:@"更改失败，联网自动更新" addToView:self.window];
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"gIsUpBanner"];
            
        }
        
        NSLog(@"上传banner标志位%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"gIsUpBanner"]);
        
        
        //发通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chagePersonalInformation" object:nil];
        
    }else if (request.tag == 123)//上传用户头像
    {
        
        NSLog(@"走了request.tag = %d    123:用户头像",request.tag);
        
        NSDictionary * dic = [[NSDictionary alloc] initWithDictionary:[request.responseData objectFromJSONData]];
        NSLog(@"tupiandic==%@",dic);
        
        if ([[dic objectForKey:@"errcode"]intValue] == 0) {
            request.delegate = nil;
            NSString *str = @"no";
            [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpFace"];
            
        }else{
            NSString *str = @"yes";
            [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpFace"];
        }
        
        NSLog(@"上传头像标志位%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"gIsUpFace"]);
        
        //发通知
        [[NSNotificationCenter defaultCenter]postNotificationName:@"chagePersonalInformation" object:nil];
        
    }
    
}


#pragma - mark - 获取融云token -

- (void)loginToRongCloud
{
    [self loginToRoncloudUserId:[GMAPI getUid] userName:[GMAPI getUsername] userHeadImage:[ZSNApi returnMiddleUrl:[GMAPI getUid]]];
}

- (void)loginToRoncloudUserId:(NSString *)userId
                     userName:(NSString *)userName
                userHeadImage:(NSString *)headImage
{
    
    if (headImage.length == 0) {
        headImage = @"nnn";
    }
    
    NSString *url = [NSString stringWithFormat:RONCLOUD_GET_TOKEN,userId,userName,headImage];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"result %@",result);
        
        [LTools cache:result[@"token"] ForKey:RONGCLOUD_TOKEN];
        
        [self rongCloudDefaultLoginWithToken:result[@"token"]];
        
        
    } failBlock:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"获取融云token失败 %@",result);
        
        [LTools showMBProgressWithText:result[ERROR_INFO] addToView:self.window];
        
    }];
}


- (void)rongCloudDefaultLoginWithToken:(NSString *)loginToken
{
    //默认测试
    
    if (loginToken.length > 0) {
        
        
        __weak typeof(self)weakSelf = self;
        [RCIM connectWithToken:loginToken completion:^(NSString *userId) {
            
            NSLog(@"------> rongCloud 登陆成功 %@",userId);
            
//            [LTools cacheBool:YES ForKey:LOGIN_RONGCLOUD_STATE];
            
        } error:^(RCConnectErrorCode status) {
            
            NSLog(@"------> rongCloud 登陆失败 %d",(int)status);
            
//            [LTools cacheBool:NO ForKey:LOGIN_RONGCLOUD_STATE];
            
            if (status == ConnectErrorCode_TOKEN_INCORRECT) {
                //错误的令牌 服务器重新获取
                
                [weakSelf loginToRongCloud];
            }
            
        }];
    }
}

/**
 *  监测融云连接状态
 */
-(void)rongCloudConnectionState{
    
    
}

#pragma mark - RCIMReceiveMessageDelegate

-(void)didReceivedMessage:(RCMessage *)message left:(int)nLeft
{
    if (0 == nLeft) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber+1;
        });
    }
    
    [[NSNotificationCenter defaultCenter]postNotificationName:NOTIFICATION_UNREADNUM object:nil];
    
    [[RCIM sharedRCIM] invokeVoIPCall:self.window.rootViewController message:message];
}

#pragma mark - RCIMUserInfoFetcherDelegagte method

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    NSString *userName = [LTools rongCloudUserNameWithUid:userId];
    
    if ([userId isEqualToString:[GMAPI getUid]]) {
        
        userName = [GMAPI getUsername];
    }
    
    if ([userName isKindOfClass:[NSString class]] && userName.length == 0) {
        NSString *url = [NSString stringWithFormat:G_USERINFO,userId];
        LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
        [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
            
            NSDictionary *dic = [result objectForKey:@"datainfo"];
            
            NSString *name = dic[@"username"];
            
            if ([name isKindOfClass:[NSString class]] && name.length > 0) {
                
                [LTools cacheRongCloudUserName:name forUserId:userId];
            }
            
            RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:userId name:name portrait:[ZSNApi returnMiddleUrl:userId]];
            
            return completion(userInfo);
            
        } failBlock:^(NSDictionary *failDic, NSError *erro) {
            
        }];
    }
    
    RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:userId name:userName portrait:[ZSNApi returnMiddleUrl:userId]];
    
    return completion(userInfo);
}


#pragma mark - RCIMConnectionStatusDelegate <NSObject>

-(void)responseConnectionStatus:(RCConnectionStatus)status{
    if (ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT == status) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"----->%d %d",status,self.alert.isVisible);
//            if ([self.alert isVisible] == NO) {
//                
//                self.alert= [[UIAlertView alloc]initWithTitle:@"" message:@"您已下线，重新连接？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确定",nil];
//                self.alert.tag = 2000;
//                [self.alert show];
//            }
            
        });

//        [LTools cacheBool:NO ForKey:LOGIN_RONGCLOUD_STATE];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (2000 == alertView.tag) {
        
        if (0 == buttonIndex) {
            
            NSLog(@"NO");
        }
        
        if (1 == buttonIndex) {
            
            NSLog(@"YES");
            
            [RCIMClient reconnect:self];
        }
    }
    
}

#pragma mark - ReConnectDelegate
/**
 *  回调成功。
 *
 *  @param userId 当前登录的用户 Id，既换取登录 Token 时，App 服务器传递给融云服务器的用户 Id。
 */
- (void)responseConnectSuccess:(NSString*)userId{
    
    NSLog(@"userId %@ rongCloud登录成功",userId);
}

/**
 *  回调出错。
 *
 *  @param errorCode 连接错误代码。
 */
- (void)responseConnectError:(RCConnectErrorCode)errorCode
{
    NSLog(@"rongCloud重新连接失败--- %d",(int)errorCode);
    
    if (errorCode == ConnectErrorCode_TOKEN_INCORRECT) {
        //错误的令牌 服务器重新获取
        
        [self loginToRongCloud];
    }
}

#pragma mark -
#pragma mark BMKGeneralDelegate
- (void)onGetNetworkState:(int)iError {
    NSLog(@"百度地图：网络状态 %i", iError);
}

- (void)onGetPermissionState:(int)iError {
    NSLog(@"百度地图：授权状态 %i", iError);
}


@end
