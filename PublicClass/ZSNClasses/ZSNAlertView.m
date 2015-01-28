//
//  ZSNAlertView.m
//  FBCircle
//
//  Created by soulnear on 14-5-24.
//  Copyright (c) 2014年 szk. All rights reserved.
//

#import "ZSNAlertView.h"

@implementation ZSNAlertView
@synthesize backgroundImageView = _backgroundImageView;
@synthesize forward_label = _forward_label;
@synthesize imageView = _imageView;
@synthesize userName_label = _userName_label;
@synthesize content_label = _content_label;
@synthesize textField = _textField;
@synthesize cancel_button = _cancel_button;
@synthesize done_button = _done_button;



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.frame = [UIScreen mainScreen].bounds;
        
        self.window.windowLevel = UIWindowLevelStatusBar;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        
        
        if (!_backgroundImageView) {
            //            _backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-540_420.png"]];
            
            _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,271,195)];
            
            _backgroundImageView.image = [UIImage imageNamed:@"bg-540_420.png"];
            
            //lcw iPhone5: 20
            CGPoint aCenter = self.center;
            aCenter.y -= 55;
            _backgroundImageView.center = aCenter;
            
            _backgroundImageView.userInteractionEnabled = YES;
            
            [self addSubview:_backgroundImageView];
        }
        
        if (!_forward_label) {
            
            _forward_label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,_backgroundImageView.frame.size.width,41)];
            _forward_label.text = @"分享";
            _forward_label.textAlignment = NSTextAlignmentCenter;
            _forward_label.textColor = RGBCOLOR(3,3,3);
            _forward_label.backgroundColor = [UIColor clearColor];
            [_backgroundImageView addSubview:_forward_label];
        }
        
        if (!_imageView) {
            _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20,70,45,45)];
            _imageView.clipsToBounds = YES;
            _imageView.image = PERSONAL_DEFAULTS_IMAGE;
            _imageView.contentMode = UIViewContentModeScaleAspectFill;
            [_backgroundImageView addSubview:_imageView];
        }
        
        if (!_userName_label) {
            _userName_label = [[UILabel alloc] initWithFrame:CGRectMake(75,52.5,180,90)];
            _userName_label.textAlignment = NSTextAlignmentLeft;
            _userName_label.textColor = RGBCOLOR(153,153,153);
            _userName_label.font = [UIFont systemFontOfSize:15];
            _userName_label.numberOfLines = 0;
            _userName_label.lineBreakMode = NSLineBreakByCharWrapping;
            [_backgroundImageView addSubview:_userName_label];
        }
        
        if (!_content_label)
        {
            _content_label = [[OHAttributedLabel alloc] initWithFrame:CGRectMake(75,72.5,180,20)];
            _content_label.textAlignment = NSTextAlignmentLeft;
            _content_label.textColor = RGBCOLOR(3,3,3);
            _content_label.font = [UIFont systemFontOfSize:14];
            _content_label.backgroundColor = [UIColor clearColor];
         //   [_backgroundImageView addSubview:_content_label];
        }
        
        if (!_textField)
        {
            UIImageView * shurukuang = [[UIImageView alloc]  initWithFrame:CGRectMake(8.75+15,104,223,30)];
            shurukuang.userInteractionEnabled = YES;
            shurukuang.image = [UIImage imageNamed:@"shuru-446_60.png"];
         //   [_backgroundImageView addSubview:shurukuang];
            
            _textField = [[UITextField alloc] initWithFrame:CGRectMake(8,0,207,30)];
            _textField.placeholder = @"输入内容...";
            _textField.delegate = self;
            _textField.returnKeyType = UIReturnKeyDone;
            _textField.font = [UIFont systemFontOfSize:14];
            _textField.backgroundColor = [UIColor clearColor];
            [shurukuang addSubview:_textField];
            
        }
        
        if (!_cancel_button) {
            _cancel_button = [UIButton buttonWithType:UIButtonTypeCustom];
            _cancel_button.frame = CGRectMake(0,151,135,44);
            _cancel_button.backgroundColor = [UIColor clearColor];
            [_cancel_button setBackgroundImage:[UIImage imageNamed:@"button1-down252_94.png"] forState:UIControlStateHighlighted];
            [_cancel_button setTitle:@"取消" forState:UIControlStateNormal];
            [_cancel_button setTitleColor:RGBCOLOR(18,107,255) forState:UIControlStateNormal];
            [_cancel_button addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_backgroundImageView addSubview:_cancel_button];
        }
        
        
        if (!_done_button) {
            _done_button = [UIButton buttonWithType:UIButtonTypeCustom];
            _done_button.frame = CGRectMake(136,151,135,44);
            _done_button.backgroundColor = [UIColor clearColor];
            [_done_button setBackgroundImage:[UIImage imageNamed:@"button2-down252_94.png"] forState:UIControlStateHighlighted];
            [_done_button addTarget:self action:@selector(doneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_done_button setTitle:@"分享" forState:UIControlStateNormal];
            [_done_button setTitleColor:RGBCOLOR(18,107,255) forState:UIControlStateNormal];
            [_backgroundImageView addSubview:_done_button];
        }
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
    }
    return self;
}


