//
//  GFabuAnliViewController.m
//  CustomNewProject
//
//  Created by gaomeng on 15/3/11.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "GFabuAnliViewController.h"
#import "GHolderTextView.h"
#import "GFabuCustomTableViewCell.h"
#import "QBImagePickerController.h"
#import "GluyinClass.h"
#import "AFNetworking.h"
#import "GmPrepareNetData.h"
#import "NSDictionary+GJson.h"

@interface GFabuAnliViewController ()<UITableViewDataSource,UITableViewDelegate,QBImagePickerControllerDelegate,UITextFieldDelegate,UITextViewDelegate,GluyinDelegate>
{
    UITableView *_tableView;//主tableview
    NSMutableArray *_dataArray;
    UIView *_tableHeaderView;
    UIView *_tableFooterView;
    NSMutableArray *_chooseFlagArray;//编辑标志数组
    
    GFabuCustomTableViewCell *_tmpcell;//获取高度的cell
    
    QBImagePickerController *_imagePickerController;
    
    
    GHolderTextView *_gaizhuangshuoming;//改装说明
    UITextField *_shangpinjiage;//商品价格
    UITextField *_gaizhuangbiaoqian;//改装标签
    UITextField *_anli_title;//案例标题
    
    
    GluyinClass *_cc;
    
    NSMutableArray *_upReturnImageIdArray;
    
    NSMutableArray *_recordUploadSuccessArray;//语音上传成功之后写进去一个success
    int _recordCount;//总共有几个录音文件
    
    UIButton *_title_upBtn;//输入标题下面的button
    
}
@end

@implementation GFabuAnliViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden=NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.haveLuyinArray = [NSMutableArray arrayWithCapacity:1];
    
//    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    
    UILabel *_myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,44)];
    _myTitleLabel.textAlignment = NSTextAlignmentCenter;
    _myTitleLabel.text = @"发布案例";
    _myTitleLabel.textColor = [UIColor blackColor];
    _myTitleLabel.font = [UIFont systemFontOfSize:17];
    self.navigationItem.titleView = _myTitleLabel;
    
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceButton.width = MY_MACRO_NAME?-5:5;
    
    self.navigationController.navigationBarHidden=NO;
    
    NSString *imageName;
    if (self.isPush) {
        
        imageName = NAVIGATION_MENU_IMAGE_NAME2;
    }else
    {
        imageName = BACK_DEFAULT_IMAGE_GRAY;
    }

    UIImage * leftImage = [UIImage imageNamed:imageName];
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0,0,leftImage.size.width,leftImage.size.height);
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItems = @[spaceButton,leftBarButton];
    
   
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtn)];
//    rightBtnItem.tintColor = RGBCOLOR(154, 154, 154);
    rightBtnItem.tintColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = rightBtnItem;
    
    
    
//    @property(nonatomic,strong)NSMutableArray * allImageArray;
//    @property(nonatomic,strong)NSMutableArray * allAssesters;
//    @property(nonatomic,strong)NSMutableArray * TempAllImageArray;
//    @property(nonatomic,strong)NSMutableArray * TempAllAssesters;
    
    
    _chooseFlagArray = [NSMutableArray arrayWithCapacity:1];
    
    NSLog(@"allImageArray.count %d",self.allImageArray.count);
    NSLog(@"allAssesters.count %d",self.allAssesters.count);
    NSLog(@"TempAllImageArray.count %d",self.TempAllImageArray.count);
    NSLog(@"TempAllAssesters.count %d",self.TempAllAssesters.count);
    
    _dataArray = [NSMutableArray arrayWithCapacity:self.TempAllImageArray.count];
    for (UIImage *image in self.TempAllImageArray) {
        NSString *text = @"";
        NSData *voice = [NSData data];
        
        NSMutableDictionary*dic = [[NSMutableDictionary alloc]initWithCapacity:3];
        [dic setValue:image forKey:@"image"];
        [dic setValue:text forKey:@"text"];
        [dic setValue:voice forKey:@"voice"];
        [_dataArray addObject:dic];
    }
    
    
    [self creatTableView];
    [self creatHeaderView];
    [self creatFooterView];
    
    
    //编辑状态
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(GlongPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
//    [_tableView addGestureRecognizer:longPressGr];
    _tableView.editing = NO;
    
    
    //收键盘
    UITapGestureRecognizer *shou = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Gshou)];
    [_tableView addGestureRecognizer:shou];
    [_tableView.tableHeaderView addGestureRecognizer:shou];
    [_tableView.tableFooterView addGestureRecognizer:shou];
    
}


