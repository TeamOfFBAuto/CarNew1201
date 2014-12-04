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

#define WXAPPID @"wxda592c816f3e5c23"
#define SINAAPPID @"1552967260"
#define UMENG_APPKEY @"54646d3efd98c5657c005abc"

@interface AppDelegate ()<MobClickDelegate,WXApiDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    [UMSocialData setAppKey:UMENG_APPKEY];
    [WXApi registerApp:WXAPPID];
    
    [WeiboSDK registerApp:SINAAPPID];
    [WeiboSDK enableDebugMode:YES ];
    
    
    [MobClick startWithAppkey:UMENG_APPKEY reportPolicy:BATCH channelId:nil];
    
    [MobClick setLogEnabled:YES];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    
    BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
    
    if (isLogIn)//已经登陆跳转到主界面
    {
        [self showControlView:Root_home];
    }else//未登录跳转到登陆界面
    {
        [self showControlView:Root_login];
    }
    
  //  [self NewShowMainVC];
    return YES;
}

- (void)showControlView:(ROOTVC_TYPE)type
{
    if (type == Root_home)
    {
        _picVC = [[PicViewController alloc] init];
        UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:_picVC];
        
        PHMenuViewController   * menuController = [[PHMenuViewController alloc] initWithRootViewController:navc atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UINavigationController * menu_nav = [[UINavigationController alloc] initWithRootViewController:menuController];
        self.window.rootViewController = menu_nav;
    }else if (type == Root_login)
    {
        LogInViewController * logIn = [LogInViewController sharedManager];//[[LogInViewController alloc] initWithNibName:@"LogInViewController" bundle:nil];
        
        UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:logIn];
        
        self.window.rootViewController = navc;
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







- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
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
            [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"gIsUpBanner"];
            
        }else{
            NSString *str = @"yes";
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

@end
