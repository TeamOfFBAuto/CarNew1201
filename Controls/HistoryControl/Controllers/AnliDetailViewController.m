//
//  AnliDetailViewController.m
//  CustomNewProject
//
//  Created by lichaowei on 14/12/2.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "AnliDetailViewController.h"
#import "ShareView.h"

#import "WeiboSDK.h"
#import "WXApi.h"

#import <MessageUI/MessageUI.h>

#import "NavigationFunctionView.h"
#import "LShareTools.h"

#import "BusinessHomeViewController.h"
#import "BusinessViewController.h"

#import "LogInViewController.h"

#import "GscoreStarViewController.h"

#import "CommentBottomView.h"
#import "BusinessDetailModel.h"

#import "BusinessCommentView.h"

#import "FBMapViewController.h"

#import "ChatViewController.h"

#import "RCIM.h"



@interface AnliDetailViewController ()<MFMailComposeViewControllerDelegate,UIWebViewDelegate,UIScrollViewDelegate>
{
    ShareView *_shareView;
    MBProgressHUD *loading;
    NavigationFunctionView * functionView;
    
    UIView *comment_view;//评论视图
    
//    CommentBottomView *bottomView;
    
    CGFloat currentOffY;
    
    UIView *progress;
    UIView *greenView;//绿色
    NSTimer *timer;
    
    BOOL isCollect;
    
    ///底部评论视图
    BusinessCommentView * bottomView;
    ///返回按钮
    UIButton * back_button;
    ///菜单按钮
    UIButton * right_button;
    
    CGFloat web_old_height;//记录原始高度
    
    BOOL noHidden;//不需要隐藏
    
    NSString * CURRENT_SHOW_NUM;
}

///存放标题、图片、是否收藏 、简介信息
@property(nonatomic,strong)BusinessDetailModel * detail_info;

@end

@implementation AnliDetailViewController

- (void)dealloc
{
    NSLog(@"---dealloc");
    [self.webView stopLoading];
    self.webView.delegate = nil;
    self.webView = nil;
    bottomView = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
   // [self updateStatusBarColor];
    [MobClick beginEvent:@"AnliDetailViewController"];
    
    [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_GOTO WithObject:CURRENT_SHOW_NUM WithValue:@""];
}

//更新状态栏颜色

- (void)updateStatusBarColor
{
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self setNavigationViewHidden:NO];
    self.edgesForExtendedLayout = UIRectEdgeAll;

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [MobClick endEvent:@"AnliDetailViewController"];
}

-(void)back:(UIButton *)button
{
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
//    if (self.isFromAnli) {
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    currentOffY = 0.f;
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH,DEVICE_HEIGHT)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    if (self.detailType == Detail_Peijian) {
        _webView.scrollView.delegate = self;
    }
    
    
    _webView.scrollView.bounces = NO;
    
    NSString *api;
    if (self.detailType == Detail_Anli) {
        
        api = [NSString stringWithFormat:ANLI_DETAIL,self.anli_id,[GMAPI getAuthkey]];
        
    }else if (self.detailType == Detail_Peijian){
        
        api =[NSString stringWithFormat:ANLI_PEIJIAN_DETAIL,self.anli_id,[GMAPI getAuthkey]];
    }
    
    NSString *url = [NSString stringWithFormat:api,self.anli_id,[GMAPI getUid]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    self.webView.backgroundColor = COLOR_WEB_DETAIL_BACKCOLOR;
    
    self.view.backgroundColor = COLOR_WEB_DETAIL_BACKCOLOR;
    
    CURRENT_SHOW_NUM = @"1";
    if (self.detailType == Detail_Peijian) {
        CURRENT_SHOW_NUM = @"3";
        _webView.height = DEVICE_HEIGHT-64;
        [self createBottom];
    }
    
    
    [self setNavgationView];
    
//    [self rightButtonTap:nil];
    
    [self networkForCollectState];//获取收藏状态
    
    
    [self progress];//底部进度条
    
    
    ///接受评论成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successComment) name:@"successedComment" object:nil];
    ///接受收藏变更通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successComment) name:G_USERCENTERLOADUSERINFO object:nil];
}

