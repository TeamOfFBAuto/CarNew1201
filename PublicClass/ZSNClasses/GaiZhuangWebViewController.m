//
//  GaiZhuangWebViewController.m
//  CustomNewProject
//
//  Created by soulnear on 15-1-29.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "GaiZhuangWebViewController.h"

@interface GaiZhuangWebViewController ()<UIWebViewDelegate>

@end

@implementation GaiZhuangWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    
    UIWebView * myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,DEVICE_WIDTH,DEVICE_HEIGHT-64)];
    myWebView.delegate = self;
    [self.view addSubview:myWebView];
    
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_web_url]]];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.myTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
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
