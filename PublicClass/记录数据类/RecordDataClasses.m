//
//  RecordDataClasses.m
//  CustomNewProject
//
//  Created by soulnear on 15-3-12.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "RecordDataClasses.h"

@implementation RecordDataClasses

+ (RecordDataClasses *)sharedManager
{
    static RecordDataClasses *sharedAccountManagerInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAccountManagerInstance = [[self alloc] init];
    });
    return sharedAccountManagerInstance;
}

-(id)init
{
    self = [super init];
    if (self) {
        _action_string = @"";
        [self timing];
    }
    
    return self;
}

-(void)timing{
    
    [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(updateData) userInfo:nil repeats:YES];
}

-(void)updateData
{
    NSLog(@"record data ----  %@",_action_string);
    _action_string = @"";
}

-(void)setActionStringWithAction:(NSString *)aAction WithObject:(NSString *)aObject WithValue:(NSString *)aValue
{
    NSString * UID = [GMAPI getUid];
    
    if (UID.length == 0 || [UID isKindOfClass:[NSNull class]]) {
        UID = @"0";
    }
    
    NSString * object_value;
    if (aValue.length == 0) {
        object_value = aObject;
    }else
    {
        object_value = [NSString stringWithFormat:@"%@-%@",aObject,aValue];
    }
    
    if (_action_string.length != 0)
    {
        _action_string = [_action_string stringByAppendingString:@"|"];
    }
    
    _action_string  = [NSString stringWithFormat:@"%@%@_%@_%@_%@",_action_string,UID,aAction,object_value,[ZSNApi timechangeToDateline]];
}


@end
