//
//  KKIMMgr.m
//  kk_espw
//
//  Created by 阿杜 on 2019/7/25.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKIMMgr.h"
#import "JKEncrypt.h"
#import "KKCustomTabViewController.h"
#import "KKTabBadgeValueManager.h"

NSString *const RCTokenServerName = @"RCLOUD_TLS_USER_TOKEN_GET";

static KKIMMgr *_instance = nil;
static dispatch_once_t onceToken;

@interface KKIMMgr()
@property (nonatomic,copy,nullable) NSString *RCUserToken;
@property (nonatomic,copy,nullable) NSString *RCAppKey;

@end

@implementation KKIMMgr

#pragma mark - life circle
+(instancetype)shareInstance{
    dispatch_once(&onceToken, ^{
        _instance = [[KKIMMgr alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupInfo];
    }
    return self;
}

-(void)setupInfo
{
    self.RCAppKey = [ccs getDefault:RCIMSdkAppKey];
    self.RCUserToken = [ccs getDefault:RCIMUserToken];
    CCLOG(@"RCUserToken === %@", self.RCUserToken);
}


#pragma mark - login/logout
-(void)login
{
    [self loginRC];
}


-(void)logout
{
    [self logoutRC];
}

-(void)loginRC
{
    if (self.RCAppKey.length > 0 && self.RCUserToken.length > 0) {
        [self initRCloudKitWithSdkId];
     } else {
        [self fetchRCloudUserToken];
    }
}

-(void)logoutRC
{
    self.RCUserToken = nil;
    self.RCAppKey = nil;
    
//    [ccs saveDefaultKey:RCIMSdkAppKey andV:nil];
//    [ccs saveDefaultKey:RCIMUserToken andV:nil];
    
    onceToken = 0;
    _instance = nil;
    
    [[IMUIKitManager sharedInstance] logoutTIMKit:^{
        
    } fail:^(int code, NSString * _Nullable msg) {
        
    }];
}

#pragma mark - RC
- (void)fetchRCloudUserToken {
    
    
    if (![KKUserInfoMgr isLogin]) {
        return;
    }
    [[IMUIKitManager sharedInstance] fetchRCloudUserTokenWithUrl:[[KKNetworkConfig currentUrl] absoluteString] service:RCTokenServerName complection:^(ResModel * _Nullable response) {
        CCLOG(@"1");
        if(!response.errorMsgStr.length) {
            NSString *token = response.resultDic[@"response"][@"rCloudInfo"][@"userToken"];
            NSString *appSdkId = response.resultDic[@"response"][@"rCloudInfo"][@"appSdkId"];
            
            NSString *cryptKey = [KKNetworkConfig shareInstance].user_cryptKey;
            //解密
            JKEncrypt * encryptObj = [[JKEncrypt alloc]init];
            NSString *decUserToken = [encryptObj doDecEncryptStr:token withKey:cryptKey];
            
            [self saveRongCloudTokenInfo:@{
                                           RCIMUserToken:decUserToken,
                                           RCIMSdkAppKey:appSdkId,
                                           }];
            
            [self initRCloudKitWithSdkId];
        }
    }];
}

- (void)initRCloudKitWithSdkId {
    [[IMUIKitManager sharedInstance] initRCloudKitWithAppKey:self.RCAppKey];
    
    //1.注册自定义消息
    //1.1聊天室状态改变
    [[RCIMClient sharedRCIMClient] registerMessageType:NSClassFromString(@"KKChatRoomCustomMsg")];
    //1.2 招募厅麦位变化
    [[RCIMClient sharedRCIMClient] registerMessageType:NSClassFromString(@"KKChatRoomMicPositionMsg")];
    //1.3 聊天室成员变化
    [[RCIMClient sharedRCIMClient] registerMessageType:NSClassFromString(@"KKChatRoomMemberChangeMsg")];
    
    
    //2.获取token
    [[IMUIKitManager sharedInstance] loginRCloudKitWithToken:self.RCUserToken succ:^{
        //            [KKTabBadgeValueManager setBadgeValue];
    } fail:^(int code, NSString * _Nullable msg) {
        BBLOG(@"--------融云链接失败");
        [self performSelector:@selector(fetchRCloudUserToken) withObject:nil afterDelay:3];
    }];
}


-(void)checkAndConnectRCSuccess:(void (^)(void))successBlock error:(void (^)(RCConnectErrorCode))errorBlock
{
    RCConnectionStatus status = [[RCIMClient sharedRCIMClient] getConnectionStatus];
    if (status != ConnectionStatus_Connected) {
        if (self.RCUserToken) {
            [[IMUIKitManager sharedInstance] loginRCloudKitWithToken:self.RCUserToken succ:^{
                successBlock();
            } fail:^(int code, NSString * _Nullable msg) {
                BBLOG(@"--------融云链接失败");
                errorBlock(code);
            }];
        }
    } else {
        successBlock();
    }
}


#pragma mark - 登录腾讯云、融云
-(void)saveRongCloudTokenInfo:(NSDictionary *)dic
{
    //1.内存保存
    self.RCAppKey = dic[RCIMSdkAppKey];
    self.RCUserToken = dic[RCIMUserToken];
    
//    //2.NSUserDefault保存
//    [ccs saveDefaultKey:RCIMSdkAppKey andV:self.RCAppSdkId];
//    [ccs saveDefaultKey:RCIMUserToken andV:self.RCUserToken];
}


@end
