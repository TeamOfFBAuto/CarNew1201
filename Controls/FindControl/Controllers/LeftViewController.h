//
//  LeftViewController.h
//  CustomNewProject
//
//  Created by szk on 14/11/25.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SelectedViewController.h"

@interface LeftViewController : PHAirViewController{

    NSArray *titles;
    NSArray *imageArr;
    int currentSelectButtonIndex;

}
@property(nonatomic,strong)SelectedViewController *firstVC;

@end
