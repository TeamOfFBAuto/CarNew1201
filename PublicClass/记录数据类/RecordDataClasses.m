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
        [self timing];
    }
    
    return self;
}

-(void)timing{
    
    [NSTimer scheduledTimerWithTimeInterval:300.0f target:self selector:@selector(updateData) userInfo:nil repeats:YES];
}

-(void)updateData
{
    NSLog(@"record data ----  %@",_action_string);
    _action_string = @"";
}

-(void)setActionStringWithAction:(NSString *)aAction WithObject:(NSString *)aObject
{
    _action_string  = [_action_string stringByAppendingString:[NSString stringWithFormat:@"|%@_%@_%@_%@",[GMAPI getUid],aAction,aObject,[ZSNApi timechangeToDateline]]];
}


@end
