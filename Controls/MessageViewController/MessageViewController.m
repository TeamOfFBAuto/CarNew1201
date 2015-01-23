//
//  MessageViewController.m
//  CustomNewProject
//
//  Created by soulnear on 15-1-23.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "MessageViewController.h"

#import "ChatViewController.h"

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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestures:)];
    panGestureRecognizer.minimumNumberOfTouches = 1;
    panGestureRecognizer.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    
    swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeOnAirImageView:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipe];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.view removeGestureRecognizer:panGestureRecognizer];
    [self.view removeGestureRecognizer:swipe];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (MY_MACRO_NAME) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
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
    
    
    UIImage * leftImage = [UIImage imageNamed:NAVIGATION_MENU_IMAGE_NAME2];
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:NAVIGATION_MENU_IMAGE_NAME2] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0,0,leftImage.size.width,leftImage.size.height);
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItems = @[spaceButton,leftBarButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self showCustomEmptyBackView];
    
    self.portraitStyle = RCUserAvatarCycle;
    
}

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
    [self.navigationController pushViewController:chat animated:YES];
}

/**
 *  隐藏 默认背景图
 */

-(BOOL)showCustomEmptyBackView
{
    return YES;
=======
>>>>>>> FETCH_HEAD
}

-(void)leftButtonTap:(UIButton *)sender
{
    [self.airViewController showAirViewFromViewController:self.navigationController complete:nil];
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
