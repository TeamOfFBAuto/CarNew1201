//
//  BusinessHomeViewController.h
//  CustomNewProject
//你好
//  Created by soulnear on 14-12-4.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessHomeViewController : MyViewController
{
    
}


@property(nonatomic,strong)NSString * business_id;
///要分享的图片
@property(nonatomic,strong)UIImage * share_image;
///要分享的标题
@property(nonatomic,strong)NSString * share_title;
///商家名称
@property(nonatomic,strong)NSString * business_name;

@end
