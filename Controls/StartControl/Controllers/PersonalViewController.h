//
//  PersonalViewController.h
//  CustomNewProject
//
//  Created by szk on 14/11/25.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//


//个人中心vc

#import <UIKit/UIKit.h>
#import "RefreshTableView.h"

@interface PersonalViewController : MyViewController<RefreshDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *_noDataView;//没有数据时候的展示view
    NSString *_isNoDataView;//是否显示没有数据的view
}
@end
