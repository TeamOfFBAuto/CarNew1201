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

@implementation PHMenuViewController
{
    UINavigationController *_picNav;
    
    UINavigationController *_storeNav;
    
    UINavigationController *_businessNav;
    
    UINavigationController *_personalNav;
    
    NSArray * titles;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(32,33,35);
    
    _picNav=[[UINavigationController alloc]initWithRootViewController:[[PicViewController alloc]init]];
    
    _storeNav=[[UINavigationController alloc]initWithRootViewController:[[StoreViewController alloc]init]];
    
    _businessNav=[[UINavigationController alloc]initWithRootViewController:[[BusinessViewController alloc]init]];
    
    _personalNav=[[UINavigationController alloc]initWithRootViewController:[[PersonalViewController alloc]init]];
    
    titles = @[@"精选推荐",@"案例图库",@"配件商城", @"服务商家", @"个人中心"];
    
}

#pragma mark - 跳到设置界面
-(void)settingTap:(UIButton *)sender
{
    NSLog(@"设置");
}

#pragma mark - PHAirMenuDelegate & DataSource

- (NSInteger)numberOfSession
{
    return 1;
}

- (NSInteger)numberOfRowsInSession:(NSInteger)sesion
{
    return 5;
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
        case 0:
            viewController = [(AppDelegate*)[UIApplication sharedApplication].delegate selectedVC];
            break;
        case 1:
            viewController = _picNav;
            break;
        case 2:
            viewController = _storeNav;
            break;
        case 3:
            viewController = _businessNav;
            break;
        case 4:
            viewController = _personalNav;
            break;
    }
    return viewController;
}

@end
