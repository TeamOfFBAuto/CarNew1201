//
//  GaiZhuangRefreshTableView.m
//  CustomNewProject
//
//  Created by soulnear on 15-1-11.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "GaiZhuangRefreshTableView.h"

@implementation GaiZhuangRefreshTableView

-(void)createHeaderView
{
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setValue:[NSString stringWithFormat:@"%f",scrollView.contentOffset.y] forKey:@"offsetY"];
}

@end
