//
//  AnliDetailViewController.h
//  CustomNewProject
//
//  Created by lichaowei on 14/12/2.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "MyViewController.h"

typedef enum {
    
    Detail_Anli = 0, //案例
    Detail_Peijian //配件
    
}Detail_Type;

/**
 *  案例详情 配件详情
 */
@interface AnliDetailViewController : UIViewController

@property(nonatomic,assign)Detail_Type detailType;

@property (nonatomic,retain)NSString *anli_id;
@property (strong, nonatomic) IBOutlet UIWebView *webView;

@property(nonatomic,retain)NSString *shareTitle;
@property(nonatomic,retain)NSString *shareDescrition;
@property(nonatomic,retain)UIImage *shareImage;

@property(nonatomic,retain)NSString *storeName;//店铺名称
@property(nonatomic,retain)UIImage *storeImage;//店铺图标
@property(nonatomic,retain)NSString *storeId;//商家id

@property(nonatomic,assign)BOOL isFromAnli;//是否是来自案例详情页

@end
