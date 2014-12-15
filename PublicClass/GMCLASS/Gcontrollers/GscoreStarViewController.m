//
//  GscoreStarViewController.m
//  CustomNewProject
//
//  Created by gaomeng on 14/12/15.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "GscoreStarViewController.h"
#import "GMAPI.h"
#import "TQStarRatingView.h"

@interface GscoreStarViewController ()<StarRatingViewDelegate,UITextViewDelegate>
{
    UITextView *_tv;//textView
}
@end

@implementation GscoreStarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我要点评";
    
    //收键盘
    UIControl *backControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [backControl addTarget:self action:@selector(allShou) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:backControl];
    
    
    
    //叉叉
//    UIView *rightView_buttonItem = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
//    rightView_buttonItem.userInteractionEnabled = YES;
//    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
//    [imv setImage:[UIImage imageNamed:@"logIn_close.png"]];
//    [rightView_buttonItem addSubview:imv];
//    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightView_buttonItem];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"logIn_close.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(Gdismiss)];
    
    
    self.navigationItem.rightBarButtonItem = right;
    
//    self.navigationItem.rightBarButtonItems = []
    
    
    //框
    UIView *textview_backView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 280*GscreenRatio_320, 120)];
    
    textview_backView.layer.borderColor = [RGBCOLOR(253, 144, 39)CGColor];
    textview_backView.layer.borderWidth = 0.5;
    [self.view addSubview:textview_backView];
    
    //textview
    _tv = [[UITextView alloc]initWithFrame:CGRectMake(15, 15, textview_backView.frame.size.width-30, textview_backView.frame.size.height-30)];
    _tv.delegate = self;
    [textview_backView addSubview:_tv];
    
    //星星view
    TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(textview_backView.frame)+16, 210*GscreenRatio_320, 35) numberOfStar:5];
    starRatingView.delegate = self;
    [self.view addSubview:starRatingView];
    
    //提交评论按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setBackgroundColor:RGBCOLOR(253, 144, 39)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(20, CGRectGetMaxY(starRatingView.frame)+20, 280*GscreenRatio_320, 46)];
    [btn setTitle:@"提交评论" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    
    
}


-(void)starRatingView:(TQStarRatingView *)view score:(float)score
{
    self.theScore = score*10/2.0;
    
    NSLog(@"score:%f",self.theScore);
}


-(void)Gdismiss{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}



-(void)allShou{
    [_tv resignFirstResponder];
}




- (void)textViewDidChange:(UITextView *)textView{
    
    
    self.cc_content = textView.text;
    NSLog(@"评论内容%@",self.cc_content);
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
