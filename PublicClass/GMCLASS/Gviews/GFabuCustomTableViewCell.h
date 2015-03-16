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

@interface GFabuCustomTableViewCell : UITableViewCell
{
    NSIndexPath *_flagIndexPath;
}

@property(nonatomic,strong)UIImageView *imv;
@property(nonatomic,strong)NSData *voice;

@property(nonatomic,strong)UIButton *btn;//按住说话
@property(nonatomic,strong)UIButton *tubiao;//键盘 或 说话

@property(nonatomic,assign)BOOL isHaveRecording;



@property(nonatomic,assign)GFabuAnliViewController *delegate;

-(CGFloat)loadCustomCellWithIndexPath:(NSIndexPath*)theIndexPath dataArray:(NSMutableArray *)theData;

@end