- (void)progress
{
    progress = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT - 2, DEVICE_WIDTH, 2)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    
    greenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, progress.height)];
    greenView.backgroundColor = RGBCOLOR(0, 255, 0);
    [progress addSubview:greenView];
    
    [self progressAnimation];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:5.f target:self selector:@selector(progressToFinish) userInfo:nil repeats:NO];

}

- (void)progressAnimation
{
    CGFloat seg = DEVICE_WIDTH / 10.f;
    
    
        [UIView animateWithDuration:1.5 animations:^{
            
            if (greenView.width <= 7 * seg) {
                
                greenView.width = 7 * seg;
                
            }
            
        } completion:^(BOOL finished) {
            
            
            [UIView animateWithDuration:1.5 animations:^{
                
                greenView.width = 9 * seg;
                
            }];
            
        }];
}

- (void)progressToFinish
{
    NSLog(@"------finish 5s");
    
    [timer invalidate];
    
    [UIView animateWithDuration:1.f animations:^{
        
        greenView.width = DEVICE_WIDTH;
        
    } completion:^(BOOL finished) {
        
        [greenView removeFromSuperview];
        greenView = nil;
        [progress removeFromSuperview];
        progress = nil;
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 分享

-(void)rightButtonTap:(UIButton *)button
{
    if (!functionView)
    {
        functionView = [[NavigationFunctionView alloc] init];
        functionView.myHidden = YES;
        [self.view addSubview:functionView];
        
        if (self.detailType == Detail_Peijian)
        {
            [functionView setIsShowThirdButton:NO];
        }
        
        
        __weak typeof(self)weakSelf = self;
        
        __weak typeof(functionView)weakFucntion = functionView;
        [functionView setFunctionBlock:^(int index) {
            
            if (index == 0) {
                
                [MobClick event:@"AnliDetailViewController_fenxiang"];
                
                [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_SHARE WithObject:CURRENT_SHOW_NUM WithValue:weakSelf.anli_id];
                
                LShareTools *tool = [LShareTools shareInstance];
                
                NSString *url; //= [NSString stringWithFormat:ANLI_DETAIL_SHARE,weakSelf.anli_id,[GMAPI getAuthkey]];
                
                if (weakSelf.detailType == Detail_Peijian) {
                    url = [NSString stringWithFormat:PEIJIAN_SHARE_URL,weakSelf.anli_id];
                }else
                {
                    url = [NSString stringWithFormat:ANLI_DETAIL_SHARE,weakSelf.anli_id,[GMAPI getAuthkey]];
                }
                
//                NSString *imageUrl = weakSelf.detail_info.pichead;
                
//                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
                
                [tool showOrHidden:YES title:weakSelf.detail_info.title description:weakSelf.detail_info.content imageUrl:weakSelf.detail_info.pichead aShareImage:weakSelf.storeImage linkUrl:url isNativeImage:NO];
                
            }else if (index == 1){
                [MobClick event:@"AnliDetailViewController_dianzan"];
                [weakSelf clickToCollectAction];
            }else if (index == 2){
                
                [MobClick event:@"AnliDetailViewController_quxiaomaodian"];
                
                [weakFucntion setEyesState:NO];
                
                if (!weakFucntion.isOpen) {
                    
                    [weakSelf.webView stringByEvaluatingJavaScriptFromString:@"$.showBtn();"];
                    
                }else
                {
                    [weakSelf.webView stringByEvaluatingJavaScriptFromString:@"$.hideBtn();"];
                }
            }
            
        }];
    }
    
    [functionView setCollectionState:isCollect];
    
    functionView.myHidden = !functionView.myHidden;
}

- (void)clickToCollectAction
{
    BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
    if (!isLogIn) {
//        LogInViewController * logInVc = [[LogInViewController alloc] init];
//        [self presentViewController:logInVc animated:YES completion:nil];
        
        NewLogInView * loginView = [[NewLogInView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT)];
        loginView.backgroundColor = [UIColor colorWithPatternImage:[ZSNApi screenShot]];
        [[UIApplication sharedApplication].keyWindow addSubview:loginView];
        return;
    }
    
    
    
    if (isCollect) {
        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_CANCEL_COLLECT WithObject:CURRENT_SHOW_NUM WithValue:_anli_id];
        [self networkForCancelCollect];
        
    }else
    {
        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_ADD_COLLECT WithObject:CURRENT_SHOW_NUM WithValue:_anli_id];
        [self networkForCollect];
    }
}

#pragma mark -  网络请求

/**
 *  收藏状态(调取的详情接口)
 */
- (void)networkForCollectState
{
    NSString *url;
    if (self.detailType == Detail_Anli) {
        
        url = [NSString stringWithFormat:ANLI_COLLECT_STATE,self.anli_id,[GMAPI getAuthkey]];
        
    }else if (self.detailType == Detail_Peijian){
        
        url = [NSString stringWithFormat:ANLI_PEIJIAN_INFORMATION_URL,self.anli_id,[GMAPI getAuthkey]];
    }
    
//    NSString *url = [NSString stringWithFormat:ANLI_COLLECT_STATE,self.anli_id,[GMAPI getAuthkey]];
    __weak typeof(self)bself = self;
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        int errcode = [[result objectForKey:@"errcode"]intValue];
        if (errcode == 0) {
            
            NSDictionary *datainfo = result[@"datainfo"];
            bself.detail_info = [[BusinessDetailModel alloc] initWithDictionary:datainfo];
            int isshoucang = [bself.detail_info.isshoucang intValue];
            
            isCollect = (isshoucang == 1) ? YES : NO;
            
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [LTools showMBProgressWithText:failDic[@"errinfo"] addToView:self.view];
        
    }];
}


