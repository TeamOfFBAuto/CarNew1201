//
//  ScreeningCarView.m
//  CustomNewProject
//
//  Created by soulnear on 14-12-2.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "ScreeningCarView.h"
#import "BrandModel.h"

@implementation ScreeningCarView


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
    _section_array = [NSMutableArray array];
    _brand_array = [NSMutableArray array];
    _cars_array = [NSMutableArray array];
    
    _brand_tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    _brand_tableView.sectionIndexBackgroundColor = RGBCOLOR(239,237,237);
    _brand_tableView.separatorColor = RGBCOLOR(197,197,197);
    _brand_tableView.delegate = self;
    _brand_tableView.dataSource = self;
    [self addSubview:_brand_tableView];
    [[UITableViewHeaderFooterView appearance] setTintColor:RGBCOLOR(239,237,237)];
    _brand_tableView.sectionIndexColor = RGBCOLOR(138,136,137);
    _brand_tableView.sectionIndexTrackingBackgroundColor = [UIColor lightGrayColor];
    _brand_tableView.sectionIndexBackgroundColor = [UIColor clearColor];

    
    _cars_tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.bounds.size.width+10,0,180,self.frame.size.height) style:UITableViewStylePlain];
    _cars_tableView.separatorColor = RGBCOLOR(197,197,197);
    _cars_tableView.delegate = self;
    _cars_tableView.dataSource = self;
    _cars_tableView.layer.masksToBounds = NO;
    _cars_tableView.layer.shadowColor = [UIColor blackColor].CGColor;
    _cars_tableView.layer.shadowOffset = CGSizeMake(-4,0);
    _cars_tableView.layer.shadowRadius = 2;
    _cars_tableView.layer.shadowOpacity = 0.2;
    [self addSubview:_cars_tableView];
    
    [self getBrandData];
}

#pragma marl - 请求所有品牌数据
///请求所有品牌数据
-(void)getBrandData
{
    NSString * fullUrl = @"http://carport.fblife.com/carapi/getcaralllist.php?datatype=json&groupid=0";
    
    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        NSMutableArray * temp_array = [NSMutableArray array];
        if ([[allDic objectForKey:@"errno"] intValue] == 0) {
            NSArray * array = [allDic objectForKey:@"carlist"];
            
            for (NSDictionary * dic in array) {
                BrandModel * info = [[BrandModel alloc] init];
                info.car_name = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
                info.car_id = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                info.car_fwords = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fwords"]];
                info.car_words = [NSString stringWithFormat:@"%@",[dic objectForKey:@"words"]];
                [temp_array addObject:info];
            }
            [self exChangeData:temp_array];
            temp_array = nil;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [request start];
}

///请求品牌下所有车型数据
-(void)getCarsDataWithType:(NSString *)brand
{
    
    if (_cars_array.count > 0) {
        [_cars_array removeAllObjects];
        [_cars_tableView reloadData];
    }
    
    NSString * fullUrl = [NSString stringWithFormat:@"http://carport.fblife.com/carapi/getserieslist.php?words=%@&datatype=json",[brand stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    __weak typeof(self) bself = self;
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        NSLog(@"allDic ----  %@",allDic);
        if ([[allDic objectForKey:@""] intValue] == 0) {
            NSArray * array = [allDic objectForKey:@"series"];
            for (NSDictionary * dic in array)
            {
                [bself.cars_array addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]]];
            }
            [bself.cars_tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [request start];
    
}

-(void)exChangeData:(NSMutableArray *)temp_array
{
    NSMutableArray * temp = [[NSMutableArray alloc] init];
    
    for (BrandModel * info in temp_array)
    {
        
        if (![_section_array containsObject:info.car_fwords])
        {
            [_section_array addObject:info.car_fwords];
        }
        [temp addObject:info];
    }
    
    
    for (int i = 0;i < _section_array.count;i++)
    {
        NSMutableArray * array = [[NSMutableArray alloc] init];
        
        [_brand_array addObject:array];
    }
    
    for (BrandModel * info in temp)
    {
        for (int i = 0;i < _section_array.count;i++)
        {
            NSString * string = [_section_array objectAtIndex:i];
            
            if ([string isEqualToString:info.car_fwords])
            {
                [[_brand_array objectAtIndex:i] addObject:info];
                break;
            }
        }
    }
    [self.brand_tableView reloadData];
}

#pragma mark - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (tableView == _brand_tableView)
    {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
    }else
    {
        return 0;
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == _brand_tableView)
    {
        return [NSArray arrayWithArray:_section_array];
    }else
    {
        return nil;
    }
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == _brand_tableView) {
        return _section_array.count;
    }else
    {
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _brand_tableView) {
        return [[_brand_array objectAtIndex:section] count];
    }else
    {
        return _cars_array.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _brand_tableView) {
        return 40;
    }else
    {
        return 41;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _brand_tableView) {
        return 20;
    }else
    {
        return 0;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == _brand_tableView) {
        return [_section_array objectAtIndex:section];
    }else
    {
        return @"";
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _brand_tableView) {
        UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,20)];
        label.backgroundColor = RGBCOLOR(239,237,237);
        label.font = [UIFont boldSystemFontOfSize:12];
        label.textColor = RGBCOLOR(21,21,21);
        label.text = [NSString stringWithFormat:@"    %@",[_section_array objectAtIndex:section]];
        return label;
    }else
    {
        return nil;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _brand_tableView) {
        static NSString * identifier = @"identifier";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        BrandModel * model = [[_brand_array objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.text = model.car_name;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = RGBCOLOR(12,12,12);
        return cell;
    }else
    {
        static NSString * identifier = @"identifier";
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.textLabel.text = [_cars_array objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = [UIColor blackColor];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _brand_tableView)
    {
        BrandModel * model = [[_brand_array objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        [self getCarsDataWithType:model.car_words];
        
        [self ShowCarsView:YES];
    }else
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ChooseCarTypeNotification" object:[_cars_array objectAtIndex:indexPath.row] userInfo:nil];
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _brand_tableView) {
        [self ShowCarsView:NO];
    }
}


#pragma mark - 显示/隐藏车型视图
-(void)ShowCarsView:(BOOL)isShow
{
    [UIView animateWithDuration:0.4 animations:^{
        _cars_tableView.frame = CGRectMake(isShow?(DEVICE_WIDTH-_cars_tableView.frame.size.width):(self.frame.size.width+10),_cars_tableView.frame.origin.y,_cars_tableView.frame.size.width,_cars_tableView.frame.size.height);
    } completion:^(BOOL finished)
     {
         
     }];
}


@end














