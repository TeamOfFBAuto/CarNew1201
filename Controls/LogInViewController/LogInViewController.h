//
//  LogInViewController.h
//  CustomNewProject
//
//  Created by soulnear on 14-11-27.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogInViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *logIn_close_button;

- (IBAction)CloseButtonTap:(id)sender;
+ (LogInViewController *)sharedManager;

@end
