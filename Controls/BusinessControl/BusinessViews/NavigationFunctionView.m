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
        
        self.frame = CGRectMake(DEVICE_WIDTH-50,50,34,72);
        self.backgroundColor = [UIColor blackColor];
        [self setup];
        
    }
    return self;
}


-(void)setup
{
    NSArray * image_array = [NSArray arrayWithObjects:[UIImage imageNamed:@"navigation_forward_image"],[UIImage imageNamed:@"navigation_praise_image"],nil];
    
    UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(0,0,33,0.5)];
    line_view.backgroundColor = RGBCOLOR(70,70,70);
    line_view.center = CGPointMake(self.width/2,self.height/2);
    [self addSubview:line_view];
    for (int i = 0;i < 2;i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0,(self.height/2+0.5)*i,self.width,(self.height-0.5)/2);
        [button setImage:[image_array objectAtIndex:i] forState:UIControlStateNormal];
        [button setTag:100+i];
        [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
}


-(void)buttonTap:(UIButton *)button
{
    _nav_function_block(button.tag - 100);
}

-(void)setNav_function_block:(navFunctionBlock)nav_function_block
{
    _nav_function_block = nav_function_block;
}

-(void)setMyHidden:(BOOL)myHidden
{
    _myHidden = myHidden;
    [UIView animateWithDuration:0.4 animations:^{
        if (myHidden)
        {
            self.alpha = 0;
        }else
        {
            self.alpha = 0.8;
        }
    } completion:^(BOOL finished) {
        
    }];
}


@end












