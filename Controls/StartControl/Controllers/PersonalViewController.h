//
//  PersonalViewController.h
//  CustomNewProject
//
//  Created by szk on 14/11/25.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableView.h"

@interface PersonalViewController : MyViewController<RefreshDelegate,UITableViewDataSource,UITableViewDelegate>

@end
