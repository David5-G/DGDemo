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
#import "KKChatRoomUserSimpleModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 在具体请求中看code的意义 */
typedef void(^KKChatRoomUserListBlock)(NSInteger code);

@interface KKChatRoomUserListViewModel : NSObject

/** 聊天室的id */
@property (nonatomic, copy) NSString *channelId;

/** 是否需要跳过权限校验 true为跳过
 *  语音房 要设为true
 *  招募厅 要设为false
 */
@property (nonatomic, assign) BOOL canForbidConsult;

#pragma mark - 在线
/** 在线用户总数 */
@property (nonatomic, assign) NSInteger onlineTotalUserCount;

/** 在线列表的paginator */
@property (nonatomic, strong,nullable) KKPaginator *onlinePaginator;

/** 在线用户 */
@property (nonatomic, strong) NSMutableArray <KKChatRoomUserSimpleModel *>*onlineUsers;

/** 请求 在线用户
 * code=-3  请求被拦截,超页了noMoreData
 * code=-2  请求被拦截,
 * code=-1  请求失败
 * code=0   请求成功,获取了数据
 */
-(void)requestOnlineUsers:(KKChatRoomUserListBlock)success;



#pragma mark - 排麦
/** 排麦用户 */
@property (nonatomic, strong) NSArray <KKChatRoomUserSimpleModel *>*micRankUsers;

/** 请求 排麦用户
 * code=-2  请求被拦截,
 * code=-1 请求失败
 * code=0  请求成功, 不在麦上
 * code=x  请求成功,x>0代表当前排麦序号(第几名)
 */
-(void)requestMicRankUsers:(KKChatRoomUserListBlock)success;

/** 请求 加入排麦
 * code=-2  请求被拦截,
 * code=-1 请求失败
 * code=0  请求成功,加入排麦
 */
-(void)requestMicRankJoin:(KKChatRoomUserListBlock)success;

/** 请求 取消排麦
 * code=-2  请求被拦截,
 * code=-1 请求失败
 * code=0  请求成功,退出排麦
 */
-(void)requestMicRankQuit:(NSString *)userId success:(KKChatRoomUserListBlock)success;;



#pragma mark - 禁言
/** 禁言列表的paginator */
@property (nonatomic, strong,nullable) KKPaginator *forbidWordPaginator;

/** 禁言用户列表 */
@property (nonatomic, strong) NSMutableArray <KKChatRoomUserSimpleModel *>*forbidWordUsers;

/** 请求 禁言用户列表
 * code=-3  请求被拦截,超页了noMoreData
 * code=-2  请求被拦截,
 * code=-1  请求失败
 * code=0   请求成功,获取了数据
 */
-(void)requestForbidWordUsers:(KKChatRoomUserListBlock)success;

/** 请求 禁言某用户
 * code=-2  请求被拦截,
 * code=-1  请求失败
 * code=0   请求成功,获取了数据
 */
-(void)requestForbidWord:(NSString *)userId success:(KKChatRoomUserListBlock)success;

/** 请求 取消禁言某用户
 * code=-2  请求被拦截,
 * code=-1  请求失败
 * code=0   请求成功,获取了数据
 */
-(void)requestForbidWordCancel:(NSString *)userId success:(KKChatRoomUserListBlock)success;

/** 请求 查询 是否被禁言
 * code=-2  请求被拦截,
 * code=-1  请求失败
 * code=0   请求成功,没被禁言
 * code=0   请求成功,被禁言
 */
-(void)requestForbidWordCheck:(NSString *)userId success:(KKChatRoomUserListBlock)success;




@end

NS_ASSUME_NONNULL_END
