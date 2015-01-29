//
//  AppDelegate.h
//  CustomNewProject
//
//  Created by gaomeng on 14/11/25.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//
typedef enum{
    Root_login = 0,
    Root_home
} ROOTVC_TYPE;
#import <UIKit/UIKit.h>

#import "MMDrawerController.h"

#import "FansViewController.h"
#import "SelectedViewController.h"

@class PicViewController;
@class PHMenuViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;



@property(nonatomic,strong)UINavigationController *navigationController;

@property(nonatomic,strong)UINavigationController * root_nav;

@property(nonatomic,strong)MMDrawerController *RootVC;

@property(nonatomic,strong)FansViewController * pushViewController;//控制跳转的透明view
@property(nonatomic,strong)SelectedViewController * selectedVC;
@property(nonatomic,strong)PicViewController * picVC;
@property(nonatomic,strong)UINavigationController * picNavc;

@property(nonatomic,strong)UIAlertView *alert;

@property(nonatomic,strong)PHMenuViewController *root_menu;

- (void)showControlView:(ROOTVC_TYPE)type;
@end

