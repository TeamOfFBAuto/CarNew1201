//
//  BusinessCommentView.h
//  CustomNewProject
//
//  Created by soulnear on 14-12-15.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//
/*
 商家详情界面底部菜单视图
 */

#import <UIKit/UIKit.h>
typedef enum
{
    BusinessCommentViewTapTypeLogIn = 0,//登陆
    BusinessCommentViewTapTypeConsult,//咨询
    BusinessCommentViewTapTypeComment//点评
}BusinessCommentViewTapType;



typedef void(^BusinessCommentViewBlock)(BusinessCommentViewTapType aType);
@interface BusinessCommentView : UIView
{
    BusinessCommentViewBlock BusinessCommentView_block;
}

-(void)setMyBlock:(BusinessCommentViewBlock)aBlock;

@end
