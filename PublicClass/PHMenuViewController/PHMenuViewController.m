//
//  PHMenuViewController.m
//  Demo2
//
//  Created by Ta Phuoc Hai on 2/12/14.
//  Copyright (c) 2014 Phuoc Hai. All rights reserved.
//

#import "PHMenuViewController.h"
#import "PicViewController.h"
#import "StoreViewController.h"
#import "BusinessViewController.h"
#import "PersonalViewController.h"
#import "AppDelegate.h"
#import "SliderRightSettingViewController.h"
#import "LogInViewController.h"
#import "MessageViewController.h"

#import "NewLogInView.h"
#import "UIImage+ImageEffects.h"

@implementation PHMenuViewController
{
    UINavigationController *_picNav;
    
    UINavigationController *_storeNav;
    
    UINavigationController *_businessNav;
    
    UINavigationController *_personalNav;
    
    UINavigationController * _settingNav;
    
    UINavigationController * _messageNav;
    
    NSArray * titles;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(32,33,35);
    self.navigationController.navigationBarHidden = YES;
    
    _picNav=[[UINavigationController alloc]initWithRootViewController:[[PicViewController alloc]init]];
    
    _storeNav=[[UINavigationController alloc]initWithRootViewController:[[StoreViewController alloc]init]];
    
    _businessNav=[[UINavigationController alloc]initWithRootViewController:[[BusinessViewController alloc]init]];
    
    MessageViewController *message = [[MessageViewController alloc]init];
    [message showCustomEmptyBackView];
    
    _messageNav = [[UINavigationController alloc]initWithRootViewController:[[MessageViewController alloc]init]];
    
    _personalNav=[[UINavigationController alloc]initWithRootViewController:[[PersonalViewController alloc]init]];
    
    _settingNav = [[UINavigationController alloc] initWithRootViewController:[[SliderRightSettingViewController alloc] init]];
    
    titles = @[@"改装案例", @"服务商家",@"我的消息",@"个人中心"];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark - 跳到设置界面
-(void)settingTap:(UIButton *)sender
{
    NSLog(@"设置");
    
    self.setting_button.hidden=YES;
    
    SliderRightSettingViewController * settingVC = [[SliderRightSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
    
    self.setting_button.hidden=NO;
}

#pragma mark - 跳到登录界面
-(void)headerTap:(UITapGestureRecognizer *)sender
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:USER_IN]) {
        [self pushToLogInViewController];
    }
}

#pragma mark - PHAirMenuDelegate & DataSource

- (NSInteger)numberOfSession
{
    return 1;
}

- (NSInteger)numberOfRowsInSession:(NSInteger)sesion
{
    return titles.count;
}

- (NSString*)titleForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return titles[indexPath.row];
}

- (NSString*)titleForHeaderAtSession:(NSInteger)session
{
    return @"";//[NSString stringWithFormat:@"Session %ld", (long)session];
}

- (UIViewController*)viewControllerForIndexPath:(NSIndexPath*)indexPath
{
    UIViewController * viewController;
    switch (indexPath.row) {
        case 4:///精选推荐
            viewController = [(AppDelegate*)[UIApplication sharedApplication].delegate selectedVC];
            break;
        case 0:///案例图库
//            viewController = _picNav;
            viewController = [(AppDelegate*)[UIApplication sharedApplication].delegate picNavc];
            break;
        case 2:///我的消息
            viewController = _messageNav;
            break;
        case 1:///服务商家
            viewController = _businessNav;
            break;
        case 3:///个人中心
        {
            viewController = _personalNav;
        }
            break;
        case 5:///设置界面
            viewController = _settingNav;
            break;
    }
    return viewController;
}


-(void)pushToLogInViewController
{
    
    NewLogInView * loginView = [[NewLogInView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT)];
    loginView.backgroundColor = [UIColor colorWithPatternImage:[ZSNApi screenShot]];
    [[UIApplication sharedApplication].keyWindow addSubview:loginView];
    
//    LogInViewController * logIn = [[LogInViewController alloc]init];
//    UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:logIn];
//    [self presentViewController:navc animated:YES completion:nil];
    
}

///截图并模糊处理
- (UIImage *)screenShot
{
//    UIView * aview = [[UIApplication sharedApplication].keyWindow snapshotViewAfterScreenUpdates:YES];
    UIGraphicsBeginImageContextWithOptions([UIApplication sharedApplication].keyWindow.bounds.size,YES,0.0f);
    [[UIApplication sharedApplication].keyWindow drawViewHierarchyInRect:[UIApplication sharedApplication].keyWindow.bounds afterScreenUpdates:YES];
    UIImage *uiImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage * screenShot = [uiImage applyBlurWithRadius:5 tintColor:[UIColor colorWithWhite:0.2 alpha:0.1] saturationDeltaFactor:1.0 maskImage:nil];
    
    return screenShot;
}


@end
