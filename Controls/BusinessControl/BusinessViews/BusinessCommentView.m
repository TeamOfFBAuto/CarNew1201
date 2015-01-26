//
//  BusinessCommentView.m
//  CustomNewProject
//
//  Created by soulnear on 14-12-15.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "BusinessCommentView.h"

@implementation BusinessCommentView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0,DEVICE_HEIGHT-64,DEVICE_WIDTH,64);
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}

-(void)setup
{
    UIView * line_view = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.width,0.5)];
    line_view.backgroundColor = RGBCOLOR(217,217,217);
    [self addSubview:line_view];
    
    for (int i = 0;i < 2;i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100+i;
        button.frame = CGRectMake(10 + ((DEVICE_WIDTH-28.5)/2.0f+8.5)*i,12,(DEVICE_WIDTH-28.5)/2.0,73/2.0);
        [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        if (i == 0)
        {
            [button setTitle:@"购买咨询" forState:UIControlStateNormal];
            button.backgroundColor = RGBCOLOR(254,160,28);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
        }else
        {
            [button setTitle:@"我要点评" forState:UIControlStateNormal];
            button.backgroundColor = RGBCOLOR(144,144,144);
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        [self addSubview:button];
    }
}

-(void)buttonTap:(UIButton *)button
{
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:USER_IN])
    {
        BusinessCommentView_block(BusinessCommentViewTapTypeLogIn);
        return;
    }
    
    switch (button.tag-100)
    {
        case 0:
        {
            BusinessCommentView_block(BusinessCommentViewTapTypeConsult);
        }
            break;
        case 1:
        {
            BusinessCommentView_block(BusinessCommentViewTapTypeComment);
        }
            break;
            
        default:
            break;
    }
    
    
}


-(void)setMyBlock:(BusinessCommentViewBlock)aBlock
{
    BusinessCommentView_block = aBlock;
}

@end
