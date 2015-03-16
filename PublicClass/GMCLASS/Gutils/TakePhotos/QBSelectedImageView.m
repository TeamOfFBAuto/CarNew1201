//
//  QBSelectedImageView.m
//  FBCircle
//
//  Created by soulnear on 14-8-5.
//  Copyright (c) 2014年 soulnear. All rights reserved.
//

#import "QBSelectedImageView.h"

@implementation QBSelectedImageView
@synthesize label = _label;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.image = [UIImage imageNamed:@"qbasset_collection_chose.png"];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake((DEVICE_WIDTH-8)/3-23,3,23,20)];
        
        _label.backgroundColor = [UIColor clearColor];
        
        _label.font = [UIFont systemFontOfSize:14];
        
        _label.text = @"";
        
        _label.textColor = [UIColor whiteColor];
        
        _label.textAlignment = NSTextAlignmentCenter;

        [self addSubview:_label];
    }
    return self;
}



-(void)setNumberLabel:(NSString *)theText
{
    _label.text = theText;
    
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
