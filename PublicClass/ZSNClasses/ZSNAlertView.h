//
//  ZSNAlertView.h
//  FBCircle
//
//  Created by soulnear on 14-5-24.
//  Copyright (c) 2014年 szk. All rights reserved.
//
/*
 转发分享弹出视图
 */

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"
#import "OHLableHelper.h"


typedef void(^ZSNAlertViewBlock)(NSString * theString);


@interface ZSNAlertView : UIView<UITextFieldDelegate>
{
    ZSNAlertViewBlock zsnAlertViewBlock;
    
    MBProgressHUD * hud;
}


@property(nonatomic,strong)UIImageView * backgroundImageView;

@property(nonatomic,strong)UILabel * forward_label;

@property(nonatomic,strong)UIImageView * imageView;

@property(nonatomic,strong)UILabel * userName_label;

@property(nonatomic,strong)OHAttributedLabel * content_label;

@property(nonatomic,strong)UITextField * textField;

@property(nonatomic,strong)UIButton * cancel_button;

@property(nonatomic,strong)UIButton * done_button;



-(void)setInformationWithImageUrl:(NSString *)url WithShareUrl:(NSString *)shareUrl WithUserName:(NSString *)userName WithContent:(NSString *)content WithBlock:(ZSNAlertViewBlock)theBlock;

-(void)show;


@end