/**
 *  取消收藏
 */
- (void)networkForCancelCollect
{
    int tag = 1;//案例
    
    if (self.detailType == Detail_Anli) {
        
        tag = 1;
        
    }else if (self.detailType == Detail_Peijian){
        
        tag = 2;
    }
    
    NSString *url = [NSString stringWithFormat:ANLI_CANCEL_COLLECT,[GMAPI getAuthkey],tag,self.anli_id];
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        int errcode = [[result objectForKey:@"errcode"]intValue];
        if (errcode == 0) {
            
            isCollect = NO;
            
            [functionView setCollectionState:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:G_USERCENTERLOADUSERINFO object:nil userInfo:nil];

        }else
        {
            
        }
        [LTools showMBProgressWithText:@"取消收藏成功" addToView:self.view];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [LTools showMBProgressWithText:failDic[@"errinfo"] addToView:self.view];
        
    }];
}

/**
 *  添加收藏 案例
 */
- (void)networkForCollect
{
    
    NSString *api;
    if (self.detailType == Detail_Anli) {
        
        api = ANLI_COLLECT;
        
    }else if (self.detailType == Detail_Peijian){
        
        api = PEIJIAN_COLLECT;
    }
    
    NSString *url = [NSString stringWithFormat:api,[GMAPI getAuthkey],self.anli_id];
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        int errcode = [[result objectForKey:@"errcode"]intValue];
        if (errcode == 0) {
            
            isCollect = YES;
            
            [functionView setCollectionState:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:G_USERCENTERLOADUSERINFO object:nil userInfo:nil];

        }else
        {
            
        }
        [LTools showMBProgressWithText:result[@"errinfo"] addToView:self.view];

        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [LTools showMBProgressWithText:failDic[@"errinfo"] addToView:self.view];

    }];
}

#pragma mark 创建视图
/**
 *  评论 和 电话咨询
 */
