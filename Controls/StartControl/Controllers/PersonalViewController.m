//
//  PersonalViewController.m
//  CustomNewProject
//
//  Created by szk on 14/11/25.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//


//个人中心

#import "PersonalViewController.h"

#import "GmPrepareNetData.h"

@interface PersonalViewController ()
{
    UIView *_upThreeViewBackGroundView;//headerview
    UIImageView *_topImv;//banner
    UIImageView *_faceImv;//头像
    UILabel *_nameLabel;//用户名
    UIView *_threeBtnBackgroundView;//三个按钮的底层view
    
    
    UILabel *_anliNumLabel;//收藏案例上的数字
    UILabel *_chanpinNumLabel;//收藏产品上的数字
    UILabel *_dianpuLabel;//收藏店铺上的数字
    
    
    

    int _page;//第几页
    int _pageCapacity;//一页请求几条数据
    NSArray *_dataArray;//数据源
    
    RefreshTableView *_tableView;//主tableview
    
}
@end

@implementation PersonalViewController



- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%s",__FUNCTION__);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.leftString = @"菜单";
    self.myTitle = @"个人中心";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeText WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    
    //设置tabelview headerview
    [self creatHeaderView];
    
    _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT)];
    _tableView.refreshDelegate = self;//用refreshDelegate替换UITableViewDelegate
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _page = 1;
    
    [_tableView showRefreshHeader:YES];//进入界面先刷新数据
    
    _tableView.tableHeaderView = _upThreeViewBackGroundView;
    
}


-(void)leftButtonTap:(UIButton *)sender
{
    [self.airViewController showAirViewFromViewController:self.navigationController complete:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//创建tableviewheaderview
-(void)creatHeaderView{
    //bannaer 头像 用户名 三个按钮底层view 的下层view
    _upThreeViewBackGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, 0)];
    _upThreeViewBackGroundView.backgroundColor = [UIColor yellowColor];
    
    
    
    //banner
    _topImv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH,ALL_FRAME_HEIGHT*142/568 )];
    _topImv.backgroundColor = [UIColor redColor];
    [_upThreeViewBackGroundView addSubview:_topImv];
    
    //头像
    _faceImv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH*70/320, ALL_FRAME_HEIGHT*70/568)];
    _faceImv.backgroundColor = [UIColor orangeColor];
    _faceImv.center = CGPointMake(ALL_FRAME_WIDTH/2, _topImv.frame.size.height);
    _faceImv.layer.cornerRadius = ALL_FRAME_WIDTH*70/320/2;
    _faceImv.layer.masksToBounds = YES;
    [_upThreeViewBackGroundView addSubview:_faceImv];
    
    //用户名
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_faceImv.frame)+8, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT *17/568)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.text = @"newbilityPangSmall";
    _nameLabel.textColor = [UIColor blackColor];
    _nameLabel.backgroundColor = [UIColor lightGrayColor];
    [_upThreeViewBackGroundView addSubview:_nameLabel];
    
    
    //三个按钮的下层view
    _threeBtnBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameLabel.frame)+25, ALL_FRAME_WIDTH, ALL_FRAME_WIDTH *50/320)];
    _threeBtnBackgroundView.backgroundColor = RGBCOLOR(214, 213, 218);
    [_upThreeViewBackGroundView addSubview:_threeBtnBackgroundView];
    _upThreeViewBackGroundView.frame = CGRectMake(0, 0, ALL_FRAME_WIDTH, CGRectGetMaxY(_threeBtnBackgroundView.frame));
    
    for (int i = 0; i<3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0+i * ALL_FRAME_WIDTH/3, 0.5, ALL_FRAME_WIDTH/3, _threeBtnBackgroundView.frame.size.height)];
        view.backgroundColor = RGBCOLOR(arc4random()%255, arc4random()%255, arc4random()%255);
        [_threeBtnBackgroundView addSubview:view];
        
    }
    
    
    
    
    
    
    [self.view addSubview:_upThreeViewBackGroundView];
}

#pragma mark - 上提下拉相关方法开始

//请求网络数据
-(void)prepareNetData{
    
    NSString *api = [@"123" stringByAppendingString:[NSString stringWithFormat:@"&page=%d&ps=%d",_page,_pageCapacity]];
    //请求用户通知接口
    NSLog(@"请求用户通知接口:%@",api);
    
    __weak typeof (self)bself = self;
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        
        NSDictionary *datainfo = [result objectForKey:@"datainfo"];
        
        NSArray *dataArray = [datainfo objectForKey:@"data"];
        
        if (dataArray.count < _pageCapacity) {
            
            _tableView.isHaveMoreData = NO;
        }else
        {
            _tableView.isHaveMoreData = YES;
        }
        
        
        [bself reloadData:dataArray isReload:_tableView.isReloadData];
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        if (_tableView.isReloadData) {
            
            _page --;
            
            [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
        }
    }];
    
}


#pragma mark - 下拉刷新上提加载更多
/**
 *  刷新数据列表
 *
 *  @param dataArr  新请求的数据
 *  @param isReload 判断在刷新或者加载更多
 */
- (void)reloadData:(NSArray *)dataArr isReload:(BOOL)isReload
{
    if (isReload) {
        
        _dataArray = dataArr;
        
    }else
    {
        NSMutableArray *newArr = [NSMutableArray arrayWithArray:_dataArray];
        [newArr addObjectsFromArray:dataArr];
        _dataArray = newArr;
    }
    
    [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:1.0];
}



#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    _page = 1;
    
    [self prepareNetData];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    
    _page ++;
    
    [self prepareNetData];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__FUNCTION__);
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


//- (void)loadNewData;
//- (void)loadMoreData;
//- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
//- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath;
//- (UIView *)viewForHeaderInSection:(NSInteger)section;
//- (CGFloat)heightForHeaderInSection:(NSInteger)section;




#pragma mark -  UITableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
    return _dataArray.count;
}







//单元格个数一个屏幕里占不满的话 下面不显示出来
//_tableView继承自RefreshTableView  RefreshTableView遵循UITableViewDelegate协议
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return [UIView new];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01f;
//}


#pragma mark - 上提下拉相关方法结束







@end
