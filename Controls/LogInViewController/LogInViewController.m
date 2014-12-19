//
//  LogInViewController.m
//  CustomNewProject
//123
//  Created by soulnear on 14-11-27.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//


//登录界面vc

#import "LogInViewController.h"
#import "AppDelegate.h"
#import "GloginView.h"//登录view
#import "LTools.h"//伟哥工具类
#import "MyPhoneNumViewController.h"//注册界面vc
#import "GfindPasswViewController.h"//找回密码界面vc
#import "GMAPI.h"


#define LOGIN_PHONE @"LOGIN_PHONE"//登录手机号
#define LOGIN_PASS @"LOGIN_PASS"//登录密码

#import "GmPrepareNetData.h"


@interface LogInViewController ()
{
    UIActivityIndicatorView *j;
    UIAlertView *al;
    GloginView *_gloginView;
}

@end

@implementation LogInViewController

- (void)CloseButtonTap:(id)sender
{
//    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate showControlView:Root_home];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

+ (LogInViewController *)sharedManager
{
    static LogInViewController *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}



- (void)dealloc
{
    
    NSLog(@"%s",__FUNCTION__);
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    if (IOS7_OR_LATER) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    }

    
    NSLog(@"%s",__FUNCTION__);
    
    _gloginView = [[GloginView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, ALL_FRAME_HEIGHT)];
    [self.view addSubview:_gloginView];
    
    
    
    __weak typeof (self)bself = self;
    __weak typeof (_gloginView)bgloginView = _gloginView;
    
    //设置跳转注册block
    [_gloginView setZhuceBlock:^{
        [bgloginView Gshou];
        [bself pushToZhuceVC];
    }];
    
    //设置找回密码block
    [_gloginView setFindPassBlock:^{
        [bgloginView Gshou];
        [bself pushToFindPassWordVC];
    }];
    
    //登录
    [_gloginView setDengluBlock:^(NSString *usern, NSString *passw) {
        
        NSLog(@"--%@     --%@",usern,passw);
        
        if (usern.length ==0 && passw.length == 0) {//无账号密码
            
            [bself noUserNameAndPassW];
        }else if (usern.length == 0 || passw.length == 0){//无账号或密码
            if (usern.length == 0) {
                [bself noUserName];
            }else if (passw.length == 0){
                [bself noPassW];
            }
        }else{//有账号密码
            [bself dengluWithUserName:usern pass:passw];
        }
        
    }];
    
    UIButton * close_button = [UIButton buttonWithType:UIButtonTypeCustom];
    close_button.frame = CGRectMake(DEVICE_WIDTH - 50,20,50,50);
    [close_button setImage:[UIImage imageNamed:@"login_close_image"] forState:UIControlStateNormal];
    [close_button addTarget:self action:@selector(CloseButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close_button];
    
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopJ) name:@"beginInput" object:nil];
    
    
    
}


-(void)stopJ{
    if (j) {
        [j stopAnimating];
        [j removeFromSuperview];
        j = nil;
    }
}


-(void)noUserNameAndPassW{
    id obj=NSClassFromString(@"UIAlertController");
    if ( obj!=nil){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请填写用户名和密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写用户名和密码"
                                                       delegate:self cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil,nil];
        
        [alert show];
    }
}

-(void)noUserName{
    id obj=NSClassFromString(@"UIAlertController");
    if ( obj!=nil){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请填写用户名" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写用户名"
                                                       delegate:self cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil,nil];
        
        [alert show];
    }
}

-(void)noPassW{
    id obj=NSClassFromString(@"UIAlertController");
    if ( obj!=nil){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请填写密码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写密码"
                                                       delegate:self cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil,nil];
        
        [alert show];
    }
}


-(void)loginFail{
    id obj=NSClassFromString(@"UIAlertController");
    if ( obj!=nil){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失败，请检查网络" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录失败，请检查网络"
                                                       delegate:self cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil,nil];
        
        [alert show];
    }
}


