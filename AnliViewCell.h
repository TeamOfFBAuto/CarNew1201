//
//  AnliViewCell.h
//  CustomNewProject
//
//  Created by lichaowei on 14/12/1.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnliViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *bigImageView;
@property (strong, nonatomic) IBOutlet UILabel *aTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *smallImageView;

- (void)setCellWithModel:(id)aModel;
@property (strong, nonatomic) IBOutlet UIImageView *quanImageView;

@end
