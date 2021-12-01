//
//  KKGameRoomManager.h
//  kk_espw
//
//  Created by hsd on 2019/8/14.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKGameRoomManager : NSObject

/// 单例
+ (instancetype _Nonnull)sharedInstance;

/// 尝试加入开黑房
- (void)joinGameRoomWithGameBoardId:(NSString *_Nullable)gameboardId
                            Success:(void(^_Nullable)(void))successBlock;

/**
 退出开黑房
 @param successBlock  是否退出成功
 */
- (void)exitFromGameRoomWithSuccess:(void(^_Nullable)(void))successBlock;

@end
