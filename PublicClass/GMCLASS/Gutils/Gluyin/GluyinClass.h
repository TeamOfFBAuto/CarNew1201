//
//  GluyinClass.h
//  CustomNewProject
//
//  Created by gaomeng on 15/3/16.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "VoiceRecorderBaseVC.h"



@protocol GluyinDelegate <NSObject>

-(void)theRecord:(NSData *)data indexPath:(NSIndexPath *)theIndexPath Time:(CGFloat)theTime;

@end

@interface GluyinClass : NSObject<AVAudioRecorderDelegate>

//录音相关
@property(nonatomic,strong)NSString * recordFileName;
@property(nonatomic,strong)NSString * recordFilePath;
@property (retain, nonatomic)AVAudioRecorder *recorder;//录音对象
@property (nonatomic,assign)id<GluyinDelegate>delegate;
@property(nonatomic,strong)NSIndexPath *theIndexPath;
@property(nonatomic,assign)int maxTime;

//播放录音相关
@property(nonatomic,strong)AVAudioPlayer *paleyer;


//开始录音
- (void)beginRecordByFileName:(NSString*)_fileName;

//停止录音
-(void)stopLuyinWithIndexPath:(NSIndexPath*)theIndexPath;


//单例
+(GluyinClass*)sharedManager;

-(void)gPlayWithData:(NSData*)data;


@end
