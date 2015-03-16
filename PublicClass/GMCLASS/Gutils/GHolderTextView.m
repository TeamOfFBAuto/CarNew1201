//
//  GHolderTextView.m
//  FBCircle
//
//  Created by gaomeng on 14-5-26.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "GHolderTextView.h"
#import "GFabuAnliViewController.h"


@implementation GHolderTextView

- (id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder holderSize:(CGFloat)holderSizeFloat;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.TV = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.TV.text = placeholder;
        self.TV.font = [UIFont systemFontOfSize:holderSizeFloat];
        self.TV.textColor = [UIColor grayColor];
        self.TV.backgroundColor = [UIColor clearColor];
        self.TV.editable = NO;
        [self addSubview:self.TV];
        [self sendSubviewToBack:self.TV];
        self.delegate = self;
    }
    return self;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    //placeholder
    if (self.text.length == 0) {
        self.TV.hidden = NO;
    }
    else {
        self.TV.hidden = YES;
    }
    
    NSLog(@"%@",self.text);
    
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self.delegate_fbvc changeTheTableViewContentOffset];
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [self.delegate_fbvc changeTheTableViewContentOffset1];
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    return YES;
}

@end
