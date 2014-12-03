//
//  GmPrepareNetData.h
//  FBAuto
//
//  Created by gaomeng on 14-8-4.
//  Copyright (c) 2014年 szk. All rights reserved.
//



//网络数据类
#import <Foundation/Foundation.h>

typedef void(^ urlRequestBlock)(NSDictionary *result,NSError *erro);

@interface GmPrepareNetData : NSObject
{
    urlRequestBlock successBlock;
    urlRequestBlock failBlock;
    NSString *requestUrl;
    NSData *requestData;
    BOOL isPostRequest;//是否是post请求
}


/**
 *  对象初始化方法
 *
 *  @param url      网络请求地址
 *  @param isPost   是否为post
 *  @param postData post的data数据
 *
 *  @return no
 */
- (id)initWithUrl:(NSString *)url isPost:(BOOL)isPost postData:(NSData *)postData;



/**
 *  发起网络请求
 *
 *  @param completionBlock 网络请求成功之后的block result为json解析出来的字典
 *  @param failedBlock     网络请求失败的block
 */
- (void)requestCompletion:(void(^)(NSDictionary *result,NSError *erro))completionBlock failBlock:(void(^)(NSDictionary *failDic,NSError *erro))failedBlock;


@end
