//
//  KKUserInfoMgr.h
//  kk_buluo
//
//  Created by david on 2019/3/17.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKUserInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKUserInfoMgr : NSObject

#pragma mark - life circle
+ (instancetype)shareInstance;
- (void)remove;


#pragma mark - 用户信息
/** request获取我的用户信息 */
-(void)requestUserInfoSuccess:(nullable void(^)(void))success fail:(nullable void(^)(void))fail;

#pragma mark - login
/** 是否已登录 */
+ (BOOL)isLogin;

/** 登出 */
- (void)logoutAndSetNil:(nullable void(^)(void))finish;



#pragma mark - 属性
/** 储存userInfo */
@property (nonatomic, strong) KKUserInfoModel *userInfoModel;

/** 用户Id */
@property (nonatomic,copy) NSString *userId;

/** 方舟平台的userId(loginKit中角色列表的userId也是这个) */
@property (nonatomic, copy) NSString *platformUserId;

@end

NS_ASSUME_NONNULL_END
