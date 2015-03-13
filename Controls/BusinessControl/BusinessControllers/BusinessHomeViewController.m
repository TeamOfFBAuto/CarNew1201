//
//  BusinessHomeViewController.m
//  CustomNewProject
//
//  Created by soulnear on 14-12-4.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "BusinessHomeViewController.h"
#import "NavigationFunctionView.h"
#import "LShareTools.h"
#import "BusinessCommentView.h"
#import "AnliDetailViewController.h"
#import "GscoreStarViewController.h"
#import "LogInViewController.h"
#import "BusinessDetailModel.h"
#import "FBMapViewController.h"
#import "PicViewController.h"
#import "PeiJianListViewController.h"
///数据统计该类代表的数字
#define CURRENT_SHOW_NUM @"2"


@interface BusinessHomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,UIScrollViewDelegate>
{
    ///背景图
    UIImageView * banner_imageView;
    ///商家信息视图
    UIView * sectionView;
    ///用户头像
    UIImageView * header_imageView;
    ///用户名
    UILabel * userName_label;
    ///商家简介
    UILabel * content_label;
    ///商家地址
    UIButton * address_button;
    ///商家电话
    UIButton * phone_button;
    
    UIButton * right_button;
    
    MBProgressHUD * hud;
    
    ///右上角菜单栏
    NavigationFunctionView * functionView;
    ///底部评论视图
    BusinessCommentView * bottomView;
    ///屏幕点击
    UITapGestureRecognizer * view_tap;
    
    float currentOffY;
    
    ///进度条
    UIView * progress;
    UIView * greenView;
    NSTimer * timer;
    ///是否收藏
    BOOL isCollected;
    ///商家电话
    NSString * telphone;
}

@property(nonatomic,strong)UITableView * myTableView;
@property(nonatomic,strong)BusinessDetailModel * businessModel;
@property(nonatomic,strong)UIWebView * myWebView;
@end

