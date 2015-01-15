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
#import "ZSNApi.h"

#import "GscoreStarViewController.h"


#import "BusinessHomeViewController.h"

#import "AnliModel.h"
#import "AnliDetailViewController.h"
#import "AnliViewCell.h"
#import "GaiZhuangRefreshTableView.h"

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

@interface PersonalViewController ()<GcustomActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,MLImageCropDelegate,RefreshDelegate>
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
    
    GaiZhuangRefreshTableView *_tableView;//主tableview
    
    
    ASIFormDataRequest *_request;//tap==123 上传头像
    CHANGEIMAGETYPE _changeImageType;//imagePicker 更改的是头像还是banner
    
    
    UIView *_hudView;//浮层view
    
    BOOL _isLoadUserInfoSuccess;

    
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

-(void)viewDidDisappear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    self.isAddGestureRecognizer = YES;
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }
    
    _isLoadUserInfoSuccess = NO;
    
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    
    NSLog(@"%s",__FUNCTION__);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.myTitle = @"个人中心";
    self.leftImageName = NAVIGATION_MENU_IMAGE_NAME;
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeOther WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    
    
    //设置tabelview headerview
    [self creatHeaderView];
    
    [_topImv setImage:[UIImage imageNamed:@"gBanner.png"]];
    [_faceImv setImage:[UIImage imageNamed:HEADER_DEFAULT_IMAGE]];
    
    _page = 1;
    _pageCapacity = 10;
    
    [self changeNumAndTitleColorWithTag:11];
    
    _tableView = [[GaiZhuangRefreshTableView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, DEVICE_HEIGHT)];
    _tableView.refreshDelegate = self;//用refreshDelegate替换UITableViewDelegate
    _tableView.dataSource = self;
    _tableView.netWorking = GIS;
    [self.view addSubview:_tableView];
    
    _tableView.tableHeaderView = _upThreeViewBackGroundView;
    
    [_tableView addObserver:self forKeyPath:@"offsetY" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    
    
    
    
    
    UIButton *gBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [gBackBtn setImage:[UIImage imageNamed:NAVIGATION_MENU_IMAGE_NAME] forState:UIControlStateNormal];
    [gBackBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 10, 15)];
    gBackBtn.adjustsImageWhenHighlighted = NO;
    [gBackBtn setFrame:CGRectMake(0, 15, 80.00/320*ALL_FRAME_WIDTH, 80.00/320*ALL_FRAME_WIDTH)];
    [gBackBtn addTarget:self action:@selector(gGoBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gBackBtn];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dengluchenggong) name:@"gdengluchenggong" object:nil];
    
    
    
    _hudView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_upThreeViewBackGroundView.frame), DEVICE_WIDTH, DEVICE_HEIGHT-_upThreeViewBackGroundView.frame.size.height)];
    _hudView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake((DEVICE_WIDTH-110)*0.5, 10, 110, 50)];
    titleLabel.backgroundColor = RGBCOLOR(51, 51, 51);
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.layer.cornerRadius = 15;
    titleLabel.layer.masksToBounds = YES;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = @"正在加载";
    [_hudView addSubview:titleLabel];
    
    _hudView.hidden = YES;
    [self.view addSubview:_hudView];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadNewData) name:G_USERCENTERLOADUSERINFO object:nil];
    
    
    
}

//通知接受登录成功调用的方法
-(void)dengluchenggong{
    [self changeNumAndTitleColorWithTag:11];
}




-(void)gGoBack{
    [self.airViewController showAirViewFromViewController:self.navigationController complete:nil];
}


