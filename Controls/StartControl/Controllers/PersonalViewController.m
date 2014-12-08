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

#import "BusinessListTableViewCell.h"
#import "BusinessListModel.h"

#import "GcustomActionSheet.h"

#import "MLImageCrop.h"

#import "GpersonCenterCustomCell.h"

#import "GGoodsModel.h"

#import "GCaseModel.h"

#import "NSDictionary+GJson.h"

typedef enum{
    GANLI = 0,//案例
    GCHANPIN ,//产品
    GDIANPU ,//店铺
}CELLTYPE;

typedef enum{
    USERFACE = 0,//头像
    USERBANNER,//banner
    USERIMAGENULL,
}CHANGEIMAGETYPE;

@interface PersonalViewController ()<GcustomActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,MLImageCropDelegate>
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
    
    
    ASIFormDataRequest *_request;//tap==123 上传头像
    CHANGEIMAGETYPE _changeImageType;//imagePicker 更改的是头像还是banner

    
}

@property(nonatomic,strong)UIImage *userUpFaceImage;//用户需要上传的头像image
@property(nonatomic,strong)NSData *userUpFaceImagedata;//用户上传头像data
@property(nonatomic,strong)UIImage *userUpBannerImage;//用户需要上传的bannerImage
@property(nonatomic,strong)NSData *userUpBannerImageData;//用户上传bannerdata

@end

@implementation PersonalViewController



- (void)dealloc
{
    NSLog(@"%s",__FUNCTION__);
}


-(void)viewWillAppear:(BOOL)animated{
    
    NSString *api = [NSString stringWithFormat:G_USERINFO,[GMAPI getUid],[GMAPI getAuthkey]];
    
    
    NSLog(@"请求个人信息接口：%@",api);
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"请求个人信息成功");
        NSLog(@"个人信息dic：%@",result);
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        NSLog(@"请求个人信息失败");
    }];
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
    _topImv.userInteractionEnabled = YES;
    UITapGestureRecognizer *ddd = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userBannerClicked)];
    [_topImv addGestureRecognizer:ddd];
    
    //头像
    _faceImv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH*70/320.0, ALL_FRAME_WIDTH*70/320.0)];
    _faceImv.backgroundColor = RGBCOLOR_ONE;
    _faceImv.center = CGPointMake(ALL_FRAME_WIDTH/2, _topImv.frame.size.height);
    _faceImv.layer.cornerRadius = ALL_FRAME_WIDTH*70/320/2;
    _faceImv.layer.masksToBounds = YES;
    _faceImv.userInteractionEnabled = YES;
    UITapGestureRecognizer *ccc = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userFaceClicked)];
    [_faceImv addGestureRecognizer:ccc];
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
        
        UIView *view = [[UIView alloc]init];
        if (i == 0) {
            view.frame = CGRectMake(0+i * ALL_FRAME_WIDTH/3.0, 0.5, ALL_FRAME_WIDTH/3, _threeBtnBackgroundView.frame.size.height);
        }else{
            view.frame = CGRectMake(0+i * (ALL_FRAME_WIDTH/3.0+0.5), 0.5, ALL_FRAME_WIDTH/3, _threeBtnBackgroundView.frame.size.height);
        }
        
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


//banner的点击方法
-(void)userBannerClicked{
    NSLog(@"点击用户banner");
    
    
    
    GcustomActionSheet *aaa = [[GcustomActionSheet alloc]initWithTitle:nil
                                                          buttonTitles:@[@"更换相册封面"]
                                                     buttonTitlesColor:[UIColor blackColor]
                                                           buttonColor:[UIColor whiteColor]
                                                           CancelTitle:@"取消"
                                                      cancelTitelColor:[UIColor whiteColor]
                                                           CancelColor:RGBCOLOR(253, 144, 39)
                                                       actionBackColor:RGBCOLOR(236, 236, 236)];
    
    
    aaa.tag = 90;
    aaa.delegate = self;
    [aaa showInView:self.view WithAnimation:YES];
    
    
}