@implementation BusinessHomeViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//    self.navigationController.navigationBarHidden = YES;
    
    [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_GOTO WithObject:CURRENT_SHOW_NUM WithValue:@""];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successLogIn) name:@"gdengluchenggong" object:nil];
    
    
    [MobClick beginEvent:@"BusinessHomeViewController"];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
    [MobClick endEvent:@"BusinessHomeViewController"];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"gdengluchenggong" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    _businessModel = [[BusinessDetailModel alloc] init];
    currentOffY = 0.f;
    
    _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT-64)];
    _myWebView.delegate = self;
    _myWebView.scrollView.delegate = self;
    _myWebView.scrollView.bounces = NO;
    
    [self.view addSubview:_myWebView];
    
    NSString * fullUrl = [NSString stringWithFormat:@"http://g.fblife.com/web.php?c=wap&a=getStore&storeid=%@",_business_id];
    [_myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    _myWebView.backgroundColor = COLOR_WEB_DETAIL_BACKCOLOR;
    
    
//    hud = [ZSNApi showMBProgressWithText:@"加载中..." addToView:self.view];
//    hud.mode = MBProgressHUDModeIndeterminate;
    
    /*
    [self setTableSectionView];
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT) style:UITableViewStylePlain];
    _myTableView.delegate = self;
    _myTableView.dataSource = self;
    _myTableView.separatorColor = RGBCOLOR(217,217,217);
    [self.view addSubview:_myTableView];
    _myTableView.tableHeaderView = sectionView;
    
    
    [self setNavgationView];
     */
    
    
    bottomView = [[BusinessCommentView alloc] init];
    [self.view addSubview:bottomView];
    __weak typeof(self)bself = self;
    [bottomView setMyBlock:^(BusinessCommentViewTapType aType) {
        switch (aType) {
            case BusinessCommentViewTapTypeLogIn://登陆
            {
//                LogInViewController * logInVC = [[LogInViewController alloc] init];
//                UINavigationController * navc = [[UINavigationController alloc] initWithRootViewController:logInVC];
//                [bself presentViewController:navc animated:YES completion:nil];
                
                NewLogInView * loginView = [[NewLogInView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT)];
                loginView.backgroundColor = [UIColor colorWithPatternImage:[ZSNApi screenShot]];
                [[UIApplication sharedApplication].keyWindow addSubview:loginView];
            }
                break;
            case BusinessCommentViewTapTypeComment://评论
            {
                
                [MobClick event:@"BusinessHomeViewController_dianping"];
                
                GscoreStarViewController *cc = [[GscoreStarViewController alloc]init];
                cc.commentType = Comment_DianPu;//评论类型（枚举）
                cc.commentId = bself.business_id;//对应的id
                UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:cc];
                [bself presentViewController:navc animated:YES completion:^{
                    
                }];
            }
                break;
            case BusinessCommentViewTapTypeConsult://购买咨询
            {
                /*电话咨询
                if (bself.businessModel.tel.length > 0) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",bself.businessModel.tel]]];
                }else
                {
                    [LTools showMBProgressWithText:@"暂无商家电话信息" addToView:bself.view];
                }
                 */
                
                [MobClick event:@"BusinessHomeViewController_goumaizixun"];
                
                [LTools rongCloudChatWithUserId:bself.business_id userName:bself.business_name viewController:bself];
            }
                break;
                
            default:
                break;
        }
    }];
    
    [self setNavgationView];
    
    [self getBusinessDetailData];

    [self progress];
    
    ///接受评论成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successComment) name:@"successedComment" object:nil];
    ///接受收藏成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successComment) name:G_USERCENTERLOADUSERINFO object:nil];
    
}
#pragma mark - 登陆成功通知
-(void)successLogIn
{
    [self getBusinessDetailData];
}
#pragma mark - 评论成功
-(void)successComment
{
    [_myWebView reload];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    hud.labelText = @"加载失败";
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:1.5];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [hud hide:YES];
    right_button.userInteractionEnabled = YES;
    [self progressToFinish];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@" -- - -- - - - --   %d -----  %@",navigationType,[request.URL absoluteString]);
    
    NSString *relativeUrl = request.URL.relativeString;
    if ([relativeUrl rangeOfString:@"anlixingqing"].length > 0) {
        
        NSArray *dianpu = [relativeUrl componentsSeparatedByString:@"&anlixingqing"];
        if (dianpu.count > 1) {
            
            [MobClick event:@"BusinessHomeViewController_anlidetail"];
            
            NSString *dianpuId = dianpu[1];
            NSLog(@"案例详情 id:%@",dianpuId);
            
            AnliDetailViewController *detail = [[AnliDetailViewController alloc]init];
            detail.anli_id = dianpuId;
            detail.detailType = Detail_Anli;
            detail.storeImage = self.share_image;
            detail.storeName = self.business_name;
            detail.storeId = self.business_id;
            [self.navigationController pushViewController:detail animated:YES];
        }
        
        return NO;
    }
    
    if ([relativeUrl rangeOfString:@"peijianxiangqing"].length > 0) {
        
        NSArray *dianpu = [relativeUrl componentsSeparatedByString:@"&peijianxiangqing"];
        if (dianpu.count > 1) {
            
            [MobClick endEvent:@"BusinessHomeViewController_peijianDetail"];
            
            NSString *dianpuId = dianpu[1];
            NSLog(@"配件详情 id:%@",dianpuId);
            
            AnliDetailViewController *detail = [[AnliDetailViewController alloc]init];
            detail.anli_id = dianpuId;
            detail.storeName = self.business_name;
            detail.detailType = Detail_Peijian;
            detail.storeImage = self.share_image;
            detail.storeId = self.business_id;
            self.edgesForExtendedLayout = UIRectEdgeAll;
            self.navigationController.navigationBarHidden = NO;
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            [self.navigationController pushViewController:detail animated:YES];

        }
        
        return NO;
    }
    
    
    if ([relativeUrl rangeOfString:@"map:"].length > 0)
    {
        
        [MobClick event:@"BusinessHomeViewController_map"];
        
        NSString * lat;
        NSString * lng;
        NSString * latlng = [relativeUrl stringByReplacingOccurrencesOfString:@"map:" withString:@""];
        
        
        NSArray * array = [latlng componentsSeparatedByString:@","];
        
        NSLog(@"array ------   %@",array);
        
        if (latlng)
        {
            lat = [array objectAtIndex:1];
            lng = [array objectAtIndex:0];
            
            if ([lat isEqualToString:@"0"] && [lng isEqualToString:@"0"])
            {
                [ZSNApi showAutoHiddenMBProgressWithText:@"商家没有上传地图信息" addToView:self.view];
                return NO;
            }
        }
        
        
        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_LOCATION WithObject:[NSString stringWithFormat:@"%@,%@",lat,lng] WithValue:@""];
        
        NSString * address = [relativeUrl stringByReplacingOccurrencesOfString:@"map:" withString:@""];
        NSLog(@"address ------   %@",address);
        
        FBMapViewController * mapViewController = [[FBMapViewController alloc] init];
        mapViewController.address_content = _businessModel.phone;
        mapViewController.address_title = _businessModel.title;
        mapViewController.address_latitude = [lat doubleValue];
        mapViewController.address_longitude = [lng doubleValue];
        
        [self.navigationController pushViewController:mapViewController animated:YES];
        
        return NO;
    }
    
    if ([relativeUrl rangeOfString:@"tel:"].length > 0)
    {
        NSString * phone = [relativeUrl stringByReplacingOccurrencesOfString:@"tel:" withString:@""];
        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_DAIL WithObject:phone WithValue:@""];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]]];
    }
    
    
    ///案例更过按钮
    if ([relativeUrl rangeOfString:@"case"].length > 0) {
        
        [MobClick event:@"BusinessHomeViewController_anlimore"];
        
        PicViewController * pic = [[PicViewController alloc] init];
        pic.business_id = _business_id;
        [self.navigationController pushViewController:pic animated:YES];
        
        return NO;
    }
    
    ///配件更多按钮
    if ([relativeUrl rangeOfString:@"goods"].length > 0) {
        
        [MobClick event:@"BusinessHomeViewController_peijianmore"];
        
        PeiJianListViewController * peijianList = [[PeiJianListViewController alloc] init];
        peijianList.business_id = _business_id;
        peijianList.business_share_image = _share_image;
        self.edgesForExtendedLayout = UIRectEdgeAll;
        [self.navigationController pushViewController:peijianList animated:YES];
        
        return NO;
    }
    
    
    [MobClick event:@"BusinessHomeViewController_phone"];
    
    
    return YES;
}



