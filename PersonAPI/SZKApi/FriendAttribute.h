//
//  FriendAttribute.h
//  FBCircle
//
//  Created by 史忠坤 on 14-5-12.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendAttribute : NSObject{

    /**
     uid: "362465",
     username: "love0819",
     telphone: "15552499996",
     usertype: "1",
     rname: "sdfafa",
     optype: 2
     
     uid:用户uid   username:用户名   telphone:手机号    usertype:用户类型（1：圈子用户，2：论坛用户，3：不是用户）  rname：通讯录名字 opttype:1.接受，2添加，3，邀请4，验证中，5，已添加


     */
    

}

@property(nonatomic,strong)NSString *fbuname;//fb圈的name

@property(nonatomic,strong)NSString *fbuid;//user的uid

@property(nonatomic,strong)NSString *headimg;//头像

@property(nonatomic,strong)NSString *telePhoneNumber;//电话号码

@property(nonatomic,assign)int sectionNum;

@property(nonatomic,strong)NSString *usertype;//

@property(nonatomic,strong)NSString *rname;

@property(nonatomic,strong)NSString *username;

@property(nonatomic,strong)NSString *telphone;

@property(nonatomic,strong)NSString *uid;

@property(nonatomic,strong)NSString *optype;
/**
我的好友列表
 face = "http://bbs.fblife.com/ucenter/avatar.php?uid=355696&type=virtual&size=small";
 status = 1;
 uid = 355696;
 uname = ivyandrich;
 */
@property(nonatomic,strong)NSString *face;
@property(nonatomic,strong)NSString *uname;


-(void)setFriendAttributeDic:(NSDictionary *)dicinfo;
- (NSString *) getFirstName;

- (NSString *)zkingPaixufirstname;

@end