-(void)GlongPressToDo:(UILongPressGestureRecognizer *)gesture{
    [_chooseFlagArray removeAllObjects];
    [_tableView reloadData];//进入拖动排序显示绿框
    NSLog(@"%d",_tableView.editing);
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:_tableView];
        NSIndexPath * indexPath = [_tableView indexPathForRowAtPoint:point];
        if(indexPath == nil) return ;
        
        _tableView.editing = !_tableView.editing;
        self.editKuang = _tableView.editing;
        
    }
    NSLog(@"%d",_tableView.editing);
}




-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
}



-(void)rightBtn{
    NSLog(@"点击发布");
    
    NSString *title = _anli_title.text;//标题
    NSString *content = _anli_title.text;//案例描述
    NSString *fee = _shangpinjiage.text;//案例价格
    NSString *tags = _gaizhuangbiaoqian.text;//标签描述以“|”分割
    
    if (_dataArray.count == 0||title.length == 0 ||content.length == 0 || fee.length == 0 || tags.length == 0) {
        [GMAPI showAutoHiddenMBProgressWithText:@"请完善信息" addToView:self.view];
    }else{
        _recordCount = 0;
        _recordUploadSuccessArray = [NSMutableArray arrayWithCapacity:1];
        [self uploadData];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    
    
    
    
    
}


//上传
-(void)uploadData{
    [self uploadImage];
}


//上传图片
-(void)uploadImage{
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *dic in _dataArray) {
        UIImage *image = [dic objectForKey:@"image"];
        [imageArray addObject:image];
    }
    
    //上传图片url
    NSString *url = @"http://g.fblife.com/index.php?c=interface&a=uploadPhoto&fbtype=json";
    NSLog(@"上传图片接口:%@",url);
    //设置接收响应类型为标准HTTP类型(默认为响应类型为JSON)
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation  * o2= [manager
                                   POST:url
                                   parameters:@{
                                                @"authkey":[GMAPI getAuthkey]//产品名
                                                }
                                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                   {
                                       
                                       for (int i = 0; i < imageArray.count; i ++) {
                                           
                                           UIImage *aImage = imageArray[i];
                                           
                                           NSData * data= UIImageJPEGRepresentation(aImage, 0.8);
                                           
                                           NSLog(@"---> 大小 %ld",(unsigned long)data.length);
                                           
                                           NSString *imageName = [NSString stringWithFormat:@"image%d.jpg",i];
                                           
                                           NSString *picName = [NSString stringWithFormat:@"caseimg[%d]",i];
                                           
                                           [formData appendPartWithFileData:data name:picName fileName:imageName mimeType:@"image/jpg"];
                                           
                                       }
                                       
                                       
                                   }
                                   success:^(AFHTTPRequestOperation *operation, id responseObject)
                                   {
                                       
                                       
                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                       
                                       NSLog(@"success %@",responseObject);
                                       
                                       NSError * myerr;
                                       
                                       NSDictionary *mydic=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:&myerr];
                                       NSLog(@"mydic == %@ err0 = %@",mydic,myerr);
                                       
                                       if (mydic == nil) {
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                           [GMAPI showAutoHiddenMBProgressWithText:@"上传失败" addToView:self.view];
                                           return;
                                       }
                                       
                                       if ([[mydic objectForKey:@"errcode"]intValue]==0) {
                                           NSArray *dataInfoArray = [mydic objectForKey:@"datainfo"];
                                           NSLog(@"%@",dataInfoArray);
                                           _upReturnImageIdArray = [NSMutableArray arrayWithArray:dataInfoArray];
                                           [self uploadVoice];
                                           
                                       }else{
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                           [GMAPI showAutoHiddenMBProgressWithText:[mydic objectForKey:@"errinfo"] addToView:self.view];
                                       }
                                       
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       
                                       [GMAPI showAutoHiddenMBProgressWithText:@"上传失败请重新上传" addToView:self.view];
                                       
                                       NSLog(@"失败 : %@",error);
                                       
                                       
                                   }];
    
    //设置上传操作的进度
    [o2 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
}


