//
//  KKAppInfo.m
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/24.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKAppSdkMgr.h"

@implementation KKAppSdkMgr
 

+ (NSString *)aMapAppKey {
    return @"76807e0e738e6f9b69891049e757a3bd";
}

+ (NSString *)wechatAppKey {
    //0:线下环境, 1:线上环境
    NSInteger appType = [KKNetworkConfig shareInstance].appType;
    if (1 == appType) {
        return @"wx1b3a0be9a0b1cc8a";
    }
    return @"wx291deed91962b46d";
}

+ (NSString *)wechatAppSecret {
    
    //0:线下环境, 1:线上环境
    NSInteger appType = [KKNetworkConfig shareInstance].appType;
    if (1 == appType) {
        return @"0daa1f6cc04c903d55448597fb8b843d";
    }
    
    return @"f62caa6efa19ed7c640ffd5f4ef415a9";
}

+ (NSString *)buglyAppId {
    return @"70e889563a";
}

+ (NSString *)buglyAppKey {
    return @"fb6fcb53-6d0c-44ac-888b-7eec93e7bcb5";
}

+ (NSString *)qqAppId {
    return @"101751321";
}

+ (NSString *)qqAppsecret {
    return @"2d2757066e02e7047d83f6002c0959c2";
}

+ (NSString *)jShareAppKey {
    return @"2ce219a73c8f5524e51f5971";
}
@end
