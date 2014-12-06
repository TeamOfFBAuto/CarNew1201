//
//  ScreeningViewController.m
//  CustomNewProject
//
//  Created by soulnear on 14-12-2.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "ScreeningViewController.h"
#import "ScreeningCarView.h"
#import "ScreeningAreaView.h"

@interface ScreeningViewController ()<UIScrollViewDelegate>
{
    UIScrollView * myScrollView;
}

@end

@implementation ScreeningViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    UIBarButtonItem * right_bar = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = right_bar;
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH+20,DEVICE_HEIGHT-64)];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    myScrollView.bounces = NO;
    myScrollView.backgroundColor=[UIColor grayColor];
    myScrollView.contentSize = CGSizeMake((DEVICE_WIDTH+20)*2,0);
    [self.view addSubview:myScrollView];
    
    ///筛选车型
    ScreeningCarView * carView = [[ScreeningCarView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,myScrollView.frame.size.height)];
    carView.clipsToBounds = YES;
    [myScrollView addSubview:carView];
    
    ///地区筛选
    ScreeningAreaView * areaView = [[ScreeningAreaView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH+20,0,DEVICE_WIDTH,myScrollView.frame.size.height)];
    [myScrollView addSubview:areaView];
    
    
    ///加载顶部选择
    __weak typeof(self)bself = self;
    _seg_view = [[SliderBBSTitleView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH-80,44)];
    [_seg_view setAllViewsWith:[NSArray arrayWithObjects:@"按车型筛选",@"按地区筛选",nil] withBlock:^(int index) {
        [bself selectedForumWith:index];
    }];
    self.navigationItem.titleView = _seg_view;
    
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

#pragma mark - UIScrollViewDelegate
//滚动视图释放滚动
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int current_page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [_seg_view MyButtonStateWithIndex:current_page];
    [self selectedForumWith:current_page];
}


#pragma mark - 左右切换
-(void)selectedForumWith:(int)index
{
    [myScrollView setContentOffset:CGPointMake(myScrollView.frame.size.width*index,0)animated:YES];
}

#pragma mark - 选中车型通知
-(void)chooseCarType:(NSNotification *)notification
{
    NSLog(@"notificaiton ------   %@ ----- %@",notification.object,notification);
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
