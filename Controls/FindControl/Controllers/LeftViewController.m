//
//  LeftViewController.m
//  CustomNewProject
//
//  Created by szk on 14/11/25.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "LeftViewController.h"


#import "PicViewController.h"

#import "StoreViewController.h"

#import "BusinessViewController.h"

#import "PersonalViewController.h"

#import "UIViewController+MMDrawerController.h"


#import "AppDelegate.h"


#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)


@interface LeftViewController (){
    
//    UINavigationController *_rootNav;
    
    UINavigationController *_picNav;
    
    UINavigationController *_storeNav;
    
    UINavigationController *_businessNav;
    
    UINavigationController *_personalNav;


}

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor blueColor];
    
    _picNav=[[UINavigationController alloc]initWithRootViewController:[[PicViewController alloc]init]];
    
    _storeNav=[[UINavigationController alloc]initWithRootViewController:[[StoreViewController alloc]init]];

    _businessNav=[[UINavigationController alloc]initWithRootViewController:[[BusinessViewController alloc]init]];

    _personalNav=[[UINavigationController alloc]initWithRootViewController:[[PersonalViewController alloc]init]];

    currentSelectButtonIndex=0;

    titles = @[@"精选推荐",@"案例图库",@"配件商城", @"服务商家", @"个人中心"];
    
    
    
    for (int i=0; i<5; i++) {
        
        
        UIButton *tabbutton=[[UIButton alloc] initWithFrame:CGRectMake(0,iPhone5? 64+i*70:64+i*60, 300, 50)];
        // [tabbutton setSelected:YES];
        tabbutton.tag=i+100;
        if (i==0) {
            [tabbutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            
        }else{
            [tabbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            
        }
        
        [tabbutton setTitle:titles[i] forState:UIControlStateNormal];
        
        [tabbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        
        
        
        [tabbutton addTarget:self action:@selector(dobutton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:tabbutton];
        
    }
    
    self.view.backgroundColor=[UIColor colorWithRed:24/255.f green:25/255.f blue:26/255.f alpha:1];
    

    // Do any additional setup after loading the view.
}

-(void)dobutton:(UIButton *)sender{
    UIButton *preButton=(UIButton *)[self.view viewWithTag:currentSelectButtonIndex+100];
    
    [preButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    currentSelectButtonIndex=sender.tag-100;
    
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    
    
    switch (sender.tag) {
        case 100:
        {
            NSLog(@"选择的第%d个button",sender.tag-100);
            
            
            
            [self.mm_drawerController
             setCenterViewController:[self appDelegate].navigationController
             withCloseAnimation:YES
             completion:nil];
            
        }
            break;
        case 101:
        {
            NSLog(@"选择的第%d个button",sender.tag-100);
            
            
            [self.mm_drawerController
             setCenterViewController:_picNav    withCloseAnimation:YES
             completion:nil];
        }
            break;
            
        case 102:
        {
            NSLog(@"选择的第%d个button",sender.tag-100);
            
            
            [self.mm_drawerController
             setCenterViewController:_storeNav    withCloseAnimation:YES
             completion:nil];
        }
            break;
            
            
        case 103:
        {
            [self.mm_drawerController
             setCenterViewController:_businessNav    withCloseAnimation:YES
             completion:nil];
            
            
        }
            break;
        case 104:
        {
            NSLog(@"选择的第%d个button",sender.tag-100);
            
            [self.mm_drawerController
             setCenterViewController:_personalNav    withCloseAnimation:YES
             completion:nil];
            
            
            
            
        }
            break;
            
            
        default:
            break;
    }
    
    
}

-(AppDelegate *)appDelegate{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
