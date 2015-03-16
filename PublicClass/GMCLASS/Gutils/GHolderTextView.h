//
//  GHolderTextView.h
//  FBCircle
//
//  Created by gaomeng on 14-5-26.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GFabuAnliViewController;

@interface GHolderTextView : UITextView <UITextViewDelegate>

@property(nonatomic,copy) NSString *placeholder;
@property(nonatomic,strong) UITextView *TV;
@property(nonatomic,assign)GFabuAnliViewController *delegate_fbvc;

- (id)initWithFrame:(CGRect)frame placeholder:(NSString *)placeholder holderSize:(CGFloat)holderSizeFloat;


@end
