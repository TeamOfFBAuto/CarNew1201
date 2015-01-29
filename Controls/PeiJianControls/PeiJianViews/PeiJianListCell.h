//
//  PeiJianListCell.h
//  CustomNewProject
//
//  Created by soulnear on 15-1-29.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PeiJianListModel.h"

@interface PeiJianListCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *header_imageView;

@property (strong, nonatomic) IBOutlet UILabel *title_label;


@property (strong, nonatomic) IBOutlet UILabel *price_label;

@property (strong, nonatomic) IBOutlet UIView *line_view;

-(void)setInfoWithModel:(PeiJianListModel *)model;

@end
