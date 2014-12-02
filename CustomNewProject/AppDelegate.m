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

@interface AppDelegate ()

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

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
