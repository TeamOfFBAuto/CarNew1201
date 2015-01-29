//
//  MyViewController.m
//  FBCircle
//
//  Created by soulnear on 14-5-12.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "MyViewController.h"
#import "RCIM.h"

@interface MyViewController ()
{
    UIPanGestureRecognizer * panGestureRecognizer;
    UISwipeGestureRecognizer * swipe;
}

@end

@implementation MyViewController
@synthesize leftButtonType = _leftButtonType;
@synthesize rightString = _rightString;
@synthesize leftImageName = _leftImageName;
@synthesize rightImageName = _rightImageName;
@synthesize leftString = _leftString;

@synthesize my_right_button = _my_right_button;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
       self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    if (_isAddGestureRecognizer) {
        panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestures:)];
        panGestureRecognizer.minimumNumberOfTouches = 1;
        panGestureRecognizer.maximumNumberOfTouches = 1;
        [self.view addGestureRecognizer:panGestureRecognizer];
        
        
        swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeOnAirImageView:)];
        swipe.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swipe];
    }
    
    [self updateUnreadNum:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.view removeGestureRecognizer:panGestureRecognizer];
    [self.view removeGestureRecognizer:swipe];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [XTSideMenuManager resetSideMenuRecognizerEnable:NO];

    
    if (MY_MACRO_NAME) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        //iOS 5 new UINavigationBar custom background
        
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:MY_MACRO_NAME?IOS7DAOHANGLANBEIJING_PUSH:IOS6DAOHANGLANBEIJING] forBarMetrics: UIBarMetricsDefault];
    }
    
    _myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,44)];
    _myTitleLabel.textAlignment = NSTextAlignmentCenter;
    _myTitleLabel.text = _myTitle;
    _myTitleLabel.textColor = [UIColor blackColor];
    _myTitleLabel.font = [UIFont systemFontOfSize:17];
    self.navigationItem.titleView = _myTitleLabel;
    
    spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = MY_MACRO_NAME?-5:5;
    
    self.navigationController.navigationBarHidden=NO;
    
    //监控未读消息数
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateUnreadNum:) name:NOTIFICATION_UNREADNUM object:nil];

}

#pragma mark - 更新未读消息条数

- (void)updateUnreadNum:(NSNotification *)notification
{
    int unreadNum = [[RCIM sharedRCIM]getTotalUnreadCount];
    
    unreadNum = (unreadNum >= 0) ? unreadNum : 0;
    
    NSLog(@"unreadNum -->%d",unreadNum);
    
    if ([LTools cacheBoolForKey:USER_IN] == NO) {
        
        unreadNum = 0;
    }
    
    if (unreadNum == 0) {
        
        _unreadNum_label.hidden = YES;
    }else
    {
        _unreadNum_label.hidden = NO;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.unreadNum_label.text = [NSString stringWithFormat:@"%d",unreadNum];
        
    });
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

