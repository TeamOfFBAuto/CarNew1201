//
//  NewLogInView.h
//  CustomNewProject
//
//  Created by soulnear on 15-1-26.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewLogInView : UIView
{
    UIView * main_view;
    UIImageView * up_background_imageView;
    UIImageView * bottom_background_view;
    UIButton * loginButton;
    UIButton * zhuce_button;
}

///用户名
@property(nonatomic,strong)UITextField * username_tf;
///密码
@property(nonatomic,strong)UITextField * password_tf;
///邮箱
@property(nonatomic,strong)UITextField * email_tf;
///电话号码
@property(nonatomic,strong)UITextField * phone_tf;
///验证码
@property(nonatomic,strong)UITextField * code_tf;


@end
