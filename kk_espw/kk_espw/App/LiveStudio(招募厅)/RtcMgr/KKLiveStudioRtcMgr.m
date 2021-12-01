//
//  KKLiveStudioRtcMgr.m
//  kk_espw
//
//  Created by david on 2019/8/6.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioRtcMgr.h"
//controller
#import "KKLiveStudioVC.h"
//rtc
#import "KKRtcService.h"
#import <RongRTCLib/RongRTCLib.h>


@interface KKLiveStudioRtcMgr ()
@property (nonatomic, copy) NSString *joinedRtcRoomId;
@property (nonatomic, copy) NSString *joinedImRoomId;
@end

@implementation KKLiveStudioRtcMgr

static KKLiveStudioRtcMgr *_rtcMgr = nil;
static dispatch_once_t onceToken;

#pragma mark - life circle
+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        _rtcMgr = [[KKLiveStudioRtcMgr alloc] init];
    });
    return _rtcMgr;
}

#pragma mark - public
/** 请求 进入招募厅 */
-(void)requestJoinStudio:(NSString *)studioId success:(void(^)(void))success {
    if(studioId.length < 1){
        [CC_Notice show:@"招募厅id不能为空"];
        return;
    }

    WS(weakSelf)
    [[KKIMMgr shareInstance] checkAndConnectRCSuccess:^{
        //进入trtc
        [weakSelf rtcJoinStudio:studioId success:^{
            //kk后台进入房间
            [weakSelf reqJoinStudio:studioId success:success];
        }];
        
    } error:^(RCConnectErrorCode status) {
        [CC_Notice show:@"房间连接失败"];
        return;
    }];
}

/** 请求 离开招募厅 */
-(void)requestLeaveStudio:(NSString *)studioId success:(void(^)(void))success {
    WS(weakSelf)
    //1.离开招募厅rtc
    [weakSelf rtcLeaveStudio:studioId success:^{
        //移除rtc配置
        [[KKLiveStudioVC shareInstance] removeRtcConfig];
        //2.kk后台退出房间
        [self reqLeaveStudio:studioId success:success];
    }];
}

-(void)requestLeaveRtcRoomByLoginElse:(void (^)(void))success {
    //过滤
    NSString *studioId = self.joinedRtcRoomId;
    if (studioId.length < 1) {
        return;
    }
    //1.离开rtc
    [self rtcLeaveStudio:studioId success:^{
        if (success) {
            success();
        }
    }];
    
    //移除rtc配置
    [[KKLiveStudioVC shareInstance] removeRtcConfig];
}


#pragma mark - RTC
-(void)rtcJoinStudio:(NSString *)studioId success:(void(^)(void))success{
    WS(weakSelf)
    MaskProgressBlackBackHUD *HUD = [MaskProgressBlackBackHUD hudStartAnimatingAndAddToView:[KKRootContollerMgr getCurrentWindow]];
    [[KKRtcService shareInstance] joinRoom:studioId success:^(RongRTCRoom * _Nonnull room) {
        [HUD stop];
        BBLOG(@"进入rtc招募厅 - 成功");
        //成功了, 再去调后台的进入
        dispatch_main_async_safe(^{
            weakSelf.joinedRtcRoomId = studioId;
            if (success) {
                success();
            }
        });
        
    } error:^(RongRTCCode code) {
        [HUD stop];
        BBLOG(@"进入rtc招募厅 - 失败");
        
        dispatch_main_async_safe(^{
            [CC_Notice show:@"进入招募厅失败！"];
        });
    }];
}

/** 请求 离开招募厅 */
-(void)rtcLeaveStudio:(NSString *)studioId success:(void(^)(void))success {
    
    studioId = studioId.length>0 ? studioId : self.joinedRtcRoomId;
    if(studioId.length < 1){
        [CC_Notice show:@"招募厅id不能为空"];
        return;
    }
    
    WS(weakSelf)
    MaskProgressBlackBackHUD *HUD = [MaskProgressBlackBackHUD hudStartAnimatingAndAddToView:[KKRootContollerMgr getCurrentWindow]];
    [[KKRtcService shareInstance] leaveRoom:studioId success:^{
        [HUD stop];
        BBLOG(@"退出rtc招募厅 - 成功");
        //成功了, 再去调后台的退出
        dispatch_main_async_safe(^{
            weakSelf.joinedRtcRoomId = nil;
            if (success) {
                success();
            }
        });
        
        
    } error:^(RongRTCCode code) {
        [HUD stop];
        BBLOG(@"退出rtc招募厅 - 失败");
        
        dispatch_main_async_safe(^{
            [CC_Notice show:@"退出招募厅失败！"];
        });
    }];
}




#pragma mark - req
/** 请求 进入招募厅 */
-(void)reqJoinStudio:(NSString *)studioId success:(void(^)(void))success {
    
    if(studioId.length < 1){
        [CC_Notice show:@"招募厅id不能为空"];
        return;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"USER_ENTER_CHANNEL" forKey:@"service"];
    [params safeSetObject:studioId forKey:@"channelId"];
    
    //2.请求
    WS(weakSelf)
    MaskProgressBlackBackHUD *HUD = [MaskProgressBlackBackHUD hudStartAnimatingAndAddToView:[KKRootContollerMgr getCurrentWindow]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_Notice show:error];
            
        }else{
            //NSDictionary *responseDic = resModel.resultDic[@"response"];
            weakSelf.joinedImRoomId = studioId;
            if (success) {
                success();
            }
        }
    }];
}

/** 请求 离开招募厅 */
-(void)reqLeaveStudio:(NSString *)studioId success:(void(^)(void))success {
    
    if(studioId.length < 1){
        [CC_Notice show:@"招募厅id不能为空"];
        return;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"USER_LEAVE_CHANNEL" forKey:@"service"];
    [params safeSetObject:studioId forKey:@"channelId"];
    
    //2.请求
    WS(weakSelf)
    MaskProgressBlackBackHUD *HUD = [MaskProgressBlackBackHUD hudStartAnimatingAndAddToView:[KKRootContollerMgr getCurrentWindow]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_Notice show:error];
            
        }else{
            //NSDictionary *responseDic = resModel.resultDic[@"response"];
            weakSelf.joinedImRoomId = nil;
            if (success) {
                success();
            }
        }
    }];
}

#pragma mark - tool
-(BOOL)isJoinedStudio:(NSString *)stutioId {
    if ([stutioId isEqualToString:self.joinedRtcRoomId] &&
        [stutioId isEqualToString:self.joinedImRoomId]) {
        return YES;
    }
    return NO;
}



@end