-(void)setInformationWithImageUrl:(NSString *)url WithShareUrl:(NSString *)shareUrl WithUserName:(NSString *)userName WithContent:(NSString *)content WithBlock:(ZSNAlertViewBlock)theBlock;
{
    
    /*老版本展示标题图片输入内容框
    
    if ([content isKindOfClass:[NSNull class]] || content == nil || [content isEqualToString:@"(null)"]) {
        _content_label.frame = CGRectMake(75,72.5,180,0);
        _userName_label.frame = CGRectMake(75,52.5,180,40);
    }else
    {
        _content_label.frame = CGRectMake(75,72.5,180,22);
        _userName_label.frame = CGRectMake(75,52.5,180,15);
        [OHLableHelper creatAttributedText:[[ZSNApi decodeSpecialCharactersString:content] stringByReplacingEmojiCheatCodesWithUnicode] Label:_content_label OHDelegate:nil WithWidht:IMAGE_SMALL_WIDTH WithHeight:IMAGE_SMALL_HEIGHT WithLineBreak:YES];
    }
     */
    
    ///新版本只显示图片标题
    
    _userName_label.text = [NSString stringWithFormat:@"分享自改装志:“%@”,链接:%@",userName,shareUrl];
    
    zsnAlertViewBlock = theBlock;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:PERSONAL_DEFAULTS_IMAGE];
}

-(void)show
{
    CAKeyframeAnimation * animation;
    
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.duration = 0.5;
    
    animation.delegate = self;
    
    animation.removedOnCompletion = YES;
    
    animation.fillMode = kCAFillModeForwards;
    
    
    NSMutableArray *values = [NSMutableArray array];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
    
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    
    
    
    animation.values = values;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName: @"easeInEaseOut"];
    
    [_backgroundImageView.layer addAnimation:animation forKey:nil];
}


-(void)cancelButtonClick:(UIButton *)sender
{
    [self removeFromSuperview];
}


-(void)doneButtonClick:(UIButton *)sender
{
    /*
    if (zsnAlertViewBlock) {
        zsnAlertViewBlock(_textField.text);
    }
    
    [self removeFromSuperview];
     */
    
    if (_imageView.image) {
        [self uploadImage];
    }else
    {
        [self submitWeiBoDataWithImageId:@""];
    }
}


#pragma mark-UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - 上传数据
//上传图片
#define TT_CACHE_EXPIRATION_AGE_NEVER     (1.0 / 0.0)   // inf
- (void)uploadImage
{
    hud = [ZSNApi showMBProgressWithText:@"发表中..." addToView:self];
    hud.mode = MBProgressHUDModeIndeterminate;
    
    NSString* fullURL = [NSString stringWithFormat:URLIMAGE,[GMAPI getAuthkey_GBK]];
    
    NSLog(@"上传图片的url  ——--  %@",fullURL);
    ASIFormDataRequest * request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:fullURL]];
    request.delegate = self;
    request.tag = 1;
    
    //得到图片的data
    NSData* data;
    NSMutableData *myRequestData=[NSMutableData data];
    
    for (int i = 0;i < 1; i++)
    {
        [request setPostFormat:ASIMultipartFormDataPostFormat];
        
        UIImage *image=_imageView.image;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"savedImage%d.png",i]];
        //also be .jpg or another
        NSData *imageData = UIImagePNGRepresentation(image);
        //UIImageJPEGRepresentation(image)
        [imageData writeToFile:savedImagePath atomically:NO];
        
