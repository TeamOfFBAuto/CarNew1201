//
//  GscoreStarViewController.h
//  CustomNewProject
//
//  Created by gaomeng on 14/12/15.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

//星星评分
#import <UIKit/UIKit.h>

typedef enum {
    Comment_Anli = 0,//案例
    Comment_DianPu,//店铺
    Comment_PeiJian //配件
    
}Comment_Type;

@interface GscoreStarViewController : UIViewController

@property(nonatomic,assign)Comment_Type commentType;
@property(nonatomic,retain)NSString *commentId;//对应 案例、店铺、配件id

@property(nonatomic,assign)float theScore;//评分  1.0~5.0

@property(nonatomic,strong)NSString *cc_content;//评论内容



@end