-(void)setNavgationView
{
    UIImageView * navigation_view = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,64)];
    navigation_view.image = [UIImage imageNamed:@"default_navigation_clear_image"];
    [self.view addSubview:navigation_view];
    navigation_view.userInteractionEnabled = YES;
    [self.view bringSubviewToFront:navigation_view];
    
    UIButton * back_button = [UIButton buttonWithType:UIButtonTypeCustom];
    back_button.frame = CGRectMake(2,0,38.5,39.5);
//        back_button.backgroundColor = [UIColor orangeColor];
    [back_button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [back_button setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    [navigation_view addSubview:back_button];
    
    
    right_button = [UIButton buttonWithType:UIButtonTypeCustom];
    right_button.frame = CGRectMake(DEVICE_WIDTH-40,6,40,24.5);
    right_button.userInteractionEnabled = NO;
    [right_button addTarget:self action:@selector(rightButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [right_button setImage:[UIImage imageNamed:@"navigation_right_menu_image"] forState:UIControlStateNormal];
    [navigation_view addSubview:right_button];
}

-(void)back:(UIButton *)button
{
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightButtonTap:(UIButton *)button
{
    if (!functionView)
    {
        functionView = [[NavigationFunctionView alloc] init];
        functionView.myHidden = YES;
        [functionView setIsShowThirdButton:NO];
        
        [self.view addSubview:functionView];
        __weak typeof(self)bself = self;
        __weak typeof(functionView)bFunctionView = functionView;
        [functionView setFunctionBlock:^(int index) {
            switch (index) {
                case 0:
                {
                    [MobClick event:@"BusinessHomeViewController_fenxiang"];
                    [bself shareClicked];
                }
                    break;
                case 1:
                {
                    [MobClick event:@"BusinessHomeViewController_zan"];
                    [bself collectionClicked];
                }
                    break;
                case 2:
                {
                    [bFunctionView setEyesState:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }];
    }
    [functionView setCollectionState:isCollected];
    functionView.myHidden = !functionView.myHidden;
}

#pragma mark - 分享
-(void)shareClicked
{
    [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_SHARE WithObject:@"2" WithValue:_business_id];
    
    LShareTools *tool = [LShareTools shareInstance];
    
    NSString *url = [NSString stringWithFormat:BUSINESS_SHARE_URL,_business_id];
//    NSString *imageUrl = @"http://fbautoapp.fblife.com/resource/head/84/9b/thumb_1_Thu.jpg";
    
    [tool showOrHidden:YES title:_businessModel.title description:_businessModel.content imageUrl:_businessModel.pichead aShareImage:_share_image linkUrl:url isNativeImage:YES];
}
#pragma mark - 收藏或取消收藏
-(void)collectionClicked
{
    BOOL isLogIn = [[NSUserDefaults standardUserDefaults] boolForKey:USER_IN];
    if (!isLogIn) {
//        LogInViewController * logInVc = [[LogInViewController alloc] init];
//        [self presentViewController:logInVc animated:YES completion:nil];
        
        
        NewLogInView * loginView = [[NewLogInView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT)];
        loginView.backgroundColor = [UIColor colorWithPatternImage:[ZSNApi screenShot]];
        [[UIApplication sharedApplication].keyWindow addSubview:loginView];
        
        return;
    }
    
    
    
    NSString * fullUrl;
    
    if (isCollected)
    {
        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_CANCEL_COLLECT WithObject:CURRENT_SHOW_NUM WithValue:_business_id];
        fullUrl = [NSString stringWithFormat:ANLI_CANCEL_COLLECT,[GMAPI getAuthkey],3,_business_id];
    }else
    {
        [[RecordDataClasses sharedManager] setActionStringWithAction:USER_ACTION_ADD_COLLECT WithObject:CURRENT_SHOW_NUM WithValue:_business_id];
        fullUrl = [NSString stringWithFormat:BUSINESS_COLLECTION_URL,[GMAPI getAuthkey],_business_id];
    }
    
    
    MBProgressHUD * aHud = [ZSNApi showMBProgressWithText:isCollected?@"正在取消收藏...":@"正在收藏..." addToView:self.view];
    aHud.mode = MBProgressHUDModeIndeterminate;
    
//    NSString *url = [NSString stringWithFormat:BUSINESS_COLLECTION_URL,[GMAPI getAuthkey],_business_id];
    NSLog(@"收藏接口 ------    %@",fullUrl);
    LTools *tool = [[LTools alloc]initWithUrl:fullUrl isPost:NO postData:nil];
    __weak typeof(self)bself = self;
    [tool requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        NSLog(@"收藏结果 ----  %@",result);
        
        int errcode = [[result objectForKey:@"errcode"]intValue];
        if (errcode == 0)
        {
            aHud.labelText = isCollected?@"取消收藏成功":@"收藏成功";
            aHud.mode = MBProgressHUDModeText;
            [aHud hide:YES afterDelay:1.5];
            
            isCollected = !isCollected;
            
            [functionView setCollectionState:isCollected];
            [bself.myWebView reload];
            [[NSNotificationCenter defaultCenter] postNotificationName:G_USERCENTERLOADUSERINFO object:nil userInfo:nil];
        }else
        {
            aHud.labelText = [result objectForKey:ERROR_INFO];
            aHud.mode = MBProgressHUDModeText;
            [aHud hide:YES afterDelay:1.5];
        }
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        NSLog(@"收藏结果 ----  %@",failDic);
        
        [functionView setCollectionState:YES];
        aHud.labelText = [failDic objectForKey:ERROR_INFO];
        aHud.mode = MBProgressHUDModeText;
        [aHud hide:YES afterDelay:1.5];
        
    }];
}


-(void)setTableSectionView
{
    CGRect section_frame = CGRectMake(0,0,DEVICE_WIDTH,298);
    
    sectionView = [[UIView alloc] initWithFrame:section_frame];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    banner_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,243)];
    [banner_imageView sd_setImageWithURL:[NSURL URLWithString:@"http://g.fblife.com/resource/userhead/45/c4/9_1_0.jpg"] placeholderImage:nil];
    banner_imageView.backgroundColor = [UIColor grayColor];
    [sectionView addSubview:banner_imageView];
    
    
    userName_label = [[UILabel alloc] initWithFrame:CGRectMake(0,140,DEVICE_WIDTH,22)];
    userName_label.text = [GMAPI getUsername];
    userName_label.textAlignment = NSTextAlignmentCenter;
    userName_label.textColor = [UIColor whiteColor];
    userName_label.font = [UIFont boldSystemFontOfSize:22];
    [sectionView addSubview:userName_label];
    
    header_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(DEVICE_WIDTH/2-32,211,64,64)];
    [header_imageView sd_setImageWithURL:[NSURL URLWithString:[ZSNApi returnUrl:[GMAPI getUid]]] placeholderImage:[UIImage imageNamed:HEADER_DEFAULT_IMAGE]];
    header_imageView.layer.masksToBounds = YES;
    header_imageView.layer.cornerRadius = 30;
    header_imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    header_imageView.layer.borderWidth = 2;
    [sectionView addSubview:header_imageView];
    
    
    NSString * content = @"友信美卡是国内最专业的美式皮卡进口与服务商是美式皮卡文化的引进与传播者，我们向用户提供纯正的美国。";
    CGSize content_size = [ZSNApi stringHeightAndWidthWith:content WithHeight:MAXFLOAT WithWidth:DEVICE_WIDTH-24 WithFont:14];
    content_label = [[UILabel alloc] initWithFrame:CGRectMake(12,284,DEVICE_WIDTH-24,content_size.height)];
    content_label.text = content;
    content_label.numberOfLines = 0;
    content_label.textAlignment = NSTextAlignmentLeft;
    content_label.textColor = RGBCOLOR(105,105,105);
    content_label.font = [UIFont systemFontOfSize:14];
    [sectionView addSubview:content_label];
    section_frame.size.height = section_frame.size.height + content_size.height;
    sectionView.frame = section_frame;
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0,section_frame.size.height-0.5,DEVICE_WIDTH,0.5)];
    lineView.backgroundColor = RGBCOLOR(217,217,217);
    [sectionView addSubview:lineView];
}