- (void)createBottom
{
    bottomView = [[BusinessCommentView alloc] init];
    [self.view addSubview:bottomView];
    __weak typeof(self)bself = self;
    [bottomView setMyBlock:^(BusinessCommentViewTapType aType) {
        switch (aType) {
            case BusinessCommentViewTapTypeLogIn://登陆
            {
//                LogInViewController * logInVC = [[LogInViewController alloc] init];
//                UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:logInVC];
//                [bself presentViewController:navc animated:YES completion:nil];
                
                NewLogInView * loginView = [[NewLogInView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT)];
                loginView.backgroundColor = [UIColor colorWithPatternImage:[ZSNApi screenShot]];
                [[UIApplication sharedApplication].keyWindow addSubview:loginView];
            }
                break;
            case BusinessCommentViewTapTypeComment://评论
            {
                GscoreStarViewController *cc = [[GscoreStarViewController alloc]init];
                cc.commentType = Comment_PeiJian;//评论类型（枚举）
                cc.commentId = bself.anli_id;//对应的id
                UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:cc];
                [bself presentViewController:navc animated:YES completion:^{
                    
                }];
            }
                break;
            case BusinessCommentViewTapTypeConsult://电话咨询
            {
                /*
                if (bself.detail_info.tel.length > 0) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",bself.detail_info.tel]]];
                }else
                {
                    [LTools showMBProgressWithText:@"暂无商家电话信息" addToView:bself.view];
                }
                 */
                [LTools rongCloudChatWithUserId:bself.storeId userName:bself.storeName viewController:bself];
            }
                break;
                
            default:
                break;
        }
    }];

}

