//
//  NavigationFunctionView.h
//  CustomNewProject
//
//  Created by soulnear on 14-12-12.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

/*
 *详情页点击右上角按钮弹出的视图（包括转发、点赞）
 */

#import <UIKit/UIKit.h>

typedef void(^navFunctionBlock)(int index);

@interface NavigationFunctionView : UIView
{
    navFunctionBlock nav_function_block;
    UIView * back_view;
}

///设置当前view是否隐藏
@property(nonatomic,assign)BOOL myHidden;
///设置是否收藏
@property(nonatomic,assign)BOOL isCollection;

//@property(nonatomic,weak)navFunctionBlock nav_function_block;

///点击第一个为分享，点击第二个为收藏
//-(void)setNav_function_block:(navFunctionBlock)nav_function_block;

-(void)setFunctionBlock:(navFunctionBlock)aBlock;
///isCollect为NO,未收藏为YES已收藏，默认为NO
-(void)setCollectionState:(BOOL)isCollect;
@end
