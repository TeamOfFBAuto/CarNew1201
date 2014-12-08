//
//  GcustomActionSheet.h
//  FBCircle
//
//  Created by gaomeng on 14-9-3.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//


//自定义actionsheet

#import <UIKit/UIKit.h>

typedef enum{
    GcustomActionSheetLogOut = 0,//退出登录
}GcustomActionSheetEnum;

///普通按钮间隔
#define normalBtnSpacing 10.0f

///取消或按钮和普通按钮之间的间隔
#define cancelBtnSpacing 20.0f

///第一个按钮和上边框的间距
#define firstBtnForTopSpacing 22.0f

///按钮的高度
#define HeightOfNormalBtn 44.0f

@class GcustomActionSheet;
@protocol GcustomActionSheetDelegate <NSObject>

-(void)gActionSheet:(GcustomActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;

@end

@interface GcustomActionSheet : UIView
///标题
@property(nonatomic,strong)UILabel * title_label;

///内容
@property(nonatomic,strong)UIView * content_view;

///代理
@property(nonatomic,assign)id<GcustomActionSheetDelegate>delegate;


 
///点进来看吧
-(GcustomActionSheet *)initWithTitle:(NSString *)aTitle//标题
                        buttonTitles:(NSArray *)buttonTitles//普通按钮的标题数组
                   buttonTitlesColor:(UIColor*)buttonTitleColor//普通按钮的title颜色
                         buttonColor:(UIColor *)buttonColor//普通按钮的背景颜色
                         CancelTitle:(NSString *)canceTitle//取消按钮的标题
                    cancelTitelColor:(UIColor*)cancelTitleColor//取消按钮的titile颜色
                         CancelColor:(UIColor *)cancelColor//取消按钮的背景颜色
                     actionBackColor:(UIColor *)actionColor;//自定义action的背景颜色






-(void)showInView:(UIView *)view WithAnimation:(BOOL)animatio;

@end
