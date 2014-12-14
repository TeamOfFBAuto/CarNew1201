//
//  BusinessViewController.h
//  CustomNewProject
//
//  Created by szk on 14/11/25.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//
/*
 *改装商家
 */

#import <UIKit/UIKit.h>

@interface BusinessViewController : MyViewController

@property(nonatomic,assign)BOOL isStoreAnli;//是否是某个店铺的案例列表

@property(nonatomic,retain)NSString *storeName;
@property(nonatomic,retain)NSString *storeId;//店铺id

@end
