//
//  KKNetworkConfig.h
//  kk_buluo
//
//  Created by david on 2019/3/16.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kNetConfig_id        @"id" 
#define kNetConfig_loginKey  @"loginKey"
#define kNetConfig_signKey   @"signKey"
#define kNetConfig_cryptKey  @"cryptKey"

NS_ASSUME_NONNULL_BEGIN

@interface KKNetworkConfig : NSObject

#pragma mark - life circle
+(instancetype)shareInstance;
- (void)removeHttpTaskConfig;

#pragma mark - 签名
#pragma mark oneAuth
/** 保存用户的(方舟LoginKit)oneAuth签名信息
 *
 * dic的key 分别是id,loginKey,signKey,cryptKey
 */
-(void)saveOneAuthInfo:(NSDictionary *)dic;
@property (nonatomic,copy,nullable) NSString *oneAuth_id;
@property (nonatomic,copy,nullable) NSString *oneAuth_loginKey;
@property (nonatomic,copy,nullable) NSString *oneAuth_signKey;
@property (nonatomic,copy,nullable) NSString *oneAuth_cryptKey;

#pragma mark oneAuth
/** 保存用户的(方舟LoginKit)user签名信息
 *
 * dic的key 分别是id,loginKey,signKey,cryptKey
 */
-(void)saveAuthInfo:(NSDictionary *)dic;
@property (nonatomic,copy,nullable) NSString *auth_id;
@property (nonatomic,copy,nullable) NSString *auth_loginKey;
@property (nonatomic,copy,nullable) NSString *auth_signKey;
@property (nonatomic,copy,nullable) NSString *auth_cryptKey;

#pragma mark user
/** 保存用户的user(角色)签名信息
 *
 * dic的key 分别是id,loginKey,signKey,cryptKey
 */
-(void)saveUserInfo:(NSDictionary *)dic;
@property (nonatomic,copy,nullable) NSString *user_id;
@property (nonatomic,copy,nullable) NSString *user_loginKey;
@property (nonatomic,copy,nullable) NSString *user_signKey;
@property (nonatomic,copy,nullable) NSString *user_cryptKey;


#pragma mark - appConfig
//由appConfig.plist的参数配置
/** app的类型 (0:线下, 1:线上) */
@property (nonatomic,assign,readonly) NSInteger appType;
/** appName的类型 (0:默认, 1:单角色, 2:多角色) */
@property (nonatomic,assign,readonly)NSInteger appNameType;
/** 用于签名的appName */
@property (nonatomic,copy,readonly)NSString *appName;
/** 根据urlType和appType确定 */
@property (nonatomic,copy,readonly)NSString *domainStr;
/** 根据loginUrlType和appType确定 */
@property (nonatomic,copy,readonly)NSString *loginDomainStr;

#pragma mark - 配置网络
+(void)configNetWork;

/** 获取 当前请求地址 */
+(NSURL *)currentUrl;

/** 获取头像地址 */
+(NSURL *)baseHeadURL;
 
@end

NS_ASSUME_NONNULL_END
