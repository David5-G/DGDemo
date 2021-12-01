//
//  KKVoiceRoomRtcMgr.m
//  kk_espw
//
//  Created by david on 2019/10/16.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKVoiceRoomRtcMgr.h"
#import "KKVoiceRoomVC.h"
//rtc
#import "KKRtcService.h"
#import <RongRTCLib/RongRTCLib.h>


@interface KKVoiceRoomRtcMgr ()
@property (nonatomic, copy) NSString *joinedRoomId;
@property (nonatomic, copy) NSString *joinedRtcChannelId;
@end


@implementation KKVoiceRoomRtcMgr

static KKVoiceRoomRtcMgr *_rtcMgr = nil;
static dispatch_once_t onceToken;

#pragma mark - life circle
+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        _rtcMgr = [[KKVoiceRoomRtcMgr alloc] init];
    });
    return _rtcMgr;
}


#pragma mark - public
-(void)requestJoinRoom:(NSString *)roomId channel:(NSString *)channelId success:(void(^)(void))success {
    //过滤
    if(roomId.length < 1){
        [CC_Notice show:@"房间id不能为空"];
        return;
    }
    if(channelId.length < 1){
        [CC_Notice show:@"聊天室id不能为空"];
        return;
    }
    
    //2. 请求
    WS(weakSelf);
    //2.1 IM连接状态
    [[KKIMMgr shareInstance] checkAndConnectRCSuccess:^{
        //2.2 进入rtc房间
        [weakSelf rtcJoinChannel:channelId success:^{
            //2.3 进入kk房间
            [weakSelf reqJoinRoom:roomId success:success];
        }];
        
    } error:^(RCConnectErrorCode status) {
        [CC_Notice show:@"房间连接失败"];
        return;
    }];
}

-(void)requestLeaveRoom:(NSString *)roomId channel:(NSString *)channelId success:(void(^)(void))success {
    
    //过滤
    roomId = roomId.length>0 ? roomId : self.joinedRoomId;
    if(roomId.length < 1){
        [CC_Notice show:@"房间id不能为空"];
        return;
    }
    
    channelId = channelId.length>0 ? channelId : self.joinedRtcChannelId;
    if(channelId.length < 1){
        [CC_Notice show:@"聊天室id不能为空"];
        return;
    }
    
    //1.离开rtc
    WS(weakSelf)
    [self rtcLeaveChannel:channelId success:^{
        //移除rtc配置
        [[KKVoiceRoomVC shareInstance] removeRtcConfig];
        //2.离开kk
        [weakSelf reqLeaveRoom:roomId success:success];
    }];
}

-(void)requestLeaveRtcRoomByLoginElse:(void (^)(void))success {
    //过滤
    NSString *channelId = self.joinedRtcChannelId;
    if (channelId.length < 1) {
        return;
    }
    //1.离开rtc
    [self rtcLeaveChannel:channelId success:^{
        if (success) {
            success();
        }
    }];
    
    //2.移除rtc配置
    [[KKVoiceRoomVC shareInstance] removeRtcConfig];
}

-(void)checkRoomStatus:(NSString *)roomId success:(void(^)(void))success {
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"ENTER_VOICE_CHAT_ROOM_CONSULT" forKey:@"service"];
    [params safeSetObject:roomId forKey:@"roomId"];
    
    //2.请求
    MaskProgressBlackBackHUD *HUD = [MaskProgressBlackBackHUD hudStartAnimatingAndAddToView:[KKRootContollerMgr getCurrentWindow]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        NSString *statusStr = responseDic[@"roomStatus"][@"name"];
        if (error) {
            [CC_Notice show:error];
        }else if([statusStr isEqualToString:@"CLOSE"]){
        
        }else {
            if (success) {
                success();
            }
        }
    }];
}


#pragma mark - RTC
-(void)rtcJoinChannel:(NSString *)channelId success:(void(^)(void))success{
    
    WS(weakSelf)
    MaskProgressBlackBackHUD *HUD = [MaskProgressBlackBackHUD hudStartAnimatingAndAddToView:[KKRootContollerMgr getCurrentWindow]];
    [[KKRtcService shareInstance] joinRoom:channelId success:^(RongRTCRoom * _Nonnull room) {
        [HUD stop];
        BBLOG(@"进入rtc语音房 - 成功");
        //成功了, 再去调后台的进入
        dispatch_main_async_safe(^{
            weakSelf.joinedRtcChannelId = channelId;
            if (success) {
                success();
            }
        });
        
    } error:^(RongRTCCode code) {
        [HUD stop];
        BBLOG(@"进入rtc语音房 - 失败");
        NSString *error = [NSString stringWithFormat:@"进入语音房失败！code=%ld",(long)code];
        
        dispatch_main_async_safe(^{
            [CC_Notice show:error];
        });
    }];
}


-(void)rtcLeaveChannel:(NSString *)channelId success:(void(^)(void))success {
    
    WS(weakSelf)
    MaskProgressBlackBackHUD *HUD = [MaskProgressBlackBackHUD hudStartAnimatingAndAddToView:[KKRootContollerMgr getCurrentWindow]];
    [[KKRtcService shareInstance] leaveRoom:channelId success:^{
        [HUD stop];
        BBLOG(@"退出rtc语音房 - 成功");
        //成功了, 再去调后台的退出
        dispatch_main_async_safe(^{
            weakSelf.joinedRtcChannelId = nil;
            if (success) {
                success();
            }
        });
        
        
    } error:^(RongRTCCode code) {
        [HUD stop];
        BBLOG(@"退出rtc语音房 - 失败");
        
        dispatch_main_async_safe(^{
            [CC_Notice show:@"退出语音房失败！"];
        });
    }];
}


#pragma mark - req
/** 请求 进入房间 */
-(void)reqJoinRoom:(NSString *)roomId success:(void(^)(void))success {
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"VOICE_CHAT_ROOM_DETAIL_QUERY" forKey:@"service"];
    [params safeSetObject:roomId forKey:@"roomId"];
    
    //2.请求
    WS(weakSelf)
    MaskProgressBlackBackHUD *HUD = [MaskProgressBlackBackHUD hudStartAnimatingAndAddToView:[KKRootContollerMgr getCurrentWindow]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_Notice show:error];
            
        }else{
            //NSDictionary *responseDic = resModel.resultDic[@"response"];
            weakSelf.joinedRoomId = roomId;
            if (success) {
                success();
            }
        }
    }];
}

/** 请求 离开房间 */
-(void)reqLeaveRoom:(NSString *)roomId success:(void(^)(void))success {
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"VOICE_CHAT_ROOM_CLOSE" forKey:@"service"];
    [params safeSetObject:roomId forKey:@"roomId"];
    
    //2.请求
    WS(weakSelf)
    MaskProgressBlackBackHUD *HUD = [MaskProgressBlackBackHUD hudStartAnimatingAndAddToView:[KKRootContollerMgr getCurrentWindow]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_Notice show:error];
            
        }else{
            //NSDictionary *responseDic = resModel.resultDic[@"response"];
            weakSelf.joinedRoomId = nil;
            if (success) {
                success();
            }
        }
    }];
}

#pragma mark - tool
-(BOOL)isJoinedRoom:(NSString *)roomId channel:(NSString *)channelId;
 {
     if (roomId.length < 1 ||
         channelId.length < 1) {
         return NO;
     }
     
    if ([roomId isEqualToString:self.joinedRoomId] &&
        [channelId isEqualToString:self.joinedRtcChannelId]) {
        return YES;
    }
     
    return NO;
}


@end
