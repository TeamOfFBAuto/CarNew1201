//
//  MessageViewController.m
//  CustomNewProject
//
//  Created by soulnear on 15-1-23.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "MessageViewController.h"

#import "ChatViewController.h"


///数据统计该类代表的数字
#define CURRENT_SHOW_NUM @"6"

@interface MessageViewController ()
{
    UIPanGestureRecognizer * panGestureRecognizer;
    UISwipeGestureRecognizer * swipe;
}

@end

@implementation MessageViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_GOTO WithObject:CURRENT_SHOW_NUM WithValue:@""];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    

    if (self.isPush == NO) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestures:)];
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.maximumNumberOfTouches = 1;
        [self.view addGestureRecognizer:panGestureRecognizer];
        
        
        swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeOnAirImageView:)];
        swipe.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swipe];

    }
    
    [MobClick beginEvent:@"MessageViewController"];

        
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.view removeGestureRecognizer:panGestureRecognizer];
    [self.view removeGestureRecognizer:swipe];
    
    [MobClick endEvent:@"MessageViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    _myTitleLabel.text = @"我的消息";
    _myTitleLabel.textColor = [UIColor blackColor];
    _myTitleLabel.font = [UIFont systemFontOfSize:17];
    self.navigationItem.titleView = _myTitleLabel;
    
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = MY_MACRO_NAME?-5:5;
    
    self.navigationController.navigationBarHidden=NO;
    
    
    NSString *imageName;
    if (self.isPush) {
        
        imageName = BACK_DEFAULT_IMAGE_GRAY;
    }else
    {
        imageName = NAVIGATION_MENU_IMAGE_NAME2;
    }
    
    UIImage * leftImage = [UIImage imageNamed:imageName];
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0,0,leftImage.size.width,leftImage.size.height);
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItems = @[spaceButton,leftBarButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    self.navigationItem.rightBarButtonItem = nil;
    
    self.portraitStyle = RCUserAvatarCycle;
    
//    [self setNodataView];
    
    
}

-(void)setNodataView{
    //整个视图
    UIView * _noDataView = [[UIView alloc]initWithFrame:CGRectMake(0, 240, DEVICE_WIDTH, 105)];
    _noDataView.backgroundColor = [UIColor whiteColor];
    
    //图
    UIImageView *noDataImv = [[UIImageView alloc]initWithFrame:CGRectMake(90, 90, 130, 60)];
    noDataImv.center = CGPointMake(DEVICE_WIDTH * 0.5, 120);
    [noDataImv setImage:[UIImage imageNamed:@"noDataView"]];
    
    //上分割线
    UIView *shangxian = [[UIView alloc]initWithFrame:CGRectMake(noDataImv.frame.origin.x, CGRectGetMaxY(noDataImv.frame)+12, noDataImv.frame.size.width, 1)];
    shangxian.backgroundColor = RGBCOLOR(233, 233, 233);
    
    //文字提示
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(shangxian.frame.origin.x, CGRectGetMaxY(shangxian.frame)+5, shangxian.frame.size.width, 13)];
    titleLabel.text = @"没有任何消息";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = RGBCOLOR(129, 129, 129);
    
    //下分割线
    UIView *xiaxian = [[UIView alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x, CGRectGetMaxY(titleLabel.frame)+5, titleLabel.frame.size.width, 1)];
    xiaxian.backgroundColor = RGBCOLOR(233, 233, 233);
    
    //视图添加
    [_noDataView addSubview:noDataImv];
    [_noDataView addSubview:shangxian];
    [_noDataView addSubview:titleLabel];
    [_noDataView addSubview:xiaxian];
    
    [self.conversationListView setBackgroundView:_noDataView];

}

///**
// *  隐藏 默认背景图
// */
//
//-(BOOL)showCustomEmptyBackView
//{
//    return YES;
//}



/**
 *  重载选择表格事件
 *
 *  @param conversation
 */
-(void)onSelectedTableRow:(RCConversation*)conversation{
    
    //该方法目的延长会话聊天UI的生命周期
    ChatViewController* chat = [self getChatController:conversation.targetId conversationType:conversation.conversationType];
    if (nil == chat) {
        chat =[[ChatViewController alloc]init];
        chat.portraitStyle = RCUserAvatarCycle;
        [self addChatController:chat];
    }
    chat.currentTarget = conversation.targetId;
    chat.conversationType = conversation.conversationType;
    //chat.currentTargetName = curCell.userNameLabel.text;
    chat.currentTargetName = conversation.conversationTitle;
//    chat.enablePOI = NO;
    chat.enableSettings = NO;
    [self.navigationController pushViewController:chat animated:YES];
    
}

-(void)leftButtonTap:(UIButton *)sender
{
    if (self.isPush) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_GOTO WithObject:CURRENT_SHOW_NUM WithValue:@"1"];
        [self.airViewController showAirViewFromViewController:self.navigationController complete:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 拖拽手势
BOOL isFirst;
CGPoint began_point;
-(void)handlePanGestures:(UIPanGestureRecognizer *)sender
{
    if (!isFirst)
    {
        began_point = [sender locationInView:self.view];
        if (began_point.x > 0)
        {
            isFirst = YES;
        }
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        CGPoint current_point = [sender locationInView:self.view];
        
        if (current_point.x - began_point.x > 40 && began_point.x != 0)
        {
            isFirst = NO;
            [self.airViewController showAirViewFromViewController:self.navigationController complete:nil];
        }
    }
}

-(void)handleSwipeOnAirImageView:(UISwipeGestureRecognizer *)sender
{
    [self.airViewController showAirViewFromViewController:self.navigationController complete:nil];
}

@end
