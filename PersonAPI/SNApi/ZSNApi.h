//
//  ZSNApi.h
//  FBCircle
//
//  Created by soulnear on 14-5-14.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "NSString+Emoji.h"
#import "MBProgressHUD.h"
#define PERSONAL_DEFAULTS_IMAGE [UIImage imageNamed:@"gTouxiang"]

///大表情
#define IMAGE_BIG_WIDTH 20
#define IMAGE_BIG_HEIGHT 20
///中表情
#define IMAGE_MIDDLE_WIDTH 18
#define IMAGE_MIDDLE_HEIGHT 18
///小表情
#define IMAGE_SMALL_WIDTH 16
#define IMAGE_SMALL_HEIGHT 16

#pragma mark - 屏幕宽度
///屏幕宽度
#define DEVICE_WIDTH  [UIScreen mainScreen].bounds.size.width
#pragma mark - 屏幕高度
///屏幕高度
#define DEVICE_HEIGHT [UIScreen mainScreen].bounds.size.height




@interface ZSNApi : NSObject

+(UIImage *)getImageWithName:(NSString *)name;
///获取文件大小
+(NSString *) fileSizeAtPath:(NSString*) filePath;

+(NSArray *)exChangeFriendListByOrder:(NSMutableArray *)theArray;

///裁剪图片
+(UIImage *)scaleToSizeWithImage:(UIImage *)img size:(CGSize)size;
///按比例缩放图片
+(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;

///根据uid返回论坛小头像
+(NSString *)returnUrl:(NSString *)theUrl;
///根据uid返回论坛中头像
+(NSString *)returnMiddleUrl:(NSString *)theUrl;

+(NSString *)timechange:(NSString *)placetime;

+(NSString *)timechangeByAll:(NSString *)placetime;

+(NSString *)timechange1:(NSString *)placetime;

+(NSString *)timechangeToDateline;

+(NSArray *)stringExchange:(NSString *)string;

+(float)calculateheight:(NSArray *)array;

+(CGPoint)LinesWidth:(NSString *)string Label:(UILabel *)label font:(UIFont *)thefont;

+ (float)theHeight:(NSString *)content withHeight:(CGFloat)theheight WidthFont:(UIFont *)font;

+(NSString*)timestamp:(NSString*)myTime;

+(UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve;


+ (NSString*)FBImageChange:(NSString*)imgSrc;

+ (NSString*)FBEximgreplace:(NSString*)imgSrc;


/////删除asyncimage某个缓存图片
//+(void)deleteFileWithUrl:(NSString *)path;

//保存图片到沙盒

+(void)saveImageToDocWith:(NSString *)path WithImage:(UIImage *)image;
//删除沙盒文件

+(void)deleteDocFileWith:(NSMutableArray *)fileNames;

//保存图片沙盒地址

+(NSString *)docImagePath;
///弹出提示框
+ (MBProgressHUD *)showMBProgressWithText:(NSString *)text addToView:(UIView *)aView;
///弹出框，1.5秒后自动消失
+ (void)showAutoHiddenMBProgressWithText:(NSString *)text addToView:(UIView *)aView;
///弹出提示框（包含标题，内容），1.5秒后消失
+(void)showautoHiddenMBProgressWithTitle:(NSString *)title WithContent:(NSString *)content addToView:(UIView *)aView;
///字符串编码
+(NSString *)encodeToPercentEscapeString: (NSString *) input;
///字符串解码
+(NSString *)decodeFromPercentEscapeString: (NSString *) input;

///解码特殊字符
+(NSString *)decodeSpecialCharactersString:(NSString *)input;
///特殊字符编码
+(NSString *)encodeSpecialCharactersString:(NSString *)input;
///特殊字符解码（例：&lt;转化成<）
+(NSString *)ddecodeSpecialCharactersStringWith:(NSString *)input;

///ios7计算字符串高度
+(float)returnLabelHeightForIos7:(NSString *)content WIthFont:(float)aFont WithWidth:(float)aWidth;
///给字符串排序
+(NSArray *)sortArrayWith:(NSArray *)array;
///去除所有带<>类的标签
+(NSString *)cleanHTMLWithString:(NSString *)string;
///匹配是否是网址URL
+(BOOL)matchURLWithString:(NSString *)string;
///匹配是否是纯数字
+(BOOL)matchIntWithString:(NSString *)string;
///判断是否是邮箱地址
+(BOOL) validateEmail: (NSString *) candidate;
///获取字符串高宽度
+(CGSize)stringHeightAndWidthWith:(NSString *)string WithHeight:(float)aHeight WithWidth:(float)aWidth WithFont:(float)aFont;
///截取当前屏幕并模糊处理
+(UIImage *)screenShot;
@end







