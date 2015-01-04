//
//  GloginView.m
//  FBAuto
//
//  Created by gaomeng on 14-7-1.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GloginView.h"

#import "LogInViewController.h"

#define backGroundImageName @"loginBackground@2x.png"
#define logoImageName @"logo@2x.png"
#define shurukuangimageName @""
#define logoImvWidth 150
#define logoImvHight 75



@implementation GloginView



- (void)dealloc
{
    
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"gdenglu" object:nil];
    
    NSLog(@"%s",__FUNCTION__);
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        if (iPhone5) {
            _Frame_row3Down = CGRectMake(24, 210+20, 275, 350);
            _Frame_row3Up = CGRectMake(24, 312-180+20, 275, 350);
            
            _Frame_logoDown = CGRectMake((self.bounds.size.width-logoImvWidth)/2, 70, logoImvWidth, logoImvHight);
            _Frame_logoUp = CGRectMake((self.bounds.size.width-logoImvWidth)/2, 40, logoImvWidth, logoImvHight);
            
        }else if (iPhone6 || iPhone6PLUS){
            _Frame_row3Down = CGRectMake(24, 210.00/320*ALL_FRAME_WIDTH, 280.00/320*ALL_FRAME_WIDTH, 350.00/320*ALL_FRAME_WIDTH);
            _Frame_row3Up = CGRectMake(24, (312.00-180)/320*ALL_FRAME_WIDTH, 280.00/320*ALL_FRAME_WIDTH, 350.00/320*ALL_FRAME_WIDTH);
            
            _Frame_logoDown = CGRectMake((self.bounds.size.width-logoImvWidth)/2, 70, logoImvWidth, logoImvHight);
            _Frame_logoUp = CGRectMake((self.bounds.size.width-logoImvWidth)/2, 40, logoImvWidth, logoImvHight);
        }else{
            _Frame_row3Down = CGRectMake(24, 210, 275, 350);
            _Frame_row3Up = CGRectMake(24, 312-180-50, 275, 350);
            
            _Frame_logoDown = CGRectMake((self.bounds.size.width-logoImvWidth)/2, 70, logoImvWidth, logoImvHight);
            _Frame_logoUp = CGRectMake((self.bounds.size.width-logoImvWidth)/2, 20, logoImvWidth, logoImvHight*0.8);
        }
        
        
        
        
        
        //点击回收键盘
        UIControl *backControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, 320, 568)];
        [backControl addTarget:self action:@selector(Gshou) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backControl];
        
        //背景图
        UIImageView *backGroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:backGroundImageName]];
        backGroundImageView.frame = CGRectMake(0, 0, ALL_FRAME_WIDTH, DEVICE_HEIGHT);
        [self addSubview:backGroundImageView];

        
        //logo图
        UIImageView *logoImv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:logoImageName] highlightedImage:nil];
        logoImv.frame = _Frame_logoDown;
        logoImv.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:logoImv];
        self.logoImv = logoImv;

        
        
        
        //账号 密码 登录 底层view
        self.Row3backView = [[UIView alloc]initWithFrame:_Frame_row3Down];
        [self addSubview:self.Row3backView];
        
        
        //账号和密码输入框
        //输入框
        _zhanghaoBackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 275.00/320*ALL_FRAME_WIDTH, 45)];
        _zhanghaoBackView.layer.borderColor = [UIColor whiteColor].CGColor;
        _zhanghaoBackView.layer.borderWidth = 1;
        
        if (iPhone6PLUS) {
            [_zhanghaoBackView setFrame:CGRectMake(0, 0, 280.00/320*ALL_FRAME_WIDTH, 45)];
        }
        
        
        _passWordBackView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 60, 275.00/320*ALL_FRAME_WIDTH, 45)];
        _passWordBackView.layer.borderColor = [UIColor whiteColor].CGColor;
        _passWordBackView.layer.borderWidth = 1;
        if (iPhone6PLUS) {
            [_passWordBackView setFrame:CGRectMake(0, 60, 280.00/320*ALL_FRAME_WIDTH, 45)];
        }
        
        
        
        UIColor *a_color = RGBCOLOR(164, 164, 164);
        a_color = [UIColor redColor];
        
        
        //用户名图标
        UIImageView *userImv = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 15, 15)];
        [userImv setImage:[UIImage imageNamed:@"login_userName_image@2x.png"]];
        [_zhanghaoBackView addSubview:userImv];
        
        
        
        //密码图标
        UIImageView *passwordImv = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 15, 15)];
        [passwordImv setImage:[UIImage imageNamed:@"login_mima_image@2x.png"]];
        [_passWordBackView addSubview:passwordImv];
        
        
        //竖线
        UIView *shuxian1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userImv.frame)+10, userImv.frame.origin.y, 0.5, 15)];
        shuxian1.backgroundColor = RGBCOLOR(128, 129, 134);
        [_zhanghaoBackView addSubview:shuxian1];
        UIView *shuxian2 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(passwordImv.frame)+10, passwordImv.frame.origin.y, 0.5, 15)];
        shuxian2.backgroundColor = RGBCOLOR(128, 129, 134);
        [_passWordBackView addSubview:shuxian2];
        
        //输入textField
        //用户名
        self.userTf = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(userImv.frame)+20, 0,220.00/320*ALL_FRAME_WIDTH, 45)];
        self.userTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.userTf.keyboardType = UIKeyboardTypeDefault;
        self.userTf.textColor = [UIColor whiteColor];
        self.userTf.delegate = self;
        self.userTf.tag = 50;
        self.userTf.placeholder = @"用户名";
        [self.userTf setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        
        //密码
        self.passWordTf = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(passwordImv.frame)+20, 60, 220.00/320*ALL_FRAME_WIDTH, 45)];
        self.passWordTf.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.passWordTf.secureTextEntry = YES;
        self.passWordTf.textColor = a_color;
        self.passWordTf.delegate = self;
        self.passWordTf.tag = 51;
        self.passWordTf.placeholder = @"密码";
        self.passWordTf.textColor = [UIColor whiteColor];
        [self.passWordTf setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        
        [self.Row3backView addSubview:_zhanghaoBackView];
        [self.Row3backView addSubview:_passWordBackView];
        [self.Row3backView addSubview:self.userTf];
        [self.Row3backView addSubview:self.passWordTf];
        
        
        
        //登录
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.backgroundColor = RGBCOLOR(253, 145, 39);
        [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
        loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        loginBtn.titleLabel.textColor = [UIColor whiteColor];
        loginBtn.frame = CGRectMake(0, 120, 275.00/320*ALL_FRAME_WIDTH, 50);
        if (iPhone6PLUS) {
            [loginBtn setFrame:CGRectMake(0, 120, 280.00/320*ALL_FRAME_WIDTH, 50)];
        }
        
        [loginBtn addTarget:self action:@selector(denglu) forControlEvents:UIControlEventTouchUpInside];
        [self.Row3backView addSubview:loginBtn];
        
        
        
        //注册
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn1 setTitle:@"注册账号" forState:UIControlStateNormal];
        if (iPhone5) {
            btn1.frame = CGRectMake(105.00/320*ALL_FRAME_WIDTH, CGRectGetMaxY(loginBtn.frame)+110, 65, 30);
        }else if (iPhone6PLUS || iPhone6){
            btn1.frame = CGRectMake(115.00/320*ALL_FRAME_WIDTH, CGRectGetMaxY(loginBtn.frame)+110, 65, 30);
        }else{
            btn1.frame = CGRectMake(105.00/320*ALL_FRAME_WIDTH, CGRectGetMaxY(loginBtn.frame)+40, 65, 30);
        }
        
        btn1.titleLabel.font = [UIFont systemFontOfSize:15];
        btn1.titleLabel.textColor = RGBCOLOR(123, 123, 123);
        [btn1 addTarget:self action:@selector(zhuce) forControlEvents:UIControlEventTouchUpInside];
        [self.Row3backView addSubview:btn1];
        
        
        //竖线
        UIView *shuxian3 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame)+10, btn1.frame.origin.y+8, 0.5, 15)];
        shuxian3.backgroundColor = RGBCOLOR(128, 129, 134);
        [self.Row3backView addSubview:shuxian3];
        shuxian3.hidden = YES;
        
        //忘记密码
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn2 setTitle:@"忘记密码" forState:UIControlStateNormal];
        btn2.frame = CGRectMake(CGRectGetMaxX(btn1.frame)+27, btn1.frame.origin.y, 65, 30);
        btn2.titleLabel.font = [UIFont systemFontOfSize:15];
        btn2.titleLabel.textColor = RGBCOLOR(123, 123, 123);
        [self.Row3backView addSubview:btn2];
        btn2.hidden = YES;
        
        [btn2 addTarget:self action:@selector(findmima) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        //接受登录的通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Gshou) name:@"gdenglu" object:nil];
        
    }
    return self;
}


