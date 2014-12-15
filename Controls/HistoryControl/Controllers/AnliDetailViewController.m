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

@interface AnliDetailViewController ()<MFMailComposeViewControllerDelegate,UIWebViewDelegate>
{
    ShareView *_shareView;
    MBProgressHUD *loading;
    NavigationFunctionView * functionView;
    
    UIView *comment_view;//评论视图
}

@end

@implementation AnliDetailViewController

- (void)dealloc
{
    NSLog(@"---dealloc");
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
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
    
//    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
//    self.myTitle = @"案例详情";
//    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
//    [self createNavigationTools];
    
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT + 20 - 65)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    loading = [LTools MBProgressWithText:@"数据加载中..." addToView:self.view];
    [loading show:YES];

    NSString *api;
    if (self.detailType == Detail_Anli) {
        
        api = ANLI_DETAIL;
        
    }else if (self.detailType == Detail_Peijian){
        
        api = ANLI_PEIJIAN_DETAIL;
    }
    
    NSString *url = [NSString stringWithFormat:api,self.anli_id,[GMAPI getUid]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    self.webView.backgroundColor = COLOR_WEB_DETAIL_BACKCOLOR;
    
    [self setNavgationView];
    
    [self createCommentView];//评论view

}

- (void)createCommentView
{
    comment_view = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.bottom - 65, ALL_FRAME_WIDTH, 65)];
    comment_view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:comment_view];
    
    CGFloat left = 0.f;
    if ([LTools cacheBoolForKey:USER_IN]) {
        
        left = 15.f;
    }else
    {
//        UIButton *login = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(15, 0, 42, 42) normalTitle:@"" image:nil backgroudImage:nil superView:comment_view target:self action:@selector(clickToLogin:)];
//        login.layer.cornerRadius = login.width/2.f;
//        [login setTitle:@"登录" forState:UIControlStateNormal];
//        [login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [login setBackgroundColor:[UIColor colorWithHexString:@"cfcfcf"]];
//        
        left =  15.f;
    }
    
    NSString *title = @"下面,我简单说两句";
    UIButton *comment_btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(left, 0, ALL_FRAME_WIDTH - 30, 30) normalTitle:title image:nil backgroudImage:nil superView:comment_view target:self action:@selector(clickToLogin:)];
    comment_btn.layer.borderColor = [UIColor colorWithHexString:@"ff9000"].CGColor;
    comment_btn.layer.borderWidth = 0.5f;
    [comment_btn setTitleColor:[UIColor colorWithHexString:@"979797"] forState:UIControlStateNormal];
    comment_btn.center = CGPointMake(ALL_FRAME_WIDTH /2.f, comment_view.height / 2.f);
    comment_btn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    //发表按钮
    
    NSString *title1 = @"发表";
    UIButton *fabiao_btn = [LTools createButtonWithType:UIButtonTypeCustom frame:CGRectMake(comment_btn.width - 50 - 2.5, 2.5, 50, 25) normalTitle:title1 image:nil backgroudImage:nil superView:comment_btn target:self action:@selector(clickToLogin:)];
   
    [fabiao_btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [fabiao_btn setBackgroundColor:[UIColor colorWithHexString:@"ff9000"]];
    fabiao_btn.titleLabel.font = [UIFont systemFontOfSize:15];
    
}

- (void)clickToLogin:(UIButton *)sender
{
    if ([LTools cacheBoolForKey:USER_IN] == NO) {
        LogInViewController * logIn = [LogInViewController sharedManager];
        UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:logIn];
        [self presentViewController:navc animated:YES completion:nil];
    }else
    {
        NSLog(@"点评页面");
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setNavgationView
{
    UIImageView * navigation_view = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,64)];
    navigation_view.image = [UIImage imageNamed:@"default_navigation_clear_image"];
    [self.view addSubview:navigation_view];
    navigation_view.userInteractionEnabled = YES;
    [self.view bringSubviewToFront:navigation_view];
    
    
    UIButton * back_button = [UIButton buttonWithType:UIButtonTypeCustom];
    back_button.frame = CGRectMake(0,20,40,44);
