//
//  PeiJianListViewController.m
//  CustomNewProject
//
//  Created by soulnear on 15-1-29.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "PeiJianListViewController.h"
#import "PeiJianListModel.h"
#import "PeiJianListCell.h"
#import "AnliDetailViewController.h"
///数据统计该类代表的数字
#define CURRENT_SHOW_NUM @"10"


@interface PeiJianListViewController ()<RefreshDelegate,UITableViewDataSource>
{
    
}

@property(nonatomic,strong)RefreshTableView * myTableView;

@end

@implementation PeiJianListViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_GOTO WithObject:CURRENT_SHOW_NUM WithValue:@""];
   
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
     self.edgesForExtendedLayout = UIRectEdgeAll;
    if (self.navigationController.navigationBarHidden) {
        self.navigationController.navigationBarHidden = NO;
    }
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

-(void)leftButtonTap:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)] )
    {
        //iOS 5 new UINavigationBar custom background
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:MY_MACRO_NAME?IOS7DAOHANGLANBEIJING_PUSH:IOS6DAOHANGLANBEIJING] forBarMetrics: UIBarMetricsDefault];
    }
    
    UIBarButtonItem * spaceButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton1.width = MY_MACRO_NAME?-13:5;
    
    UIButton *button_back=[[UIButton alloc]initWithFrame:CGRectMake(MY_MACRO_NAME? -5:5,8,40,44)];
    [button_back addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [button_back setImage:[UIImage imageNamed:BACK_DEFAULT_IMAGE_GRAY] forState:UIControlStateNormal];
    UIBarButtonItem *back_item=[[UIBarButtonItem alloc]initWithCustomView:button_back];
    self.navigationItem.leftBarButtonItems=@[spaceButton1,back_item];
    
    UILabel * _myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,44)];
    _myTitleLabel.textAlignment = NSTextAlignmentCenter;
    _myTitleLabel.text = @"配件列表";
    _myTitleLabel.textColor = [UIColor blackColor];
    _myTitleLabel.font = [UIFont systemFontOfSize:17];
    self.navigationItem.titleView = _myTitleLabel;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //数据展示table
    _myTableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH,DEVICE_HEIGHT-64)];
    _myTableView.refreshDelegate = self;
    _myTableView.dataSource = self;
    
    _myTableView.backgroundColor = [UIColor clearColor];
    
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_myTableView];
    
    _myTableView.noDataStr = @"没有配件商品";
    [_myTableView showRefreshHeader:YES];
  
}

#pragma mark - 网络请求
-(void)networkGetPeiJianData
{
    NSString * fullUrl = [NSString stringWithFormat:PEIJIAN_LIEST_URL,_business_id,_myTableView.pageNum];
    
    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    __weak typeof(self)bself = self;
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        
        NSString * errcode = [allDic objectForKey:@"errcode"];
        NSString * errinfo = [allDic objectForKey:@"errinfo"];
        int total = [[[allDic objectForKey:@"datainfo"] objectForKey:@"total"] intValue];
        
        
        if ([errcode intValue] == 0)
        {
            NSArray * array = [[allDic objectForKey:@"datainfo"] objectForKey:@"data"];
            
            NSMutableArray *temp_arr = [NSMutableArray arrayWithCapacity:array.count];
            
            for (NSDictionary * dic in array) {
                PeiJianListModel * model = [[PeiJianListModel alloc] initWithDictionary:dic];
                [temp_arr addObject:model];
            }
            
            [bself.myTableView reloadData:temp_arr total:total];
        }else
        {
            [bself.myTableView loadFail];
            [ZSNApi showautoHiddenMBProgressWithTitle:@"" WithContent:errinfo addToView:self.view];
        }        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ZSNApi showAutoHiddenMBProgressWithText:@"获取失败" addToView:self.view];
        [bself.myTableView loadFail];
    }];
    
    
    [request start];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _myTableView.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    
    PeiJianListCell * cell = (PeiJianListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PeiJianListCell" owner:self options:nil] objectAtIndex:0];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PeiJianListModel * model = (PeiJianListModel *)[_myTableView.dataArray objectAtIndex:indexPath.row];
    
    [cell setInfoWithModel:model];
    
    return cell;
}


#pragma mark - Refresh Delegate
- (void)loadNewData
{
    [self networkGetPeiJianData];
}
- (void)loadMoreData
{
    [self networkGetPeiJianData];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PeiJianListModel * model = (PeiJianListModel *)[_myTableView.dataArray objectAtIndex:indexPath.row];
    
    AnliDetailViewController *detail = [[AnliDetailViewController alloc]init];
    detail.anli_id = model.id;
    detail.storeName = model.storename;
    detail.storeImage = _business_share_image;
    detail.detailType = Detail_Peijian;
    detail.storeId = self.business_id;
    [self.navigationController pushViewController:detail animated:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
