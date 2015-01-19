//
//  GpersonCenterCustomCell.m
//  CustomNewProject
//
//  Created by gaomeng on 14/12/4.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "GpersonCenterCustomCell.h"
#import "UILabel+GautoMatchedText.h"

@implementation GpersonCenterCustomCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)loadCustomViewWithType:(int)theType{
    if (theType == 1) {//收藏案例
        _mainImv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, 240.00/320*ALL_FRAME_WIDTH)];
        _logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 190.0*GscreenRatio_320, 34.00*GscreenRatio_320, 34.00*GscreenRatio_320)];
        _logoImageView.backgroundColor = RGBCOLOR_ONE;
        _logoImageView.layer.cornerRadius = 34.00*GscreenRatio_320/2;
        _logoImageView.layer.masksToBounds = YES;
        _logoImageView.userInteractionEnabled = YES;
        _logoImageView.layer.borderWidth = 2;
        _logoImageView.layer.borderColor = [RGBCOLOR(172, 172, 176)CGColor];
        
        
        _titleLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_logoImageView.frame)+10, _logoImageView.frame.origin.y-2, ALL_FRAME_WIDTH - 15-15-10-_logoImageView.frame.size.width, _logoImageView.frame.size.height*0.5)];
        _titleLabel1.textColor = [UIColor whiteColor];
        _titleLabel1.layer.shadowColor = [UIColor blackColor].CGColor;
        _titleLabel1.font = [UIFont systemFontOfSize:15];
        _titleLabel1.layer.shadowOffset = CGSizeMake(0,1);
        _titleLabel1.layer.shadowRadius = 0.5;
        _titleLabel1.layer.shadowOpacity = 0.8;

        
        
        _titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel1.frame.origin.x, CGRectGetMaxY(_titleLabel1.frame)+4, _titleLabel1.frame.size.width, _titleLabel1.frame.size.height)];
        _titleLabel2.textColor = RGBCOLOR(165, 163, 164);
        _titleLabel2.font = [UIFont systemFontOfSize:14];
        _titleLabel2.layer.shadowColor = [UIColor blackColor].CGColor;
        _titleLabel2.layer.shadowOffset = CGSizeMake(0,1);
        _titleLabel2.layer.shadowRadius = 0.5;
        _titleLabel2.layer.shadowOpacity = 0.8;

        
        UIImageView *_mainImv_backImv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"anli_bottom_clear.png"]];
        
        CGFloat yinyingHeight = (100.00/320*ALL_FRAME_WIDTH);
        
        CGRect r = CGRectMake(0, _mainImv.frame.size.height-yinyingHeight, ALL_FRAME_WIDTH, yinyingHeight);
        [_mainImv_backImv setFrame:r];
        
        
        [self.contentView addSubview:_mainImv];
        [self.contentView addSubview:_mainImv_backImv];
        [self.contentView addSubview:_logoImageView];
        [self.contentView addSubview:_titleLabel1];
        [self.contentView addSubview:_titleLabel2];
        
        
        
        
    }else if (theType == 2){//收藏产品
        
        _mainImv_chapin = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ALL_FRAME_WIDTH, 240.00/320*ALL_FRAME_WIDTH)];
        
        _price_chanpin = [[UILabel alloc]initWithFrame:CGRectMake(15, 200.00/320*ALL_FRAME_WIDTH-15, 130, 35)];
        _price_chanpin.font = [UIFont systemFontOfSize:35];
        _price_chanpin.textColor = RGBCOLOR(252, 160, 51);
        
        
        _title1_chanpin = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_price_chanpin.frame), _price_chanpin.frame.origin.y+2, ALL_FRAME_WIDTH - 15 -_price_chanpin.frame.size.width-15, _price_chanpin.frame.size.height*0.5)];
        _title1_chanpin.textAlignment = NSTextAlignmentLeft;
        _title1_chanpin.font = [UIFont systemFontOfSize:14];
        _title1_chanpin.textColor = RGBCOLOR(222, 222, 222);
        
        _title2_chanpin = [[UILabel alloc]initWithFrame:CGRectMake(_title1_chanpin.frame.origin.x, CGRectGetMaxY(_title1_chanpin.frame), _title1_chanpin.frame.size.width, _title1_chanpin.frame.size.height)];
        _title2_chanpin.textAlignment = NSTextAlignmentLeft;
        _title2_chanpin.font = [UIFont systemFontOfSize:14];
        _title2_chanpin.textColor = RGBCOLOR(222, 222, 222);
        
        
        UIImageView *_mainImv_backImv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"anli_bottom_clear.png"]];
        
        CGFloat yinyingHeight = (100.00/320*ALL_FRAME_WIDTH);
        
        CGRect r = CGRectMake(0, _mainImv_chapin.frame.size.height-yinyingHeight, ALL_FRAME_WIDTH, yinyingHeight);
        [_mainImv_backImv setFrame:r];
        
        [self.contentView addSubview:_mainImv_chapin];
        [self.contentView addSubview:_mainImv_backImv];
        [self.contentView addSubview:_price_chanpin];
        [self.contentView addSubview:_title1_chanpin];
        [self.contentView addSubview:_title2_chanpin];
        
        
    }else if (theType == 3){//收藏店铺
        //图片
        self.header_imageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 12, 60.00, 60.00)];
        self.header_imageView.image = [UIImage imageNamed:BUSINESS_DEFAULT_IMAGE];
        //名字
        _business_name_label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.header_imageView.frame)+12, self.header_imageView.frame.origin.y, ALL_FRAME_WIDTH-self.header_imageView.frame.size.width-12-12-12, 17.0/320*ALL_FRAME_WIDTH)];
        _business_name_label.font = [UIFont systemFontOfSize:16];
        
        //星星
        _stars_back_view = [[GstartView alloc]initWithStartNum:0 Frame:CGRectMake(_business_name_label.frame.origin.x, CGRectGetMaxY(_business_name_label.frame)+6, 60, 12)];
        
        //评论
        _comment_num_label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_stars_back_view.frame)+5, _stars_back_view.frame.origin.y, ALL_FRAME_WIDTH-12-self.header_imageView.frame.size.width-12-_stars_back_view.frame.size.width-5-5, _stars_back_view.frame.size.height)];
        _comment_num_label.font = [UIFont systemFontOfSize:_comment_num_label.frame.size.height-1];
        _comment_num_label.textColor = RGBCOLOR(253, 163, 72);
        
        //标签
        _labels_back_view = [[UIView alloc]initWithFrame:CGRectMake(_stars_back_view.frame.origin.x, CGRectGetMaxY(_stars_back_view.frame)+9, DEVICE_WIDTH - 12-12-12 - self.header_imageView.frame.size.width, 16.0)];
