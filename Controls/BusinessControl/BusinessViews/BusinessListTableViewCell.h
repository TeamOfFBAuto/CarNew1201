//
//  BusinessListTableViewCell.h
//  CustomNewProject
//
//  Created by soulnear on 14-12-2.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BusinessListModel.h"

@interface BusinessListTableViewCell : UITableViewCell




@property (strong, nonatomic) IBOutlet UIImageView *header_imageView;
@property (strong, nonatomic) IBOutlet UILabel *business_name_label;
@property (strong, nonatomic) IBOutlet UILabel *comment_num_label;
@property (strong, nonatomic) IBOutlet UIView *stars_back_view;
@property (strong, nonatomic) IBOutlet UIView *labels_back_view;

-(void)setInfoWithModel:(BusinessListModel *)info;
@end
