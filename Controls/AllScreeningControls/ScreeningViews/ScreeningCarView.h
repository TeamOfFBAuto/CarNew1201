//
//  ScreeningCarView.h
//  CustomNewProject
//
//  Created by soulnear on 14-12-2.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//
/*
 *筛选车型界面
 */

#import <UIKit/UIKit.h>

@interface ScreeningCarView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    
}

///品牌
@property(nonatomic,strong)UITableView * brand_tableView;
///品牌数据容器
@property(nonatomic,strong)NSMutableArray * brand_array;
///车型
@property(nonatomic,strong)UITableView * cars_tableView;
///车系数据容器
@property(nonatomic,strong)NSMutableArray * cars_array;
///列表头
@property(nonatomic,strong)NSMutableArray * section_array;

@end
