//
//  AboutViewController.m
//  CustomNewProject
//
//  Created by soulnear on 15-1-21.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myTitle = @"关于";
    [self setMyViewControllerLeftButtonType:MyViewControllerLeftbuttonTypeBack WithRightButtonType:MyViewControllerRightbuttonTypeNull];
    self.view.backgroundColor = RGBCOLOR(245,245,245);
    
    _logo_imageView.top = 85;
    _bottom_imageView.bottom = DEVICE_HEIGHT-64;
    _bottom_imageView.width = DEVICE_WIDTH;
    
    _description_label.bottom = _bottom_imageView.top - 10;
    _version_label.bottom = _description_label.top - 20;
    
    _logo_imageView.center = CGPointMake(DEVICE_WIDTH/2.0,_logo_imageView.center.y);
    _description_label.center = CGPointMake(DEVICE_WIDTH/2.0,_description_label.center.y);
    _version_label.center = CGPointMake(DEVICE_WIDTH/2.0,_version_label.center.y);

    
    NSString * string = [_description_label.text stringByReplacingOccurrencesOfString:@"2012" withString:[self returnCurrentYear]];
    _description_label.text = string;
    
    _version_label.text = [NSString stringWithFormat:@"版本:%@",NOW_VERSION];
}

#pragma mark - 获取当前是哪一年
-(NSString *)returnCurrentYear
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY"];
    NSString *confromTimespStr = [formatter stringFromDate:[NSDate date]];
    
    return confromTimespStr;
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
