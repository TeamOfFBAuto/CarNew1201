//
//  ChatViewController.m
//  CustomNewProject
//
//  Created by lichaowei on 15/1/23.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "ChatViewController.h"
#import "LocationViewController.h"

//#import "RCLocationPickerViewControllerDataSource"

@interface ChatViewController ()<RCLocationPickerViewControllerDataSource>

@end

@implementation ChatViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (MY_MACRO_NAME) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (MY_MACRO_NAME) {
        self.edgesForExtendedLayout = UIRectEdgeAll;
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    }
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        //iOS 5 new UINavigationBar custom background
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:MY_MACRO_NAME?IOS7DAOHANGLANBEIJING_PUSH:IOS6DAOHANGLANBEIJING] forBarMetrics: UIBarMetricsDefault];
    }
    
    UILabel *_myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,44)];
    _myTitleLabel.textAlignment = NSTextAlignmentCenter;
    _myTitleLabel.text = self.currentTargetName;
    _myTitleLabel.textColor = [UIColor blackColor];
    _myTitleLabel.font = [UIFont systemFontOfSize:17];
    self.navigationItem.titleView = _myTitleLabel;
    
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = MY_MACRO_NAME?-5:5;
    
    self.navigationController.navigationBarHidden=NO;
    
    
    UIBarButtonItem * spaceButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton1.width = MY_MACRO_NAME?-13:5;
    
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(MY_MACRO_NAME? -5:5,8,40,44)];
    [button_back addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [button_back setImage:[UIImage imageNamed:BACK_DEFAULT_IMAGE_GRAY] forState:UIControlStateNormal];
    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
    self.navigationItem.leftBarButtonItems=@[spaceButton1,back_item];
    
    self.enablePOI = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 事件处理

- (void)leftButtonTap:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)openLocationPicker:(id)sender; {
    LocationViewController *locationViewController = [[LocationViewController alloc] initWithDataSource:Nil];
    [self.navigationController pushViewController:locationViewController animated:YES];
}

//- (UIView*)mapView
//{
//    
//}
//- (CLLocationCoordinate2d)mapViewCenter
//{
//    
//}
//-  \- (void)setOnPoiSearchResult:(OnPoiSearchResul)poiSearchResult
//-  \- (void)beginFetchPoisOfCurrentLocation;
//-  \- (UIImage*)mapViewScreenShot;

@end
