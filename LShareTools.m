//
//  LShareView.m
//  CustomNewProject
//
//  Created by lichaowei on 14/12/12.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "LShareTools.h"
#import "ShareView.h"

#import "WeiboSDK.h"
#import "WXApi.h"
#import "WXApiObject.h"

#import "AppDelegate.h"
#import "ZSNAlertView.h"
#import "LogInViewController.h"

@implementation LShareTools

+ (id)shareInstance
{
    static dispatch_once_t once_t;
    static LShareTools *dataBlock;
    
    dispatch_once(&once_t, ^{
        dataBlock = [[LShareTools alloc]init];
    });
    
    return dataBlock;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        
        __weak typeof(self)wself=self;
        if (!_shareView) {
            _shareView =[[ShareView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) thebloc:^(NSInteger indexPath) {
                
                NSLog(@"xxx==%d",indexPath);
                [wself clickedButtonAtIndex:indexPath];
            }];
        }
//        [_shareView ShareViewShow];
    }
    return self;
}

- (void)showOrHidden:(BOOL)show
               title:(NSString *)atitle
         description:(NSString *)description
                 imageUrl:(NSString *)aimageUrl
               aShareImage:(UIImage *)aImage
            linkUrl:(NSString *)linkUrl
       isNativeImage:(BOOL)isNative
{
    _title = atitle;
    _description = description;
    _imageUrl = aimageUrl;
    _aShareImage = aImage;
    _linkUrl = linkUrl;
    _isNativeImage = isNative;

    
    if (show) {
        
        [_shareView ShareViewShow];
    }else
    {
        [_shareView shareviewHiden];
    }
    
}
/**
 *  一键分享
 */
- (void)shareToPlat:(ShareStyle)shareStyle
              title:(NSString *)atitle
        description:(NSString *)description
           imageUrl:(NSString *)aimageUrl
        aShareImage:(UIImage *)aImage
            linkUrl:(NSString *)linkUrl
{
    _title = atitle;
    _description = description;
    _imageUrl = aimageUrl;
    _aShareImage = aImage;
    _linkUrl = linkUrl;
    
//    [_shareView shareviewHiden];
    
    switch (shareStyle) {
        case ShareToWeibo:
        {
            
            [self clickedButtonAtIndex:3];
        }
            break;
        case ShareToPengyouquan:
        {
            
            [self clickedButtonAtIndex:2];
        }
            break;
        case ShareToWeixin:
        {
            
            [self clickedButtonAtIndex:1];
        }
            break;
            
        default:
            break;
    }
}


-(void)clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    if(buttonIndex==0){
        
        
        [MobClick event:@"LShareTools_ziliudi"];
        
        NSLog(@"自留地");
        
        BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
        if (!isLogIn)
        {
//            UIViewController *root = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
//            LogInViewController * logInVC = [[LogInViewController alloc] init];
//        
//            [root presentViewController:logInVC animated:YES completion:nil];
            
            NewLogInView * loginView = [[NewLogInView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT)];
            loginView.backgroundColor = [UIColor colorWithPatternImage:[ZSNApi screenShot]];
            [[UIApplication sharedApplication].keyWindow addSubview:loginView];
            
            return;
        }
        
        ZSNAlertView * alertView = [[ZSNAlertView alloc] init];
        
        [alertView setInformationWithImageUrl:_imageUrl WithShareUrl:_linkUrl WithUserName:_title WithContent:_description WithBlock:^(NSString *theString) {
            
        }];
        
        [alertView show];
        
    }
    
    else if(buttonIndex==4){
        
        [MobClick event:@"LShareTools_youxiang"];
        
        NSLog(@"分享到邮箱");
        
        NSString *string_bodyofemail=[NSString stringWithFormat:@"%@ \n %@ \n\n 下载改装志客户端 http://mobile.fblife.com",_title,_linkUrl] ;
        [self shareToEmail:string_bodyofemail];
        
        
    }else if(buttonIndex == 1 || buttonIndex == 2 || buttonIndex == 3){
        
        [MobClick event:@"LShareTools_weixin"];
        
        NSLog(@"1分享给微信好友");
        NSLog(@"2分享给微信朋友圈");
        NSLog(@"3到新浪微博界面的");
        
        if (_isNativeImage) {
            
            [self shareWithNativeImage:_aShareImage buttonIndex:buttonIndex];
                        
        }else
        {
            [self shareWithImageUrl:_imageUrl buttonIndex:buttonIndex];
        }
    }
    
    //分享编辑页面的接口
    
}

/**
 *  分享本地with本地图片
 */
- (void)shareWithNativeImage:(UIImage *)shareImage buttonIndex:(int)buttonIndex
{
    NSData *data = [self thumbDataWithImage:shareImage];
    
    if (buttonIndex == 1) {
        
        [self shareToWeiXinIsFriend:YES image:data];
    }else if (buttonIndex == 2){
        [self shareToWeiXinIsFriend:NO image:data];
    }else if (buttonIndex == 3){
        [self shareToSinaWithImaegeData:data];
    }
}

