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
    
}

///设置当前view是否隐藏
@property(nonatomic,assign)BOOL myHidden;

@property(nonatomic,assign)navFunctionBlock nav_function_block;

///点击第一个为分享，点击第二个为收藏
-(void)setNav_function_block:(navFunctionBlock)nav_function_block;


@end
