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
#import "GAPIHeader.h"

#define LOGIN_PHONE @"LOGIN_PHONE"//登录手机号
#define LOGIN_PASS @"LOGIN_PASS"//登录密码


@interface LogInViewController ()
{
    UIActivityIndicatorView *j;
    UIAlertView *al;
}

@end

@implementation LogInViewController

- (void)CloseButtonTap:(id)sender
{
    AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate showControlView:Root_home];
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
    
    
    NSLog(@"%s",__FUNCTION__);
    
    GloginView *gloginView = [[GloginView alloc]initWithFrame:CGRectMake(0, 0, 320, iPhone5?568:480)];
    [self.view addSubview:gloginView];
    
    
    __weak typeof (self)bself = self;
    __weak typeof (gloginView)bgloginView = gloginView;
    
    //设置跳转注册block
    [gloginView setZhuceBlock:^{
        [bgloginView Gshou];
        [bself pushToZhuceVC];
    }];
    
    //设置找回密码block
    [gloginView setFindPassBlock:^{
        [bgloginView Gshou];
        [bself pushToFindPassWordVC];
    }];
    
    //登录
    [gloginView setDengluBlock:^(NSString *usern, NSString *passw) {
        
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
            j.center = CGPointMake(160, 170);
        }
        
        [self.view addSubview:j];
        [j startAnimating];
    }
    
    
    
    //登录接口
    //http://gztest.fblife.com/index.php?c=interface&a=dologin&username=ivyandrich&password=yangjinli&token=12sadddsa&fbtype=xml
    
    
    NSString *deviceToken = [GMAPI getDeviceToken] ? [GMAPI getDeviceToken] : @"testToken";
    
    NSString *str = [NSString stringWithFormat:G_LOGIN,name,passw,deviceToken];
    
    
    
    NSLog(@"登录请求接口======%@",str);
    
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSLog(@"error-----------%@",connectionError);
        
        [j stopAnimating];
        j = nil;
        
        if ([data length] == 0) {
            return;
        }
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if ([dic isKindOfClass:[NSDictionary class]]) {
            
            NSLog(@"%@",dic);
            if ([[dic objectForKey:@"errcode"] intValue] == 0) {//登录成功
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:USER_IN];
                NSDictionary *datainfo = [dic objectForKey:@"datainfo"];
                NSString *userid = [datainfo objectForKey:@"uid"];
                NSString *username = [datainfo objectForKey:@"name"];
                NSString *authkey = [datainfo objectForKey:@"authkey"];
                [GMAPI cache:userid ForKey:USER_UID];
                [GMAPI cache:username ForKey:USER_NAME];
                [GMAPI cache:authkey ForKey:USER_AUTHOD];
                
                AppDelegate * delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate showControlView:Root_home];
                
            }else{
                id obj=NSClassFromString(@"UIAlertController");
                if ( obj!=nil){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请核对用户名或密码是否正确" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

                    }];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:^{
                        
                    }];
                }
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请核对用户名或密码是否正确"
                                                                   delegate:self cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil,nil];
                    
                    [alert show];
                }
                
                
                
                
                
                [defaults setBool:NO forKey:USER_IN];
            }
            
            [defaults synchronize];
        }
        
        
    }];
    
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