//上传录音
-(void)uploadVoice{
    //上传录音url
    NSString *url = @"http://g.fblife.com/index.php?c=interface&a=uploadvoice&fbtype=json";
    
    int vvv = _dataArray.count;
    for (int i = 0;i<vvv;i++) {
        NSDictionary *dic = _dataArray[i];
        NSDictionary *pid_dic = _upReturnImageIdArray[i];
        NSString *pid = [pid_dic objectForKey:@"imgid"];
        url = [NSString stringWithFormat:@"%@&pid=%@",url,pid];
        NSData *voice = [dic objectForKey:@"voice"];
        if ([voice length]>0) {
            _recordCount++;
            NSLog(@"上传录音url:%@",url);
            //设置接收响应类型为标准HTTP类型(默认为响应类型为JSON)
            AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            AFHTTPRequestOperation  * o2= [manager
                                           POST:url
                                           parameters:@{
                                                        @"authkey":[GMAPI getAuthkey]
                                                        }
                                           constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                           {
                                               NSLog(@"---> 大小 %ld",(unsigned long)voice.length);
                                               
                                               NSString *voiceName = [NSString stringWithFormat:@"voice"];
                                               
                                               NSString *voiceName_php = [NSString stringWithFormat:@"casevoice"];
                                               
                                               [formData appendPartWithFileData:voice name:voiceName_php fileName:voiceName mimeType:@"wav"];
                                               
                                               
                                           }
                                           success:^(AFHTTPRequestOperation *operation, id responseObject)
                                           {
                                               
                                               
                                               NSLog(@"success %@",responseObject);
                                               
                                               NSError * myerr;
                                               
                                               NSDictionary *mydic=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:&myerr];
                                               NSLog(@"mydic == %@ err0 = %@",mydic,myerr);
                                               
                                               if (mydic == nil) {
                                                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                   [GMAPI showAutoHiddenMBProgressWithText:@"上传失败" addToView:self.view];
                                                   return;
                                               }
                                               
                                               if ([[mydic objectForKey:@"errcode"]intValue]==0) {
                                                   NSArray *dataInfoArray = [mydic objectForKey:@"datainfo"];
                                                   NSLog(@"%@",dataInfoArray);
                                                   
                                                   [_recordUploadSuccessArray addObject:@"success"];
                                                   
                                                   if (_recordUploadSuccessArray.count == _recordCount) {
                                                       [self uploadCommoncase];//上传描述文字
                                                   }
                                                   
                                                   
                                               }else{
                                                   [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                                   [GMAPI showAutoHiddenMBProgressWithText:[mydic objectForKey:@"errinfo"] addToView:self.view];
                                               }
                                               
                                           }
                                           failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                               
                                               [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                               
                                               [GMAPI showAutoHiddenMBProgressWithText:@"上传失败请重新上传" addToView:self.view];
                                               
                                               NSLog(@"失败 : %@",error);
                                               
                                               
                                           }];
            
            //设置上传操作的进度
            [o2 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                
            }];
        }
    }
    
    
    if (_recordCount == 0) {
        [self uploadCommoncase];
    }
    
   
    
}


//上传案例
-(void)uploadCommoncase{
    
    //上传描述url
    NSString *str = @"http://g.fblife.com/index.php?c=interface&a=addcommoncase&fbtype=json";
    //参数
    NSString *title = _anli_title.text;//标题
    NSString *img_id = @"";//图片字符串
    NSMutableArray *img_id_Array = [NSMutableArray arrayWithCapacity:1];
    
    NSMutableArray *pic_descArray = [NSMutableArray arrayWithCapacity:1];//图片描述数组：带pic_desc[]参数
    
    if (_dataArray.count != _upReturnImageIdArray.count) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [GMAPI showAutoHiddenMBProgressWithText:@"上传失败，请检查网络" addToView:self.view];
        return;
    }
    for (int i = 0; i<_dataArray.count; i++) {
        NSDictionary *dic = _dataArray[i];
        NSDictionary *dic1 = _upReturnImageIdArray[i];
        NSString *text = [dic stringValueForKey:@"text"];
        if (text == nil || text.length == 0) {
            text = @" ";
        }
        if ([text length]>0) {
            NSString *aaa = [NSString stringWithFormat:@"&pic_desc[]=%@",text];
            [pic_descArray addObject:aaa];//图片描述数组
            [img_id_Array addObject:[dic1 objectForKey:@"imgid"]];//图片id数组
        }
    }
    
    
    img_id = [img_id_Array componentsJoinedByString:@"-"];
    NSString *pichead = img_id_Array[0];//封面图id
    NSString *content = _anli_title.text;//案例描述
    NSString *fee = _shangpinjiage.text;//案例价格
    NSString *tags_mutable = [NSMutableString stringWithString:_gaizhuangbiaoqian.text];
    NSString *tags = [tags_mutable stringByReplacingOccurrencesOfString:@" " withString:@"-"];//标签描述以“|”分割
    NSString *car_brand = @"0";//汽车品牌
    NSString *car_model = @"0";//汽车品牌车系
    
    NSString *url = [NSString stringWithFormat:@"%@&authkey=%@&title=%@&img_id=%@&pichead=%@&content=%@&fee=%@&tags=%@&car_brand=%@&car_model=%@",str,[GMAPI getAuthkey],title,img_id,pichead,content,fee,tags,car_brand,car_model];
    
    int ccc = pic_descArray.count;
    for (int i = 0; i<ccc; i++) {
        NSString *pic_desc = pic_descArray[i];
        NSString *uuu = [NSString stringWithFormat:@"%@%@",url,pic_desc];
        url = uuu;
    }
    
    NSLog(@"发布案例接口:%@",url);
    
    GmPrepareNetData *ddd = [[GmPrepareNetData alloc]initWithUrl:url isPost:YES postData:nil];
    [ddd requestCompletion:^(NSDictionary *result, NSError *erro) {
        
        
        
        if (result == nil) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GMAPI showAutoHiddenMBProgressWithText:@"上传失败" addToView:self.view];
            return;
        }
        
        if ([[result objectForKey:@"errcode"]intValue]==0) {
            NSArray *dataInfoArray = [result objectForKey:@"datainfo"];
            NSLog(@"%@",dataInfoArray);
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GMAPI showAutoHiddenMBProgressWithText:[result objectForKey:@"errinfo"] addToView:self.view];
            [self performSelector:@selector(fabuyifuSuccessToGoBack) withObject:[NSNumber numberWithBool:YES] afterDelay:1];
            
        }else{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [GMAPI showAutoHiddenMBProgressWithText:[result objectForKey:@"errinfo"] addToView:self.view];
        }
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [GMAPI showAutoHiddenMBProgressWithText:@"上传失败请重新上传" addToView:self.view];
        NSLog(@"failDic : %@",[failDic objectForKey:@"ERRO_INFO"]);
    }];
    
    
}

