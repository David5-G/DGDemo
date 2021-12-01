//
//  KKLiveStudioRtcMgr.h
//  kk_espw
//
//  Created by david on 2019/8/6.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKLiveStudioRtcMgr : NSObject

#pragma mark - life circle
+ (instancetype)shareInstance;

#pragma mark - service
/** 请求 进入招募厅
 *  先加入rtc,再请求后台的加入接口
 */
-(void)requestJoinStudio:(NSString *)studioId success:(void(^)(void))success;

/** 请求 离开招募厅
 *  先请求后台的离开接口, 再离开rtc (因为要在离开rtc之前,取消发布,取消订阅)
 */
-(void)requestLeaveStudio:(NSString *)studioId success:(void(^)(void))success;


/** 请求 离开rtc语音房 */
-(void)requestLeaveRtcRoomByLoginElse:(void( ^ _Nullable )(void))success;

#pragma mark - tool
/** 是否加入了某招募厅 */
-(BOOL)isJoinedStudio:(NSString *)stutioId;

@end

NS_ASSUME_NONNULL_END
