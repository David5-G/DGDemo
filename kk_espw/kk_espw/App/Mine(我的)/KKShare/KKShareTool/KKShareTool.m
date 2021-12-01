//
//  KKShareTool.m
//  kk_espw
//
//  Created by 景天 on 2019/7/30.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKShareTool.h"

@implementation KKShareTool
static KKShareTool *shareTool = nil;
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareTool = [[KKShareTool alloc] init];
    });
    return shareTool;
}

+ (void)configJShare {
    JSHARELaunchConfig *config = [[JSHARELaunchConfig alloc] init];
    config.appKey = [KKAppSdkMgr jShareAppKey];
    config.QQAppId = [KKAppSdkMgr qqAppId];
    config.QQAppKey = [KKAppSdkMgr qqAppsecret];
    config.WeChatAppId = [KKAppSdkMgr wechatAppKey];
    config.WeChatAppSecret = [KKAppSdkMgr wechatAppSecret];
    [JSHAREService setupWithConfig:config];
    [JSHAREService setDebug:NO];
}

+ (void)configJShareWithPlatform:(JSHAREPlatform)platform title:(NSString *)title text:(NSString *)text url:(NSString *)url type:(ShareType)type{
    
    [KKShareTool requestShareWorkCreate];
    JSHAREMessage *message = [JSHAREMessage message];
    message.text = text;
    message.title = title;
    message.mediaType = JSHARELink;
    if (type == ActivityType) {
        message.image = UIImagePNGRepresentation(Img(@"kklogon"));
    }else {    
        UIImage *shareUserImage = [KKShareTool getImageFromURL:[ccs getDefault:@"shareUserLogo"]];
        UIImage *yShareUserImage = [KKShareTool compressImage:shareUserImage toByte:32765];
        message.image = UIImagePNGRepresentation(yShareUserImage);
    }
    message.url = url;
    if (platform == JSHAREPlatformQQ) {
        message.platform = JSHAREPlatformQQ;
    }else if (platform == JSHAREPlatformWechatSession) {
        if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]] ) {
            
            [CC_Notice show:@"您未安装微信"];
            return;
        }
        message.platform = JSHAREPlatformWechatSession;
    }else if (platform == JSHAREPlatformWechatTimeLine) {
        message.platform = JSHAREPlatformWechatTimeLine;
    }
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        switch (state) {
            case JSHAREStateSuccess:
                [CC_Notice show:@"分享成功"];
                break;
            case JSHAREStateCancel:
                [CC_Notice show:@"取消分享"];
                break;
            case JSHAREStateUnknown:
                [CC_Notice show:@"未知错误"];
                break;
            case JSHAREStateFail:
                [CC_Notice show:@"分享失败"];
                
                break;
            default:
                break;
        }
    }];
}

+ (void)requestShareWorkCreate{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"USER_SHARE_MISSION_CREATE" forKey:@"service"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            
        }else {
            
        }
    }];
}

+ (UIImage *)getImageFromURL:(NSString *)fileURL{
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}

+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}
@end
