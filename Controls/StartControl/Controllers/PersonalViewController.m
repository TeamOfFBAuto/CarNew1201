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

typedef enum{
    GANLI = 0,//案例
    GCHANPIN ,//产品
    GDIANPU ,//店铺
}CELLTYPE;

@interface PersonalViewController ()
{
    UIView *_upThreeViewBackGroundView;//headerview
    UIImageView *_topImv;//banner
    UIImageView *_faceImv;//头像
    UILabel *_nameLabel;//用户名
    UIView *_threeBtnBackgroundView;//三个按钮的底层view
    
    
    UILabel *_anliNumLabel;//收藏案例上的数字label
    UILabel *_chanpinNumLabel;//收藏产品上的数字label
    UILabel *_dianpuNumLabel;//收藏店铺上的数字label
    UILabel *_anliTitleLabel;//案例title
    UILabel *_chanpinTitleLabel;//产品title
    UILabel *_dianpuTitleLabel;//店铺title
    
    CGFloat _cellHight;//单元格高度
    CELLTYPE _cellType;//单元格类型 案例 产品 店铺
    
    
    

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
    
    _page = 1;
    _pageCapacity = 10;
    
    [self changeNumAndTitleColorWithTag:11];
    
    _tableView = [[RefreshTableView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT)];
    _tableView.refreshDelegate = self;//用refreshDelegate替换UITableViewDelegate
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    
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
//    _upThreeViewBackGroundView.backgroundColor = [UIColor yellowColor];
    
    
    
    //banner
    _topImv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH,ALL_FRAME_HEIGHT*142/568 )];
    _topImv.backgroundColor = RGBCOLOR_ONE;
    [_upThreeViewBackGroundView addSubview:_topImv];
    
    //头像
    _faceImv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH*70/320.0, ALL_FRAME_WIDTH*70/320.0)];
    _faceImv.backgroundColor = RGBCOLOR_ONE;
    _faceImv.center = CGPointMake(ALL_FRAME_WIDTH/2, _topImv.frame.size.height);
    _faceImv.layer.cornerRadius = ALL_FRAME_WIDTH*70/320/2;
    _faceImv.layer.masksToBounds = YES;
    [_upThreeViewBackGroundView addSubview:_faceImv];
    
    //用户名
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_faceImv.frame)+8, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT *19/568)];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.text = [GMAPI getUsername];
    _nameLabel.textColor = [UIColor blackColor];
//    _nameLabel.backgroundColor = [UIColor lightGrayColor];
    [_upThreeViewBackGroundView addSubview:_nameLabel];
    
    
    //三个按钮的下层view
    _threeBtnBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameLabel.frame)+25, ALL_FRAME_WIDTH, ALL_FRAME_WIDTH *50/320)];
    _threeBtnBackgroundView.backgroundColor = RGBCOLOR(214, 213, 218);
    [_upThreeViewBackGroundView addSubview:_threeBtnBackgroundView];
    _upThreeViewBackGroundView.frame = CGRectMake(0, 0, ALL_FRAME_WIDTH, CGRectGetMaxY(_threeBtnBackgroundView.frame));
    
    for (int i = 0; i<3; i++) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0+i * ALL_FRAME_WIDTH/3.0, 0.5, ALL_FRAME_WIDTH/3, _threeBtnBackgroundView.frame.size.height)];
        view.backgroundColor = RGBCOLOR(251, 251, 251);
        view.tag = i+10;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gTap:)];
        [view addGestureRecognizer:tap];
        
        if (i == 0) {//案例
            //案例的数字
            _anliNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 28.0/568*ALL_FRAME_HEIGHT)];
//            _anliNumLabel.backgroundColor = RGBCOLOR_ONE;
            _anliNumLabel.textAlignment = NSTextAlignmentCenter;
            NSLog(@"案例的数字label%@",NSStringFromCGRect(_anliNumLabel.frame));
            _anliNumLabel.text = @"8";
            [view addSubview:_anliNumLabel];
            
            _anliTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_anliNumLabel.frame), _anliNumLabel.frame.size.width, view.frame.size.height-_anliNumLabel.frame.size.height)];
            _anliTitleLabel.text = @"收藏案例";
            _anliTitleLabel.textColor = RGBCOLOR(134, 134, 134);
            _anliTitleLabel.font = [UIFont systemFontOfSize:13];
            _anliTitleLabel.textAlignment = NSTextAlignmentCenter;
            [view addSubview:_anliTitleLabel];
            
            
        }else if (i == 1){//产品
            //产品的数字
            _chanpinNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 28.0/568*ALL_FRAME_HEIGHT)];
//            _chanpinNumLabel.backgroundColor = RGBCOLOR_ONE;
            _chanpinNumLabel.text = @"23";
            _chanpinNumLabel.textAlignment = NSTextAlignmentCenter;
            [view addSubview:_chanpinNumLabel];
            
            _chanpinTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_chanpinNumLabel.frame), _chanpinNumLabel.frame.size.width, view.frame.size.height-_chanpinNumLabel.frame.size.height)];
            _chanpinTitleLabel.text = @"收藏产品";
            _chanpinTitleLabel.textColor = RGBCOLOR(134, 134, 134);
            _chanpinTitleLabel.font = [UIFont systemFontOfSize:13];
            _chanpinTitleLabel.textAlignment = NSTextAlignmentCenter;
            [view addSubview:_chanpinTitleLabel];

            
            
        }else if (i == 2){//收藏店铺
            //店铺的数字
            _dianpuNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 28.0/568 * ALL_FRAME_HEIGHT)];
