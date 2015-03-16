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
    ///数据统计代表的数字
    NSString * current_show_num;
}
@end

@implementation GscoreStarViewController


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillDisappear:YES];
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
    if (self.commentType == Comment_Anli) {
        
        current_show_num = @"1";
        
    }else if (self.commentType == Comment_DianPu){
        
        current_show_num = @"2";
        
    }else if (self.commentType == Comment_PeiJian){
        
        current_show_num = @"3";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,44)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"我要点评";
    titleLabel.font = [UIFont systemFontOfSize:18];
    self.navigationItem.titleView = titleLabel;
    
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
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setFrame:CGRectMake(0,0,36/2,33/2)];
    [rightBtn setImage:[UIImage imageNamed:@"dianping.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(Gdismiss) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    
    self.navigationItem.rightBarButtonItem = right;
    
    
    //框
    UIView *textview_backView = [[UIView alloc]initWithFrame:CGRectMake(20, 20, 280*GscreenRatio_320, 120)];
    
    textview_backView.layer.borderColor = [RGBCOLOR(253, 144, 39)CGColor];
    textview_backView.layer.borderWidth = 0.5;
    [self.view addSubview:textview_backView];
    
    //textview
    _tv = [[UITextView alloc]initWithFrame:CGRectMake(5,5, textview_backView.frame.size.width-20, textview_backView.frame.size.height-20)];
    _tv.delegate = self;
    _tv.font = [UIFont systemFontOfSize:16];
    [_tv becomeFirstResponder];
    [textview_backView addSubview:_tv];
    
    //星星view
    TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake((DEVICE_WIDTH-(75/2.0f)*5)*0.5, CGRectGetMaxY(textview_backView.frame)+16,(75/2.0f)*5,72/2) numberOfStar:5];
    starRatingView.delegate = self;
    [self.view addSubview:starRatingView];
    
    
    self.theScore = 5.0;//默认是五星
    
    //提交评论按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setBackgroundColor:RGBCOLOR(253, 144, 39)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(20, CGRectGetMaxY(starRatingView.frame)+20, 280*GscreenRatio_320, 46)];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    [btn setTitle:@"提交评论" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(clickToComment:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma mark - 事件处理

- (void)clickToComment:(UIButton *)sender
{
    
    [self allShou];
    
    self.cc_content = [self.cc_content stringByReplacingEmojiUnicodeWithCheatCodes];
    
    
    self.cc_content = [self.cc_content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (self.cc_content.length == 0) {
        
        [ZSNApi showAutoHiddenMBProgressWithText:@"评论不能为空" addToView:self.view];
        
        return;
    }
    
    //点5
    if (self.theScore - (int)self.theScore >=0.5) {
        self.theScore = (int)self.theScore+0.5;
    }else{
        self.theScore = (int)self.theScore;
    }
    
    [self networkForCommentContent:self.cc_content score:[NSString stringWithFormat:@"%.1f",self.theScore]];
}


#pragma mark - 网络请求

/**
 *  添加评论
 */
- (void)networkForCommentContent:(NSString *)content score:(NSString *)scoreStr
{
    [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_CHAT WithObject:current_show_num WithValue:_commentId];
    
    NSString *api;
    
    if (self.commentType == Comment_Anli) {
        
        api = COMMENT_ANLI_API;
        
    }else if (self.commentType == Comment_DianPu){
        
        api = COMMENT_DIANPU_API;
        
    }else if (self.commentType == Comment_PeiJian){
        
        api = COMMENT_PEIJIAN_API;
    }
    
    NSString *url = [NSString stringWithFormat:api,[GMAPI getAuthkey],self.commentId,scoreStr,content];
    
    
    NSLog(@"评论的url:%@",url);
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        
        [LTools showMBProgressWithText:result[@"errinfo"] addToView:self.view];
        
        int errcode = [[result objectForKey:@"errcode"]intValue];
        
        if (errcode == 0) {
            
            [self performSelector:@selector(Gdismiss) withObject:nil afterDelay:0.5];
            
            ///发送评论成功通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"successedComment" object:nil];
            
        }else
        {
            
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [LTools showMBProgressWithText:failDic[@"errinfo"] addToView:self.view];
        
    }];
}



@end
