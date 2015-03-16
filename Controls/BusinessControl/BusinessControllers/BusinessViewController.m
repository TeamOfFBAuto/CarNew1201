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
#import "ScreeningViewController.h"
#import "BusinessHomeViewController.h"
#import "GpersonCenterCustomCell.h"
///数据统计该类代表的数字
#define CURRENT_SHOW_NUM @"5"
@interface BusinessViewController ()<SNRefreshDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    
}

@property(nonatomic,strong)SNRefreshTableView * myTableView;
@property(nonatomic,strong)NSMutableArray * data_array;
@end

@implementation BusinessViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.navigationController.navigationBarHidden) {
        self.navigationController.navigationBarHidden = NO;
    }
    
    
    [MobClick beginEvent:@"BusinessViewController"];
    [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_GOTO WithObject:CURRENT_SHOW_NUM WithValue:@""];
}

-(void)viewWillDisappear:(BOOL)animated{
    [MobClick endEvent:@"BusinessViewController"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.isStoreAnli) {
        
        self.leftImageName = BACK_DEFAULT_IMAGE_GRAY;
        self.myTitle = self.storeName;
        
    }else
    {
        self.leftImageName = NAVIGATION_MENU_IMAGE_NAME2;

        self.myTitle = @"改装商家";
        self.isAddGestureRecognizer = YES;
        
        self.isShowUnreadNumLabel = YES;//左上角是否显示未读消息
    }
    
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeOther WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    _data_array = [NSMutableArray array];
    _myTableView = [[SNRefreshTableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT-64) showLoadMore:YES];
    _myTableView.refreshDelegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorColor = RGBCOLOR(223,223,223);
    _myTableView.contentSize = CGSizeMake(DEVICE_WIDTH+20,_myTableView.contentSize.height);
    [self.view addSubview:_myTableView];
    
    [self getBusinessData];
    
    
}


-(void)leftButtonTap:(UIButton *)sender
{
    if (self.isStoreAnli) {
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_GOTO WithObject:CURRENT_SHOW_NUM WithValue:@"1"];
    [self.airViewController showAirViewFromViewController:self.navigationController complete:nil];
}

-(void)rightButtonTap:(UIButton *)sender
{
    /*跳到筛选界面
    ScreeningViewController * screenVC = [[ScreeningViewController alloc] init];
    [self.navigationController pushViewController:screenVC animated:YES];
     */
}

#pragma mark - 获取数据
-(void)getBusinessData
{
    NSString * fullUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,[NSString stringWithFormat:BUSINESS_LIST_URL,self.storeId,_myTableView.pageNum]];
    NSLog(@"商家列表接口 -----  %@",fullUrl);
    AFHTTPRequestOperation * operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    __weak typeof(self)bself = self;
    __block typeof(operation) request = operation;
    
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        if ([[allDic objectForKey:@"errcode"] intValue] == 0)
        {
            if (bself.myTableView.pageNum == 1) {
                [bself.data_array removeAllObjects];
                bself.myTableView.isHaveMoreData = YES;
            }
            
            NSDictionary * datainfo = [allDic objectForKey:@"datainfo"];
            int allPages = [[datainfo objectForKey:@"total"] intValue];
            NSArray * array = [datainfo objectForKey:@"data"];
            if ([array isKindOfClass:[NSArray class]])
            {
                for (NSDictionary * dic in array) {
                    BusinessListModel * model = [[BusinessListModel alloc] initWithDictionary:dic];
                    [bself.data_array addObject:model];
                }
                
                if (bself.data_array.count == allPages)
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
    GpersonCenterCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GpersonCenterCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    for (UIView * view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    BusinessListModel *model = _data_array[indexPath.row];
    [cell loadCustomViewWithType:3];
    [cell setdataWithData:model];
    
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
    
    [MobClick event:@"BusinessViewController_cellClicked"];
    
    GpersonCenterCustomCell * cell = (GpersonCenterCustomCell*)[_myTableView cellForRowAtIndexPath:indexPath];
    
    BusinessListModel *model = _data_array[indexPath.row];
    BusinessHomeViewController * home = [[BusinessHomeViewController alloc] init];
    home.business_id = model.id;
    home.share_title = model.storename;
    home.share_image = cell.header_imageView.image;
    home.business_name = model.storename;
    [self.navigationController pushViewController:home animated:YES];
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{//d6601
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
