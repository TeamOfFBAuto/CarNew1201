//
//  AnliViewCell.m
//  CustomNewProject
//
//  Created by lichaowei on 14/12/1.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "AnliViewCell.h"
#import "AnliModel.h"

@implementation AnliViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
    }
    return self;
}

//根据实际宽度等比例调整高度
- (CGFloat)height:(CGFloat)oldHeight
{
    return 0;
}

- (void)awakeFromNib {
    // Initialization code
    
    self.smallImageView.layer.cornerRadius = _smallImageView.width / 2.f;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setCellWithModel:(AnliModel *)aModel
{
    [self.bigImageView sd_setImageWithURL:[NSURL URLWithString:aModel.pichead] placeholderImage:[UIImage imageNamed:ANLI_LIST_DEFAULT] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        NSLog(@"----> %@",error);
        
        if (error) {
            
            self.bigImageView.contentMode = UIViewContentModeCenter;
        }else
        {
            self.bigImageView.contentMode = UIViewContentModeScaleToFill;
        }
        
    }];
    
    
    self.aTitleLabel.text = aModel.title;
    self.nameLabel.text = aModel.sname;
    [self.smallImageView sd_setImageWithURL:[NSURL URLWithString:aModel.spichead] placeholderImage:PERSONAL_DEFAULTS_IMAGE];

    
    self.smallImageView.layer.masksToBounds = YES;
    self.smallImageView.layer.cornerRadius = 32 / 2.f;
    
    self.nameLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.nameLabel.layer.shadowOffset = CGSizeMake(0,1);
    self.nameLabel.layer.shadowRadius = 0.5;
    self.nameLabel.layer.shadowOpacity = 0.8;
    
    self.aTitleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    self.aTitleLabel.layer.shadowOffset = CGSizeMake(0,1);
    self.aTitleLabel.layer.shadowRadius = 0.5;
    self.aTitleLabel.layer.shadowOpacity = 0.8;
    
    //layer.cornerRadius
    
    
}

@end
