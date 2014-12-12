//
//  AnliDetailViewController.h
//  CustomNewProject
//
//  Created by lichaowei on 14/12/2.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "MyViewController.h"

/**
 *  案例详情
 */
@interface AnliDetailViewController : MyViewController

@property (nonatomic,retain)NSString *anli_id;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property(nonatomic,retain)NSString *shareTitle;
@property(nonatomic,retain)NSString *shareDescrition;
@property(nonatomic,retain)UIImage *shareImage;


@end
