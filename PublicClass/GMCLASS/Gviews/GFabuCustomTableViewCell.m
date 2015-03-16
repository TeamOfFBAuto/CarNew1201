//
//  GFabuCustomTableViewCell.m
//  CustomNewProject
//
//  Created by gaomeng on 15/3/13.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "GFabuCustomTableViewCell.h"
#import "GFabuAnliViewController.h"


@implementation GFabuCustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(CGFloat)loadCustomCellWithIndexPath:(NSIndexPath*)theIndexPath dataArray:(NSMutableArray *)theData{
    
    
    _flagIndexPath = theIndexPath;
    
    //数据源
    NSDictionary *data_dic = theData[theIndexPath.row];
    UIImage *image = [data_dic objectForKeyedSubscript:@"image"];
    NSString *text = [data_dic objectForKeyedSubscript:@"text"];
    NSData *voice = [data_dic objectForKeyedSubscript:@"voice"];
    
    
    
    //图片
    self.imv = [[UIImageView alloc]init];
    self.imv.userInteractionEnabled = YES;
    //给图片赋值
    [self.imv setImage:image];
    CGFloat im_height = self.imv.image.size.height*(DEVICE_WIDTH-24)/self.imv.image.size.width;
    [self.imv setFrame:CGRectMake(12, 12, DEVICE_WIDTH-24, im_height)];
    [self.contentView addSubview:self.imv];
    
    if (self.delegate.editKuang) {
        self.imv.layer.borderWidth = 2;
        self.imv.layer.borderColor = [[UIColor greenColor]CGColor];
        self.imv.layer.masksToBounds = YES;
    }
    
    
    
    //阴影
    UIImageView *_mainImv_backImv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"anli_bottom_clear.png"]];
    
    CGFloat yinyingHeight = (100.00/320*ALL_FRAME_WIDTH);
    
    CGRect r = CGRectMake(0, self.imv.frame.size.height-yinyingHeight, self.imv.frame.size.width, yinyingHeight);
    [_mainImv_backImv setFrame:r];
    _mainImv_backImv.userInteractionEnabled = YES;
    [self.imv addSubview:_mainImv_backImv];

    
    
    
    //键盘/说话
    self.tubiao = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tubiao setFrame:CGRectMake(16, self.imv.frame.size.height-14-24, 24, 24)];
    [self.tubiao setBackgroundImage:[UIImage imageNamed:@"jianpan.png"] forState:UIControlStateNormal];
    self.tubiao.layer.cornerRadius = 12;
    self.tubiao.layer.masksToBounds = YES;
    self.tubiao.hidden = YES;
    [self.imv addSubview:self.tubiao];
    
    
    //按住说话
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setFrame:CGRectMake(CGRectGetMaxX(self.tubiao.frame)+10, self.tubiao.frame.origin.y, DEVICE_WIDTH-CGRectGetMaxX(self.tubiao.frame)-10-14-12-12, 25)];
    [self.btn addTarget:self action:@selector(Gspeak_TouchDown:) forControlEvents:UIControlEventTouchDown];//按下
    [self.btn addTarget:self action:@selector(Gspeak_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];//松开
    [self.btn setTitle:@"按住 说话" forState:UIControlStateNormal];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.btn.layer.cornerRadius = 4;
    self.btn.layer.masksToBounds = YES;
    [self.btn setTitleColor:RGBCOLOR(107, 109, 119) forState:UIControlStateNormal];
    [self.btn setBackgroundColor:RGBCOLOR(242, 245, 247)];
    self.btn.hidden = YES;
    [self.imv addSubview:self.btn];
    
    if (self.isHaveRecording) {
        [self finishiLuyinAndChangeTheView];
    }
    
    
    
    
    NSLog(@"---------------图片高度 单元格高度%f",self.imv.frame.size.height+24);
    
    return self.imv.frame.size.height+24;
}



//录音开始
-(void)Gspeak_TouchDown:(UIButton *)sender{
    NSLog(@"%s",__FUNCTION__);
    
    NSDate *date = [NSDate date];
    [self.delegate beginRecordByFileName:[NSString stringWithFormat:@"%@",date]];
    
    [sender setTitle:@"松开完成说话" forState:UIControlStateNormal];

}


//录音完成
-(void)Gspeak_TouchUpInside:(UIButton *)sender{
    NSLog(@"%s",__FUNCTION__);
    
    [self.delegate stopLuyinWithIndexPath:_flagIndexPath];
    [self.delegate.haveLuyinArray addObject:_flagIndexPath];
    
    [sender setTitle:@"播放" forState:UIControlStateNormal];
    
    
    [self finishiLuyinAndChangeTheView];
}


//录音完成后改变视图和点击方法
-(void)finishiLuyinAndChangeTheView{
    
    CGRect r = self.btn.frame;
    r.origin.x = 15;
    self.btn.frame = r;
    [self.btn setTitle:@"播放" forState:UIControlStateNormal];
    [self.btn removeTarget:self action:@selector(Gspeak_TouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.btn removeTarget:self action:@selector(Gspeak_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn addTarget:self action:@selector(GspeakLuyin) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGRect r1 = self.tubiao.frame;
    r1.origin.x = CGRectGetMaxX(self.btn.frame)+10;
    self.tubiao.frame = r1;
    [self.tubiao setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [self.tubiao removeTarget:self action:@selector(Gnoluyin) forControlEvents:UIControlEventTouchUpInside];
    [self.tubiao addTarget:self action:@selector(GdeleteLuyin) forControlEvents:UIControlEventTouchUpInside];
    
}

//删除录音后改变视图和点击方法
-(void)deleteLuyinAndChangeTheView{
    
    //键盘/说话
    [self.tubiao setFrame:CGRectMake(16, self.imv.frame.size.height-14-24, 24, 24)];
    [self.tubiao setBackgroundImage:[UIImage imageNamed:@"jianpan.png"] forState:UIControlStateNormal];
    [self.tubiao removeTarget:self action:@selector(GdeleteLuyin) forControlEvents:UIControlEventTouchUpInside];
    [self.tubiao addTarget:self action:@selector(Gnoluyin) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    //按住说话
    [self.btn setFrame:CGRectMake(CGRectGetMaxX(self.tubiao.frame)+10, self.tubiao.frame.origin.y, DEVICE_WIDTH-CGRectGetMaxX(self.tubiao.frame)-10-14-12-12, 25)];
    [self.btn removeTarget:self action:@selector(GspeakLuyin) forControlEvents:UIControlEventTouchUpInside];
    [self.btn addTarget:self action:@selector(Gspeak_TouchDown:) forControlEvents:UIControlEventTouchDown];//按下
    [self.btn addTarget:self action:@selector(Gspeak_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];//松开
    [self.btn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self.btn setTitleColor:RGBCOLOR(107, 109, 119) forState:UIControlStateNormal];
    
}


//播放录音
-(void)GspeakLuyin{
    [self.delegate playTheRecordWithIndexPath:_flagIndexPath];
}

//删除录音
-(void)GdeleteLuyin{
    [self deleteLuyinAndChangeTheView];
    [self.delegate.haveLuyinArray removeObject:_flagIndexPath];
    [self.delegate deletTheRecordWithIndexPath:_flagIndexPath];
}


//切换到文字描述输入
-(void)Gnoluyin{
    
}

@end