-(void)fabuyifuSuccessToGoBack{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


//备用上传方式
-(void)uploadCommoncase1{
    //上传描述url
    NSString *str = @"http://g.fblife.com/index.php?c=interface&a=addcommoncase&fbtype=json";
    //参数
    NSString *title = _anli_title.text;//标题
    NSString *img_id = @"";//图片字符串
    NSMutableArray *img_id_Array = [NSMutableArray arrayWithCapacity:1];
    
    NSMutableArray *pic_descArray = [NSMutableArray arrayWithCapacity:1];//图片描述数组：带pic_desc[]参数
    
    if (_dataArray.count != _upReturnImageIdArray.count) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [GMAPI showAutoHiddenMBProgressWithText:@"上传失败，请检查网络" addToView:self.view];
        return;
    }
    for (int i = 0; i<_dataArray.count; i++) {
        NSDictionary *dic = _dataArray[i];
        NSDictionary *dic1 = _upReturnImageIdArray[i];
        NSString *text = [dic stringValueForKey:@"text"];
        if (text == nil || text.length == 0) {
            text = @" ";
        }
        if ([text length]>0) {
            [pic_descArray addObject:text];
            [img_id_Array addObject:[dic1 objectForKey:@"imgid"]];//图片id数组
        }
    }
    
    
    img_id = [img_id_Array componentsJoinedByString:@"-"];
    NSString *pichead = img_id_Array[0];//封面图id
    NSString *content = _anli_title.text;//案例描述
    NSString *fee = _shangpinjiage.text;//案例价格
    NSString *tags = _gaizhuangbiaoqian.text;//标签描述以“|”分割
    NSString *car_brand = @"0";//汽车品牌
    NSString *car_model = @"0";//汽车品牌车系
    
    NSString *url = [NSString stringWithFormat:@"%@&authkey=%@&title=%@&img_id=%@&pichead=%@&content=%@&fee=%@&tags=%@&car_brand=%@&car_model=%@",str,[GMAPI getAuthkey],title,img_id,pichead,content,fee,tags,car_brand,car_model];
    

    
    NSLog(@"发布案例接口:%@",url);
    
    
    //设置接收响应类型为标准HTTP类型(默认为响应类型为JSON)
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation  * o2= [manager
                                   POST:url
                                   parameters:@{
                                                @"authkey":[GMAPI getAuthkey]//产品名
                                                }
                                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
                                   {
                                       
                                       for (int i = 0; i < pic_descArray.count; i ++) {
                                           
                                           NSString *pic_desc = pic_descArray[i];
                                           
                                           NSData * data= [pic_desc dataUsingEncoding:NSUTF8StringEncoding];
                                           
                                           NSLog(@"---> 大小 %ld",(unsigned long)data.length);
                                           
                                           NSString *picDesc = [NSString stringWithFormat:@"picDesc%d.jpg",i];
                                           
                                           NSString *picDesc_php = [NSString stringWithFormat:@"caseimg[%d]",i];
                                           
                                           [formData appendPartWithFileData:data name:picDesc_php fileName:picDesc mimeType:@"text/HTML"];
                                           
                                       }
                                       
                                       
                                   }
                                   success:^(AFHTTPRequestOperation *operation, id responseObject)
                                   {
                                       
                                       
                                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                                       
                                       NSLog(@"success %@",responseObject);
                                       
                                       NSError * myerr;
                                       
                                       NSDictionary *mydic=[NSJSONSerialization JSONObjectWithData:(NSData *)responseObject options:NSJSONReadingAllowFragments error:&myerr];
                                       NSLog(@"mydic == %@ err0 = %@",mydic,myerr);
                                       
                                       if (mydic == nil) {
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                           [GMAPI showAutoHiddenMBProgressWithText:@"上传失败" addToView:self.view];
                                           return;
                                       }
                                       
                                       if ([[mydic objectForKey:@"errcode"]intValue]==0) {
                                           NSArray *dataInfoArray = [mydic objectForKey:@"datainfo"];
                                           NSLog(@"%@",dataInfoArray);
                                           _upReturnImageIdArray = [NSMutableArray arrayWithArray:dataInfoArray];
                                           [self uploadVoice];
                                           
                                       }else{
                                           [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                           [GMAPI showAutoHiddenMBProgressWithText:[mydic objectForKey:@"errinfo"] addToView:self.view];
                                       }
                                       
                                   }
                                   failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                       
                                       [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                                       
                                       [GMAPI showAutoHiddenMBProgressWithText:@"上传失败请重新上传" addToView:self.view];
                                       
                                       NSLog(@"失败 : %@",error);
                                       
                                       
                                   }];
    
    //设置上传操作的进度
    [o2 setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    }];
}










