//
//  KKAppInfo.h
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/24.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKAppSdkMgr : NSObject

/// 高德地图的AppKey
+ (NSString *)aMapAppKey;

/// 微信的AppKey
+ (NSString *)wechatAppKey;
/// 微信的AppSecret
+ (NSString *)wechatAppSecret;

/// bugly的AppId
+ (NSString *)buglyAppId;
/// bugly的AppKey
+ (NSString *)buglyAppKey;

/// qq分享appId
+ (NSString *)qqAppId;
/// qq分享 秘钥
+ (NSString *)qqAppsecret;

/// 极光分享Key
+ (NSString *)jShareAppKey;
@end

NS_ASSUME_NONNULL_END
