//
//  KKIMMgr.h
//  kk_espw
//
//  Created by 阿杜 on 2019/7/25.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RCIMUserToken   @"RCUserToken"
#define RCIMSdkAppKey  @"RCIMSdkAppKey"

NS_ASSUME_NONNULL_BEGIN

@interface KKIMMgr : NSObject

+(instancetype)shareInstance;


-(void)login;

-(void)logout;


/**
 检查是否登录融云 ，没有登会再次登一遍，进入招募厅要掉的接口

 @param successBlock 连接成功
 @param errorBlock 连接失败
 */
-(void)checkAndConnectRCSuccess:(void (^)(void))successBlock
                          error:(void (^)(RCConnectErrorCode status))errorBlock;
@end

NS_ASSUME_NONNULL_END
