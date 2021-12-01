//
//  KKEditUserInfoService.m
//  kk_espw
//
//  Created by 景天 on 2019/7/22.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKEditUserInfoService.h"

@implementation KKEditUserInfoService

static KKEditUserInfoService *editUserInfoService = nil;
static dispatch_once_t onceToken;
+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        editUserInfoService = [[KKEditUserInfoService alloc] init];
    });
    return editUserInfoService;
}

+ (void)requestEditUserInfoSuccess:(requestEditUserInfoBlockSuccess)success Fail:(requestEditUserInfoBlockFail)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"USER_INFO_MODIFY" forKey:@"service"];
    [params safeSetObject:[KKEditUserInfoService shareInstance].sex forKey:@"sex"];
    [params safeSetObject:[KKEditUserInfoService shareInstance].birthday forKey:@"birthday"];
    [params safeSetObject:[KKEditUserInfoService shareInstance].userLocation forKey:@"userLocation"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            [CC_Notice show:@"编辑成功"];
            if (success) {
                success();
            }
        }
    }];
}

+ (void)requestUploadImageSuccess:(requestUploadImageGetFileNameBlockSuccess)success Fail:(requestUploadImageGetFileNameBlockFail)fail {
    [[CC_Mask getInstance] start];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"USER_LOGO_MODIFY" forKey:@"service"];
    [[CC_HttpTask getInstance] uploadImages:@[[KKEditUserInfoService shareInstance].image] url:[KKNetworkConfig currentUrl] params:params imageSize:1 reConnectTimes:0 finishBlock:^(NSArray<ResModel *> *errorModelArr, NSArray<ResModel *> *successModelArr) {
        
        ResModel *res = errorModelArr.firstObject;
        if (res) {
            [[CC_Mask getInstance] stop];
            [CC_Notice show:res.errorMsgStr];
            if (fail) {
                fail();
            }
        }else {
            [[CC_Mask getInstance] stop];
            if (success) {
                success();
            }
        }
    }];
}

+ (void)requestUpdateImageSuccess:(requestUpdateImageBlockSuccess)success Fail:(requestUpdateImageBlockFail)fail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"USER_LOGO_MODIFY" forKey:@"service"];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *str, ResModel *resModel) {
        if (str) {
            [CC_Notice show:str];
            if (fail) {
                fail();
            }
        }else {
            if (success) {
                success();
            }
        }
    }];
}

@end