-(void)getUserInfo{
    NSString *api = [NSString stringWithFormat:G_USERINFO,[GMAPI getUid]];
    
    NSLog(@"请求个人信息接口：%@",api);
    
    if ([GMAPI getUserBannerImage]) {
        
        [_topImv setImage:[GMAPI getUserBannerImage]];
    }
    
    if ([GMAPI getUserFaceImage]) {
        [_faceImv setImage:[GMAPI getUserFaceImage]];
    }
    
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:api isPost:NO postData:nil];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        NSLog(@"请求个人信息成功");
        _isLoadUserInfoSuccess = YES;
        NSLog(@"个人信息dic：%@",result);
        NSDictionary *dic = [result dictionaryValueForKey:@"datainfo"];
        
        //banner
        if ([GMAPI getUserBannerImage]) {
            
            [_topImv setImage:[GMAPI getUserBannerImage]];
        }else{
        
            [_topImv sd_setImageWithURL:[NSURL URLWithString:[dic stringValueForKey:@"bunner"]] placeholderImage:[UIImage imageNamed:@"gBanner.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                NSLog(@"BannerImageURL:%@",imageURL);
                
                NSData *imageData = UIImageJPEGRepresentation(_topImv.image, 1.0);
                [GMAPI setUserBannerImageWithData:imageData];
            }];
        }
     
        
        //头像
        if ([GMAPI getUserFaceImage]) {
            [_faceImv setImage:[GMAPI getUserFaceImage]];
        }else{
            
            NSString *midleUserFaceStr = [ZSNApi returnMiddleUrl:[GMAPI getUid]];
            
            [_faceImv sd_setImageWithURL:[NSURL URLWithString:midleUserFaceStr] placeholderImage:[UIImage imageNamed:HEADER_DEFAULT_IMAGE] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                
                
                NSData *imageData = UIImageJPEGRepresentation(_faceImv.image, 1.0);
                NSLog(@"error ------  %@",error);
                [GMAPI setUserFaceImageWithData:imageData];
            }];
        }
        
        
        
        
        _nameLabel.text = [dic stringValueForKey:@"username"];
        _anliNumLabel.text = [dic stringValueForKey:@"fcase"];
        _chanpinNumLabel.text = [dic stringValueForKey:@"fgoods"];
        _dianpuNumLabel.text = [dic stringValueForKey:@"fstore"];
        _tableView.tableHeaderView = _upThreeViewBackGroundView;
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        
        NSLog(@"请求个人信息失败");
        _isLoadUserInfoSuccess = NO;
        _nameLabel.text = [GMAPI getUsername];
        [ZSNApi showAutoHiddenMBProgressWithText:@"请求个人信息失败" addToView:self.view];
        
//        id obj=NSClassFromString(@"UIAlertController");
//        if ( obj!=nil){
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"个人信息加载失败请重新加载" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//                
//            }];
//            [alertController addAction:cancelAction];
//            [self presentViewController:alertController animated:YES completion:^{
//                
//            }];
//        }
//        else{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"个人信息加载失败请重新加载"
//                                                           delegate:self cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil,nil];
//            
//            [alert show];
//        }
        
        
        
    }];
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
    _upThreeViewBackGroundView = [[UIView alloc]initWithFrame:CGRectZero];
    _upThreeViewBackGroundView.frame = CGRectMake(0,0, ALL_FRAME_WIDTH,240.00/320*ALL_FRAME_WIDTH);
//    _upThreeViewBackGroundView.clipsToBounds = YES;
    
    
    //banner
    _topImv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH,0)];
    _topImv.userInteractionEnabled = YES;
    
    //banner下面的黑色透明层
    UIImageView *back_topimv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, 240.00/320*ALL_FRAME_WIDTH)];
    [back_topimv setImage:[UIImage imageNamed:@"anli_bottom_clear"]];
    
    [_upThreeViewBackGroundView addSubview:_topImv];
    [_upThreeViewBackGroundView addSubview:back_topimv];
    
    
    
    UITapGestureRecognizer *ddd = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userBannerClicked)];
    [_topImv addGestureRecognizer:ddd];
    
    