//        _labels_back_view.backgroundColor = RGBCOLOR(244, 244, 244);
    
        
        NSLog(@"%@",NSStringFromCGRect(_labels_back_view.frame));
        
        
        //视图添加
        [self.contentView addSubview:self.header_imageView];
        [self.contentView addSubview:_business_name_label];
        [self.contentView addSubview:_stars_back_view];
        [self.contentView addSubview:_comment_num_label];
        [self.contentView addSubview:_labels_back_view];
        
        
    }
}


//填充数据 店铺
-(void)setdataWithData:(BusinessListModel *)theModel{
    
    
//    NSArray *biaoqianArray = @[@"改装1",@"改装2",@"改装3",@"改装4",@"改装5"];
//    
//    NSMutableArray *biaoqianContentArray = [NSMutableArray arrayWithCapacity:1];
//    
//    int num = biaoqianArray.count;
//    CGFloat totalWidth = 0.0f;
//    for (int i = 0; i<num; i++) {
//        UILabel *biaoqianLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
//        biaoqianLabel.font = [UIFont systemFontOfSize:16];
//        biaoqianLabel.text = biaoqianArray[i];
//        [biaoqianLabel setMatchedFrame4LabelWithOrigin:CGPointMake(0, 0) height:16 limitMaxWidth:224];
//        
//        NSLog(@"%@",NSStringFromCGRect(biaoqianLabel.frame));
//        totalWidth+=biaoqianLabel.frame.size.width;
//        
//        if (totalWidth<_labels_back_view.frame.size.width) {
//            [biaoqianContentArray addObject:biaoqianLabel];
//        }else{
//            return;
//        }
//    }
//    
//    int num1 = biaoqianContentArray.count;
//    for (int i = 0; i<num1; i++) {
//        UILabel *ll = biaoqianContentArray[i];
//        
//    }
    
    
    
    
    
    
    _business_name_label.text = theModel.storename;
    [self.header_imageView sd_setImageWithURL:[NSURL URLWithString:theModel.pichead] placeholderImage:[UIImage imageNamed:BUSINESS_DEFAULT_IMAGE]];
    _comment_num_label.text = [NSString stringWithFormat:@"%@人评论",theModel.com_num];
    
    _stars_back_view.startNum = [theModel.score floatValue];
    _stars_back_view.maxStartNum = 5;
    _stars_back_view.startNum = [theModel.score floatValue];
    [_stars_back_view updateStartNum];
    
    
    _biaoqianLabel.text = theModel.business;
    
    
}




