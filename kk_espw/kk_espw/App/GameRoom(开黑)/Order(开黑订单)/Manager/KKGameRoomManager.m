//
//  KKGameRoomManager.m
//  kk_espw
//
//  Created by hsd on 2019/8/14.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameRoomManager.h"
#import "KKGameRoomOwnerController.h"

@interface KKGameRoomManager ()


@end

@implementation KKGameRoomManager

static KKGameRoomManager *_gameRoomManager = nil;

#pragma mark - 单例
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _gameRoomManager = [[self alloc] init];
    });
    return _gameRoomManager;
}

/// 尝试加入开黑房
- (void)joinGameRoomWithGameBoardId:(NSString *_Nullable)gameboardId
                            Success:(void(^_Nullable)(void))successBlock {
    [[KKGameRoomOwnerController sharedInstance] joinGameRoomWithGameBoardId:gameboardId Success:successBlock];
}

/// 退出开黑房
- (void)exitFromGameRoomWithSuccess:(void (^)(void))successBlock {
    [[KKGameRoomOwnerController sharedInstance] exitGameRoomWithSuccess:successBlock];
}


@end
