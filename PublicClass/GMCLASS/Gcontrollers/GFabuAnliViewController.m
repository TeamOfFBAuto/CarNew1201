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
    
}
@end

@implementation GFabuAnliViewController


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    UINavigationBar *bar = [self.navigationController navigationBar];
    CGFloat navBarHeight = 64;
    CGRect frame = CGRectMake(0.0f,0, DEVICE_WIDTH, navBarHeight);
    [bar setFrame:frame];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    if (MY_MACRO_NAME) {
//        self.edgesForExtendedLayout = UIRectEdgeAll;
//        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.haveLuyinArray = [NSMutableArray arrayWithCapacity:1];
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeText];
    
    
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
        
        imageName = BACK_DEFAULT_IMAGE_GRAY;
    }else
    {
        imageName = NAVIGATION_MENU_IMAGE_NAME2;
    }

    UIImage * leftImage = [UIImage imageNamed:imageName];
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton addTarget:self action:@selector(leftButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0,0,leftImage.size.width,leftImage.size.height);
    UIBarButtonItem * leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItems = @[spaceButton,leftBarButton];
    
   
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtn)];
    rightBtnItem.tintColor = RGBCOLOR(154, 154, 154);
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
}

-(void)leftButtonTap:(UIButton*)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)creatHeaderView{
    _tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 46)];
    _tableHeaderView.backgroundColor = RGBCOLOR(243, 243, 243);
    _anli_title = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, DEVICE_WIDTH-20, _tableHeaderView.frame.size.height)];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(82, 15, 10, 10)];
    [img setImage:[UIImage imageNamed:@"about_telphone_image.png"]];
    _anli_title.leftView = img;
    _anli_title.leftViewMode = UITextFieldViewModeUnlessEditing;
    _anli_title.textAlignment = NSTextAlignmentCenter;
    _anli_title.leftViewMode = UITextFieldViewModeUnlessEditing;
    _anli_title.font = [UIFont systemFontOfSize:16];
    _anli_title.placeholder = @"点击添加案例标题";
    _anli_title.delegate = self;
    _anli_title.textColor = RGBCOLOR(156, 156, 156);
    _anli_title.center = _tableHeaderView.center;
    [_tableHeaderView addSubview:_anli_title];
    _tableView.tableHeaderView = _tableHeaderView;
    
}

-(void)creatFooterView{
    _tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, 286)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, DEVICE_WIDTH, 32)];
    [btn setTitle:@"继续添加图集" forState:UIControlStateNormal];
    [btn setBackgroundColor:RGBCOLOR(243, 243, 243)];
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
    title1.font = [UIFont systemFontOfSize:14];
    title1.textColor = [UIColor blackColor];
    title1.text = @"改装费用";
//    title1.backgroundColor = [UIColor orangeColor];
    [_tableFooterView addSubview:title1];
    _shangpinjiage = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(title1.frame)+37, title1.frame.origin.y, DEVICE_WIDTH-CGRectGetMaxX(title1.frame)-37-12, 15)];
    _shangpinjiage.delegate = self;
    _shangpinjiage.placeholder = @"请输入商品的价格";
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
    _gaizhuangbiaoqian = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(title2.frame)+37, title2.frame.origin.y, DEVICE_WIDTH-CGRectGetMaxX(title2.frame)-37-12, 15)];
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
    
    for (NSIndexPath *ip in self.haveLuyinArray) {
        cell.isHaveRecording = NO;
        if (indexPath.row == ip.row && indexPath.section == ip.section) {
            cell.isHaveRecording = YES;
        }
    }
    
    [cell loadCustomCellWithIndexPath:indexPath dataArray:_dataArray];
    
    for (NSIndexPath *ip in _chooseFlagArray) {
        if (ip.row == indexPath.row && ip.section == indexPath.section) {
            cell.btn.hidden = NO;
            cell.tubiao.hidden = NO;
        }
        
    }
    
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 40, 60)];
        [imv setImage:[UIImage imageNamed:@"fengmian.png"]];
        [cell.imv addSubview:imv];
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
    [_gaizhuangbiaoqian resignFirstResponder];
    [_shangpinjiage resignFirstResponder];
    [_gaizhuangshuoming resignFirstResponder];
}



-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _tableView) {
        NSLog(@"hahahaahha");
        NSLog(@"scrollview.contentoffsize %f ",_tableView.contentOffset.y);
        NSLog(@"scrollview.contentsize %f",_tableView.contentSize.height);
        
    }
}



- (void)beginRecordByFileName:(NSString*)_fileName{
    _cc = [[GluyinClass alloc]init];
    _cc.delegate = self;
    [_cc beginRecordByFileName:_fileName];
}

-(void)stopLuyinWithIndexPath:(NSIndexPath *)theIndexPath{
    [_cc stopLuyinWithIndexPath:theIndexPath];
    
    
}

#pragma mark - GluyinDelegate
-(void)theRecord:(NSData *)data indexPath:(NSIndexPath *)theIndexPath{
    
    
    NSLog(@"data%@,theindexpath:%@",data,theIndexPath);
    
    NSDictionary *dic = _dataArray[theIndexPath.row];
//    [dic setValue:data forKey:@"voice"];
    NSLog(@"%@",dic);
    
    [dic setValue:data forKey:@"voice"];
    for (NSDictionary *dic in _dataArray) {
        NSLog(@"-------------%@",dic);
    }
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

@end
