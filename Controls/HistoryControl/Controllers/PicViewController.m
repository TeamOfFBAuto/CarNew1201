//
//  PicViewController.m
//  CustomNewProject
//
//  Created by szk on 14/11/25.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "PicViewController.h"
#import "RefreshTableView.h"

#import "AnliViewCell.h"
#import "AnliModel.h"

#import "AnliDetailViewController.h"

@interface PicViewController ()<UITableViewDataSource,RefreshDelegate>
{
    RefreshTableView *_table;
}

@end

@implementation PicViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];    
    
    self.leftString = @"菜单";
    self.myTitle = @"案例图库";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeText WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    [self createNavigationTools];
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT - 44)];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    
    _table.backgroundColor = [UIColor whiteColor];
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    [_table showRefreshHeader:YES];
}


-(void)leftButtonTap:(UIButton *)sender
{
    [self.airViewController showAirViewFromViewController:self.navigationController complete:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 网络请求

- (void)networkForAnliList:(int)pageNum
{
    
    __weak typeof(RefreshTableView *)weakTable = _table;
    __weak typeof(self)weakSelf = self;
    NSString *url = [NSString stringWithFormat:ANLI_LIST,pageNum,10];
    LTools *tool = [[LTools alloc]initWithUrl:url isPost:NO postData:nil];
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        if ([result isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dataInfo = result[@"datainfo"];
            
            if ([LTools isDictinary:dataInfo]) {
                
                int total = [dataInfo[@"total"] intValue];
                NSArray *data = dataInfo[@"data"];
                NSMutableArray *temp_arr = [NSMutableArray arrayWithCapacity:data.count];
                for (NSDictionary *aDic in data) {
                    AnliModel *aModel = [[AnliModel alloc]initWithDictionary:aDic];
                    [temp_arr addObject:aModel];
                }
                
                [weakTable reloadData:temp_arr total:total];
                
            }
            
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        [weakTable loadFail];
    }];
    
}

#pragma mark 创建视图

//导航右上角按钮
- (void)createNavigationTools
{
    
    //空格
    UIBarButtonItem * spaceButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton1.width = -15;
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
    //    rightView.backgroundColor = [UIColor orangeColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    self.navigationItem.rightBarButtonItems = @[spaceButton1,rightItem];
    
    //第一个按钮
    UIButton *saveButton =[[UIButton alloc]initWithFrame:CGRectMake(10,0,30,44)];
    [saveButton addTarget:self action:@selector(clickToCar:) forControlEvents:UIControlEventTouchUpInside];
    [saveButton setImage:[UIImage imageNamed:@"anli_carType"] forState:UIControlStateNormal];
    
    [rightView addSubview:saveButton];
    
    //第二个按钮
    UIButton *share_Button =[[UIButton alloc]initWithFrame:CGRectMake(saveButton.right + 5,0,30,44)];
    [share_Button addTarget:self action:@selector(clickToSearch:) forControlEvents:UIControlEventTouchUpInside];
    [share_Button setImage:[UIImage imageNamed:@"anli_fangda"] forState:UIControlStateNormal];
    
    [rightView addSubview:share_Button];
    
}

////导航右上角按钮
//- (void)createNavigationTools
//{
//    UIButton *saveButton =[[UIButton alloc]initWithFrame:CGRectMake(0,0,25,44)];
//    [saveButton addTarget:self action:@selector(clickToCar:) forControlEvents:UIControlEventTouchUpInside];
//    [saveButton setImage:[UIImage imageNamed:@"anli_carType"] forState:UIControlStateNormal];
//    UIBarButtonItem *save_item=[[UIBarButtonItem alloc]initWithCustomView:saveButton];
//    [saveButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
////    saveButton.backgroundColor = [UIColor orangeColor];
//    
//    UIButton *share_Button =[[UIButton alloc]initWithFrame:CGRectMake(0,0,25,44)];
//    [share_Button addTarget:self action:@selector(clickToSearch:) forControlEvents:UIControlEventTouchUpInside];
//    [share_Button setImage:[UIImage imageNamed:@"anli_fangda"] forState:UIControlStateNormal];
//    [share_Button setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
//    
////    share_Button.backgroundColor = [UIColor redColor];
//    
//    UIBarButtonItem *share_item=[[UIBarButtonItem alloc]initWithCustomView:share_Button];
//    self.navigationItem.rightBarButtonItems = @[share_item,save_item];
//}

#pragma mark 事件处理

/**
 *  车型筛选
 */
- (void)clickToCar:(UIButton *)sender
{
    
}

/**
 *  车型条件筛选
 */
- (void)clickToSearch:(UIButton *)sender
{
    
}

#pragma mark delegate

#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    NSLog(@"loadNewData");
    
    [self networkForAnliList:1];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    [self networkForAnliList:_table.pageNum];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AnliModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
    AnliDetailViewController *detail = [[AnliDetailViewController alloc]init];
    detail.anli_id = aModel.id;
    [self.navigationController pushViewController:detail animated:YES];
    
    [_table deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 297;
}

#pragma mark - UITableViewDelegate


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _table.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"AnliViewCell";
    
    AnliViewCell *cell = (AnliViewCell *)[LTools cellForIdentify:identifier cellName:@"AnliViewCell" forTable:tableView];
    
    AnliModel *aModel = (AnliModel *)[_table.dataArray objectAtIndex:indexPath.row];
    [cell setCellWithModel:aModel];
    
    return cell;
    
}


@end
