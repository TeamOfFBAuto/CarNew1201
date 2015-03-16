//
//  RecordDataClasses.m
//  CustomNewProject
//
//  Created by soulnear on 15-3-12.
//  Copyright (c) 2015年 FBLIFE. All rights reserved.
//

#import "RecordDataClasses.h"

@implementation RecordDataClasses
{
    ASIFormDataRequest * request;
}

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
    
   NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:60.0f target:self selector:@selector(updateData) userInfo:nil repeats:YES];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}

-(void)updateData
{
    NSLog(@"record data ----  %@",_action_string);
    
    /*
     
    if (request)
    {
        [request cancel];
        request = nil;
    }
    NSString * fullUrl = [NSString stringWithFormat:RECORD_ACTION_DATA_URL,_action_string];
    
    request = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:fullUrl]]];
    __weak typeof(self)bself = self;
    [request setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary * allDic = [operation.responseString objectFromJSONString];
        
        if ([[allDic objectForKey:@"errorcode"] intValue] == 0)
        {
            bself.action_string = @"";
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    [request start];
     */
    
    
    if (request)
    {
        [request cancel];
        request = nil;
    }
    
    if (_action_string.length == 0) {
        return;
    }
    
    request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:RECORD_ACTION_DATA_URL]];
    [request setPostValue:_action_string forKey:@"actionData"];
    
    __weak typeof(self)bself = self;
    __weak typeof(request)brequest = request;
    
    [request setCompletionBlock:^{
        NSDictionary * allDic = [brequest.responseString objectFromJSONString];
        
        if ([[allDic objectForKey:@"errorcode"] intValue] == 0)
        {
            bself.action_string = @"";
        }
    }];
    
    
    [request setFailedBlock:^{
        
    }];
    
    [request startAsynchronous];
    
}

-(void)setActionStringWithAction:(NSString *)aAction WithObject:(NSString *)aObject WithValue:(NSString *)aValue
{
    NSString * UID = [GMAPI getUid];
    
    if (UID.length == 0 || [UID isKindOfClass:[NSNull class]] || [UID isEqualToString:@"(null)"]) {
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
