//
//  PeiJianListViewController.m
//  CustomNewProject
//
//  Created by soulnear on 15-1-29.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "PeiJianListViewController.h"
#import "PeiJianListModel.h"



@interface PeiJianListViewController ()<RefreshDelegate,UITableViewDataSource>
{
    
}

@property(nonatomic,strong)RefreshTableView * myTableView;

@end

@implementation PeiJianListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    
    //数据展示table
    _myTableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT - 44 + 20)];
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
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 0;
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
