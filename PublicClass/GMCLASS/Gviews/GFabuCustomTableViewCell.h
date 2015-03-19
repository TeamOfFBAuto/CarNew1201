//
//  GFabuCustomTableViewCell.h
//  CustomNewProject
//
//  Created by gaomeng on 15/3/13.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GFabuAnliViewController;
#define kRecorderDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:@"Recorders"]

@interface GFabuCustomTableViewCell : UITableViewCell<UITextFieldDelegate>
{
    NSIndexPath *_flagIndexPath;
    NSDictionary *_data_dic;
}

@property(nonatomic,strong)UIImageView *imv;
@property(nonatomic,strong)NSData *voice;

@property(nonatomic,strong)UIButton *btn;//按住说话
@property(nonatomic,strong)UIButton *tubiao;//键盘 或 说话

@property(nonatomic,strong)UITextField *theContentTf;//点击键盘输入文字描述
@property(nonatomic,strong)UIButton *theContentTf_queren;//文字输入完成的确认按钮
@property(nonatomic,strong)UILabel *theContentLabel;//文字描述完成之后的显示lable
@property(nonatomic,strong)UIButton *rightDeletBtn;//右上角的删除按钮


@property(nonatomic,assign)BOOL isHaveRecording;//是否有录音
@property(nonatomic,assign)BOOL isHaveText;//是否有文字描述



@property(nonatomic,assign)GFabuAnliViewController *delegate;

-(CGFloat)loadCustomCellWithIndexPath:(NSIndexPath*)theIndexPath dataArray:(NSMutableArray *)theData;

//文字录入完成之后切换图标的点击方法和图标
-(void)finishicontentEditAndChangeTheView;

////切换到文字描述输入
-(void)Gnoluyin;

@end
