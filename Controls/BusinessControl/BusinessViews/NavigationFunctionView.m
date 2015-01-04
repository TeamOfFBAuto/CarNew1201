//
//  NavigationFunctionView.m
//  CustomNewProject
//
//  Created by soulnear on 14-12-12.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "NavigationFunctionView.h"

@implementation NavigationFunctionView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0,64,DEVICE_WIDTH,DEVICE_HEIGHT-64);
        self.backgroundColor = [UIColor clearColor];
        [self setup];
        
    }
    return self;
}


-(void)setup
{
    back_view = [[UIView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH-56,6,34,72)];
    back_view.backgroundColor = [UIColor blackColor];
    [self addSubview:back_view];
    
    NSArray * image_array = [NSArray arrayWithObjects:[UIImage imageNamed:@"navigation_forward_image"],[UIImage imageNamed:@"navigation_praise_image"],nil];
    
    UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(0,0,33,0.5)];
    line_view.backgroundColor = RGBCOLOR(70,70,70);
    line_view.center = CGPointMake(back_view.width/2,back_view.height/2);
    [back_view addSubview:line_view];
    for (int i = 0;i < 2;i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0,(back_view.height/2+0.5)*i,back_view.width,(back_view.height-0.5)/2);
        [button setImage:[image_array objectAtIndex:i] forState:UIControlStateNormal];
        [button setTag:100+i];
        [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [back_view addSubview:button];
        
        if (i == 1)
        {
            [button setImage:[UIImage imageNamed:@"navigation_praised_image"] forState:UIControlStateSelected];
        }
    }
}


-(void)buttonTap:(UIButton *)button
{
    self.myHidden = YES;
    if (nav_function_block)
    {
        nav_function_block(button.tag - 100);
    }
}

-(void)setFunctionBlock:(navFunctionBlock)aBlock
{
    nav_function_block = aBlock;
}

-(void)setMyHidden:(BOOL)myHidden
{
    _myHidden = myHidden;
    __weak typeof(self)bself = self;
    [UIView animateWithDuration:0.4 animations:^{
        if (myHidden)
        {
            bself.alpha = 0;
        }else
        {
            bself.alpha = 0.8;
        }
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 设置收藏状态
-(void)setCollectionState:(BOOL)isCollect
{
    _isCollection = isCollect;
    
    UIButton * button = (UIButton *)[self viewWithTag:101];
    
    button.selected = isCollect;
}
@end












