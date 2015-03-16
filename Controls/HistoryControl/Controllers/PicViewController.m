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
#import "CarTypeViewController.h"

#import "GSeachViewController.h"

#import "RCIM.h"


@interface PicViewController ()<UITableViewDataSource,RefreshDelegate>
{
    RefreshTableView *_table;
    
    UILabel *unreadNum_label;
    
    ///数据统计该类代表的数字
    NSString * CURRENT_SHOW_NUM;

}

@end

@implementation PicViewController

- (void)viewWillAppear:(BOOL)animated
{
    [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_GOTO WithObject:CURRENT_SHOW_NUM WithValue:@""];
    
    [super viewWillAppear:animated];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    if (_business_id.length)
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        UINavigationBar *bar = [self.navigationController navigationBar];
        CGFloat navBarHeight = 64;
        CGRect frame = CGRectMake(0.0f,0, DEVICE_WIDTH, navBarHeight);
        [bar setFrame:frame];
        _table.height = DEVICE_HEIGHT-64;
    }
    
    self.navigationController.navigationBarHidden = NO;
    
    [MobClick beginEvent:@"PicViewController"];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [MobClick endEvent:@"PicViewController"];
}


#pragma mark - 更新未读消息条数

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.isAddGestureRecognizer = YES;
    
    self.isShowUnreadNumLabel = YES;//左上角是否显示未读消息
    
    if (_business_id.length)
    {
        CURRENT_SHOW_NUM = @"11";
        self.leftImageName = BACK_DEFAULT_IMAGE_GRAY;
    }else
    {
        CURRENT_SHOW_NUM = @"4";
        self.leftImageName = @"new_menu-2";
        
        UIImageView *titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"new_logo"]];
        
        self.navigationItem.titleView = titleView;
    }
    
    self.myTitle = @"改装案例";
    
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeOther WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
//    [self createNavigationTools];//暂时没有筛选和搜索
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseCarType:) name:@"ChooseCarTypeNotification" object:nil];
    
    //数据展示table
    _table = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, DEVICE_HEIGHT-44)];
    _table.refreshDelegate = self;
    _table.dataSource = self;
    
    _table.backgroundColor = [UIColor clearColor];
    
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_table];
    
    _table.noDataStr = @"没有改装案例";
    _table.headerHeight = DEVICE_HEIGHT - 44;
    
    [_table showRefreshHeader:YES];
    
    [self.view bringSubviewToFront:self.unreadNum_label];
    
}


-(void)leftButtonTap:(UIButton *)sender
{
    if (_business_id.length)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_GOTO WithObject:CURRENT_SHOW_NUM WithValue:@"1"];
        [self.airViewController showAirViewFromViewController:self.navigationController complete:nil];
    }
    
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
    NSString *url = [NSString stringWithFormat:ANLI_LIST,pageNum,10,1,_business_id];
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
                
            }else
            {
                [LTools showMBProgressWithText:@"获取数据失败" addToView:self.view];
                [weakTable loadFail];
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

- (void)chooseCarType:(NSNotification *)notification
{
    NSLog(@"notification %@ %@",notification.object,notification.userInfo);
}

/**
 *  车型筛选
 */
- (void)clickToCar:(UIButton *)sender
{
    CarTypeViewController *carType = [[CarTypeViewController alloc]init];
    [self.navigationController pushViewController:carType animated:YES];
}

/**
 *  车型条件筛选
 */
- (void)clickToSearch:(UIButton *)sender
{
    
    
    NSLog(@"点击放大镜");
    GSeachViewController *sss = [[GSeachViewController alloc]init];
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:sss];
    [self presentViewController:navc animated:YES completion:^{
        
    }];
    
    
    
    
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
    
    [MobClick event:@"PicViewController_clicked"];
    
    AnliModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
    AnliDetailViewController *detail = [[AnliDetailViewController alloc]init];
    detail.anli_id = aModel.id;
    
    detail.shareTitle = aModel.title;
    detail.shareDescrition = aModel.sname;
    detail.shareImage = [LTools sd_imageForUrl:aModel.pichead];
    detail.storeName = aModel.sname;
    detail.storeImage = [LTools sd_imageForUrl:aModel.spichead];
    detail.storeId = aModel.uid;
    [self.navigationController pushViewController:detail animated:YES];
    
    [_table deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return [self heightFor:252];
}

//根据宽度适应高度
- (CGFloat)heightFor:(CGFloat)oHeight
{
   CGFloat aHeight = (ALL_FRAME_WIDTH / 320) * oHeight;
    return aHeight;
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


@end
