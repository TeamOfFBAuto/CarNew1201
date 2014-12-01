//
//  GHolderTextView.h
//  FBCircle
//
//  Created by gaomeng on 14-5-26.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GHolderTextView : UITextView <UITextViewDelegate>

@property(nonatomic,copy) NSString *placeholder;
@property(nonatomic,strong) UITextView *TV;


- (id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder holderSize:(CGFloat)holderSizeFloat;


@end
