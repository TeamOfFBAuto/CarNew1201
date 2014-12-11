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

@implementation PHMenuViewController
{
    UINavigationController *_picNav;
    
    UINavigationController *_storeNav;
    
    UINavigationController *_businessNav;
    
    UINavigationController *_personalNav;
    
    UINavigationController * _settingNav;
    
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
    
    _personalNav=[[UINavigationController alloc]initWithRootViewController:[[PersonalViewController alloc]init]];
    
    _settingNav = [[UINavigationController alloc] initWithRootViewController:[[SliderRightSettingViewController alloc] init]];
    
    titles = @[@"案例图库", @"服务商家", @"个人中心"];
    
}

#pragma mark - 跳到设置界面
-(void)settingTap:(UIButton *)sender
{
    NSLog(@"设置");
    
    SliderRightSettingViewController * settingVC = [[SliderRightSettingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
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
        case 3:///商品
            viewController = _storeNav;
            break;
        case 1:///服务商家
            viewController = _businessNav;
            break;
        case 2:///个人中心
            viewController = _personalNav;
            break;
        case 5:///设置界面
            viewController = _settingNav;
            break;
    }
    return viewController;
}

@end