#pragma mark - 获取商家详情信息
-(void)getBusinessDetailData
{
    NSString * fullUrl = [NSString stringWithFormat:BUSINESS_DETAIL_URL,_business_id,[GMAPI getAuthkey]];
    
    AFHTTPRequestOperation * request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    __weak typeof(self)bself = self;
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        @try {
            NSDictionary * allDic = [operation.responseString objectFromJSONString];
            
            NSLog(@"allDic ------   %@",allDic);
            
            if ([[allDic objectForKey:@"errcode"] intValue] == 0)
            {
                bself.businessModel = [[BusinessDetailModel alloc] initWithDictionary:[allDic objectForKey:@"datainfo"]];
                isCollected = [bself.businessModel.isshoucang intValue];
                [functionView setCollectionState:isCollected];
                /*
                NSDictionary * datainfo = [allDic objectForKey:@"datainfo"];
                isCollected = [[datainfo objectForKey:@"isshoucang"] intValue];
                telphone = [datainfo objectForKey:@"tel"];
                
                 */
            }else
            {
                
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    [request start];
    
}


#pragma mark - UITableView methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 2) {
        return 40;
    }else
    {
        return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier = @"identifier";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row < 2)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,13,10,15)];
        imageView.backgroundColor = [UIColor redColor];
        [cell.contentView addSubview:imageView];
        
        UILabel * title_label = [[UILabel alloc] initWithFrame:CGRectMake(35,0,DEVICE_WIDTH-100,40)];
        title_label.text = @"天津市泰达开发区天台北路1号楼内";
        title_label.textAlignment = NSTextAlignmentLeft;
        title_label.textColor = RGBCOLOR(67,67,67);
        title_label.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:title_label];
        
        if (indexPath.row == 0) {
            title_label.text = @"天津市泰达开发区天台北路1号楼内";
        }else
        {
            title_label.text = @"400-0022-059";
        }
    }
    
    return cell;
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    /*
    CGFloat offset = scrollView.contentOffset.y;
    
    if (offset > currentOffY) {
//        bottomView.hidden = NO;
//        _myWebView.height = DEVICE_HEIGHT-64;
        
        [self hiddenBottomViewWith:NO];
        
    }else
    {
//        bottomView.hidden = YES;
//        _myWebView.height = DEVICE_HEIGHT;
        [self hiddenBottomViewWith:YES];
    }
    
    currentOffY = offset;
     */
}

