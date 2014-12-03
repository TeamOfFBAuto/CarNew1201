//
//  ScreeningCarView.m
//  CustomNewProject
//
//  Created by soulnear on 14-12-2.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "ScreeningCarView.h"

@implementation ScreeningCarView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

-(void)setup
{
    _brand_tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _brand_tableView.delegate = self;
    _brand_tableView.dataSource = self;
    [self addSubview:_brand_tableView];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _brand_array.count;
}

-(UITableViewCell *):(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}




@end














