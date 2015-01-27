//
//  NewLogInView.m
//  CustomNewProject
//
//  Created by soulnear on 15-1-26.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "NewLogInView.h"

@implementation NewLogInView



-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        [self setup];
        
        [self createLoginView];
    }
    return self;
}

///创建视图
-(void)setup
{
    ///背景图
    main_view = [[UIView alloc] initWithFrame:CGRectMake(0,0,208,204)];
    main_view.backgroundColor = [UIColor clearColor];
    main_view.clipsToBounds = YES;
    main_view.center = CGPointMake(DEVICE_WIDTH/2.0f,DEVICE_HEIGHT/2.0f);
    [self addSubview:main_view];
    
    ///顶部logo
    up_background_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,413/2.0f,112/2.0f)];
    up_background_imageView.image = [UIImage imageNamed:@"Loginview_up_background_image"];
    up_background_imageView.userInteractionEnabled = YES;
    [main_view addSubview:up_background_imageView];
    
    ///关闭按钮
    UIButton * close_button = [UIButton buttonWithType:UIButtonTypeCustom];
    close_button.frame = CGRectMake(main_view.width-30,0,30,30);
    [close_button setImage:[UIImage imageNamed:@"LogInView_close"] forState:UIControlStateNormal];
    [close_button addTarget:self action:@selector(closeTap:) forControlEvents:UIControlEventTouchUpInside];
    [main_view addSubview:close_button];
    
    ///底部视图
    bottom_background_view = [[UIImageView alloc] initWithFrame:CGRectMake(0,main_view.height-81,main_view.width,81)];
    bottom_background_view.image = [UIImage imageNamed:@"loginview_bottom_background_image"];
    bottom_background_view.userInteractionEnabled = YES;
    [main_view addSubview:bottom_background_view];
}

#pragma makr - 创建登陆视图
-(void)createLoginView
{
    ///登陆按钮
    loginButton = [self createButtonWithFrame:CGRectMake(11,274/2.0f,186,29) WithTitle:@"登录" WithTag:100];
    [main_view addSubview:loginButton];
    
    ///注册按钮
    zhuce_button = [UIButton buttonWithType:UIButtonTypeCustom];
    zhuce_button.frame = loginButton.frame;
    zhuce_button.tag = 99;
    zhuce_button.top = loginButton.bottom + 10;
    zhuce_button.height = 20;
    zhuce_button.backgroundColor = [UIColor clearColor];
    [zhuce_button setTitle:@"创建一个新账号>>" forState:UIControlStateNormal];
    [zhuce_button setTitleColor:RGBCOLOR(142,142,142) forState:UIControlStateNormal];
    zhuce_button.titleLabel.font = [UIFont systemFontOfSize:14];
    [zhuce_button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [main_view addSubview:zhuce_button];
    
    
    _username_tf = [self createTextFieldWithPlaceHolder:@"用户名" WithFrame:CGRectMake(0.5,up_background_imageView.bottom,main_view.width-1,35)];
    UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(0.5,_username_tf.bottom,main_view.width,0.5)];
    _password_tf = [self createTextFieldWithPlaceHolder:@"密码" WithFrame:CGRectMake(0.5,line_view.bottom,main_view.width-1,35)];
    
    line_view.backgroundColor = RGBCOLOR(194,197,200);
    
    
    [main_view addSubview:line_view];
    [main_view addSubview:_username_tf];
    [main_view addSubview:_password_tf];
    
    
    [UIView animateWithDuration:0.3 animations:^{
        main_view.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 创建输入手机号码界面
-(void)createPhoneView
{
    
    UIView * phone_jieshao_view = [[UIView alloc] initWithFrame:CGRectMake(up_background_imageView.width,up_background_imageView.bottom,up_background_imageView.width,50)];
    phone_jieshao_view.backgroundColor = [UIColor whiteColor];
    [main_view addSubview:phone_jieshao_view];
    
    UILabel * phone_jieshao_label = [[UILabel alloc] initWithFrame:CGRectMake(15,0,phone_jieshao_view.width-30,50)];
    phone_jieshao_label.numberOfLines = 0;
    phone_jieshao_label.text = @"如果您要注册,我们通过验证手机号码为您发一个清晰的编码";
    phone_jieshao_label.textAlignment = NSTextAlignmentLeft;
    phone_jieshao_label.textColor = RGBCOLOR(90, 90, 90);
    phone_jieshao_label.font = [UIFont systemFontOfSize:12];
    [phone_jieshao_view  addSubview:phone_jieshao_label];
    
    _phone_tf = [self createTextFieldWithPlaceHolder:@"手机号码" WithFrame:CGRectMake(up_background_imageView.width,phone_jieshao_view.bottom,main_view.width,35)];
    [main_view addSubview:_phone_tf];
    
    UIButton * get_code_button = [self createButtonWithFrame:CGRectMake(11,main_view.height,186,29) WithTitle:@"获取验证码" WithTag:101];
    [bottom_background_view addSubview:get_code_button];
    
    
    [UIView animateWithDuration:0.4 animations:^{
        _username_tf.left = -_username_tf.width;
        _password_tf.left = -_password_tf.width;
        loginButton.left = -loginButton.width;
        zhuce_button.alpha = -zhuce_button.width;
        bottom_background_view.top = 140;
        bottom_background_view.height = 54;
        phone_jieshao_view.left = 0;
        _phone_tf.left = 0;
        get_code_button.top = 12.5;
    } completion:^(BOOL finished) {
        
    }];
    
//    [UIView animateKeyframesWithDuration:0.5 delay:0.2 options:UIViewKeyframeAnimationOptionOverrideInheritedDuration animations:^{
//        phone_jieshao_view.left = 0;
//        _phone_tf.left = 0;
//        get_code_button.top = 12.5;
//    } completion:^(BOOL finished) {
//        
//    }];
}


///创建输入框
-(UITextField *)createTextFieldWithPlaceHolder:(NSString *)placeHolder WithFrame:(CGRect)frame
{
    UITextField * textField = [[UITextField alloc] initWithFrame:frame];
    textField.textColor = RGBCOLOR(91,91,91);
    textField.font = [UIFont systemFontOfSize:14];
    textField.placeholder = placeHolder;
    textField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    
    UIView *userNameview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,8,8)];
    userNameview.userInteractionEnabled = NO;
    textField.leftView = userNameview;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}
///创建确认按钮
-(UIButton *)createButtonWithFrame:(CGRect)frame WithTitle:(NSString *)aTitle WithTag:(int)aTag
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = aTag;
    button.backgroundColor = RGBCOLOR(255,180,0);
    [button setTitle:aTitle forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

#pragma mark - 完成按钮
-(void)buttonTap:(UIButton *)button
{
    switch (button.tag) {
        case 99:///注册按钮
        {
            [self createPhoneView];
        }
            break;
        case 100:///登陆按钮
        {
            
        }
            break;
        case 101:///获取验证码
        {
            
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - 关闭按钮操作
-(void)closeTap:(UIButton *)button
{
    [self removeFromSuperview];
}


@end