///底部栏弹出消失动画
-(void)hiddenBottomViewWith:(BOOL)isHidden
{
    _myWebView.height = isHidden?DEVICE_HEIGHT:(DEVICE_HEIGHT-64);
    [UIView animateWithDuration:0.4 animations:^{
        bottomView.top = isHidden?DEVICE_HEIGHT:(DEVICE_HEIGHT-64);
    } completion:^(BOOL finished) {
        
    }];
}



- (void)progress
{
    progress = [[UIView alloc]initWithFrame:CGRectMake(0, DEVICE_HEIGHT - 2, DEVICE_WIDTH, 2)];
    progress.backgroundColor = [UIColor clearColor];
    [self.view addSubview:progress];
    
    greenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, progress.height)];
    greenView.backgroundColor = RGBCOLOR(0, 255, 0);
    [progress addSubview:greenView];
    
    [self progressAnimation];
    
    [self performSelector:@selector(progressAnimation) withObject:nil afterDelay:5.0f];
}

- (void)progressAnimation
{
    CGFloat seg = DEVICE_WIDTH / 10.f;
    
    
    [UIView animateWithDuration:1.5 animations:^{
        
        if (greenView.width <= 7 * seg) {
            
            greenView.width = 7 * seg;
            
        }
        
    } completion:^(BOOL finished) {
        
        
        [UIView animateWithDuration:1.5 animations:^{
            
            greenView.width = 9 * seg;
            
        }];
        
    }];
}

- (void)progressToFinish
{
    [timer invalidate];
    
    [UIView animateWithDuration:1.f animations:^{
        
        greenView.width = DEVICE_WIDTH;
        
    } completion:^(BOOL finished) {
        
        [greenView removeFromSuperview];
        greenView = nil;
        [progress removeFromSuperview];
        progress = nil;
    }];
    
}




#pragma mark-touches
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    functionView.myHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
