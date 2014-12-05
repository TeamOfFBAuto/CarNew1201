//
//  SliderBBSTitleView.m
//  越野e族
//
//  Created by soulnear on 14-7-3.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "SliderBBSTitleView.h"

#define SELECTED_COLOR RGBCOLOR(255,144,0)

#define UNSELECTED_CORLOR RGBCOLOR(36,36,36)


@implementation SliderBBSTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}


-(void)setAllViewsWith:(NSArray *)array withBlock:(SliderBBSTitleViewBlock)theBlock
{
    titleView_block = theBlock;
    total_pages = array.count;
    
    NSString * title = [array objectAtIndex:0];
    CGSize size = [ZSNApi stringHeightAndWidthWith:title WithHeight:MAXFLOAT WithWidth:MAXFLOAT WithFont:16];
    
    lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,self.frame.size.height,size.width+5,2)];
    lineImageView.backgroundColor = RGBCOLOR(255,144,0);
    [self addSubview:lineImageView];
    
    for (int i = 0;i < array.count;i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100+i;
        button.frame = CGRectMake((self.frame.size.width/array.count)*i,5,self.frame.size.width/array.count,self.frame.size.height-2-5);
        [button setTitle:[array objectAtIndex:i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18];
        [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            [button setTitleColor:SELECTED_COLOR forState:UIControlStateNormal];
            lineImageView.center = CGPointMake(button.center.x,self.frame.size.height-1);
        }else
        {
            [button setTitleColor:UNSELECTED_CORLOR forState:UIControlStateNormal];
        }
        
        [self addSubview:button];
    }
}


-(void)buttonTap:(UIButton *)sender
{
    titleView_block(sender.tag-100);
    
    UIButton * button;
    
    for (int i = 0;i<total_pages;i++) {
        if (sender.tag-100 != i)
        {
            button = (UIButton *)[self viewWithTag:i+100];
            [button setTitleColor:UNSELECTED_CORLOR forState:UIControlStateNormal];
        }
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [sender setTitleColor:SELECTED_COLOR forState:UIControlStateNormal];
        lineImageView.center = CGPointMake(sender.center.x,self.frame.size.height-1);
    } completion:^(BOOL finished) {
        
    }];
    
}


-(void)MyButtonStateWithIndex:(int)index
{
    UIButton * button = (UIButton *)[self viewWithTag:index+100];
    
    [self buttonTap:button];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end





