//导航右上角按钮
- (void)createNavigationTools
{
    
    //空格
    UIBarButtonItem * spaceButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton1.width = -15;
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
//    rightView.backgroundColor = [UIColor orangeColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItems = @[spaceButton1,rightItem];
    
    //第一个按钮
    UIButton *saveButton =[[UIButton alloc]initWithFrame:CGRectMake(10,0,30,44)];
    [saveButton addTarget:self action:@selector(clickToShouCang:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setImage:[UIImage imageNamed:@"anli_shoucang"] forState:UIControlStateNormal];
    
    [rightView addSubview:saveButton];
    
    //第二个按钮
    UIButton *share_Button =[[UIButton alloc]initWithFrame:CGRectMake(saveButton.right + 5,0,30,44)];
    [share_Button addTarget:self action:@selector(clickToZhuanFa:) forControlEvents:UIControlEventTouchUpInside];
    [share_Button setImage:[UIImage imageNamed:@"anli_zhuanfa"] forState:UIControlStateNormal];
    
    [rightView addSubview:share_Button];
    
}

-(void)setNavgationView
{
//    UIImageView * navigation_view = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,64)];
//    navigation_view.image = [UIImage imageNamed:@"default_navigation_clear_image"];
//    [self.view addSubview:navigation_view];
//    navigation_view.userInteractionEnabled = YES;
//    [self.view bringSubviewToFront:navigation_view];
    
    
    back_button = [UIButton buttonWithType:UIButtonTypeCustom];
    back_button.frame = CGRectMake(2,0,38.5,39.5);
    //    back_button.backgroundColor = [UIColor orangeColor];
    [back_button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [back_button setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    [self.view addSubview:back_button];
    
    right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    right_button.frame = CGRectMake(DEVICE_WIDTH-40,6,40,24.5);
    [right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [right_button setImage:[UIImage imageNamed:@"navigation_right_menu_image"] forState:UIControlStateNormal];
    [self.view addSubview:right_button];
}

#pragma mark 事件处理

/**
 *  登录之后刷新
 */
- (void)loginAndRefresh
{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"gdengluchenggong" object:nil];
    
    NSString *api;
    if (self.detailType == Detail_Anli) {
        
        api = [NSString stringWithFormat:ANLI_DETAIL,self.anli_id,[GMAPI getAuthkey]];
        
    }else if (self.detailType == Detail_Peijian){
        
        api =[NSString stringWithFormat:ANLI_PEIJIAN_DETAIL,self.anli_id,[GMAPI getUid]];
    }
    
    NSString *url = [NSString stringWithFormat:api,self.anli_id,[GMAPI getUid]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)clickToShouCang:(UIButton *)sender
{
    [self networkForCollect];
}


#pragma mark-touches
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    functionView.myHidden = YES;
}


#define mark 代理

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"navigationType %d",navigationType);
    NSLog(@"request %@",request.URL.relativeString);

    NSString *relativeUrl = request.URL.relativeString;
    
    if ([relativeUrl rangeOfString:@"dianpuanli"].length > 0) {
        
        NSArray *dianpu = [relativeUrl componentsSeparatedByString:@"/dianpuanli"];
        if (dianpu.count > 1) {
            
            NSString *dianpuId = dianpu[1];
            NSLog(@"店铺案例 id:%@",dianpuId);
            
            BusinessViewController *business = [[BusinessViewController alloc]init];
            business.storeId = dianpuId;
            business.isStoreAnli = YES;
            business.storeName = self.storeName;
            [self.navigationController pushViewController:business animated:YES];
        }
        
        return NO;
    }
    
    ///店铺情况
    if ([relativeUrl rangeOfString:@"dianpuli"].length > 0) {
        
        NSArray *dianpu = [relativeUrl componentsSeparatedByString:@"/dianpuli"];
        if (dianpu.count > 1) {
            
            NSString *dianpuId = dianpu[1];
            NSLog(@"店铺 id:%@",dianpuId);
            
            BusinessHomeViewController * home = [[BusinessHomeViewController alloc] init];
            home.business_id = dianpuId;
            home.share_title = self.storeName;
            home.share_image = self.storeImage;
            home.business_name = _storeName;
            [self.navigationController pushViewController:home animated:YES];

        }
        
        return NO;
    }
    ///这也是店铺情况
    if ([relativeUrl rangeOfString:@"http://g.fblife.com/web.php?c=wap&a=getStore&storeid="].length > 0) {
        
        NSArray *dianpu = [relativeUrl componentsSeparatedByString:@"&storeid="];
        if (dianpu.count > 1) {
            
            NSString *dianpuId = dianpu[1];
            NSLog(@"店铺 id:%@",dianpuId);
            
            BusinessHomeViewController * home = [[BusinessHomeViewController alloc] init];
            home.business_id = dianpuId;
            home.share_title = self.storeName;
            home.share_image = self.storeImage;
            home.business_name = _storeName;
            [self.navigationController pushViewController:home animated:YES];
            
        }
        
        return NO;
    }
    
    //配件第一种情况
    
    if ([relativeUrl rangeOfString:@"peijianxiangqing"].length > 0) {
        
        NSArray *dianpu = [relativeUrl componentsSeparatedByString:@"&peijianxiangqing"];
        if (dianpu.count > 1) {
            
            NSString *dianpuId = dianpu[1];
            NSLog(@"配件详情 id:%@",dianpuId);
            
            AnliDetailViewController *detail = [[AnliDetailViewController alloc]init];
            detail.anli_id = dianpuId;
            
            detail.detailType = Detail_Peijian;
    
            detail.storeImage = self.storeImage;
            
            detail.storeId = self.storeId;
            
            detail.storeName = self.storeName;
            
            [self.navigationController pushViewController:detail animated:YES];
            
        }
        
        return NO;
    }
    
    ///放大缩小图片
    if ([relativeUrl rangeOfString:@"#big_view"].length)
    {
        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_CLICKBIG_BIG WithObject:CURRENT_SHOW_NUM WithValue:_anli_id];
        [self setNavigationViewHidden:YES];
        return NO;
    }
    if ([relativeUrl rangeOfString:@"#small_view"].length)
    {
        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_CLICKBIG_SMALL WithObject:CURRENT_SHOW_NUM WithValue:_anli_id];
        [self setNavigationViewHidden:NO];
        return NO;
    }
    
    ///点击+-显示隐藏简介
    if ([relativeUrl rangeOfString:@"#clickplus"].length)
    {
        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_CLICKPLUS_PLUS WithObject:CURRENT_SHOW_NUM WithValue:_anli_id];
    }
    if ([relativeUrl rangeOfString:@"#clickminus"].length)
    {
        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_CLICKPLUS_MINUS WithObject:CURRENT_SHOW_NUM WithValue:_anli_id];
    }
    
    
    //分享朋友圈
    if ([relativeUrl rangeOfString:@"pengyouquan"].length > 0)
    {
        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_SHARE WithObject:CURRENT_SHOW_NUM WithValue:_anli_id];
        LShareTools *tool = [LShareTools shareInstance];
        
        NSString *url = [NSString stringWithFormat:ANLI_DETAIL_SHARE,self.anli_id,[GMAPI getAuthkey]];
        
        [tool shareToPlat:ShareToPengyouquan title:self.detail_info.title description:self.detail_info.content imageUrl:self.detail_info.pichead aShareImage:self.storeImage linkUrl:url];
        
        return NO;
        
    }else if ([relativeUrl rangeOfString:@"weixin"].length > 0)
    {
        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_SHARE WithObject:CURRENT_SHOW_NUM WithValue:_anli_id];
        LShareTools *tool = [LShareTools shareInstance];
        
        NSString *url = [NSString stringWithFormat:ANLI_DETAIL_SHARE,self.anli_id,[GMAPI getAuthkey]];
        
        [tool shareToPlat:ShareToWeixin title:self.detail_info.title description:self.detail_info.content imageUrl:self.detail_info.pichead aShareImage:self.storeImage linkUrl:url];
        
        return NO;
        
    }else if ([relativeUrl rangeOfString:@"weibo"].length > 0)
    {
        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_SHARE WithObject:CURRENT_SHOW_NUM WithValue:_anli_id];
        LShareTools *tool = [LShareTools shareInstance];
        
        NSString *url = [NSString stringWithFormat:ANLI_DETAIL_SHARE,self.anli_id,[GMAPI getAuthkey]];
        
        [tool shareToPlat:ShareToWeibo title:self.detail_info.title description:self.detail_info.content imageUrl:self.detail_info.pichead aShareImage:self.storeImage linkUrl:url];
        
        return NO;
    }
    
    //融云聊天
    
    if ([relativeUrl rangeOfString:@"liaotian"].length > 0) {
        
        NSArray *dianpu = [relativeUrl componentsSeparatedByString:@"liaotian"];
        if (dianpu.count > 1) {
            
            [MobClick event:@"AnliDetailViewController_shangjialiaotian"];
            
            NSString *dianpuId = dianpu[1];
            NSLog(@"与商家聊天 id:%@",dianpuId);
            
            [LTools rongCloudChatWithUserId:dianpuId userName:self.storeName viewController:self];
            
            
        }
        
        return NO;
    }


    
    if ([relativeUrl rangeOfString:@"map:"].length > 0)
    {
        NSString * lat;
        NSString * lng;
        NSString * latlng = [relativeUrl stringByReplacingOccurrencesOfString:@"map:" withString:@""];
        
        
        NSArray * array = [latlng componentsSeparatedByString:@","];
        
        NSLog(@"array ------   %@",array);
        
        if (latlng)
        {
            lat = [array objectAtIndex:1];
            lng = [array objectAtIndex:0];
            
            if ([lat isEqualToString:@"0"] && [lng isEqualToString:@"0"])
            {
                [ZSNApi showAutoHiddenMBProgressWithText:@"商家没有上传地图信息" addToView:self.view];
                return NO;
            }
        }
        
        
        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_LOCATION WithObject:[NSString stringWithFormat:@"%@,%@",lat,lng] WithValue:@""];
        
        NSString * address = [relativeUrl stringByReplacingOccurrencesOfString:@"map:" withString:@""];
        NSLog(@"address ------   %@",address);
        
        FBMapViewController * mapViewController = [[FBMapViewController alloc] init];
        mapViewController.address_content = self.detail_info.phone;
        mapViewController.address_title = self.storeName;
        mapViewController.address_latitude = [lat doubleValue];
        mapViewController.address_longitude = [lng doubleValue];
        
        [self.navigationController pushViewController:mapViewController animated:YES];
        
        return NO;
    }
    

    if ([relativeUrl rangeOfString:@"pinglun"].length > 0) {
        
        if ([LTools cacheBoolForKey:USER_IN]) {
            
            //已经登录
            NSLog(@"已经登录");
            
            GscoreStarViewController *cc = [[GscoreStarViewController alloc]init];
//            cc.commentType = Comment_Anli;
            if (self.detailType == Detail_Anli) {
                
                cc.commentType = Comment_Anli;
                
            }else if (self.detailType == Detail_Peijian){
                
                cc.commentType = Comment_PeiJian;
            }
            cc.commentId = self.anli_id;
            UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:cc];
            [self presentViewController:navc animated:YES completion:^{
                
            }];
            
            
        }else
        {
            
//            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginAndRefresh) name:@"gdengluchenggong" object:nil];
//            LogInViewController * logIn = [[LogInViewController alloc] init];
//            UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:logIn];
//            [self presentViewController:navc animated:YES completion:nil];
            
            NewLogInView * loginView = [[NewLogInView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT)];
            loginView.backgroundColor = [UIColor colorWithPatternImage:[ZSNApi screenShot]];
            [[UIApplication sharedApplication].keyWindow addSubview:loginView];
        }
        
        return NO;
        
    }
    
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
//    bottomView.hidden = NO;
    
    [loading hide:YES];
    
  //  [self updateStatusBarColor];
    
    [self progressToFinish];
    
    NSLog(@"webViewDidFinishLoad");
    