-(void)leftButtonTap:(UIButton*)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)creatHeaderView{
    _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 46)];
    _tableHeaderView.backgroundColor = RGBCOLOR(243, 243, 243);
    _anli_title = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, DEVICE_WIDTH-100, _tableHeaderView.frame.size.height)];
    _anli_title.textAlignment = NSTextAlignmentCenter;
    _anli_title.font = [UIFont systemFontOfSize:16];
//    _anli_title.placeholder = @"点击添加案例标题";
    _anli_title.delegate = self;
    _anli_title.textColor = RGBCOLOR(156, 156, 156);
    _anli_title.center = _tableHeaderView.center;
    
    
//    NSTextAttachment *att = [[NSTextAttachment alloc]init];
//    att.image = [UIImage imageNamed:@"pen"];
//    
//    NSDictionary *dic = @{};
//    
//    NSAttributedString *str = [[NSAttributedString alloc]initWithString:@"" attributes:dic];
    
//    _title_upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_title_upBtn setImage:[UIImage imageNamed:@"pen.png"] forState:UIControlStateNormal];
//    [_title_upBtn setTitle:@"点击添加案例标题" forState:UIControlStateNormal];
//    [_title_upBtn setTitleColor:RGBCOLOR(156, 156, 156) forState:UIControlStateNormal];
//    [_title_upBtn setFrame:_anli_title.bounds];
//    [_title_upBtn addTarget:self action:@selector(hiddenTheTitleBtn) forControlEvents:UIControlEventTouchUpInside];
//    [_anli_title addSubview:_title_upBtn];
    
    
    
    
    NSMutableAttributedString *richText = [[NSMutableAttributedString alloc] initWithString:@"点击添加案例标题"];
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"pen.png"]; // suppose image exists
    attachment.bounds = CGRectZero; // configure size of attachment
    [richText insertAttributedString:[NSAttributedString attributedStringWithAttachment:attachment] atIndex:0];
    _anli_title.attributedPlaceholder = richText;
    
    
    [_tableHeaderView addSubview:_anli_title];
    _tableView.tableHeaderView = _tableHeaderView;
    
}





-(void)creatFooterView{
    _tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 286)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, DEVICE_WIDTH, 32)];
    [btn setTitle:@"继续添加图集" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setBackgroundColor:RGBCOLOR(243, 243, 243)];
    [btn setImage:[UIImage imageNamed:@"tianjiatuji.png"] forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(GgoOnAddPic) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:RGBCOLOR(161, 161, 161) forState:UIControlStateNormal];
    [_tableFooterView addSubview:btn];
    
    
    
    _gaizhuangshuoming = [[GHolderTextView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(btn.frame), DEVICE_WIDTH, 114) placeholder:@"请输入改装说明..." holderSize:13];
    _gaizhuangshuoming.delegate_fbvc = self;
    [_tableFooterView addSubview:_gaizhuangshuoming];
    
    
    UIView *fengexian = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_gaizhuangshuoming.frame), DEVICE_WIDTH, 0.5)];
    fengexian.backgroundColor = RGBCOLOR(167, 167, 167);
    [_tableFooterView addSubview:fengexian];
    
    
    UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(fengexian.frame)+16, 60, 15)];
    title1.font = [UIFont systemFontOfSize:15];
    title1.textColor = [UIColor blackColor];
    title1.text = @"改装费用";