//头像的点击方法
-(void)userFaceClicked{
    NSLog(@"点击头像");
    
    GcustomActionSheet *aaa = [[GcustomActionSheet alloc]initWithTitle:nil
                                                          buttonTitles:@[@"更换头像"]
                                                     buttonTitlesColor:[UIColor blackColor]
                                                           buttonColor:[UIColor whiteColor]
                                                           CancelTitle:@"取消"
                                                      cancelTitelColor:[UIColor whiteColor]
                                                           CancelColor:RGBCOLOR(253, 144, 39)
                                                       actionBackColor:RGBCOLOR(236, 236, 236)];
    
    
    aaa.tag = 91;
    aaa.delegate = self;
    [aaa showInView:self.view WithAnimation:YES];
}


-(void)gActionSheet:(GcustomActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"actionsheet.tag = %d, buttonIndex = %d",actionSheet.tag,buttonIndex);
    
    if (actionSheet.tag == 90) {//banner
        if (buttonIndex == 1) {
            _changeImageType = USERBANNER;
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            
            //        [picker.navigationBar setBackgroundImage:FBCIRCLE_NAVIGATION_IMAGE forBarMetrics: UIBarMetricsDefault];
            
//            picker.navigationBar.barTintColor = [UIColor blackColor];
//            UIColor * cc = [UIColor whiteColor];
//            NSDictionary * dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:cc,[UIFont systemFontOfSize:18],[UIColor clearColor],nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor,UITextAttributeFont,UITextAttributeTextShadowColor,nil]];
//            picker.navigationBar.titleTextAttributes = dict;
            
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
            [self presentViewController:picker animated:YES completion:^{
//                if (IOS7_OR_LATER) {
//                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//                }
            }];
        }
        

    }else if (actionSheet.tag == 91){//头像
        if (buttonIndex == 1) {
            _changeImageType = USERFACE;
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            //        [picker.navigationBar setBackgroundImage:FBCIRCLE_NAVIGATION_IMAGE forBarMetrics: UIBarMetricsDefault];
//            picker.navigationBar.barTintColor = [UIColor blackColor];
//            UIColor * cc = [UIColor whiteColor];
//            NSDictionary * dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:cc,[UIFont systemFontOfSize:18],[UIColor clearColor],nil] forKeys:[NSArray arrayWithObjects:UITextAttributeTextColor,UITextAttributeFont,UITextAttributeTextShadowColor,nil]];
//            picker.navigationBar.titleTextAttributes = dict;
            
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            
            [self presentViewController:picker animated:YES completion:^{
//                if (IOS7_OR_LATER) {
//                    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//                    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
//                }
            }];
        }
    }
    
    
}


#pragma mark - UIImagePickerControllerDelegate 拍照选择照片协议方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%s",__FUNCTION__);
    [UIApplication sharedApplication].statusBarHidden = NO;
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        //压缩图片 不展示原图
        UIImage *originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        //按比例缩放
        UIImage *scaleImage = [self scaleImage:originImage toScale:0.5];
        
        
        //将图片传递给截取界面进行截取并设置回调方法（协议）
        MLImageCrop *imageCrop = [[MLImageCrop alloc]init];
        imageCrop.delegate = self;
        
        //按像素缩放
        if (_changeImageType == USERFACE) {//头像
            imageCrop.ratioOfWidthAndHeight = 300.0f/300.0f;//设置缩放比例
        }else if (_changeImageType == USERBANNER){
            imageCrop.ratioOfWidthAndHeight = 750.0f/560.0f;//设置缩放比例
        }
        
        
        imageCrop.image = scaleImage;
        //[imageCrop showWithAnimation:NO];
        picker.navigationBar.hidden = YES;
        [picker pushViewController:imageCrop animated:YES];
        
    }
    
    
}

