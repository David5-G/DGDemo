//
//  KKLiveStudioViewModel.h
//  kk_espw
//
//  Created by david on 2019/7/31.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 在具体请求中看code的意义 */
typedef void(^KKLiveStudioBlock)(NSInteger code);

@interface KKLiveStudioViewModel : KKLiveStudioBaseViewModel

#pragma mark - request
#pragma mark 招募厅
/** 请求 招募厅信息
 * code=-2  请求被拦截,
 * code=-1 请求失败
 * code=0  请求成功
 */
-(void)requestLiveStudioInfo:(KKLiveStudioBlock)success;


#pragma mark 主播
/** 请求 查看是不是主播身份
 * code=-2  请求被拦截,
 * code=-1 请求失败
 * code=0  请求成功, 不是主播
 * code=1  请求成功, 是主播
 */
-(void)requestHostIdentityCheck:(KKLiveStudioBlock)success;

/** 请求 设置主播麦的状态
 * code=-2  请求被拦截,
 * code=-1 请求失败
 * code=0  请求成功
 */
-(void)requestHostMicSet:(BOOL)isClose success:(KKLiveStudioBlock)success;

/** 请求 获得主播mic
 * code=-2  请求被拦截,
 * code=-1 请求失败
 * code=0  请求成功
 */
-(void)requestHostMicGet:(KKLiveStudioBlock)success;

/** 请求 退出主播mic
 * code=-2  请求被拦截,
 * code=-1 请求失败
 * code=0  请求成功
 */
-(void)requestHostMicQuit:(KKLiveStudioBlock)success;



#pragma mark 麦位
/** 请求 设置麦位
 * code=-2  请求被拦截,
 * code=-1 请求失败
 * code=0  请求成功
 */
-(void)requestMicSet:(BOOL)isClose success:(KKLiveStudioBlock)success;

/** 请求 抱某user上麦
 * code=-2  请求被拦截,
 * code=-1 请求失败
 * code=0  请求成功, 抱麦成功
 */
-(void)requestMicGive:(NSString *)userId success:(KKLiveStudioBlock)success;

/** 请求 下麦
 * code=-2  请求被拦截,
 * code=-1 请求失败
 * code=0  请求成功, 下麦成功
 */
-(void)requestMicQuit:(NSString *)userId success:(KKLiveStudioBlock)success;


#pragma mark - tool
#pragma mark 招募厅

/** 招募厅名字 */
-(NSString *)studioName;

/** 是否在直播中 */
-(BOOL)isLiving;

/** 是否 可以成为主播 */
-(BOOL)canBeHost;

/** 是否 能发送文本消息 */
-(BOOL)cannotSendTextMsg;

/** 进入直播间时, 已进入直播间的user */
-(NSArray *)firstJoinUsers;

/** 在线人数 */
-(NSInteger)onlineUserCount;

#pragma mark 主播位
/** 获取 主播id */
-(NSString *)getHostId;

/** 获取 主播的userId */
-(NSString *)getHostUserId;

/** 获取 主播的name */
-(NSString *)getHostName;

/** 获取 主播的logoUrl */
-(NSString *)getHostLogoUrl;

#pragma mark 麦位
/** 是否 关闭麦位 */
-(BOOL)isMicPostionClosed;

/** 获取 麦位用户id */
-(NSString *)getMicUserId;

/** 获取 麦位用户的name */
-(NSString *)getMicUserName;

/** 获取 麦位用户的logoUrl */
-(NSString *)getMicUserlogoUrl;


@end

NS_ASSUME_NONNULL_END