//    title1.backgroundColor = [UIColor orangeColor];
    [_tableFooterView addSubview:title1];
    _shangpinjiage = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(title1.frame)+37, title1.frame.origin.y, DEVICE_WIDTH-CGRectGetMaxX(title1.frame)-37-12, 16)];
    _shangpinjiage.font = [UIFont systemFontOfSize:14];
    _shangpinjiage.delegate = self;
    _shangpinjiage.placeholder = @"请输入商品的价格";
    _shangpinjiage.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    _shangpinjiage.backgroundColor = [UIColor orangeColor];
    [_tableFooterView addSubview:_shangpinjiage];
    
    
    UIView *fen = [[UIView alloc]initWithFrame:CGRectMake(title1.frame.origin.x, CGRectGetMaxY(title1.frame)+16, DEVICE_WIDTH-12, 0.5)];
    fen.backgroundColor = RGBCOLOR(214, 214, 214);
    [_tableFooterView addSubview:fen];
    
    UILabel *title2 = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(fen.frame)+16, title1.frame.size.width, title1.frame.size.height)];
    title2.font = title1.font;
    title2.textColor = title1.textColor;
    title2.text = @"改装标签";
//    title2.backgroundColor = [UIColor orangeColor];
    [_tableFooterView addSubview:title2];
    _gaizhuangbiaoqian = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(title2.frame)+37, title2.frame.origin.y, DEVICE_WIDTH-CGRectGetMaxX(title2.frame)-37-12, 16)];
    _gaizhuangbiaoqian.font = [UIFont systemFontOfSize:14];
    _gaizhuangbiaoqian.delegate = self;
    _gaizhuangbiaoqian.placeholder = @"添加标签 以空格隔开";
//    _gaizhuangbiaoqian.backgroundColor = [UIColor orangeColor];
    [_tableFooterView addSubview:_gaizhuangbiaoqian];
    
    
    _tableView.tableFooterView = _tableFooterView;
    
    
    
    
}

-(void)creatTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT-64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
}


-(void)GgoOnAddPic{
    if (!_imagePickerController)
    {
        _imagePickerController = nil;
    }
    
    _imagePickerController = [[QBImagePickerController alloc] init];
    _imagePickerController.delegate = self;
    _imagePickerController.allowsMultipleSelection = YES;
    _imagePickerController.assters = self.TempAllAssesters;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_imagePickerController];
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}




#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    GFabuCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[GFabuCustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell = [[GFabuCustomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.delegate = self;
    
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    
    NSLog(@"%@",indexPath);
    NSDictionary *dic = _dataArray[indexPath.row];//数据字典
    
    for (NSIndexPath *ip in self.haveLuyinArray) {
        cell.isHaveRecording = NO;
        if (indexPath.row == ip.row && indexPath.section == ip.section) {
            cell.isHaveRecording = YES;
        }
    }
    
    if ([[dic objectForKey:@"voice"]length]>0) {
        cell.isHaveRecording = YES;
    }else{
        cell.isHaveRecording = NO;
    }
    
    
    if ([[dic objectForKey:@"text"]length]>0) {
        cell.isHaveText = YES;
    }else{
        cell.isHaveText = NO;
    }
    
    [cell loadCustomCellWithIndexPath:indexPath dataArray:_dataArray];
    
    
    // 多个单元格只有单一单元格输入源
    for (NSIndexPath *ip in _chooseFlagArray) {
        if (ip.row == indexPath.row && ip.section == indexPath.section) {
            
            cell.rightDeletBtn.hidden = NO;
            
            if (cell.isHaveRecording) {
                cell.btn.hidden = NO;
                cell.tubiao.hidden = NO;
            }else if (cell.isHaveText){
                cell.btn.hidden = YES;
                cell.tubiao.hidden = NO;
                cell.theContentLabel.hidden = NO;
            }else{
                cell.btn.hidden = NO;
                cell.tubiao.hidden = NO;
            }
            
        }
        
    }
    
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 40, 60)];
        [imv setImage:[UIImage imageNamed:@"fengmian.png"]];
        [cell.imv addSubview:imv];
        
        UILabel *fengmianLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 40, 25)];
        fengmianLabel.numberOfLines = 1;
        fengmianLabel.textAlignment = NSTextAlignmentCenter;
        fengmianLabel.text = @"封";
        fengmianLabel.font = [UIFont systemFontOfSize:22];
        fengmianLabel.textColor = [UIColor whiteColor];
        [imv addSubview:fengmianLabel];
        
        UILabel *fengmianLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 28, 40, 25)];
        fengmianLabel1.numberOfLines = 1;
        fengmianLabel1.text = @"面";
        fengmianLabel1.textAlignment = NSTextAlignmentCenter;
        fengmianLabel1.font = [UIFont systemFontOfSize:22];
        fengmianLabel1.textColor = [UIColor whiteColor];
        [imv addSubview:fengmianLabel1];
        
        
    }
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat theHeight = 0.0f;
    if (!_tmpcell) {
        _tmpcell = [[GFabuCustomTableViewCell alloc]init];
    }
    _tmpcell.delegate = self;
    
    theHeight = [_tmpcell loadCustomCellWithIndexPath:indexPath dataArray:_dataArray];
    
    return theHeight;
}




