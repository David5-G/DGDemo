//
//  KKGameRtcMgr.m
//  kk_espw
//
//  Created by jingtian9 on 2019/10/24.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameRtcMgr.h"
#import "KKGameRoomManager.h"
#import "KKRtcService.h"
@implementation KKGameRtcMgr

static KKGameRtcMgr *_rtcMgr = nil;
static dispatch_once_t onceToken;

#pragma mark - life circle
+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        _rtcMgr = [[KKGameRtcMgr alloc] init];
    });
    return _rtcMgr;
}

- (void)requestJoinGameRoomGameBoardId:(NSString *)gameBoardId channelId:(NSString *)channelId success:(void (^)(void))success{
    //1. IM
    [[KKIMMgr shareInstance] checkAndConnectRCSuccess:^{
        //2. 链接rtc房间
        [[KKRtcService shareInstance] joinRoom:channelId success:^(RongRTCRoom * _Nonnull room) {
            //3. 链接后台
            [[KKGameRoomManager sharedInstance] joinGameRoomWithGameBoardId:gameBoardId Success:^{

                success();
            }];
        } error:^(RongRTCCode code) {
            dispatch_main_async_safe(^{
                [CC_Notice show:@"进入开黑房失败！"];
            });
        }];
    } error:^(RCConnectErrorCode status) {
        [CC_Notice show:@"聊天室连接失败"];
    }];
}
@end
