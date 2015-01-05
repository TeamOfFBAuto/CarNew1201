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
        [_shareView ShareViewShow];
    }
    return self;
}

- (void)showOrHidden:(BOOL)show
               title:(NSString *)atitle
         description:(NSString *)description
                 imageUrl:(NSString *)aimageUrl
               aShareImage:(UIImage *)aImage
            linkUrl:(NSString *)linkUrl
{
//    NSString *title;//标题
//    NSString *imageUrl;//图片url
//    UIImage *aShareImage;//图片对象
//    NSString *linkUrl;//连接地址
    
    _title = atitle;
    _description = description;
    _imageUrl = aimageUrl;
    _aShareImage = aImage;
    _linkUrl = linkUrl;
    
    if (show) {
        
        [_shareView ShareViewShow];
    }else
    {
        [_shareView shareviewHiden];
    }
    
}


-(void)clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    NSString * string_url = _linkUrl;
    
    NSString *string_title = _title;
    
    NSString *description = _description;
    
    UIImage *shareImage = _aShareImage;//[UIImage imageNamed:@"Icon@2x.png"]
    
    NSString *imageUrl = _imageUrl;
    
    if(buttonIndex==0){
        
        NSLog(@"自留地");
        
        BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
        if (!isLogIn)
        {
            UIViewController *root = ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
            LogInViewController * logInVC = [LogInViewController sharedManager];
        
            [root presentViewController:logInVC animated:YES completion:nil];
            
            return;
        }
        
        
        
        ZSNAlertView * alertView = [[ZSNAlertView alloc] init];
        
        [alertView setInformationWithImageUrl:_imageUrl WithShareUrl:_linkUrl WithUserName:_title WithContent:_description WithBlock:^(NSString *theString) {
            
        }];
        
        [alertView show];

        
        
    }else if(buttonIndex==3){
        NSLog(@"到新浪微博界面的");
        WBWebpageObject *pageObject = [ WBWebpageObject object ];
        pageObject.objectID =@"nimeideid";
        pageObject.thumbnailData = UIImageJPEGRepresentation(shareImage, 0.1);
        pageObject.title = @"分享自改装车客户端";
        pageObject.description = description;
        pageObject.webpageUrl = string_url;
        WBMessageObject *message = [ [ WBMessageObject alloc ] init ];
        message.text =[NSString stringWithFormat:@"%@（分享自@越野e族）",string_title] ;
        
        message.mediaObject = pageObject;
        WBSendMessageToWeiboRequest *req = [ [  WBSendMessageToWeiboRequest alloc ] init  ];
        req.message = message;
        [ WeiboSDK sendRequest:req ];
        
    }
    
    else if(buttonIndex==4){
        
        NSLog(@"分享到邮箱");
        
        NSString *string_bodyofemail=[NSString stringWithFormat:@"%@ \n %@ \n\n 下载越野e族客户端 http://mobile.fblife.com/download.php",string_title,string_url] ;
        [self shareToEmail:string_bodyofemail];
        
        
    }else if(buttonIndex==1){
        NSLog(@"分享给微信好友");
        
        
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = string_title;
            message.description = description;
            
//            [message setThumbImage:shareImage] ;
            
            message.thumbData = UIImageJPEGRepresentation(shareImage, 0.1);
            
            WXWebpageObject *ext = [WXWebpageObject object];
            //ext.imageData = _weburl_Str;
            ext.webpageUrl=string_url;
            message.mediaObject = ext;
            
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            
            req.bText = NO;
            req.message = message;
            req.scene=WXSceneSession;
            
            [WXApi sendReq:req];
        }else{
            UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"" message:@"你的iPhone上还没有安装微信。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alView show];
            
        }
        
    }
    else if(buttonIndex==2){
        
        NSLog(@"分享给微信朋友圈");
        
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
            WXMediaMessage *message = [WXMediaMessage message];
            message.title = string_title;
            message.description = description;
            
//            [message setThumbImage:shareImage] ;
            
            message.thumbData = UIImageJPEGRepresentation(shareImage, 0.1);
            
            WXWebpageObject *ext = [WXWebpageObject object];
//            ext.imageData = _weburl_Str;
            
            ext.webpageUrl=string_url;

            message.mediaObject = ext;
            
            SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
            
            req.bText = NO;
            req.message = message;
            req.scene=WXSceneTimeline;
            
            
            [WXApi sendReq:req];
        }else{
            UIAlertView *alView = [[UIAlertView alloc]initWithTitle:@"" message:@"你的iPhone上还没有安装微信。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alView show];
            
        }
        
        
        NSLog(@"分享到微信朋友圈");
        
    }
    //分享编辑页面的接口
    
}


-(void)shareToEmail:(NSString *)___str{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"分享自越野e族"];
    
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