//    back_button.backgroundColor = [UIColor orangeColor];
    [back_button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [back_button setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    [navigation_view addSubview:back_button];
    
    UIButton * right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    right_button.frame = CGRectMake(DEVICE_WIDTH-8-44,20,44,44);
    [right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [right_button setImage:[UIImage imageNamed:@"navigation_right_menu_image"] forState:UIControlStateNormal];
    [navigation_view addSubview:right_button];
}

-(void)back:(UIButton *)button
{
    self.edgesForExtendedLayout = UIRectEdgeAll;
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButtonTap:(UIButton *)button
{
    if (!functionView)
    {
        functionView = [[NavigationFunctionView alloc] init];
        functionView.myHidden = YES;
        [self.view addSubview:functionView];
        
        
        __weak typeof(self)weakSelf = self;
        
        [functionView setFunctionBlock:^(int index) {
            
            if (index == 0) {
                
                LShareTools *tool = [LShareTools shareInstance];
                
                NSString *url = [NSString stringWithFormat:ANLI_DETAIL,weakSelf.anli_id,[GMAPI getUid]];
                NSString *imageUrl = @"http://fbautoapp.fblife.com/resource/head/84/9b/thumb_1_Thu.jpg";
                
                [tool showOrHidden:YES title:@"这里是分享的标题" description:@"这是一个非常牛逼的应用" imageUrl:imageUrl aShareImage:[UIImage imageNamed:@""] linkUrl:url];
                
            }else if (index == 1){
                
                [weakSelf networkForCollect];
                
//                [weakSelf networkForCancelCollect];
                
            }
            
        }];
    }
    
    functionView.myHidden = !functionView.myHidden;
}

#pragma mark - 网络请求

/**
 *  添加评论
 */
- (void)networkForComment
{
    NSString *url = [NSString stringWithFormat:ANLI_COLLECT,[GMAPI getUid],self.anli_id];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        int errcode = [[result objectForKey:@"errcode"]intValue];
        if (errcode == 0) {
            
            
        }else
        {
            
        }
        [LTools alertText:result[@"errinfo"]];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [LTools alertText:failDic[@"errinfo"]];
        
    }];
}

/**
 *  取消收藏
 */
- (void)networkForCancelCollect
{
    NSString *url = [NSString stringWithFormat:ANLI_CANCEL_COLLECT,[GMAPI getUid],1,self.anli_id];
    
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        int errcode = [[result objectForKey:@"errcode"]intValue];
        if (errcode == 0) {
            
            
        }else
        {
            
        }
        [LTools alertText:result[@"errinfo"]];
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [LTools alertText:failDic[@"errinfo"]];
        
    }];
}

/**
 *  添加收藏 案例
 */
- (void)networkForCollect
{
    NSString *url = [NSString stringWithFormat:ANLI_COLLECT,[GMAPI getUid],self.anli_id];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        int errcode = [[result objectForKey:@"errcode"]intValue];
        if (errcode == 0) {
            
            
        }else
        {
            
        }
        [LTools alertText:result[@"errinfo"]];

        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [LTools alertText:failDic[@"errinfo"]];

    }];
}

#pragma mark 创建视图

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

#pragma mark 事件处理

- (void)clickToShouCang:(UIButton *)sender
{
    [self networkForCollect];
}

