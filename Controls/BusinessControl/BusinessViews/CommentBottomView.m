//
//  CommentBottomView.m
//  CustomNewProject
//
//  Created by soulnear on 14-12-15.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "CommentBottomView.h"

@implementation CommentBottomView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0,DEVICE_HEIGHT-62,DEVICE_WIDTH,62);
        self.backgroundColor = [UIColor whiteColor];
        [self setup];
    }
    return self;
}


-(void)setup
{
    UIImageView * headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16,10,42,42)];
    headerImageView.layer.cornerRadius = 21;
    headerImageView.layer.masksToBounds = YES;
    headerImageView.userInteractionEnabled = YES;
    [self addSubview:headerImageView];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_IN])
    {
        [headerImageView sd_setImageWithURL:[NSURL URLWithString:[ZSNApi returnMiddleUrl:[GMAPI getUid]]] placeholderImage:[UIImage imageNamed:HEADER_DEFAULT_IMAGE]];
    }
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
    [headerImageView addGestureRecognizer:tap];
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(72,16,232,30);
    button.layer.borderColor = RGBCOLOR(255,183,88).CGColor;
    button.layer.borderWidth = 0.5;
    [button setTitle:@"下面,我简单说两句" forState:UIControlStateNormal];
    [button setTitleColor:RGBCOLOR(105,105,105) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0,0,0,90)];
    [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(180,2,50,26)];
    label.backgroundColor = RGBCOLOR(255,144,0);
    label.text = @"发表";
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    [button addSubview:label];
}
-(void)doTap:(UITapGestureRecognizer *)sender
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_IN]) {
        return;
    }
    comment_bottom_block(CommentTypeLogIn);
}

-(void)buttonTap:(UIButton *)button
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:USER_IN]) {
        comment_bottom_block(CommentTypeComent);
    }else
    {
        comment_bottom_block(CommentTypeLogIn);
    }
}

-(void)setMyBlock:(CommentBottomViewBlock)aBlock
{
    comment_bottom_block = aBlock;
}

@end
