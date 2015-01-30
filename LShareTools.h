//
//  LShareView.h
//  CustomNewProject
//
//  Created by lichaowei on 14/12/12.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@class ShareView;

typedef enum {
  
    ShareToWeibo = 0,//分享到微博
    ShareToWeixin,//分享到微信
    ShareToPengyouquan //朋友圈
    
}ShareStyle;

@interface LShareTools : NSObject<MFMailComposeViewControllerDelegate>
{
    ShareView *_shareView;
    NSString *_title;//标题
    NSString *_description;//描述
    NSString *_imageUrl;//图片url
    UIImage *_aShareImage;//图片对象
    NSString *_linkUrl;//连接地址
    
    BOOL _isNativeImage;//是否是本地图片
}

+ (id)shareInstance;

- (void)showOrHidden:(BOOL)show
               title:(NSString *)atitle
         description:(NSString *)description
            imageUrl:(NSString *)aimageUrl
         aShareImage:(UIImage *)aImage
             linkUrl:(NSString *)linkUrl
       isNativeImage:(BOOL)isNative;//分享view

- (void)shareToPlat:(ShareStyle)shareStyle
               title:(NSString *)atitle
         description:(NSString *)description
            imageUrl:(NSString *)aimageUrl
         aShareImage:(UIImage *)aImage
            linkUrl:(NSString *)linkUrl;//一键分享

@end