#pragma mark - 登录
-(void)dengluWithUserName:(NSString *)name pass:(NSString *)passw{
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"gdenglu" object:nil];
    
    //菊花
    if (j) {
        
    }else{
        j = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        if (iPhone5) {
            j.center = CGPointMake(160, 170);
        }else{
            j.center = CGPointMake(DEVICE_WIDTH/2.0, 170);
        }
        
        [self.view addSubview:j];
        [j startAnimating];
    }
    
    
    
    __weak typeof (_gloginView)bloginView = _gloginView;
    
    //登录接口
    
    NSString *deviceToken = [GMAPI getDeviceToken] ? [GMAPI getDeviceToken] : @"testToken";
    
    NSString *post = [NSString stringWithFormat:@"&username=%@&password=%@&token=%@",name,passw,deviceToken];
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    GmPrepareNetData *cc = [[GmPrepareNetData alloc]initWithUrl:G_LOGIN isPost:YES postData:postData];
    [cc requestCompletion:^(NSDictionary *result, NSError *erro) {
        [j stopAnimating];
        NSLog(@"登录成功:%@",result);
        if ([[result objectForKey:@"errcode"] intValue] == 0) {//登录成功
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USER_IN];
            
                [bloginView cleanUserNameAndPassWordTextfied];
                NSDictionary *datainfo = [result objectForKey:@"datainfo"];
                NSString *userid = [datainfo objectForKey:@"uid"];
                NSString *username = [datainfo objectForKey:@"username"];
                NSString *authkey = [datainfo objectForKey:@"authkey"];
                [GMAPI cache:userid ForKey:USER_UID];
                [GMAPI cache:username ForKey:USER_NAME];
                [GMAPI cache:authkey ForKey:USER_AUTHOD];

//                AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                [delegate showControlView:Root_home];
            
            [self CloseButtonTap:nil];

            }else{
                id obj=NSClassFromString(@"UIAlertController");
                if ( obj!=nil){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[result objectForKey:@"errinfo"] preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

                    }];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:^{

                    }];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[result objectForKey:@"errinfo"]
                                                                   delegate:self cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil,nil];
                    
                    [alert show];
                }
                
                
                
                
                
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:USER_IN];
            }
            
            [[NSUserDefaults standardUserDefaults] synchronize];
        
        
     
    } failBlock:^(NSDictionary *failDic, NSError *erro) {
        [j stopAnimating];
        
        id obj=NSClassFromString(@"UIAlertController");
        if ( obj!=nil){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[failDic objectForKey:@"ERRO_INFO"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:^{
                
            }];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[failDic objectForKey:@"ERRO_INFO"]
                                                           delegate:self cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil,nil];
            
            [alert show];
        }
        
        NSLog(@"登录失败:%@",failDic);
        
        [self loginFail];
    }];
    
    
    
    
//    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        
//        NSLog(@"error-----------%@",connectionError);
//        
//        [j stopAnimating];
//        j = nil;
//        
//        if ([data length] == 0) {
//            
//            [self loginFail];
//            
//            return;
//        }
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        
//        if ([dic isKindOfClass:[NSDictionary class]]) {
//            
//            NSLog(@"%@",dic);
//            if ([[dic objectForKey:@"errcode"] intValue] == 0) {//登录成功
//                
//                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USER_IN];
//                NSDictionary *datainfo = [dic objectForKey:@"datainfo"];
//                NSString *userid = [datainfo objectForKey:@"uid"];
//                NSString *username = [datainfo objectForKey:@"username"];
//                NSString *authkey = [datainfo objectForKey:@"authkey"];
//                [GMAPI cache:userid ForKey:USER_UID];
//                [GMAPI cache:username ForKey:USER_NAME];
//                [GMAPI cache:authkey ForKey:USER_AUTHOD];
//                
//                AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//                [delegate showControlView:Root_home];
//                
//            }else{
//                id obj=NSClassFromString(@"UIAlertController");
//                if ( obj!=nil){
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请核对用户名或密码是否正确" preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
//
//                    }];
//                    [alertController addAction:cancelAction];
//                    [self presentViewController:alertController animated:YES completion:^{
//                        
//                    }];
//                }
//                else{
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请核对用户名或密码是否正确"
//                                                                   delegate:self cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil,nil];
//                    
//                    [alert show];
//                }
//                
//                
//                
//                
//                
//                [defaults setBool:NO forKey:USER_IN];
//            }
//            
//            [defaults synchronize];
//        }
//        
//        
//    }];
    
}

#pragma mark - 跳转到注册界面
-(void)pushToZhuceVC{
    MyPhoneNumViewController *gzhuceVc = [[MyPhoneNumViewController alloc]init];
    [self.navigationController pushViewController:gzhuceVc animated:YES];
}

#pragma mark - 跳转找回密码界面
-(void)pushToFindPassWordVC{
    GfindPasswViewController *gfindwVc = [[GfindPasswViewController alloc]init];
    [self.navigationController pushViewController:gfindwVc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
}

@end
