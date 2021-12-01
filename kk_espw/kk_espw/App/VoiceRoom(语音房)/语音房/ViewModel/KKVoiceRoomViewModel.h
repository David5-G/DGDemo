//
//  KKVoiceRoomViewModel.h
//  kk_espw
//
//  Created by david on 2019/10/17.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
//model
#import "KKVoiceRoomSimpleModel.h"

NS_ASSUME_NONNULL_BEGIN

/** 在具体请求中看code的意义 */
typedef void(^KKVoiceRoomBlock)(NSInteger code);

@interface KKVoiceRoomViewModel : NSObject

@property (nonatomic, copy) NSString *roomId;
@property (nonatomic, copy, readonly) NSString *shareUrl;

#pragma mark  房间信息
/** 请求 房间信息
 * code=-2  请求被拦截,
 * code=-1 请求失败
 * code=0  请求成功
 */
-(void)requestVoiceRoomInfo:(KKVoiceRoomBlock)success;

/** 请求 退出语音房
 * code=-2  请求被拦截,
 * code=-1 请求失败
 * code=0  请求成功
 */
-(void)requestVoicRoomQuit:(KKVoiceRoomBlock)success;

/** 请求 踢人
* code=-2  请求被拦截,
* code=-1 请求失败
* code=0  请求成功
*/
-(void)requestKickUser:(NSString *)userId success:(KKVoiceRoomBlock)success;


#pragma mark  麦位
/** 请求 设置麦位
 * code=-2  请求被拦截,
 * code=-1 请求失败
 * code=0  请求成功
 */
-(void)requestMicClose:(BOOL)isClose micId:(NSInteger)micId success:(KKVoiceRoomBlock)success;

/** 请求 上麦/更换麦位
* code=-2  请求被拦截,
* code=-1 请求失败
* code=0  请求成功
*/
-(void)requestMicGet:(NSInteger)micId oldMicId:(NSInteger)oldMicId success:(KKVoiceRoomBlock)success;

/** 请求 下麦
* code=-2  请求被拦截,
* code=-1 请求失败
* code=0  请求成功
*/
-(void)requestMicQuit:(KKVoiceRoomBlock)success;

/** 请求 抱上麦
* code=-2  请求被拦截,
* code=-1 请求失败
* code=0  请求成功
*/
-(void)requestMicGive:(NSString *)userId micId:(NSInteger)micId success:(KKVoiceRoomBlock)success;

/** 请求 抱下麦
* code=-2  请求被拦截,
* code=-1 请求失败
* code=0  请求成功
*/
-(void)requestMicTakeAway:(NSString *)userId success:(KKVoiceRoomBlock)success;


#pragma mark - tool
/** 进入直播间时, 已进入直播间的user */
-(NSArray *)firstJoinUsers;

/** 在线人数 */
-(NSInteger)onlineUserCount;

/** 是否被禁言 */
-(BOOL)isForbidWord;

/** 麦位users */
-(NSArray *)micPSimples;

/** 语音房样例model */
-(KKVoiceRoomSimpleModel *)voiceRoomSimple;


@end

NS_ASSUME_NONNULL_END
