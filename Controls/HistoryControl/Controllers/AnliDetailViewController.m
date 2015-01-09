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

@interface AnliDetailViewController ()<MFMailComposeViewControllerDelegate,UIWebViewDelegate,UIScrollViewDelegate>
{
    ShareView *_shareView;
    MBProgressHUD *loading;
    NavigationFunctionView * functionView;
    
    UIView *comment_view;//评论视图
    
    CommentBottomView *bottomView;
    
    CGFloat currentOffY;
    
    UIView *progress;
    UIView *greenView;//绿色
    NSTimer *timer;
    
    BOOL isCollect;
}

///存放标题、图片、是否收藏 、简介信息
@property(nonatomic,strong)BusinessDetailModel * detail_info;

@end

@implementation AnliDetailViewController

- (void)dealloc
{
    NSLog(@"---dealloc");
    self.webView.delegate = nil;
    self.webView = nil;
    bottomView = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self updateStatusBarColor];
    
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
    
    currentOffY = 0.f;
    
    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT + 20)];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    _webView.scrollView.delegate = self;
    
    _webView.scrollView.bounces = NO;
    
    NSString *api;
    if (self.detailType == Detail_Anli) {
        
        api = ANLI_DETAIL;
        
    }else if (self.detailType == Detail_Peijian){
        
        api = ANLI_PEIJIAN_DETAIL;
    }
    
    NSString *url = [NSString stringWithFormat:api,self.anli_id,[GMAPI getUid]];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    
    self.webView.backgroundColor = COLOR_WEB_DETAIL_BACKCOLOR;
    
    self.view.backgroundColor = COLOR_WEB_DETAIL_BACKCOLOR;
    
    [self setNavgationView];
    
//    [self rightButtonTap:nil];
    
    [self networkForCollectState];
    
    bottomView = [[CommentBottomView alloc] init];
    bottomView.hidden = YES;
    [self.view addSubview:bottomView];
    
    __weak typeof(self)weakSelf = self;
    
    [bottomView setMyBlock:^(CommentTapType aType) {
        NSLog(@"bottom tap : %d",aType);
        
        if (aType == CommentTypeLogIn) {
            
            LogInViewController * logIn = [[LogInViewController alloc] init];
            UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:logIn];
            [weakSelf presentViewController:navc animated:YES completion:nil];
            
        }else if (aType == CommentTypeComent){
            
            GscoreStarViewController *cc = [[GscoreStarViewController alloc]init];
            cc.commentType = Comment_Anli;
            cc.commentId = weakSelf.anli_id;
            UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:cc];
            [weakSelf presentViewController:navc animated:YES completion:^{
                
            }];
        }
        
    }];
    
    [self progress];

}

- (void)progress
{
    progress = [[UIView alloc]initWithFrame:CGRectMake(0, bottomView.bottom - 2, DEVICE_WIDTH, 2)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    
    greenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, progress.height)];
    greenView.backgroundColor = RGBCOLOR(0, 255, 0);
    [progress addSubview:greenView];
    
    [self progressAnimation];

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
                
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
                
                [tool showOrHidden:YES title:weakSelf.detail_info.title description:weakSelf.detail_info.content imageUrl:weakSelf.detail_info.pichead aShareImage:image linkUrl:url];
                
            }else if (index == 1){
                
                [weakSelf clickToCollectAction];
            }
            
        }];
    }
    
    [functionView setCollectionState:isCollect];
    
    functionView.myHidden = !functionView.myHidden;
}

- (void)clickToCollectAction
{
    if (isCollect) {
        
        [self networkForCancelCollect];
        
    }else
    {
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
            
        }else
        {
            
        }
        [LTools showMBProgressWithText:result[@"errinfo"] addToView:self.view];

        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [LTools showMBProgressWithText:failDic[@"errinfo"] addToView:self.view];

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

-(void)setNavgationView
{
//    UIImageView * navigation_view = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,64)];
//    navigation_view.image = [UIImage imageNamed:@"default_navigation_clear_image"];
//    [self.view addSubview:navigation_view];
//    navigation_view.userInteractionEnabled = YES;
//    [self.view bringSubviewToFront:navigation_view];
    
    
    UIButton * back_button = [UIButton buttonWithType:UIButtonTypeCustom];
    back_button.frame = CGRectMake(0,20,40,44);
    //    back_button.backgroundColor = [UIColor orangeColor];
    [back_button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [back_button setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    [self.view addSubview:back_button];
    
    UIButton * right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    right_button.frame = CGRectMake(DEVICE_WIDTH-44,20,44,44);
    [right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [right_button setImage:[UIImage imageNamed:@"navigation_right_menu_image"] forState:UIControlStateNormal];
    [self.view addSubview:right_button];
}

#pragma mark 事件处理

- (void)clickToShouCang:(UIButton *)sender
{
    [self networkForCollect];
}


#pragma mark-touches
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    functionView.myHidden = YES;
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
//    bottomView.hidden = NO;
    
    [loading hide:YES];
    
    [self updateStatusBarColor];
    
    [self progressToFinish];
    
//    webView.scrollView.contentSize  = CGSizeMake(webView.width, webView.scrollView.contentSize.height + 62);
//    [webView.scrollView addSubview:bottomView];
//    bottomView.top = webView.scrollView.contentSize.height - 62;
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [loading hide:YES];
    NSLog(@"erro %@",error);
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"=== %@",NSStringFromCGSize(scrollView.contentSize));
    
    CGFloat offset = scrollView.contentOffset.y;
    
    
    if (offset > currentOffY) {
        bottomView.hidden = NO;
        
        self.webView.height = ALL_FRAME_HEIGHT + 20 - 62;
        
    }else
    {
        bottomView.hidden = YES;
        self.webView.height = ALL_FRAME_HEIGHT + 20;
    }
    
    currentOffY = offset;
}

@end
