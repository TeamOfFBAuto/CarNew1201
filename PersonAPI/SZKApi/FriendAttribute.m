//
//  FriendAttribute.m
//  FBCircle
//  Created by 史忠坤 on 14-5-12.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "FriendAttribute.h"

#import "pinyin.h"

@implementation FriendAttribute
@synthesize sectionNum = _sectionNum;

-(void)setFriendAttributeDic:(NSDictionary *)dicinfo{
    
    
    _fbuname=[dicinfo objectForKey:@"tmpLastName"];//手机里面找出来的
    
    _fbuid=[dicinfo objectForKey:@"tmpFirstName"];//手机里面找出来的
    
    _telePhoneNumber=[dicinfo objectForKey:@"tmpPhoneIndex0"];//手机里面找出来的
    if (_telePhoneNumber.length==0||[_telePhoneNumber isEqualToString:@"(null)"]) {
        _telePhoneNumber=@"123";
    }
    
// *************uid:用户uid   username:用户名   telphone:手机号    usertype:用户类型（1：圈子用户，2：论坛用户，3：不是用户）  rname：通讯录名字

    
    _headimg=[dicinfo objectForKey:@"headimg"];
    
    _rname=[dicinfo objectForKey:@"rname"];
    
    _usertype=[dicinfo objectForKey:@"usertype"];
    
    _uid=[dicinfo objectForKey:@"uid"];

    _username=[dicinfo objectForKey:@"username"];

    _telphone=[dicinfo objectForKey:@"telphone"];

    _optype=[dicinfo objectForKey:@"optype"];
    _face=[dicinfo objectForKey:@"face"];
    _uname=[dicinfo objectForKey:@"uname"];

}

- (NSString *) getFirstName
{
    NSString * firstName;
    if ([[[self.uname substringToIndex:1] substringFromIndex:0] canBeConvertedToEncoding: NSASCIIStringEncoding])
    {
        //如果是英语
        firstName = self.uname;
    }
    else
    {
        //如果是非英语
      firstName = [NSString stringWithFormat:@"%c",pinyinFirstLetter([[[self.uname substringToIndex:1] substringFromIndex:0] characterAtIndex:0])];
    }
    
    return firstName;
    
}


- (NSString *)zkingPaixufirstname{

    NSString * firstName;
    if ([[[self.fbuname substringToIndex:1] substringFromIndex:0] canBeConvertedToEncoding: NSASCIIStringEncoding])
    {
        //如果是英语
        firstName = self.fbuname;
    }
    else
    {
        //如果是非英语
        firstName = [NSString stringWithFormat:@"%c",pinyinFirstLetter([[[self.fbuname substringToIndex:1] substringFromIndex:0] characterAtIndex:0])];
    }
    
    return firstName;
    


}








@end
