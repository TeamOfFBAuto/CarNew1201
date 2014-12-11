//
//  BusinessHomeViewController.m
//  CustomNewProject
//
//  Created by soulnear on 14-12-4.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "BusinessHomeViewController.h"

@interface BusinessHomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
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
    
    MBProgressHUD * hud;
}

@property(nonatomic,strong)UITableView * myTableView;

@end

@implementation BusinessHomeViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    UIWebView * myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT)];
    myWebView.delegate = self;
    [self.view addSubview:myWebView];
    
    NSString * fullUrl = @"http://gztest.fblife.com/web.php?c=wap&a=getStore&storeid=1";
    
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    
    
    hud = [ZSNApi showMBProgressWithText:@"加载中..." addToView:self.view];
    hud.mode = MBProgressHUDModeIndeterminate;
    
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
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSLog(@"request.url ----   %@ ---  %d",[request.URL absoluteString],navigationType);
    
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
    back_button.frame = CGRectMake(10,20,44,44);
    [back_button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [back_button setImage:BACK_DEFAULT_IMAGE forState:UIControlStateNormal];
    [navigation_view addSubview:back_button];
}

-(void)back:(UIButton *)button
{
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setTableSectionView
{
    CGRect section_frame = CGRectMake(0,0,DEVICE_WIDTH,298);
    
    sectionView = [[UIView alloc] initWithFrame:section_frame];
    sectionView.backgroundColor = [UIColor whiteColor];
    
    banner_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,243)];
    [banner_imageView sd_setImageWithURL:[NSURL URLWithString:@"http://gztest.fblife.com/resource/userhead/45/c4/9_1_0.jpg"] placeholderImage:nil];
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