-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self Gshou];
    
    NSIndexPath *ip11;
    BOOL isHave = NO;
    
    for (NSIndexPath *ip in _chooseFlagArray) {
        ip11 = ip;
        [_chooseFlagArray removeObject:ip];
        isHave = YES;
        break;
    }
    if (ip11.row == indexPath.row && ip11.section == indexPath.section && isHave == YES) {
        [_tableView reloadData];
        return;
    }
    [_chooseFlagArray addObject:indexPath];
    [_tableView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}


-(BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [_dataArray exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    [_tableView reloadData];//封面永远在第一个
    
}


- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}




//多图选择
#pragma mark-QBImagePickerControllerDelegate

-(void)imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController
{
    [imagePickerController dismissViewControllerAnimated:YES completion:^{
        
    }];
}



-(void)imagePickerControllerWillFinishPickingMedia:(QBImagePickerController *)imagePickerController
{
    
}

-(void)imagePickerController1:(QBImagePickerController *)imagePickerController didFinishPickingMediaWithInfo:(id)info
{
    NSArray *mediaInfoArray = (NSArray *)info;
    
    
    
    
//    NSMutableArray * allImageArray = [NSMutableArray array];
//    
//    NSMutableArray * allAssesters = [[NSMutableArray alloc] init];
    
    for (int i = 0;i < mediaInfoArray.count;i++)
    {
        
        UIImage * image = [[mediaInfoArray objectAtIndex:i] objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        UIImage * newImage = [self scaleToSizeWithImage:image size:CGSizeMake(image.size.width>1024?1024:image.size.width,image.size.width>1024?image.size.height*1024/image.size.width:image.size.height)];
        
        [_allImageArray addObject:newImage];
        newImage = nil;
        
        NSURL * url = [[mediaInfoArray objectAtIndex:i] objectForKey:@"UIImagePickerControllerReferenceURL"];
        
        NSString * url_string = [[url absoluteString] stringByReplacingOccurrencesOfString:@"/" withString:@""];
        
        url_string = [url_string stringByAppendingString:@".png"];
        
        [_allAssesters addObject:url_string];
        
        
        NSDictionary *dic = @{@"image":image,@"text":@"",@"voice":@""};
        [_dataArray addObject:dic];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
            [ZSNApi saveImageToDocWith:url_string WithImage:image];
        });
        
    }
    
    for (NSIndexPath *ip in _chooseFlagArray) {
        [_chooseFlagArray removeObject:ip];
    }
    [_tableView reloadData];
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (IOS7_OR_LATER) {
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        }
    }];
}


-(UIImage *)scaleToSizeWithImage:(UIImage *)img size:(CGSize)size{
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




-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _shangpinjiage || textField == _gaizhuangbiaoqian){//商品价格//改装标签
        [self changeTheTableViewContentOffset];
    }else if (textField == _anli_title){//案例标题
        [self changeTheTableViewContentOffset2];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _shangpinjiage || textField == _gaizhuangbiaoqian) {
        [self changeTheTableViewContentOffset1];
    }else if (textField == _anli_title){//案例标题
        [self changeTheTableViewContentOffset3];
    }
    
    
}

