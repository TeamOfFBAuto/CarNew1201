//
//  ScreeningAreaView.m
//  CustomNewProject
//
//  Created by soulnear on 14-12-5.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "ScreeningAreaView.h"

@implementation ScreeningAreaView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup
{
    _myTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    [self addSubview:_myTableView];
}


#pragma mark - UITableView Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,20)];
    label.backgroundColor = RGBCOLOR(239,237,237);
    label.font = [UIFont boldSystemFontOfSize:12];
    label.textColor = RGBCOLOR(21,21,21);
    label.text = @"    A";
    return label;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = @"安徽";
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = RGBCOLOR(12,12,12);
    
    return cell;
}

@end
