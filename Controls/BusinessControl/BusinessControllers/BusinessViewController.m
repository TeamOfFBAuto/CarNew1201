//
//  BusinessViewController.m
//  CustomNewProject
//
//  Created by szk on 14/11/25.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "BusinessViewController.h"
#import "BusinessListTableViewCell.h"
#import "SNRefreshTableView.h"

@interface BusinessViewController ()<SNRefreshDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    
}

@property(nonatomic,strong)SNRefreshTableView * myTableView;
@property(nonatomic,strong)NSMutableArray * data_array;
@end

@implementation BusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.leftString = @"菜单";
    self.myTitle = @"服务商家";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeText WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    
    _data_array = [NSMutableArray array];
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT-64) showLoadMore:YES];
    _myTableView.refreshDelegate = self;
    _myTableView.dataSource = self;
    _myTableView.contentSize = CGSizeMake(340,_myTableView.contentSize.height);
    [self.view addSubview:_myTableView];
    
    [self getBusinessData];
}


-(void)leftButtonTap:(UIButton *)sender
{
    [self.airViewController showAirViewFromViewController:self.navigationController complete:nil];
}



#pragma mark - 获取数据
-(void)getBusinessData
{
    NSString * fullUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,[NSString stringWithFormat:BUSINESS_LIST_URL,_myTableView.pageNum]];
    NSLog(@"current_page -----  %d",_myTableView.pageNum);
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    __weak typeof(self)bself = self;
    __block typeof(operation) request = operation;
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        if ([[allDic objectForKey:@"errcode"] intValue] == 0)
        {
            if (bself.myTableView.pageNum == 1) {
                [_data_array removeAllObjects];
                bself.myTableView.isHaveMoreData = YES;
            }
            
            NSDictionary * datainfo = [allDic objectForKey:@"datainfo"];
            int allPages = [[datainfo objectForKey:@"total"] intValue];
            NSArray * array = [datainfo objectForKey:@"data"];
            if ([array isKindOfClass:[NSArray class]])
            {
                for (NSDictionary * dic in array) {
                    BusinessListModel * model = [[BusinessListModel alloc] initWithDictionary:dic];
                    [_data_array addObject:model];
                }
                
                if (_data_array.count == allPages)
                {
                    bself.myTableView.isHaveMoreData = NO;
                }
            }
        }else
        {
            [ZSNApi showAutoHiddenMBProgressWithText:[allDic objectForKey:@"errinfo"] addToView:self.view];
        }
        [bself.myTableView finishReloadigData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [bself.myTableView finishReloadigData];
        [ZSNApi showAutoHiddenMBProgressWithText:@"加载失败，请检查您当前网络" addToView:self.view];
    }];
    
    [operation start];
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data_array.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    BusinessListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"BusinessListTableViewCell" owner:nil options:nil] objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (UIView * view in cell.labels_back_view.subviews) {
        [view removeFromSuperview];
    }
    
    [cell setInfoWithModel:[_data_array objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - 刷新代理
- (void)loadNewData
{
    [self getBusinessData];
}
- (void)loadMoreData
{
    [self getBusinessData];
}
- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x<-40)
    {
        [self.airViewController showAirViewFromViewController:self.navigationController complete:nil];
    }
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
