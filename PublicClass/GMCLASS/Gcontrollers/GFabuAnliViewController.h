//
//  GFabuAnliViewController.h
//  CustomNewProject
//
//  Created by gaomeng on 15/3/11.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GFabuCustomTableViewCell;
/*
 
 发布案例界面
 
 */

@interface GFabuAnliViewController : MyViewController


@property(nonatomic,assign)BOOL isPush;//是否是push过来的

//多图选择相关
@property(nonatomic,strong)NSMutableArray * allImageArray;
@property(nonatomic,strong)NSMutableArray * allAssesters;
@property(nonatomic,strong)NSMutableArray * TempAllImageArray;
@property(nonatomic,strong)NSMutableArray * TempAllAssesters;


//编辑状态相关
@property(nonatomic,assign)BOOL editKuang;//进入编辑拖动排序之后 出现的绿框



@property(nonatomic,strong)NSMutableArray *haveLuyinArray;//有录音的数组 里面装NSIndexPath


-(void)changeTheTableViewContentOffset;
-(void)changeTheTableViewContentOffset1;


//开始录音
- (void)beginRecordByFileName:(NSString*)_fileName;

//停止录音
-(void)stopLuyinWithIndexPath:(NSIndexPath*)theIndexPath;

//播放录音
-(void)playTheRecordWithIndexPath:(NSIndexPath*)theIndexPath;

//删除录音
-(void)deletTheRecordWithIndexPath:(NSIndexPath*)theIndexPath;

//完成文字描述输入
-(void)addContentTextToDataArrayWithIndexPath:(NSIndexPath*)theIndexPath ContentString:(NSString *)theString;

//判断文字录入框是否出现
-(BOOL)panduanContentTfHiddenWithIndexPath:(NSIndexPath*)theIndexPath;

//有文字 然后又录音会调用这个方法
-(void)clearContentTextWithIndexPath:(NSIndexPath*)theIndexPath;

//删除cell
-(void)deletCellWithIndexPath:(NSIndexPath *)theIndexPath;



@end