//        UIImage * newImage = [personal scaleToSizeWithImage:image size:CGSizeMake(image.size.width>1024?1024:image.size.width,image.size.width>1024?image.size.height*1024/image.size.width:image.size.height)];
        
        data = UIImageJPEGRepresentation(image,1.0);
        
        [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [myRequestData length]]];
        
        //设置http body
        
        [request addData:data withFileName:[NSString stringWithFormat:@"boris%d.png",i] andContentType:@"image/PNG" forKey:@"topic[]"];
    }
    
    [request setRequestMethod:@"POST"];
    request.cachePolicy = TT_CACHE_EXPIRATION_AGE_NEVER;
    request.cacheStoragePolicy = ASICacheForSessionDurationCacheStoragePolicy;
    [request startAsynchronous];
}

#pragma mark - 发送微博
-(void)submitWeiBoDataWithImageId:(NSString *)imageId
{
    hud = [ZSNApi showMBProgressWithText:@"分享中..." addToView:self];
    hud.mode = MBProgressHUDModeIndeterminate;

    
    ASIFormDataRequest * up_request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:SEND_WEIBO_URL]];
    [up_request setPostValue:_userName_label.text forKey:@"content"];
    [up_request setPostValue:[GMAPI getAuthkey_GBK] forKey:@"authkey"];
    [up_request setPostValue:imageId forKey:@"imgid"];
    
    __weak typeof(up_request)brequest = up_request;
    __weak typeof(self)bself = self;
    [brequest setCompletionBlock:^{
        NSDictionary * jieguo = [brequest.responseData objectFromJSONData];
        NSLog(@"request.tag1111 = 2 ==%@",[jieguo objectForKey:@"data"]);
        
        if ([[jieguo objectForKey:@"errcode"]intValue] == 0)
        {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = @"成功分享到自留地";
            [hud hide:YES afterDelay:1.5];
            [bself performSelector:@selector(cancelButtonClick:) withObject:nil afterDelay:1.5];
            
        }else
        {
            hud.mode = MBProgressHUDModeText;
            hud.labelText = [jieguo objectForKey:@"data"];
            [hud hide:YES afterDelay:1.5];
            [bself performSelector:@selector(cancelButtonClick:) withObject:nil afterDelay:1.5];
        }
    }];
    
    [brequest setFailedBlock:^{
        NSLog(@"error = %@",brequest.error);
        
        hud.mode = MBProgressHUDModeText;
        hud.labelText = @"分享失败，请检查您当前网络";
        [hud hide:YES afterDelay:1.5];
        [bself performSelector:@selector(cancelButtonClick:) withObject:nil afterDelay:1.5];
    }];
    
    [up_request startAsynchronous];
}


-(void)requestFinished:(ASIHTTPRequest *)request
{
    
    @try {
        if (request.tag == 1)
        {
            NSDictionary * dic = [[NSDictionary alloc] initWithDictionary:[request.responseData objectFromJSONData]];
            
            NSLog(@"上传图片返回结果 ------   %@",dic);
            //    NSString *errcode = [dic objectForKey:ERRCODE];
            
            
            if ([[dic objectForKey:@"errcode"] intValue] == 0)
            {
                NSDictionary * dictionary = [dic objectForKey:@"data"];
                
                NSArray * array2 = [dictionary allKeys];
                
                NSArray *array = [array2 sortedArrayUsingSelector:@selector(compare:)];
                
                NSString* authod = @"";
                
                
                for (int i = 0;i < array.count;i++)
                {
                    if (i == 0)
                    {
                        authod = [array objectAtIndex:i];
                    }else
                    {
                        authod = [NSString stringWithFormat:@"%@|%@",authod,[array objectAtIndex:i]];
                    }
                    
                }
                
                [hud hide:YES];
                
                NSLog(@"authod -------   %@",authod);
                
                [self submitWeiBoDataWithImageId:authod];
                
            }else
            {
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"分享失败，请检查您当前网络";
                [hud hide:YES afterDelay:1.5];
                [self performSelector:@selector(cancelButtonClick:) withObject:nil afterDelay:1.5];
            }
            
        }else if (request.tag == 2)
        {
            NSDictionary * jieguo = [request.responseData objectFromJSONData];
            
            NSLog(@"request.tag1111 = 2 ==%@",[jieguo objectForKey:@"data"]);
            
        }else if (request.tag == 3)
        {
            NSLog(@"request.tag22222 = 2 ==%@",[request responseString]);
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"error = %@",request.error);
    
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"分享失败，请检查您当前网络";
    [hud hide:YES afterDelay:1.5];
    [self performSelector:@selector(cancelButtonClick:) withObject:nil afterDelay:1.5];
}




/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
