//
//  PicViewController.h
//  CustomNewProject
//
//  Created by szk on 14/11/25.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicViewController : MyViewController
{
    
}

///商家id，如果有值那么请求该商家下所有案例，如果没有请求所有案例
@property(nonatomic,strong)NSString * business_id;

@end