//填充数据 ： 案例
-(void)setAnliDataWithData:(GCaseModel *)theModel{

    
    
    if ([theModel isKindOfClass:[GCaseModel class]]) {
        [_logoImageView sd_setImageWithURL:[NSURL URLWithString:theModel.spichead] placeholderImage:nil];
        [_mainImv sd_setImageWithURL:[NSURL URLWithString:theModel.pichead] placeholderImage:nil];
        
        _titleLabel1.text = theModel.title;
        _titleLabel2.text = theModel.sname;
    }
    
    
    
    
    
}

//填充数据 ： 产品
-(void)setChanpinWithData:(GGoodsModel *)theModel{
    
    
    if ([theModel isKindOfClass:[GGoodsModel class]]) {
        [_mainImv_chapin sd_setImageWithURL:[NSURL URLWithString:theModel.pichead] placeholderImage:nil];
        
        
        NSString *sss = [NSString stringWithFormat:@"￥%@",theModel.price];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:sss];
        
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 1)];
        [str addAttribute:NSForegroundColorAttributeName value:RGBCOLOR(253, 180, 44) range:NSMakeRange(0,1)];
        
        _price_chanpin.attributedText = str;
        _price_chanpin.font = [UIFont systemFontOfSize:35];
        [_price_chanpin setMatchedFrame4LabelWithOrigin:CGPointMake(15, 200.00/320*ALL_FRAME_WIDTH-15) height:35 limitMaxWidth:130];
        _price_chanpin.attributedText = str;
        
        
        [_title1_chanpin setFrame:CGRectMake(CGRectGetMaxX(_price_chanpin.frame), _price_chanpin.frame.origin.y+2, ALL_FRAME_WIDTH - 15 -_price_chanpin.frame.size.width-15, _price_chanpin.frame.size.height*0.5)];
        [_title2_chanpin setFrame:CGRectMake(_title1_chanpin.frame.origin.x, CGRectGetMaxY(_title1_chanpin.frame), _title1_chanpin.frame.size.width, _title1_chanpin.frame.size.height)];
        
        _title1_chanpin.text = theModel.title;
        _title2_chanpin.text = theModel.gtype;
    }
    
    
    
    
    
    //调试颜色
//    _price_chanpin.backgroundColor = [UIColor redColor];
//    _title1_chanpin.backgroundColor = [UIColor orangeColor];
//    _title2_chanpin.backgroundColor = [UIColor blackColor];
    
    
}


@end