//    //zking
//    
//    
//    UIImageView *imgV=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 6+ALL_FRAME_WIDTH*70/320.0,6+ ALL_FRAME_WIDTH*70/320.0)];
//    
//    imgV.center=CGPointMake(ALL_FRAME_WIDTH/2,88.00/320*ALL_FRAME_WIDTH);
//    
//    imgV.layer.cornerRadius = ALL_FRAME_WIDTH*72/320/2;
//    imgV.layer.masksToBounds = YES;
//
//    
//    imgV.backgroundColor=[[UIColor whiteColor]colorWithAlphaComponent:0.5];
//    
//    [_upThreeViewBackGroundView addSubview:imgV];
    
    
    UIView * face_quan_view = [[UIView alloc] initWithFrame:CGRectMake(0,0,76,76)];
    face_quan_view.center = CGPointMake(ALL_FRAME_WIDTH/2,88.00/320*ALL_FRAME_WIDTH);
    face_quan_view.layer.masksToBounds = YES;
    face_quan_view.layer.cornerRadius = face_quan_view.width*0.5;
    face_quan_view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [_upThreeViewBackGroundView addSubview:face_quan_view];
    
    
    
    
    
    //头像
    _faceImv = [[UIImageView alloc]initWithFrame:CGRectMake(3,3,70,70)];
//    _faceImv.backgroundColor = RGBCOLOR_ONE;
//    _faceImv.center = CGPointMake(ALL_FRAME_WIDTH/2,88.00/320*ALL_FRAME_WIDTH);
    _faceImv.layer.cornerRadius = 70*0.5;
    _faceImv.backgroundColor = [UIColor clearColor];
    _faceImv.layer.masksToBounds = YES;
//    _faceImv.layer.borderWidth = 4;
//    _faceImv.layer.borderColor = [[[UIColor whiteColor]colorWithAlphaComponent:0.5]CGColor];
//    _faceImv.userInteractionEnabled = YES;
//    _faceImv.layer.masksToBounds = YES;
    UITapGestureRecognizer *ccc = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userFaceClicked)];
    [_faceImv addGestureRecognizer:ccc];
    [face_quan_view addSubview:_faceImv];
    
    
    //用户名
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(face_quan_view.frame)+8, ALL_FRAME_WIDTH, 19.00/320*ALL_FRAME_WIDTH)];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
//    _nameLabel.text = [GMAPI getUsername];
    _nameLabel.textColor = [UIColor whiteColor];
    
    
//    _nameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
//    _nameLabel.layer.shadowOffset = CGSizeMake(0,1);
//    _nameLabel.layer.shadowRadius = 0.5;
//    _nameLabel.layer.shadowOpacity = 0.8;
    
    [_upThreeViewBackGroundView addSubview:_nameLabel];
    
    

    
    //三个按钮的下层view
    _threeBtnBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameLabel.frame)+27, ALL_FRAME_WIDTH, 50.00/320*ALL_FRAME_WIDTH)];
    _threeBtnBackgroundView.backgroundColor = [UIColor clearColor];
    [_upThreeViewBackGroundView addSubview:_threeBtnBackgroundView];
    
    
    
    
    _topImv.frame = _upThreeViewBackGroundView.frame;
    
    //模糊效果
    _topImv.layer.masksToBounds = NO;
    _topImv.layer.shadowColor = [UIColor blackColor].CGColor;
    _topImv.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _topImv.layer.shadowOpacity = 0.5f;//阴影透明度，默认0
    _topImv.layer.shadowRadius = 4;//阴影半径，默认3
    
    //整个图片变模糊 四周