//block的set方法

-(void)setZhuceBlock:(zhuceBlock)zhuceBlock{
    _zhuceBlock = zhuceBlock;
}
-(void)setFindPassBlock:(findPasswBlock)findPassBlock{
    _findPassBlock = findPassBlock;
}
-(void)setDengluBlock:(dengluBlock)dengluBlock{
    _dengluBlock = dengluBlock;
}


//收键盘
-(void)Gshou{
    
    if (self.userTf) {
        [self.userTf resignFirstResponder];
    }
    
    if (self.passWordTf) {
        [self.passWordTf resignFirstResponder];
    }
    
    
    if (self.Row3backView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.Row3backView.frame = _Frame_row3Down;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    
    
    if (self.logoImv) {
        [UIView animateWithDuration:0.3 animations:^{
            self.logoImv.frame = _Frame_logoDown;
        } completion:^(BOOL finished) {
            
        }];
    }
    
    
    
    
}




//#pragma mark - UITextFieldDelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    return YES;
//}





//键盘出现
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"beginInput" object:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.Row3backView.frame = _Frame_row3Up;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.logoImv.frame = _Frame_logoUp;
    } completion:^(BOOL finished) {
        
    }];
    
    return YES;
}




//注册
-(void)zhuce{
    if (self.zhuceBlock) {
        self.zhuceBlock();
    }
}

//找回密码
-(void)findmima{
    if (self.findPassBlock) {
        self.findPassBlock();
    }
}


//登录
-(void)denglu{
    if (self.dengluBlock) {
        self.dengluBlock(self.userTf.text,self.passWordTf.text);
    }
}



-(void)cleanUserNameAndPassWordTextfied{
    
    if (self.userTf) {
        self.userTf.text = @"";
    }
    
    
    if (self.passWordTf) {
        self.passWordTf.text = @"";
    }
    
}

@end
