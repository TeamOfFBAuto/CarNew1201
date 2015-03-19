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
    _data_dic = theData[theIndexPath.row];
    UIImage *image = [_data_dic objectForKeyedSubscript:@"image"];
    NSString *text = [_data_dic objectForKeyedSubscript:@"text"];
    NSData *voice = [_data_dic objectForKeyedSubscript:@"voice"];
    
    
    
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
    
    //文字内容显示Label
    CGRect rrrr = _mainImv_backImv.frame;
    rrrr.origin.x+=15;
    rrrr.origin.y+=30;
    rrrr.size.width -=30;
    rrrr.size.height -=20;
    self.theContentLabel = [[UILabel alloc]initWithFrame:rrrr];
    self.theContentLabel.numberOfLines = 2;
    self.theContentLabel.hidden = NO;
    self.theContentLabel.textColor = [UIColor whiteColor];
    [self.imv addSubview:self.theContentLabel];
    
    
    
    //键盘/说话
    self.tubiao = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.tubiao setFrame:CGRectMake(16, self.imv.frame.size.height-14-24, 24, 24)];
    [self.tubiao setBackgroundImage:[UIImage imageNamed:@"jianpan.png"] forState:UIControlStateNormal];
    self.tubiao.layer.cornerRadius = 12;
    [self.tubiao addTarget:self action:@selector(Gnoluyin) forControlEvents:UIControlEventTouchUpInside];
    self.tubiao.layer.masksToBounds = YES;
    self.tubiao.hidden = YES;
    [self.imv addSubview:self.tubiao];
    
    
    //按住说话
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn setFrame:CGRectMake(CGRectGetMaxX(self.tubiao.frame)+10, self.tubiao.frame.origin.y, DEVICE_WIDTH-CGRectGetMaxX(self.tubiao.frame)-10-14-12-12, 25)];
    [self.btn addTarget:self action:@selector(Gspeak_TouchDown:) forControlEvents:UIControlEventTouchDown];//按下
    [self.btn addTarget:self action:@selector(Gspeak_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];//松开
    [self.btn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self.btn setImage:nil forState:UIControlStateNormal];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.btn.layer.cornerRadius = 4;
    self.btn.layer.masksToBounds = YES;
    [self.btn setTitleColor:RGBCOLOR(107, 109, 119) forState:UIControlStateNormal];
    [self.btn setBackgroundColor:RGBCOLOR(242, 245, 247)];
    self.btn.hidden = YES;
    [self.imv addSubview:self.btn];
    
    
    //文字输入
    CGRect rrr = self.btn.frame;
    rrr.size.width -=50;
    self.theContentTf = [[UITextField alloc]initWithFrame:rrr];
    self.theContentTf.layer.cornerRadius = 4;
    self.theContentTf.placeholder = @"请输入内容";
    self.theContentTf.font = [UIFont systemFontOfSize:14];
    self.theContentTf.layer.masksToBounds = YES;
    self.theContentTf.backgroundColor = [UIColor whiteColor];
    self.theContentTf.hidden = YES;
    self.theContentTf.delegate = self;
    [self.imv addSubview:self.theContentTf];
    
    //文字输入完成确认按钮
    self.theContentTf_queren = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.theContentTf_queren setFrame:CGRectMake(CGRectGetMaxX(self.theContentTf.frame)+5, self.theContentTf.frame.origin.y, 45, self.theContentTf.frame.size.height)];
    [self.theContentTf_queren setTitle:@"完成" forState:UIControlStateNormal];
    [self.theContentTf_queren addTarget:self action:@selector(finishicontentEditAndChangeTheView) forControlEvents:UIControlEventTouchUpInside];
    self.theContentTf_queren.hidden = YES;
    self.theContentTf_queren.backgroundColor = [UIColor whiteColor];
    [self.theContentTf_queren setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.theContentTf_queren.layer.cornerRadius = 4;
    self.theContentTf_queren.titleLabel.font = [UIFont systemFontOfSize:14];
    self.theContentTf_queren.layer.masksToBounds = YES;
    [self.imv addSubview:self.theContentTf_queren];
    
    //右上角的叉叉删除按钮
    self.rightDeletBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightDeletBtn setFrame:CGRectMake(CGRectGetMaxX(self.imv.frame)-40, 0, 40, 40)];
    [self.rightDeletBtn setImage:[UIImage imageNamed:@"pub_case_x.png"] forState:UIControlStateNormal];
    [self.imv addSubview:self.rightDeletBtn];
    self.rightDeletBtn.hidden = YES;
    [self.rightDeletBtn addTarget:self action:@selector(rightDeletBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
    
    if (self.isHaveRecording) {
        [self finishiLuyinAndChangeTheView];
    }
    
    if (self.isHaveText) {
        [self haveTextAndfixContentTfAndChangeTheView];
    }
    
    
    
    
    
    
    NSLog(@"---------------图片高度 单元格高度%f",self.imv.frame.size.height+24);
    
    return self.imv.frame.size.height+24;
}

//右上角删除按钮
-(void)rightDeletBtnClicked{
    [self.delegate deletCellWithIndexPath:_flagIndexPath];
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
    
    
    [self finishiLuyinAndChangeTheView];
}


//录音完成后改变视图和点击方法
-(void)finishiLuyinAndChangeTheView{
    
    CGRect r = self.btn.frame;
    r.origin.x = 15;
    self.btn.frame = r;
    
    NSString *timestr = [NSString stringWithFormat:@"%@''",[_data_dic objectForKey:@"voice_time"]];
    [self.btn setTitle:timestr forState:UIControlStateNormal];
    [self.btn setImage:[UIImage imageNamed:@"pub_case_wave.png"] forState:UIControlStateNormal];
    [self.btn setTitleEdgeInsets:UIEdgeInsetsMake(5, -500,5, 0)];
    [self.btn setImageEdgeInsets:UIEdgeInsetsMake(5, 45, 5, 5)];
    
    
    NSLog(@"%@",self.btn.titleLabel.text);
    
    [self.btn removeTarget:self action:@selector(Gspeak_TouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.btn removeTarget:self action:@selector(Gspeak_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn addTarget:self action:@selector(GspeakLuyin) forControlEvents:UIControlEventTouchUpInside];
    
    
    CGRect r1 = self.tubiao.frame;
    r1.origin.x = CGRectGetMaxX(self.btn.frame)+10;
    self.tubiao.frame = r1;
    [self.tubiao setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [self.tubiao removeTarget:self action:@selector(Gnoluyin) forControlEvents:UIControlEventTouchUpInside];
    [self.tubiao addTarget:self action:@selector(GdeleteLuyin) forControlEvents:UIControlEventTouchUpInside];
    
    [self clearTheContentLabelText];
}

-(void)clearTheContentLabelText{
    self.theContentLabel.text = @" ";
    [self.delegate clearContentTextWithIndexPath:_flagIndexPath];
    
}


//删除录音后改变视图和点击方法
-(void)deleteLuyinAndChangeTheView{
    
    //键盘/说话
    [self.tubiao setFrame:CGRectMake(16, self.imv.frame.size.height-14-24, 24, 24)];
    [self.tubiao setImage:[UIImage imageNamed:@"jianpan.png"] forState:UIControlStateNormal];
    [self.tubiao removeTarget:self action:@selector(GdeleteLuyin) forControlEvents:UIControlEventTouchUpInside];
    [self.tubiao addTarget:self action:@selector(Gnoluyin) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    //按住说话
    [self.btn setFrame:CGRectMake(CGRectGetMaxX(self.tubiao.frame)+10, self.tubiao.frame.origin.y, DEVICE_WIDTH-CGRectGetMaxX(self.tubiao.frame)-10-14-12-12, 25)];
    [self.btn removeTarget:self action:@selector(GspeakLuyin) forControlEvents:UIControlEventTouchUpInside];
    [self.btn addTarget:self action:@selector(Gspeak_TouchDown:) forControlEvents:UIControlEventTouchDown];//按下
    [self.btn addTarget:self action:@selector(Gspeak_TouchUpInside:) forControlEvents:UIControlEventTouchUpInside];//松开
    [self.btn setTitle:@"按住 说话" forState:UIControlStateNormal];
    [self.btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.btn setImage:nil forState:UIControlStateNormal];
    [self.btn setTitleColor:RGBCOLOR(107, 109, 119) forState:UIControlStateNormal];
    
}


//播放录音
-(void)GspeakLuyin{
    [self.delegate playTheRecordWithIndexPath:_flagIndexPath];
}

//删除录音
-(void)GdeleteLuyin{
    [self deleteLuyinAndChangeTheView];
    [self.delegate deletTheRecordWithIndexPath:_flagIndexPath];
}


//切换到文字描述输入
-(void)Gnoluyin{
    self.theContentTf.hidden = NO;
    self.theContentTf_queren.hidden = NO;
    self.btn.hidden = YES;
    self.tubiao.hidden = NO;
    [self.tubiao setImage:[UIImage imageNamed:@"pub_case_yy.png"] forState:UIControlStateNormal];
    [self.tubiao removeTarget:self action:@selector(Gnoluyin) forControlEvents:UIControlEventTouchUpInside];
    [self.tubiao addTarget:self action:@selector(Gluyin) forControlEvents:UIControlEventTouchUpInside];
    
}


//切换到录音界面
-(void)Gluyin{
    [self.tubiao setImage:[UIImage imageNamed:@"jianpan.png"] forState:UIControlStateNormal];
    [self.tubiao removeTarget:self action:@selector(Gluyin) forControlEvents:UIControlEventTouchUpInside];
    [self.tubiao addTarget:self action:@selector(Gnoluyin) forControlEvents:UIControlEventTouchUpInside];
    self.theContentTf.hidden = YES;
    self.theContentTf_queren.hidden = YES;
    self.btn.hidden = NO;
}






//文字录入完成之后切换图标的点击方法和图标
-(void)finishicontentEditAndChangeTheView{
    [self.theContentTf resignFirstResponder];
    self.tubiao.hidden = YES;
    self.btn.hidden = YES;
    self.theContentTf.hidden = YES;
    self.theContentTf_queren.hidden = YES;
    self.theContentLabel.hidden = NO;
    self.theContentLabel.text = self.theContentTf.text;
    [self.delegate addContentTextToDataArrayWithIndexPath:_flagIndexPath ContentString:self.theContentTf.text];
    
}

//tableVIew reloadData时候给contentTf赋值
-(void)haveTextAndfixContentTfAndChangeTheView{
    [self Gnoluyin];
    self.theContentTf.text = [_data_dic objectForKey:@"text"];
    self.theContentLabel.text = [_data_dic objectForKey:@"text"];
    BOOL hiden = [self.delegate panduanContentTfHiddenWithIndexPath:_flagIndexPath];
    self.theContentTf.hidden = hiden;
    self.tubiao.hidden = hiden;
    self.theContentTf_queren.hidden = hiden;
    self.theContentLabel.hidden = NO;
    
}





@end