-(void)changeTheTableViewContentOffset{//拉长tableview并改变contentoffset
    CGPoint p = _tableView.contentOffset;
    CGSize s = _tableView.contentSize;
    _tableView.contentOffset = CGPointMake(0, p.y+250);
    _tableView.contentSize = CGSizeMake(DEVICE_WIDTH, s.height+250);

}
-(void)changeTheTableViewContentOffset1{//还原tableview并改变contentoffset
    CGPoint p = _tableView.contentOffset;
    CGSize s = _tableView.contentSize;
    _tableView.contentOffset = CGPointMake(0, p.y-250);
    _tableView.contentSize = CGSizeMake(DEVICE_WIDTH, s.height-250);

}

-(void)changeTheTableViewContentOffset2{//拉长tableview
    CGSize s = _tableView.contentSize;
    _tableView.contentSize = CGSizeMake(DEVICE_WIDTH, s.height+250);
}

-(void)changeTheTableViewContentOffset3{//还原tableview
    CGSize s = _tableView.contentSize;
    _tableView.contentSize = CGSizeMake(DEVICE_WIDTH, s.height-250);
}



-(void)Gshou{
    [_anli_title resignFirstResponder];
    [_gaizhuangbiaoqian resignFirstResponder];
    [_shangpinjiage resignFirstResponder];
    [_gaizhuangshuoming resignFirstResponder];
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _tableView) {
//        NSLog(@"scrollview.contentoffsize %f ",_tableView.contentOffset.y);
//        NSLog(@"scrollview.contentsize %f",_tableView.contentSize.height);
        
    }
}



- (void)beginRecordByFileName:(NSString*)_fileName{
    _cc = [[GluyinClass alloc]init];
    _cc.maxTime = 60;
    _cc.delegate = self;
    [_cc beginRecordByFileName:_fileName];
}

-(void)stopLuyinWithIndexPath:(NSIndexPath *)theIndexPath{
    [_cc stopLuyinWithIndexPath:theIndexPath];
    
    
}

#pragma mark - GluyinDelegate
-(void)theRecord:(NSData *)data indexPath:(NSIndexPath *)theIndexPath Time:(CGFloat)theTime{
    
    
    NSLog(@"data%@,theindexpath:%@",data,theIndexPath);
    
    NSDictionary *dic = _dataArray[theIndexPath.row];
    NSLog(@"添加录音前%@",dic);
    [dic setValue:data forKey:@"voice"];
    
    NSString *theTimeStr = [NSString stringWithFormat:@"%.1f",theTime];
    [dic setValue:theTimeStr forKey:@"voice_time"];
    NSLog(@"添加录音后%@",dic);
    [_tableView reloadData];
}






-(void)playTheRecordWithIndexPath:(NSIndexPath*)theIndexPath{
    NSDictionary *dic = _dataArray[theIndexPath.row];
    NSData *data = [dic objectForKey:@"voice"];
    [[GluyinClass sharedManager]gPlayWithData:data];
}


-(void)deletTheRecordWithIndexPath:(NSIndexPath*)theIndexPath{
    NSDictionary *dic = _dataArray[theIndexPath.row];
    [dic setValue:[NSData data] forKey:@"voice"];
    
}



-(void)addContentTextToDataArrayWithIndexPath:(NSIndexPath*)theIndexPath ContentString:(NSString *)theString{
    NSDictionary *dic = _dataArray[theIndexPath.row];
    [dic setValue:theString forKey:@"text"];
    
    NSIndexPath *ip11;
    BOOL isHave = NO;
    
    for (NSIndexPath *ip in _chooseFlagArray) {
        ip11 = ip;
        [_chooseFlagArray removeObject:ip];
        isHave = YES;
        break;
    }
    if (ip11.row == theIndexPath.row && ip11.section == theIndexPath.section && isHave == YES) {
        [_tableView reloadData];
        return;
    }
    [_chooseFlagArray addObject:theIndexPath];
    [_tableView reloadData];
    
    
}


-(BOOL)panduanContentTfHiddenWithIndexPath:(NSIndexPath*)theIndexPath{
    BOOL YesOrNo_hiden = YES;
    for (NSIndexPath *ip in _chooseFlagArray) {
        if (ip.row == theIndexPath.row && ip.section == theIndexPath.section) {
            YesOrNo_hiden = NO;
        }
    }
    
    return YesOrNo_hiden;
}



-(void)clearContentTextWithIndexPath:(NSIndexPath*)theIndexPath{
    NSDictionary *dic = _dataArray[theIndexPath.row];
    [dic setValue:@"" forKey:@"text"];
}


-(void)deletCellWithIndexPath:(NSIndexPath *)theIndexPath{
    [_dataArray removeObjectAtIndex:theIndexPath.row];
    for (NSIndexPath *ip in _chooseFlagArray) {
        [_chooseFlagArray removeObject:ip];
    }
    [_tableView reloadData];
    
}





@end
