//
//  ScreeningViewController.m
//  CustomNewProject
//
//  Created by soulnear on 14-12-2.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "ScreeningViewController.h"
#import "ScreeningCarView.h"

@interface ScreeningViewController ()

@end

@implementation ScreeningViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    UIScrollView * myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT-64)];
    myScrollView.pagingEnabled = YES;
    myScrollView.backgroundColor=[UIColor redColor];
    myScrollView.contentSize = CGSizeMake(DEVICE_WIDTH*2,0);
    [self.view addSubview:myScrollView];
    
    
    ScreeningCarView * carView = [[ScreeningCarView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH,0,DEVICE_WIDTH,myScrollView.frame.size.height)];
    [myScrollView addSubview:carView];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseCarType:) name:@"ChooseCarTypeNotification" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ChooseCarTypeNotification" object:nil];
}

-(void)chooseCarType:(NSNotification *)notification
{
    NSLog(@"notificaiton ------   %@ ----- %@",notification.object,notification);
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