-(void)setMyViewControllerLeftButtonType:(MyViewControllerLeftbuttonType)theType WithRightButtonType:(MyViewControllerRightbuttonType)rightType
{
    
    leftType = theType;
    myRightType = rightType;
    
    if (theType == MyViewControllerLeftbuttonTypeBack)
    {
        UIBarButtonItem * spaceButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButton1.width = MY_MACRO_NAME?-13:5;
        
        UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(MY_MACRO_NAME? -5:5,8,40,44)];
        [button_back addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [button_back setImage:[UIImage imageNamed:BACK_DEFAULT_IMAGE_GRAY] forState:UIControlStateNormal];
        UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
        self.navigationItem.leftBarButtonItems=@[spaceButton1,back_item];
    }else if (theType == MyViewControllerLeftbuttonTypelogo)
    {
        UIImageView * leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ios7logo"]];
        leftImageView.center = CGPointMake(MY_MACRO_NAME? 18:30,22);
        UIView *lefttttview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
        [lefttttview addSubview:leftImageView];
        UIBarButtonItem * leftButton = [[UIBarButtonItem alloc] initWithCustomView:lefttttview];
        
        self.navigationItem.leftBarButtonItems = @[spaceButton,leftButton];
    }else if(theType == MyViewControllerLeftbuttonTypeOther)
    {
        UIImage * leftImage = [UIImage imageNamed:_leftImageName];
        UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setImage:[UIImage imageNamed:self.leftImageName] forState:UIControlStateNormal];
        leftButton.frame = CGRectMake(0,0,leftImage.size.width,leftImage.size.height);
//        leftButton.backgroundColor = [UIColor orangeColor];
        UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItems = @[spaceButton,leftBarButton];
        
        if (self.isShowUnreadNumLabel) {
            
            
                self.unreadNum_label = [[UILabel alloc]initWithFrame:CGRectMake(leftButton.right - 5 - 10 + 2, -5, 14, 14)];
                self.unreadNum_label.backgroundColor = [UIColor colorWithHexString:@"fe0000"];
                self.unreadNum_label.layer.cornerRadius = 7;
                self.unreadNum_label.textColor = [UIColor whiteColor];
                self.unreadNum_label.font = [UIFont systemFontOfSize:9];
                self.unreadNum_label.clipsToBounds = YES;
                self.unreadNum_label.textAlignment = NSTextAlignmentCenter;
                [leftButton addSubview:self.unreadNum_label];
                
        }

        
        
    }else if (theType == MyViewControllerLeftbuttonTypeText)
    {
        UIButton * left_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        left_button.frame = CGRectMake(0,0,30,44);
        
        left_button.titleLabel.textAlignment = NSTextAlignmentRight;
        
        [left_button setTitle:_leftString forState:UIControlStateNormal];
        
        left_button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [left_button setTitleColor:RGBCOLOR(91,138,59) forState:UIControlStateNormal];
        
        [left_button addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItems = @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:left_button]];
    }else
    {
        UIButton * left_button = [UIButton buttonWithType:UIButtonTypeCustom];
        left_button.frame = CGRectMake(0,0,30,44);
        self.navigationItem.leftBarButtonItems = @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:left_button]];

    }
    
    
    
    if (rightType == MyViewControllerRightbuttonTypeRefresh)
    {
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_my_right_button setImage:[UIImage imageNamed:@"ios7_refresh4139.png"] forState:UIControlStateNormal];
        _my_right_button.frame = CGRectMake(0,0,41/2,39/2);
        _my_right_button.center = CGPointMake(300,20);
        [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItems= @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
        
    }else if (rightType == MyViewControllerRightbuttonTypeSearch)
    {
        UIButton *rightview=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 37, 37/2)];
        rightview.backgroundColor=[UIColor clearColor];
        [rightview addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_my_right_button setImage:[UIImage imageNamed:@"ios7_newssearch.png"] forState:UIControlStateNormal];
        _my_right_button.frame = CGRectMake(MY_MACRO_NAME? 25:10, 0, 37/2, 37/2);
        //    refreshButton.center = CGPointMake(300,20);
        [rightview addSubview:_my_right_button];
        [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *_rightitem=[[UIBarButtonItem alloc]initWithCustomView:rightview];
        self.navigationItem.rightBarButtonItem=_rightitem;
        
    }else if(rightType == MyViewControllerRightbuttonTypeText)
    {
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _my_right_button.frame = CGRectMake(0,0,30,44);
        
        _my_right_button.titleLabel.textAlignment = NSTextAlignmentRight;
        
        [_my_right_button setTitle:_rightString forState:UIControlStateNormal];
        
        _my_right_button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        [_my_right_button setTitleColor:RGBCOLOR(80,80,80) forState:UIControlStateNormal];
        
        [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.rightBarButtonItems = @[spaceButton,[[UIBarButtonItem alloc] initWithCustomView:_my_right_button]];
        
    }else if (rightType == MyViewControllerRightbuttonTypeDelete)
    {
        
    }else if (rightType == MyViewControllerRightbuttonTypePerson)
    {
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _my_right_button.frame = CGRectMake(0,0,36/2,33/2);
        
        [_my_right_button setImage:[UIImage imageNamed:@"chat_people.png"] forState:UIControlStateNormal];
        
        [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem * People_button = [[UIBarButtonItem alloc] initWithCustomView:_my_right_button];
        
        self.navigationItem.rightBarButtonItems = @[spaceButton,People_button];
        
        
    }else if(rightType == MyViewControllerRightbuttonTypeOther)
    {
        UIImage * rightImage = [UIImage imageNamed:_rightImageName];
        
        _my_right_button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_my_right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        [_my_right_button setImage:[UIImage imageNamed:self.rightImageName] forState:UIControlStateNormal];
        
        _my_right_button.frame = CGRectMake(0,0,rightImage.size.width,rightImage.size.height);
        
        UIBarButtonItem * rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:_my_right_button];
        
        self.navigationItem.rightBarButtonItems = @[spaceButton,rightBarButton];;
        
    }else
    {
        
    }
    
}

-(void)setMyTitle:(NSString *)myTitle
{
    _myTitle = myTitle;
    _myTitleLabel.text = _myTitle;
}

-(void)setLeftString:(NSString *)leftString
{
    _leftString = leftString;
    [self setMyViewControllerLeftButtonType:leftType WithRightButtonType:myRightType];
}
-(void)setRightString:(NSString *)rightString
{
    _rightString = rightString;
    [self setMyViewControllerLeftButtonType:leftType WithRightButtonType:myRightType];
}
-(void)setRightImageName:(NSString *)rightImageName
{
    _rightImageName = rightImageName;
    [self setMyViewControllerLeftButtonType:leftType WithRightButtonType:myRightType];
}
-(void)setLeftImageName:(NSString *)leftImageName
{
    _leftImageName = leftImageName;
    [self setMyViewControllerLeftButtonType:leftType WithRightButtonType:myRightType];
}

-(void)setIsAddGestureRecognizer:(BOOL)isAddGestureRecognizer
{
    _isAddGestureRecognizer = isAddGestureRecognizer;
    if (!isAddGestureRecognizer)
    {
        [self.view removeGestureRecognizer:panGestureRecognizer];
        [self.view removeGestureRecognizer:swipe];
    }
}


-(void)rightButtonTap:(UIButton *)sender
{
    
}

-(void)leftButtonTap:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