/**
 *  分享网络图片 需要下载之后再分享
 *
 *  @param imageUrl    分享图片地址
 *
 */
- (void)shareWithImageUrl:(NSString *)imageUrl buttonIndex:(int)buttonIndex
{
    MBProgressHUD *load = [LTools MBProgressWithText:nil addToView:[UIApplication sharedApplication].keyWindow];
    [load show:YES];
    
    __weak typeof(self)weakSelf = self;
    
    SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:[NSURL URLWithString:imageUrl] options:SDWebImageDownloaderLowPriority | SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
        NSLog(@"progress %ld",(long)receivedSize);
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        
        [load hide:YES];
        if (finished && error == nil && image) {
            
            
        }else
        {
            image = [UIImage imageNamed:@"icon_share"];
        }
        
        data = [self thumbDataWithImage:image];
        
        if (buttonIndex == 1) {
            
            [weakSelf shareToWeiXinIsFriend:YES image:data];
        }else if (buttonIndex == 2){
            [weakSelf shareToWeiXinIsFriend:NO image:data];
        }else if (buttonIndex == 3){
            [weakSelf shareToSinaWithImaegeData:data];
        }
        
    }];
}

/**
 *  分享至微信好友及朋友圈
 *
 *  @param isFriend  是否是分享到好友
 *  @param imageData 图片data
 */
- (void)shareToWeiXinIsFriend:(BOOL)isFriend image:(NSData *)imageData
{
    
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        WXMediaMessage *message = [WXMediaMessage message];
        
        message.title = _title;
        message.description = _description;
        
        message.thumbData = imageData;
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = _linkUrl;
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        
        req.bText = NO;
        req.message = message;
        req.scene = isFriend ? WXSceneSession : WXSceneTimeline;
        
        [WXApi sendReq:req];
    }else{
        UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"" message:@"你的iPhone上还没有安装微信。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alView show];
        
    }

}

/**
 *  分享至新浪微博
 *
 *  @param imageData 图片data
 */
- (void)shareToSinaWithImaegeData:(NSData *)imageData
{
    if ([WeiboSDK isWeiboAppInstalled] == NO) {
        
        UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"" message:@"你的iPhone上还没有新浪微博客户端。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alView show];
        return;
    }
    
    WBWebpageObject *pageObject = [ WBWebpageObject object ];
    pageObject.objectID =@"nimeideid";

    pageObject.thumbnailData = imageData;
    pageObject.title = @"分享自改装志客户端";
    pageObject.description = _description;
    pageObject.webpageUrl = _linkUrl;
    WBMessageObject *message = [ [ WBMessageObject alloc ] init ];
    message.text =[NSString stringWithFormat:@"%@（分享自@越野e族）",_title] ;
    
    message.mediaObject = pageObject;
    WBSendMessageToWeiboRequest *req = [ [  WBSendMessageToWeiboRequest alloc ] init  ];
    req.message = message;
    [ WeiboSDK sendRequest:req ];
}

//处理图片 不超过32KB
- (NSData *)thumbDataWithImage:(UIImage *)aImage
{
    NSData *data = UIImageJPEGRepresentation(aImage, 1);
    CGFloat ss = data.length/1000.f;
    NSLog(@"image1-->%f",ss);
    if (ss > 32) {
        
        data = UIImageJPEGRepresentation(aImage, 32/ss);
        
        NSLog(@"image2-->%f",data.length/1000.f);

        return data;
    }
    
    return data;
}


-(void)shareToEmail:(NSString *)___str{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"分享自改装志"];
    
    // Fill out the email body text
    NSString *emailBody =___str;
    [picker setMessageBody:emailBody isHTML:NO];
    
    UIViewController *root = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    
    @try {
        [root presentViewController:picker animated:YES completion:^{
            
        }];
        
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}



- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error

{
    NSString *title = @"Mail";
    
    NSString *msg;
    
    switch (result)
    
    {
            
        case MFMailComposeResultCancelled:
            
            msg = @"Mail canceled";//@"邮件发送取消";
            
            break;
            
        case MFMailComposeResultSaved:
            
            msg = @"Mail saved";//@"邮件保存成功";
            
            // [self alertWithTitle:title msg:msg];
            
            break;
            
        case MFMailComposeResultSent:
            
            msg = @"邮件发送成功";//@"邮件发送成功";
            
            [self alertWithTitle:title msg:msg];
            
            break;
            
        case MFMailComposeResultFailed:
            
            msg = @"邮件发送失败";//@"邮件发送失败";
            
            [self alertWithTitle:title msg:msg];
            
            break;
            
        default:
            
            msg = @"Mail not sent";
            
            // [self alertWithTitle:title msg:msg];
            
            break;
            
    }
    
    [controller dismissViewControllerAnimated:YES completion:NULL];
    
    
}

- (void) alertWithTitle: (NSString *)_title_ msg: (NSString *)msg

{
    [LTools alertText:msg];
    
}


@end
