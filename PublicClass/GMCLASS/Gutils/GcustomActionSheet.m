//
//  GcustomActionSheet.m
//  FBCircle
//
//  Created by gaomeng on 14-9-3.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "GcustomActionSheet.h"

@implementation GcustomActionSheet

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(GcustomActionSheet *)initWithTitle:(NSString *)aTitle//标题
                        buttonTitles:(NSArray *)buttonTitles//普通按钮的标题数组
                   buttonTitlesColor:(UIColor*)buttonTitleColor//普通按钮的title颜色
                         buttonColor:(UIColor *)buttonColor//普通按钮的背景颜色
                         CancelTitle:(NSString *)canceTitle//取消按钮的标题
                    cancelTitelColor:(UIColor*)cancelTitleColor//取消按钮的titile颜色
                         CancelColor:(UIColor *)cancelColor//取消按钮的背景颜色
                     actionBackColor:(UIColor *)actionColor//自定义action的背景颜色
{
    self = [super init];
    
    if (self)
    {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        self.window.windowLevel = UIWindowLevelStatusBar+1;
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        [self addGestureRecognizer:tap];
        
        
        _content_view = [[UIView alloc] init];
        
        if (actionColor)
        {
            _content_view.backgroundColor = actionColor;
        }
        [self addSubview:_content_view];
        
        float content_height = 0;
        
        if (aTitle)
        {
            content_height = 30;
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,10,ALL_FRAME_WIDTH-40,20)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.numberOfLines = 1;
            titleLabel.text = aTitle;
            _title_label = titleLabel;
            [_content_view addSubview:_title_label];
        }
        
        //普通按钮
        if (buttonTitles.count)
        {
            for (int i = 0;i < buttonTitles.count;i++)
            {
                UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
                b.frame = CGRectMake(20,firstBtnForTopSpacing+(HeightOfNormalBtn+normalBtnSpacing)*i,ALL_FRAME_WIDTH-40,44);
                b.tag = 101 + i;
//                b.layer.cornerRadius = 5.0f;
//                b.layer.masksToBounds = YES;
//                b.layer.borderWidth = 0.5;
//                b.layer.borderColor = RGBCOLOR(0,167,21).CGColor;
                b.backgroundColor = buttonColor;
                [b setTitleColor:buttonTitleColor forState:UIControlStateNormal];
                [b setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
                [b addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [_content_view addSubview:b];
            }
            
            content_height += 22+53*buttonTitles.count;
        }
        
        //取消按钮
        if (canceTitle)
        {
            UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
            b.frame = CGRectMake(20,content_height+10,ALL_FRAME_WIDTH-40,44);
            b.tag = 100;
//            b.layer.cornerRadius = 5.0f;
//            b.layer.masksToBounds = YES;
//            b.layer.borderWidth = 0.5f;
//            b.layer.borderColor = RGBCOLOR(170,170,170).CGColor;
            b.backgroundColor = cancelColor;
            [b setTitle:canceTitle forState:UIControlStateNormal];
            [b setTitleColor:cancelTitleColor forState:UIControlStateNormal];
            [b addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [_content_view addSubview:b];
            
            content_height += 50;
        }
        content_height += 18;
        
        _content_view.frame = CGRectMake(0,ALL_FRAME_HEIGHT,ALL_FRAME_WIDTH,content_height);
    }
    
    return self;
}






#pragma mark - 点空白区域收回视图

-(void)doTap:(UITapGestureRecognizer *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(gActionSheet:clickedButtonAtIndex:)])
    {
        [_delegate gActionSheet:self clickedButtonAtIndex:0];
    }
    
    [self hiddenViewWithAnimation:YES];
}

#pragma mark - 点击按钮，进行选择

-(void)buttonPressed:(UIButton *)button
{
    [self hiddenViewWithAnimation:YES];
    
    if (_delegate && [_delegate respondsToSelector:@selector(gActionSheet:clickedButtonAtIndex:)])
    {
        [_delegate gActionSheet:self clickedButtonAtIndex:button.tag-100];
    }
}


#pragma mark - 弹出视图

-(void)showInView:(UIView *)view WithAnimation:(BOOL)animation
{
    //    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    CGRect content_frame = _content_view.frame;
    
    content_frame.origin.y = DEVICE_HEIGHT -  content_frame.size.height;
    
    if (animation)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
            _content_view.frame = content_frame;
            
        } completion:^(BOOL finished) {
            
        }];
    }else
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
        _content_view.frame = content_frame;
    }
    [view addSubview:self];
    
    //    self.window.windowLevel = UIWindowLevelAlert;
}

#pragma mark - 试图消失
-(void)hiddenViewWithAnimation:(BOOL)animation
{
    
    CGRect content_frame = _content_view.frame;
    
    content_frame.origin.y = ALL_FRAME_HEIGHT;
    
    if (animation)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            _content_view.frame = content_frame;
            
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else
    {
        [self removeFromSuperview];
    }
}

@end
