//
//  GluyinClass.m
//  CustomNewProject
//
//  Created by gaomeng on 15/3/16.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "GluyinClass.h"
#import "VoiceRecorderBaseVC.h"



@implementation GluyinClass
{
    CGFloat                 _curCount;           //当前计数,初始为0
    BOOL                    canNotSend;         //不能发送
    NSTimer                 *timer;
}


//播放相关==================
+ (GluyinClass *)sharedManager
{
    static GluyinClass *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

-(void)gPlayWithData:(NSData*)data{
    if (!self.paleyer) {
        [self.paleyer stop];
        self.paleyer = nil;
    }
    self.paleyer = [[AVAudioPlayer alloc]initWithData:data error:nil];
    [self.paleyer play];
}




//录音相关==================
#pragma mark - 开始录音
- (void)beginRecordByFileName:(NSString*)_fileName{
    
    //设置文件名和录音路径
    self.recordFileName = _fileName;
    self.recordFilePath = [VoiceRecorderBaseVC getPathByFileName:_fileName ofType:@"wav"];
    
    NSURL *url = [[NSURL alloc] initFileURLWithPath:self.recordFilePath];
    self.recorder = [[AVAudioRecorder alloc]initWithURL:url settings:[VoiceRecorderBaseVC getAudioRecorderSettingDict]
                                                                  error:nil];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
    
    
    //还原计数
    _curCount = 0;
    //还原发送
    canNotSend = NO;
    
    //开始录音 进行录音
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
    /***新添加的两行代码**/
    UInt32 audioRouteOverride = kAudioSessionProperty_OverrideCategoryDefaultToSpeaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(audioRouteOverride), &audioRouteOverride);
    
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [self.recorder record];
    
    //启动计时器
    [self startTimer];
    
}

#pragma mark - 停止录音
-(void)stopLuyinWithIndexPath:(NSIndexPath*)theIndexPath{
    self.theIndexPath = theIndexPath;
    [self.recorder stop];
    [self stopTimer];
}







#pragma mark - 启动定时器
- (void)startTimer{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
}

#pragma mark - 停止定时器
- (void)stopTimer{
    if (timer && timer.isValid){
        [timer invalidate];
        timer = nil;
    }
}

#pragma mark - 更新音频峰值
- (void)updateMeters{
    if (self.recorder.isRecording){
        //更新峰值
        [self.recorder updateMeters];
        
        _curCount += 0.1f;
        
        if (_curCount>=self.maxTime) {
            [self.recorder stop];
        }
    }
}


#pragma mark - AVAudioRecorder Delegate Methods
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    NSLog(@"录音停止");
    NSLog(@"录音保存路径:%@",self.recordFilePath);
    [self stopTimer];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(theRecord:indexPath:Time:)]) {
        NSData *data = [NSData dataWithContentsOfFile:self.recordFilePath];
        [self.delegate theRecord:data indexPath:self.theIndexPath Time:_curCount];
    }
    
    _curCount = 0;
    
    
}
- (void)audioRecorderBeginInterruption:(AVAudioRecorder *)recorder{
    NSLog(@"录音开始");
    [self stopTimer];
    _curCount = 0;
}
- (void)audioRecorderEndInterruption:(AVAudioRecorder *)recorder withOptions:(NSUInteger)flags{
    NSLog(@"录音中断");
    [self stopTimer];
    _curCount = 0;
}


@end