//    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:_topImv.bounds];
//    _topImv.layer.shadowPath = shadowPath.CGPath;
    
    for (int i = 0; i<3; i++) {
        
        UIView *view = [[UIView alloc]init];
        
        view.frame = CGRectMake(0+i * ALL_FRAME_WIDTH/3.00, 0, ALL_FRAME_WIDTH/3.00,_threeBtnBackgroundView.frame.size.height);
        
        view.tag = i+10;
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gTap:)];
        [view addGestureRecognizer:tap];
        
        if (i == 0) {//案例
            //案例的数字
            _anliNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 28.00/320*ALL_FRAME_WIDTH)];
            _anliNumLabel.text = @"0";
            _anliNumLabel.textAlignment = NSTextAlignmentCenter;
            NSLog(@"案例的数字label%@",NSStringFromCGRect(_anliNumLabel.frame));
            
            [view addSubview:_anliNumLabel];
            
            _anliTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_anliNumLabel.frame)-5, _anliNumLabel.frame.size.width, view.frame.size.height-_anliNumLabel.frame.size.height)];
            _anliTitleLabel.text = @"收藏案例";
            _anliTitleLabel.font = [UIFont systemFontOfSize:13];
            _anliTitleLabel.textAlignment = NSTextAlignmentCenter;
            [view addSubview:_anliTitleLabel];
            
            //分割线
            UIView *fView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_anliNumLabel.frame)-0.5, _anliNumLabel.frame.origin.y+5, 0.5,35.00/320*ALL_FRAME_WIDTH)];
            fView.backgroundColor = RGBCOLOR(145, 145, 145);
            [view addSubview:fView];
            
            
        }else if (i == 1){//产品
            //产品的数字
            _chanpinNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 28.00/320*ALL_FRAME_WIDTH)];
            
            _chanpinNumLabel.textAlignment = NSTextAlignmentCenter;
            _chanpinNumLabel.text = @"0";
            [view addSubview:_chanpinNumLabel];
            
            _chanpinTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_chanpinNumLabel.frame)-5, _chanpinNumLabel.frame.size.width, view.frame.size.height-_chanpinNumLabel.frame.size.height)];
            _chanpinTitleLabel.text = @"收藏产品";
            _chanpinTitleLabel.font = [UIFont systemFontOfSize:13];
            _chanpinTitleLabel.textAlignment = NSTextAlignmentCenter;
            [view addSubview:_chanpinTitleLabel];

            //分割线
            UIView *fenView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_chanpinNumLabel.frame)-0.5, _chanpinNumLabel.frame.origin.y+5, 0.5,35.00/320*ALL_FRAME_WIDTH)];
            fenView.backgroundColor = RGBCOLOR(145, 145, 145);
            [view addSubview:fenView];
            
            
        }else if (i == 2){//收藏店铺
            //店铺的数字
            _dianpuNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, view.frame.size.width, 28.00/320 * ALL_FRAME_WIDTH)];
            
            _dianpuNumLabel.textAlignment = NSTextAlignmentCenter;
            _dianpuNumLabel.text = @"0";
            [view addSubview:_dianpuNumLabel];
            
            _dianpuTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_dianpuNumLabel.frame)-5, _dianpuNumLabel.frame.size.width, view.frame.size.height-_dianpuNumLabel.frame.size.height)];
            _dianpuTitleLabel.text = @"收藏店铺";
            _dianpuTitleLabel.font = [UIFont systemFontOfSize:13];
            _dianpuTitleLabel.textAlignment = NSTextAlignmentCenter;
            [view addSubview:_dianpuTitleLabel];
            
        }
        
        
        [_threeBtnBackgroundView addSubview:view];
        
    }

   
    
    
}


