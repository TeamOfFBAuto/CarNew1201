//
//  GGoodsModel.m
//  CustomNewProject
//
//  Created by gaomeng on 14/12/5.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "GGoodsModel.h"


#import "NSDictionary+GJson.h"


@implementation GGoodsModel





-(id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.username = [dic stringValueForKey:@"username"];
        self.gtype = [dic stringValueForKey:@"gtype"];
        self.title = [dic stringValueForKey:@"title"];
        self.content = [dic stringValueForKey:@"content"];
        self.price = [dic stringValueForKey:@"price"];
        self.dateline = [dic stringValueForKey:@"dateline"];
        self.pichead = [dic stringValueForKey:@"pichead"];
        self.updatetime = [dic stringValueForKey:@"updatetime"];
        self.com_num = [dic stringValueForKey:@"com_num"];
        self.id = [dic stringValueForKey:@"id"];
        self.uid = [dic stringValueForKey:@"uid"];
        self.storename = [dic stringValueForKey:@"storename"];
    }
    return self;
}






@end
