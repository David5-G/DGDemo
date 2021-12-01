//
//  KKLiveStudioUserListViewModel.h
//  kk_espw
//
//  Created by david on 2019/7/31.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioBaseViewModel.h"
//model
#import "KKPaginator.h"
#import "KKLiveStudioUserSimpleModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 在具体请求中看code的意义 */
typedef void(^KKLiveStudioUserListBlock)(NSInteger code);

@interface KKLiveStudioUserListViewModel : NSObject

/** 聊天室的id */
@property (nonatomic, copy) NSString *channelId;

#pragma mark - 在线
/** 在线用户总数 */
@property (nonatomic, assign) NSInteger onlineTotalUserCount;

/** 在线列表的paginator */
@property (nonatomic, strong,nullable) KKPaginator *onlinePaginator;

/** 在线用户 */
@property (nonatomic, strong) NSMutableArray <KKLiveStudioUserSimpleModel *>*onlineUsers;

/** 请求 在线用户
 * code=-3  请求被拦截,超页了noMoreData
 * code=-2  请求被拦截,
 * code=-1  请求失败
 * code=0   请求成功,获取了数据
 */
-(void)requestOnlineUsers:(KKLiveStudioUserListBlock)success;



#pragma mark - 排麦
/** 排麦用户 */
@property (nonatomic, strong) NSArray <KKLiveStudioUserSimpleModel *>*micRankUsers;

/** 请求 排麦用户
 * code=-2  请求被拦截,
 * code=-1 请求失败
 * code=0  请求成功, 不在麦上
 * code=x  请求成功,x>0代表当前排麦序号(第几名)
 */
-(void)requestMicRankUsers:(KKLiveStudioUserListBlock)success;

/** 请求 加入排麦
 * code=-2  请求被拦截,
 * code=-1 请求失败
 * code=0  请求成功,加入排麦
 */
-(void)requestMicRankJoin:(KKLiveStudioUserListBlock)success;

/** 请求 取消排麦
 * code=-2  请求被拦截,
 * code=-1 请求失败
 * code=0  请求成功,退出排麦
 */
-(void)requestMicRankQuit:(NSString *)userId success:(KKLiveStudioUserListBlock)success;;



#pragma mark - 禁言
/** 禁言列表的paginator */
@property (nonatomic, strong,nullable) KKPaginator *forbidWordPaginator;

/** 禁言用户列表 */
@property (nonatomic, strong) NSMutableArray <KKLiveStudioUserSimpleModel *>*forbidWordUsers;

/** 请求 禁言用户列表
 * code=-3  请求被拦截,超页了noMoreData
 * code=-2  请求被拦截,
 * code=-1  请求失败
 * code=0   请求成功,获取了数据
 */
-(void)requestForbidWordUsers:(KKLiveStudioUserListBlock)success;

/** 请求 禁言某用户
 * code=-2  请求被拦截,
 * code=-1  请求失败
 * code=0   请求成功,获取了数据
 */
-(void)requestForbidWord:(NSString *)userId success:(KKLiveStudioUserListBlock)success;

/** 请求 取消禁言某用户
 * code=-2  请求被拦截,
 * code=-1  请求失败
 * code=0   请求成功,获取了数据
 */
-(void)requestForbidWordCancel:(NSString *)userId success:(KKLiveStudioUserListBlock)success;

/** 请求 查询 是否被禁言
 * code=-2  请求被拦截,
 * code=-1  请求失败
 * code=0   请求成功,没被禁言
 * code=0   请求成功,被禁言
 */
-(void)requestForbidWordCheck:(NSString *)userId success:(KKLiveStudioUserListBlock)success;




@end

NS_ASSUME_NONNULL_END