//banner的点击方法
-(void)userBannerClicked{
    NSLog(@"点击用户banner");
    
//    GscoreStarViewController *cc = [[GscoreStarViewController alloc]init];
//    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:cc];
//    [self presentViewController:navc animated:YES completion:^{
//        
//    }];
    
    
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
//    
//    GcustomActionSheet *aaa = [[GcustomActionSheet alloc]initWithTitle:nil
//                                                          buttonTitles:@[@"更换头像"]
//                                                     buttonTitlesColor:[UIColor blackColor]
//                                                           buttonColor:[UIColor whiteColor]
//                                                           CancelTitle:@"取消"
//                                                      cancelTitelColor:[UIColor whiteColor]
//                                                           CancelColor:RGBCOLOR(253, 144, 39)
//                                                       actionBackColor:RGBCOLOR(236, 236, 236)];
//    
//    
//    aaa.tag = 91;
//    aaa.delegate = self;
//    [aaa showInView:self.view WithAnimation:YES];
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
        [GMAPI setUserBannerImageWithData:self.userUpBannerImageData];
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
    
    [_topImv setImage:[GMAPI getUserBannerImage]];//替换用户本地图片
    
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
        
        NSString* fullURL = [NSString stringWithFormat:G_CHANGEUSERBANNER,[GMAPI getAuthkey]];
        //上传标志位
        NSString *str = @"yes";
        [[NSUserDefaults standardUserDefaults]setObject:str forKey:@"gIsUpBanner"];
        
        
        _request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:fullURL]];
        
        AppDelegate *_appDelegate=(AppDelegate *)[UIApplication sharedApplication].delegate;
        
        _request.delegate = _appDelegate;
        _request.tag = 122;
        
        
        [_request addRequestHeader:@"pichead" value:[NSString stringWithFormat:@"%d", [self.userUpBannerImageData length]]];
        //设置http body
        [_request addData:self.userUpBannerImageData withFileName:[NSString stringWithFormat:@"boris.png"] andContentType:@"image/PNG" forKey:[NSString stringWithFormat:@"pichead"]];
        
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
    
    
    _page = 1;
    
    
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _hudView.hidden = NO;
    
    if (theTag == 10) {//点击的是收藏案例
        _anliTitleLabel.textColor = RGBCOLOR(155, 155, 155);
        _anliNumLabel.textColor = RGBCOLOR(155, 155, 155);
        
        _chanpinTitleLabel.textColor = [UIColor whiteColor];
        _chanpinNumLabel.textColor = [UIColor whiteColor];
        
        _dianpuTitleLabel.textColor = [UIColor whiteColor];
        _dianpuNumLabel.textColor = [UIColor whiteColor];
        
        _cellHight = 240.00/320*ALL_FRAME_WIDTH;
        _cellType = GANLI;
        if (_isLoadUserInfoSuccess) {
            [self loadChooseData];
        }else{
            [self loadNewData];
        }
        
        
        
    }else if (theTag == 11){//点击的是收藏产品
        
        _anliTitleLabel.textColor = [UIColor whiteColor];
        _anliNumLabel.textColor = [UIColor whiteColor];
        
        _chanpinTitleLabel.textColor = RGBCOLOR(155, 155, 155);
        _chanpinNumLabel.textColor = RGBCOLOR(155, 155, 155);
        
        _dianpuTitleLabel.textColor = [UIColor whiteColor];
        _dianpuNumLabel.textColor = [UIColor whiteColor];
        
        _cellHight = 240.00/320*ALL_FRAME_WIDTH;
        _cellType = GCHANPIN;
        if (_isLoadUserInfoSuccess) {
            [self loadChooseData];
        }else{
            [self loadNewData];
        }
        
        
    }else if (theTag == 12){//收藏店铺
        
        _anliTitleLabel.textColor = [UIColor whiteColor];
        _anliNumLabel.textColor = [UIColor whiteColor];
        
        _chanpinTitleLabel.textColor = [UIColor whiteColor];
        _chanpinNumLabel.textColor = [UIColor whiteColor];
        
        _dianpuTitleLabel.textColor =  RGBCOLOR(155, 155, 155);
        _dianpuNumLabel.textColor =  RGBCOLOR(155, 155, 155);
        
        _cellHight = 85.00;
        _cellType = GDIANPU;
        if (_isLoadUserInfoSuccess) {
            [self loadChooseData];
        }else{
            [self loadNewData];
        }
        
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
    cc.shoucangchanpin = @"shoucang";
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        _tableView.netWorking = GIS;
        _hudView.hidden = YES;
        
        NSLog(@"到底走了吗%@",result);
        
        NSDictionary *datainfo = [result objectForKey:@"datainfo"];
        
        if (!datainfo || ![datainfo isKindOfClass:[NSDictionary class]]) {
            NSArray *arr = [NSArray array];
            _tableView.isHaveMoreData = NO;
            _tableView.pageNum = _page;
            [bself reloadData:arr isReload:_tableView.isReloadData];
            return ;
        }
        
        NSArray *data = [datainfo objectForKey:@"data"];
        NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:1];
        
        
        _tableView.pageNum = _page;
        
        if (data.count < _pageCapacity) {
            
            _tableView.isHaveMoreData = NO;
        }else
        {
            _tableView.isHaveMoreData = YES;
        }
        
        
        
        if (theType == GDIANPU) {//店铺
            for (NSDictionary *dic in data) {
                
                if (dic) {
                    BusinessListModel *model = [[BusinessListModel alloc]initWithDictionary:dic];
                    [dataArr addObject:model];
                }
                
                
            }
            
            
        }else if (theType == GCHANPIN){//产品
            
            for (NSDictionary *dic in data) {
                
                if (dic) {
                    GGoodsModel *model = [[GGoodsModel alloc]initWithDictionary:dic];
                    [dataArr addObject:model];
                }
                
                
            }
            
            
        }else if (theType == GANLI){//案例
            for (NSDictionary *dic in data) {
                
                if (dic) {
                    GCaseModel *aModel = [[GCaseModel alloc]initWithDictionary:dic];
                    [dataArr addObject:aModel];
                }
                
                
            }
            
        }
        
        
        if (dataArr) {
            [bself reloadData:dataArr isReload:_tableView.isReloadData];
        }
        
        
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        
        _hudView.hidden = YES;
        
        [ZSNApi showAutoHiddenMBProgressWithText:@"请求收藏信息失败" addToView:self.view];
        
        NSLog(@"---%@",failDic);
        
