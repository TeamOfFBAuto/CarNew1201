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

@interface LShareTools : NSObject<MFMailComposeViewControllerDelegate>
{
    ShareView *_shareView;
    NSString *_title;//标题
    NSString *_imageUrl;//图片url
    UIImage *_aShareImage;//图片对象
    NSString *_linkUrl;//连接地址
}

+ (id)shareInstance;

- (void)showOrHidden:(BOOL)show
               title:(NSString *)atitle
            imageUrl:(NSString *)aimageUrl
         aShareImage:(UIImage *)aImage
             linkUrl:(NSString *)linkUrl;

@end