//    if (self.detailType == Detail_Peijian) {
//        
//        CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
//        
//        NSLog(@"webheight %f",height);
//        
//        if (DEVICE_HEIGHT - height >= 64) {
//            
//            [self hiddenBottomViewWith:NO withDuration:0.f];
//            noHidden = YES;
//        }
//        
//        if (height <= DEVICE_HEIGHT && DEVICE_HEIGHT - height < 64) {
//            
//            web_old_height = height;
//            
//            _webView.scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 64 + 100);
//            
//        }
//        
//    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [loading hide:YES];
    NSLog(@"erro %@",error);
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*
    CGFloat offset = scrollView.contentOffset.y;
    
    if (offset > currentOffY) {
        
        [self hiddenBottomViewWith:NO];
        
    }else
    {
        [self hiddenBottomViewWith:YES];
    }
    
    currentOffY = offset;
     */
}

///底部栏弹出消失动画
-(void)hiddenBottomViewWith:(BOOL)isHidden
{
    if (noHidden) {
        return;
    }
    
    if (isHidden) {
        _webView.height = DEVICE_HEIGHT;

    }

    [UIView animateWithDuration:0.4 animations:^{
        bottomView.top = isHidden?DEVICE_HEIGHT:(DEVICE_HEIGHT-64);
        if (isHidden == NO) {
            _webView.height = DEVICE_HEIGHT-64;
        }
        
    } completion:^(BOOL finished) {
        
    }];
}

///底部栏弹出消失动画 加个动画时间参数

-(void)hiddenBottomViewWith:(BOOL)isHidden withDuration:(CGFloat)duration
{
    if (noHidden) {
        return;
    }
    
    if (isHidden) {
        _webView.height = DEVICE_HEIGHT;//增加时不需要动画,防止延迟造成的 黑底显示
        
        if (web_old_height <= DEVICE_HEIGHT) {
            
            _webView.scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, DEVICE_HEIGHT + 64);
        }
    }
    
    [UIView animateWithDuration:duration animations:^{
        bottomView.top = isHidden?DEVICE_HEIGHT:(DEVICE_HEIGHT-64);
        
        if (isHidden == NO) {
            _webView.height = DEVICE_HEIGHT-64;
        }
        
    } completion:^(BOOL finished) {
        
    }];
}


///设置导航栏显示隐藏
-(void)setNavigationViewHidden:(BOOL)isHidden
{
    [UIView animateWithDuration:0.35 animations:^{
        back_button.top = isHidden?-64:0;
        right_button.top = isHidden?-64:6;
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark - 评论成功刷新该界面
-(void)successComment
{
    [_webView reload];
}

@end