//        if ([[failDic objectForKey:@"ERRO_INFO"]isEqualToString:@"结果为空"]) {
//            
//        }else{
//            id obj=NSClassFromString(@"UIAlertController");
//            NSString *tishiStr = [failDic objectForKey:@"ERRO_INFO"];
//            if ( obj!=nil){
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:tishiStr preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//                    
//                }];
//                [alertController addAction:cancelAction];
//                [self presentViewController:alertController animated:YES completion:^{
//                    
//                }];
//            }
//            else{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"加载数据失败请重新加载"
//                                                               delegate:self cancelButtonTitle:@"确定"
//                                                      otherButtonTitles:nil,nil];
//                [alert show];
//            }
//        }
        
        if (_tableView.isLoadMoreData) {
            
            _page --;
            _tableView.netWorking = GNO;
            [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:0.2];
        }else{
            _tableView.netWorking = GNO;
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
        _tableView.dataArray = [NSMutableArray arrayWithArray:_dataArray];
        
    }else
    {
        NSMutableArray *newArr = [NSMutableArray arrayWithArray:_dataArray];
        [newArr addObjectsFromArray:dataArr];
        _tableView.dataArray = newArr;
        _dataArray = newArr;
    }
    
    
    
//    _tableView.dataArray = [NSMutableArray arrayWithArray:_dataArray];
    
    [_tableView performSelector:@selector(finishReloadigData) withObject:nil afterDelay:0.2];
}



#pragma - mark RefreshDelegate <NSObject>

- (void)loadNewData
{
    _page = 1;
    _tableView.isReloadData = YES;
    
    _dataArray = nil;
    _tableView.pageNum = 1;
    [_tableView.dataArray removeAllObjects];
    
    [self prepareNetDataWithCellType:_cellType];
    
    [self getUserInfo];
}


