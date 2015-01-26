//
//  ZhuCeViewController.h
//  越野e族
//
//  Created by soulnear on 13-12-23.
//  Copyright (c) 2013年 soulnear. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhuCeViewController : MyViewController<ASIHTTPRequestDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    UITextField * userName_tf;
    
    UITextField * mima_tf;
    
    UITextField * youxiang_tf;
    
    ASIFormDataRequest * request_;
}

@property(nonatomic,strong)NSString * PhoneNumber;
@property(nonatomic,strong)NSString * verification;



@end
