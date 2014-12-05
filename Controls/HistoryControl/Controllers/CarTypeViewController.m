//
//  CarTypeViewController.m
//  CustomNewProject
//
//  Created by lichaowei on 14/12/5.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "CarTypeViewController.h"
#import "ScreeningCarView.h"

@interface CarTypeViewController ()

@end

@implementation CarTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseCarType:) name:@"ChooseCarTypeNotification" object:nil];
    
    self.myTitle = @"车型选择";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    ScreeningCarView *carView = [[ScreeningCarView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT)];
    [self.view addSubview:carView];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)chooseCarType:(NSNotification *)notification
{
    NSLog(@"notification %@ %@",notification.object,notification.userInfo);
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