//- (void)clickToZhuanFa:(UIButton *)sender
//{
//    __weak typeof(self)wself=self;
//    if (!_shareView) {
//        _shareView =[[ShareView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) thebloc:^(NSInteger indexPath) {
//            
//            NSLog(@"xxx==%d",indexPath);
//            
//            
//            [wself clickedButtonAtIndex:indexPath];
//            
//            
//        }];
//        
//        [_shareView ShareViewShow];
//        
//    }else{
//        [_shareView ShareViewShow];
//        
//    }
//
//}
//
//-(void)clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//    
//    NSString * string_url = [NSString stringWithFormat:@"http://special.fblife.com/listphoto/%@.html",@"1"];
//    
//    NSString *string_title = @"asjaklsas";
//    
//    if(buttonIndex==0){
//        
//        NSLog(@"自留地");
//        
////        BOOL islogin = [self isLogIn];
////        
////        if (!islogin)
////        {
////            return;
////        }
////        
////        
////        if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_IN])
////        {
////            WriteBlogViewController * writeBlogView = [[WriteBlogViewController alloc] init];
////            
////            writeBlogView.theText = [NSString stringWithFormat:@"分享图集:“%@”,链接:%@",string_title,string_url] ;
////            
////            [self presentViewController:writeBlogView animated:YES completion:NULL];
////        }
////        else{
////            //没有激活fb，弹出激活提示
////            LogInViewController *login=[LogInViewController sharedManager];
////            [self presentViewController:login animated:YES completion:nil];
////        }
//        
//        
//    }else if(buttonIndex==3){
//        NSLog(@"到新浪微博界面的");
//        WBWebpageObject *pageObject = [ WBWebpageObject object ];
//        pageObject.objectID =@"nimeideid";
//        pageObject.thumbnailData =UIImageJPEGRepresentation([UIImage imageNamed:@"Icon@2x.png"], 1);
//        pageObject.title = @"分享自越野e族客户端";
//        pageObject.description = string_title;
//        pageObject.webpageUrl = string_url;
//        WBMessageObject *message = [ [ WBMessageObject alloc ] init ];
//        message.text =[NSString stringWithFormat:@"%@（分享自@越野e族）",string_title] ;
//        
//        message.mediaObject = pageObject;
//        WBSendMessageToWeiboRequest *req = [ [  WBSendMessageToWeiboRequest alloc ] init  ];
//        req.message = message;
//        [ WeiboSDK sendRequest:req ];
//        
//    }
//    
//    else if(buttonIndex==4){
//        
//        NSLog(@"分享到邮箱");
//        
//        NSString *string_bodyofemail=[NSString stringWithFormat:@"%@ \n %@ \n\n 下载越野e族客户端 http://mobile.fblife.com/download.php",string_title,string_url] ;
//        [self shareToEmail:string_bodyofemail];
//        
//        
//    }else if(buttonIndex==1){
//        NSLog(@"分享给微信好友");
//        
//        
//        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
//            WXMediaMessage *message = [WXMediaMessage message];
//            message.title = string_title;
//            message.description = string_title;
//            
//            [message setThumbImage:[UIImage imageNamed:@"Icon@2x.png"]] ;
//            WXWebpageObject *ext = [WXWebpageObject object];
//            //ext.imageData = _weburl_Str;
//            ext.webpageUrl=string_url;
//            message.mediaObject = ext;
//            
//            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//            
//            req.bText = NO;
//            req.message = message;
//            req.scene=WXSceneSession;
//            
//            [WXApi sendReq:req];
//        }else{
//            UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"" message:@"你的iPhone上还没有安装微信,无法使用此功能，使用微信可以方便的把你喜欢的作品分享给好友。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"免费下载微信", nil];
//            [alView show];
//            
//        }
//        
//    }
//    else if(buttonIndex==2){
//        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
//            WXMediaMessage *message = [WXMediaMessage message];
//            message.title = string_title;
//            message.description = string_title;
//            
//            [message setThumbImage:[UIImage imageNamed:@"Icon@2x.png"]] ;
//            WXWebpageObject *ext = [WXWebpageObject object];
//            //ext.imageData = _weburl_Str;
//            ext.webpageUrl=string_url;
//            message.mediaObject = ext;
//            
//            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//            
//            req.bText = NO;
//            req.message = message;
//            req.scene=WXSceneTimeline;
//            
//            [WXApi sendReq:req];
//        }else{
//            UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"" message:@"你的iPhone上还没有安装微信,无法使用此功能，使用微信可以方便的把你喜欢的作品分享给好友。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"免费下载微信", nil];
//            [alView show];
//            
//        }
//        
//        
//        NSLog(@"分享到微信朋友圈");
//        
//    }
//    //分享编辑页面的接口
//    
//    
//    
//}
//
//
//-(void)shareToEmail:(NSString *)___str{
//    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//    picker.mailComposeDelegate = self;
//    
//    [picker setSubject:@"分享自越野e族"];
//    
//    // Fill out the email body text
//    NSString *emailBody =___str;
//    [picker setMessageBody:emailBody isHTML:NO];
//    
//    @try {
//        [self presentViewController:picker animated:YES completion:^{
//            
//        }];
//        
//    }
//    @catch (NSException *exception) {
//        
//    }
//    @finally {
//        
//    }
//}
//
//
//
//- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
//
//{
//    NSString *title = @"Mail";
//    
//    NSString *msg;
//    
//    switch (result)
//    
//    {
//            
//        case MFMailComposeResultCancelled:
//            
//            msg = @"Mail canceled";//@"邮件发送取消";
//            
//            break;
//            
//        case MFMailComposeResultSaved:
//            
//            msg = @"Mail saved";//@"邮件保存成功";
//            
//            // [self alertWithTitle:title msg:msg];
//            
//            break;
//            
//        case MFMailComposeResultSent:
//            
//            msg = @"邮件发送成功";//@"邮件发送成功";
//            
//            [self alertWithTitle:title msg:msg];
//            
//            break;
//            
//        case MFMailComposeResultFailed:
//            
//            msg = @"邮件发送失败";//@"邮件发送失败";
//            
//            [self alertWithTitle:title msg:msg];
//            
//            break;
//            
//        default:
//            
//            msg = @"Mail not sent";
//            
//            // [self alertWithTitle:title msg:msg];
//            
//            break;
//            
//    }
//    
//    [self dismissViewControllerAnimated:YES completion:NULL];
//    
//    
//}
//
//- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg
//
//{
//    [LTools alertText:msg];
//    
//}

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
    
    
    if ([relativeUrl rangeOfString:@"dianpu"].length > 0) {
        
        NSArray *dianpu = [relativeUrl componentsSeparatedByString:@"&dianpu"];
        if (dianpu.count > 1) {
            
            NSString *dianpuId = dianpu[1];
            NSLog(@"店铺 id:%@",dianpuId);
            
            BusinessHomeViewController * home = [[BusinessHomeViewController alloc] init];
            home.business_id = dianpuId;
            home.share_title = self.storeName;
            home.share_image = self.storeImage;
            [self.navigationController pushViewController:home animated:YES];

        }
        
        return NO;
    }
    
    
    if ([relativeUrl rangeOfString:@"peijianxiangqing"].length > 0) {
        
        NSArray *dianpu = [relativeUrl componentsSeparatedByString:@"&peijianxiangqing"];
        if (dianpu.count > 1) {
            
            NSString *dianpuId = dianpu[1];
            NSLog(@"配件详情 id:%@",dianpuId);
            
            AnliDetailViewController *detail = [[AnliDetailViewController alloc]init];
            detail.anli_id = dianpuId;
            
            detail.detailType = Detail_Peijian;
            
            //            detail.shareTitle = aModel.title;
            //            detail.shareDescrition = aModel.sname;
            //            detail.shareImage = [LTools sd_imageForUrl:aModel.pichead];
            //            detail.storeName = aModel.sname;
            //            detail.storeImage = [LTools sd_imageForUrl:aModel.spichead];
            
            [self.navigationController pushViewController:detail animated:YES];
            
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
    [loading hide:YES];
    
    [self updateStatusBarColor];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [loading hide:YES];
    NSLog(@"erro %@",error);
}


@end