//            _dianpuNumLabel.backgroundColor = RGBCOLOR_ONE;
            _dianpuNumLabel.text = @"34";
            _dianpuNumLabel.textAlignment = NSTextAlignmentCenter;
            [view addSubview:_dianpuNumLabel];
            
            _dianpuTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_dianpuNumLabel.frame), _dianpuNumLabel.frame.size.width, view.frame.size.height-_dianpuNumLabel.frame.size.height)];
            _dianpuTitleLabel.text = @"收藏店铺";
            _dianpuTitleLabel.textColor = RGBCOLOR(134, 134, 134);
            _dianpuTitleLabel.font = [UIFont systemFontOfSize:13];
            _dianpuTitleLabel.textAlignment = NSTextAlignmentCenter;
            [view addSubview:_dianpuTitleLabel];
        }
        
        
        [_threeBtnBackgroundView addSubview:view];
        
    }
    
    
    
    
    
    
    [self.view addSubview:_upThreeViewBackGroundView];
}




-(void)gTap:(UITapGestureRecognizer *)sender{
    NSLog(@"%d",sender.view.tag);
    [self changeNumAndTitleColorWithTag:sender.view.tag];
}


-(void)changeNumAndTitleColorWithTag:(NSInteger)theTag{
    
    _dataArray = nil;
    _page = 1;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (theTag == 10) {//点击的是收藏案例
        _anliTitleLabel.textColor = RGBCOLOR(253, 160, 51);
        _anliNumLabel.textColor = RGBCOLOR(253, 160, 51);
        
        _chanpinTitleLabel.textColor = RGBCOLOR(160, 160, 160);
        _chanpinNumLabel.textColor = [UIColor blackColor];
        
        _dianpuTitleLabel.textColor = RGBCOLOR(160, 160, 160);
        _dianpuNumLabel.textColor = [UIColor blackColor];
        
        _cellHight = 220;
        _cellType = GCHANPIN;
        [self loadNewData];
        
        
    }else if (theTag == 11){//点击的是收藏产品
        
        _anliTitleLabel.textColor = RGBCOLOR(160, 160, 160);
        _anliNumLabel.textColor = [UIColor blackColor];
        
        _chanpinTitleLabel.textColor = RGBCOLOR(253, 160, 51);
        _chanpinNumLabel.textColor = RGBCOLOR(253, 160, 51);
        
        _dianpuTitleLabel.textColor = RGBCOLOR(160, 160, 160);
        _dianpuNumLabel.textColor = [UIColor blackColor];
        
        _cellHight = 220;
        _cellType = GCHANPIN;
        [self loadNewData];
        
        
    }else if (theTag == 12){//收藏店铺
        
        _anliTitleLabel.textColor = RGBCOLOR(160, 160, 160);
        _anliNumLabel.textColor = [UIColor blackColor];
        
        _chanpinTitleLabel.textColor = RGBCOLOR(160, 160, 160);
        _chanpinNumLabel.textColor = [UIColor blackColor];
        
        _dianpuTitleLabel.textColor =  RGBCOLOR(253, 160, 51);
        _dianpuNumLabel.textColor =  RGBCOLOR(253, 160, 51);
        
        _cellHight = 85;
        _cellType = GDIANPU;
        [self loadNewData];
        
    }
}



#pragma mark - 上提下拉相关方法开始

//请求网络数据
-(void)prepareNetDataWithCellType:(CELLTYPE)theType{
    
    //请求地址
    NSString *api = nil;
    
    if (theType == GANLI) {//案例
        api = [NSString stringWithFormat:G_ANLI,[GMAPI getUid],_page,_pageCapacity];
    }else if (theType == GCHANPIN){//产品
        api = [NSString stringWithFormat:G_PEIJIAN,[GMAPI getUid],_page,_pageCapacity];
    }else if (theType == GDIANPU){//店铺
        api = [NSString stringWithFormat:G_DIANPU,[GMAPI getUid],_page,_pageCapacity];
    }
    
    NSLog(@"请求的接口:%@",api);
    
    __weak typeof (self)bself = self;
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"我操到底走了吗%@",result);
        
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
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (_tableView.isReloadData) {
            
            _page --;
            
            [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:0.2];
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
    
    [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:0.2];
}



#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    _page = 1;
    _tableView.isReloadData = YES;
    
    [self prepareNetDataWithCellType:_cellType];
}

- (void)loadMoreData
{
    NSLog(@"loadMoreData");
    
    _page ++;
    _tableView.isReloadData = NO;
    
    [self prepareNetDataWithCellType:_cellType];
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s",__FUNCTION__);
}

- (CGFloat)heightForRowIndexPath:(NSIndexPath *)indexPath
{
    return _cellHight;
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