-(void)loadChooseData{
    _page = 1;
    _tableView.isReloadData = YES;
    
    _dataArray = nil;
    _tableView.pageNum = 1;
    [_tableView.dataArray removeAllObjects];
    
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
    
    if (_cellType == GDIANPU) {//店铺
        GpersonCenterCustomCell * cell = (GpersonCenterCustomCell*)[_tableView cellForRowAtIndexPath:indexPath];
        
        BusinessListModel *model = _tableView.dataArray[indexPath.row];
        BusinessHomeViewController * home = [[BusinessHomeViewController alloc] init];
        home.business_id = model.id;
        home.share_title = model.storename;
        home.share_image = cell.header_imageView.image;
        [self.navigationController pushViewController:home animated:YES];
    }else if (_cellType == GANLI){//案例
        
        GCaseModel *aModel = [_tableView.dataArray objectAtIndex:indexPath.row];
        AnliDetailViewController *detail = [[AnliDetailViewController alloc]init];
        detail.anli_id = aModel.id;
        
        detail.shareTitle = aModel.title;
        detail.shareDescrition = aModel.sname;
        detail.shareImage = [LTools sd_imageForUrl:aModel.pichead];
        detail.storeName = aModel.sname;
        detail.storeImage = [LTools sd_imageForUrl:aModel.spichead];
        
        [self.navigationController pushViewController:detail animated:YES];
    }else if (_cellType == GCHANPIN){//产品
        
        GGoodsModel *model = _tableView.dataArray[indexPath.row];
        
        AnliDetailViewController *detail = [[AnliDetailViewController alloc]init];
        detail.anli_id = model.id;
        detail.detailType = Detail_Peijian;
        detail.storeName = model.title;
        detail.shareDescrition = model.username;
        detail.shareImage = [LTools sd_imageForUrl:model.pichead];
        detail.storeName = model.username;
        detail.storeImage = [LTools sd_imageForUrl:model.pichead];
        [self.navigationController pushViewController:detail animated:YES];
    }
    
    
    
//    AnliModel *aModel = [_table.dataArray objectAtIndex:indexPath.row];
//    AnliDetailViewController *detail = [[AnliDetailViewController alloc]init];
//    detail.anli_id = aModel.id;
//    
//    detail.shareTitle = aModel.title;
//    detail.shareDescrition = aModel.sname;
//    detail.shareImage = [LTools sd_imageForUrl:aModel.pichead];
//    detail.storeName = aModel.sname;
//    detail.storeImage = [LTools sd_imageForUrl:aModel.spichead];
//    
//    [self.navigationController pushViewController:detail animated:YES];
//    
//    [_table deselectRowAtIndexPath:indexPath animated:YES];
//    
//    
//    
//    GpersonCenterCustomCell * cell = (GpersonCenterCustomCell*)[_tableView cellForRowAtIndexPath:indexPath];
//    
//    BusinessListModel *model = _dataArray[indexPath.row];
//    BusinessHomeViewController * home = [[BusinessHomeViewController alloc] init];
//    home.business_id = model.id;
//    home.share_title = model.storename;
//    home.share_image = cell.header_imageView.image;
//    [self.navigationController pushViewController:home animated:YES];
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



#pragma mark - 获取偏移量
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"offsetY"])
    {
        float offsetY_new = [[change objectForKey:@"new"] floatValue];
        
        if (offsetY_new > 0) {
            return;
        }
        
        ///宽高比
        float kuanggaobi = DEVICE_WIDTH/(_upThreeViewBackGroundView.height+20);
        
        _topImv.top = offsetY_new-20;
        //            _topImv.top += abs(offsetY_new - offsetY_old)*scale;
        _topImv.height = abs(offsetY_new) + 20 + _upThreeViewBackGroundView.height;
        _topImv.width = _topImv.height*kuanggaobi;

        _topImv.center = CGPointMake(DEVICE_WIDTH/2,_topImv.center.y);
        
    }
}


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
        if (_tableView.dataArray.count>indexPath.row) {
            BusinessListModel *model = _tableView.dataArray[indexPath.row];
            [cell loadCustomViewWithType:3];
            [cell setdataWithData:model];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        
    }else if (_cellType == GCHANPIN){//收藏产品
        
        [cell loadCustomViewWithType:2];
        
        if (_tableView.dataArray.count >indexPath.row) {
            GGoodsModel *model = _tableView.dataArray[indexPath.row];
            [cell setChanpinWithData:model];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        
        
    }else if (_cellType == GANLI){//收藏案例
        
        [cell loadCustomViewWithType:1];
        if (_tableView.dataArray.count > indexPath.row) {
            GCaseModel *model = _tableView.dataArray[indexPath.row];
            [cell setAnliDataWithData:model];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    
    
    cell.separatorInset = UIEdgeInsetsZero;
    
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
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01f;
//}


#pragma mark - 上提下拉相关方法结束







@end