#pragma mark- 缩放图片
//按比例缩放
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

//按像素缩放
-(UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}


#pragma mark - crop delegate
#pragma mark - 图片回传协议方法
- (void)cropImage:(UIImage*)cropImage forOriginalImage:(UIImage*)originalImage
{
    
    if (_changeImageType == USERFACE) {//上传用户头像
        //用户需要上传的剪裁后的image
        self.userUpFaceImage = cropImage;
        NSLog(@"在此设置用户上传的头像");
        self.userUpFaceImagedata = UIImagePNGRepresentation(self.userUpFaceImage);
        
        
        //缓存到本地
        [GMAPI setUserFaceImageWithData:self.userUpFaceImagedata];
        NSString *str = @"yes";
        [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpFace"];
        //ASI上传
        [self test];
    }else if (_changeImageType == USERBANNER){//上传用户banner
        //用户需要上传的剪裁后的image
        self.userUpBannerImage = cropImage;
        NSLog(@"在此设置用户上传的头像");
        self.userUpBannerImageData = UIImagePNGRepresentation(self.userUpBannerImage);
        
        
        //缓存到本地
        [GMAPI setUserFaceImageWithData:self.userUpBannerImageData];
        NSString *str = @"yes";
        [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpBanner"];
        //ASI上传
        [self test];
    }
    
    
    
    
    
    
//    _isChooseTouxiang = YES;
    [_tableView reloadData];
    
}


#pragma mark - 上传头像(图片)

#define TT_CACHE_EXPIRATION_AGE_NEVER     (1.0 / 0.0)
-(void)test{
    
    
    
    if (_changeImageType == USERFACE) {//上传用户头像
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //        NSString* fullURL = [NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=updatehead&authkey=%@",[GMAPI getAuthkey]];
            
            NSString* fullURL = @"123";
            NSLog(@"上传头像请求的地址===%@     ----%s",fullURL,__FUNCTION__);
            //设置标志位
            NSString *str = @"yes";
            [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpFace"];
            
            _request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:fullURL]];
            AppDelegate *_appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
            _request.delegate = _appDelegate;
            _request.tag = 123;
            
            //得到图片的data
            NSData* data;
            //获取图片质量
            NSMutableData *myRequestData=[NSMutableData data];
            [_request setPostFormat:ASIMultipartFormDataPostFormat];
            data = UIImageJPEGRepresentation(self.userUpFaceImage,0.5);
            NSLog(@"xxxx===%@",data);
            [_request addRequestHeader:@"uphead" value:[NSString stringWithFormat:@"%d", [myRequestData length]]];
            //设置http body
            [_request addData:data withFileName:[NSString stringWithFormat:@"boris.png"] andContentType:@"image/PNG" forKey:[NSString stringWithFormat:@"uphead"]];
            
            [_request setRequestMethod:@"POST"];
            _request.cachePolicy = TT_CACHE_EXPIRATION_AGE_NEVER;
            _request.cacheStoragePolicy = ASICacheForSessionDurationCacheStoragePolicy;
            [_request startAsynchronous];
            
        });
    }else if (_changeImageType == USERBANNER){//上传用户banner
        
        //        NSString* fullURL = [NSString stringWithFormat:@"http://quan.fblife.com/index.php?c=interface&a=updatehead&authkey=%@",[GMAPI getAuthkey]];
        NSString *fullURL = @"123";
        //上传标志位
        NSString *str = @"yes";
        [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpBanner"];
        
        
        _request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:fullURL]];
        
        AppDelegate *_appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        
        _request.delegate = _appDelegate;
        _request.tag = 122;
        
        
        [_request addRequestHeader:@"frontpic" value:[NSString stringWithFormat:@"%d", [self.userUpBannerImageData length]]];
        //设置http body
        [_request addData:self.userUpBannerImageData withFileName:[NSString stringWithFormat:@"boris.png"] andContentType:@"image/PNG" forKey:[NSString stringWithFormat:@"frontpic"]];
        
        [_request setRequestMethod:@"POST"];
        _request.cachePolicy = TT_CACHE_EXPIRATION_AGE_NEVER;
        _request.cacheStoragePolicy = ASICacheForSessionDurationCacheStoragePolicy;
        [_request startAsynchronous];
    }
    
    
    
    
}




