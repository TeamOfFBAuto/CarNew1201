//
//  GCaseModel.m
//  CustomNewProject
//
//  Created by gaomeng on 14/12/5.
//  Copyright (c) 2014年 FBLIFE. All rights reserved.
//

#import "GCaseModel.h"

#import "NSDictionary+GJson.h"

@implementation GCaseModel


-(id)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.id = [dic stringValueForKey:@"id"];
        self.title = [dic stringValueForKey:@"title"];
        self.pichead = [dic stringValueForKey:@"pichead"];
        self.province = [dic stringValueForKey:@"province"];
        self.city = [dic stringValueForKey:@"city"];
        self.brand = [dic stringValueForKey:@"brand"];
        self.models = [dic stringValueForKey:@"models"];
        self.dateline = [dic stringValueForKey:@"dateline"];
        self.sname = [dic stringValueForKey:@"sname"];
        self.spichead = [dic stringValueForKey:@"spichead"];
        self.username = [dic stringValueForKey:@"username"];
        
    }
    return self;
}


@end
