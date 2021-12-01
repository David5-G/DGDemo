//
//  KKGameRoomOwnerController.h
//  kk_espw
//
//  Created by hsd on 2019/7/31.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameRoomBaseController.h"

NS_ASSUME_NONNULL_BEGIN
/// 开黑房页面
@interface KKGameRoomOwnerController : KKGameRoomBaseController
/// 单例
+ (instancetype _Nonnull)sharedInstance;

/// 尝试加入开黑房
- (void)joinGameRoomWithGameBoardId:(NSString *_Nullable)gameboardId
                            Success:(void(^_Nullable)(void))successBlock;

/// 退出开黑房
- (void)exitGameRoomWithSuccess:(void(^_Nullable)(void))successBlock;

/// 移除rtc
- (void)removeRtcConfig;

- (void)pushSelfByNavi:(UINavigationController *)navi;

- (void)requestLeaveRtcRoomByLoginElse:(void( ^ _Nullable )(void))success;
@end

NS_ASSUME_NONNULL_END