//收藏案例 收藏产品 收藏店铺 的点击方法
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
        
        _cellHight = 220.0/568*ALL_FRAME_HEIGHT;
        _cellType = GANLI;
        [self loadNewData];
        
        
    }else if (theTag == 11){//点击的是收藏产品
        
        _anliTitleLabel.textColor = RGBCOLOR(160, 160, 160);
        _anliNumLabel.textColor = [UIColor blackColor];
        
        _chanpinTitleLabel.textColor = RGBCOLOR(253, 160, 51);
        _chanpinNumLabel.textColor = RGBCOLOR(253, 160, 51);
        
        _dianpuTitleLabel.textColor = RGBCOLOR(160, 160, 160);
        _dianpuNumLabel.textColor = [UIColor blackColor];
        
        _cellHight = 220.0/568*ALL_FRAME_HEIGHT;
        _cellType = GCHANPIN;
        [self loadNewData];
        
        
    }else if (theTag == 12){//收藏店铺
        
        _anliTitleLabel.textColor = RGBCOLOR(160, 160, 160);
        _anliNumLabel.textColor = [UIColor blackColor];
        
        _chanpinTitleLabel.textColor = RGBCOLOR(160, 160, 160);
        _chanpinNumLabel.textColor = [UIColor blackColor];
        
        _dianpuTitleLabel.textColor =  RGBCOLOR(253, 160, 51);
        _dianpuNumLabel.textColor =  RGBCOLOR(253, 160, 51);
        
        _cellHight = 85.0/568*ALL_FRAME_HEIGHT;
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
        
        
        
        if (theType == GDIANPU) {//店铺
            NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in dataArray) {
                
                BusinessListModel *model = [[BusinessListModel alloc]initWithDictionary:dic];
                [dataArr addObject:model];
                
            }
            
            dataArray = (NSArray*)dataArr;
            
        }else if (theType == GCHANPIN){//产品
            NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:1];
            
            for (NSDictionary *dic in dataArray) {
                
                GGoodsModel *model = [[GGoodsModel alloc]initWithDictionary:dic];
                
                [dataArr addObject:model];
                
            }
            
            dataArray = (NSArray *)dataArr;
            
        }else if (theType == GANLI){//案例
            NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in dataArray) {
                
                GCaseModel *model = [[GCaseModel alloc]initWithDictionary:dic];
                [dataArr addObject:model];
                
            }
            
            dataArray = (NSArray *)dataArr;
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
    GpersonCenterCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GpersonCenterCustomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }

    if (_cellType == GDIANPU) {//收藏店铺
        BusinessListModel *model = _dataArray[indexPath.row];
        [cell loadCustomViewWithType:3];
        [cell setdataWithData:model];
        
        return cell;
        
    }else if (_cellType == GCHANPIN){//收藏产品
        
        [cell loadCustomViewWithType:2];
        GGoodsModel *model = _dataArray[indexPath.row];
        [cell setChanpinWithData:model];
        
        return cell;
        
    }else if (_cellType == GANLI){//收藏案例
        
        [cell loadCustomViewWithType:1];
        GCaseModel *model = _dataArray[indexPath.row];
        [cell setAnliDataWithData:model];
        
        return cell;
    }
    
    
    
    
    
    
    
    
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}







//单元格个数一个屏幕里占不满的话 下面不显示出来
//_tableView继承自RefreshTableView  RefreshTableView遵循UITableViewDelegate协议
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}


#pragma mark - 上提下拉相关方法结束







@end
