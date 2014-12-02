//
//  AnliDetailViewController.m
//  CustomNewProject
//
//  Created by lichaowei on 14/12/2.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "AnliDetailViewController.h"

@interface AnliDetailViewController ()

@end

@implementation AnliDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.myTitle = @"案例图库";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    [self createNavigationTools];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 网络请求

- (void)netWorkForDetail
{
    
}

#pragma mark 创建视图

//导航右上角按钮
- (void)createNavigationTools
{
    UIButton *saveButton =[[UIButton alloc]initWithFrame:CGRectMake(0,0,25,44)];
    [saveButton addTarget:self action:@selector(clickToShouCang:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setImage:[UIImage imageNamed:@"anli_shoucang"] forState:UIControlStateNormal];
    UIBarButtonItem *save_item=[[UIBarButtonItem alloc]initWithCustomView:saveButton];
    [saveButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    //    saveButton.backgroundColor = [UIColor orangeColor];
    
    UIButton *share_Button =[[UIButton alloc]initWithFrame:CGRectMake(0,0,25,44)];
    [share_Button addTarget:self action:@selector(clickToZhuanFa:) forControlEvents:UIControlEventTouchUpInside];
    [share_Button setImage:[UIImage imageNamed:@"anli_zhuanfa"] forState:UIControlStateNormal];
    [share_Button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    
    //    share_Button.backgroundColor = [UIColor redColor];
    
    UIBarButtonItem *share_item=[[UIBarButtonItem alloc]initWithCustomView:share_Button];
    self.navigationItem.rightBarButtonItems = @[share_item,save_item];
}

#pragma mark 事件处理

- (void)clickToShouCang:(UIButton *)sender
{
    
}

- (void)clickToZhuanFa:(UIButton *)sender
{
    
}

@end
