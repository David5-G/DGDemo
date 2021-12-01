//
//  KKRtcService.m
//  kk_espw
//
//  Created by david on 2019/7/25.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKRtcService.h"

@interface KKRtcService () 
@property (nonatomic, strong) RongRTCRoom *rtcRoom;
@property (nonatomic, strong) RongRTCVideoCaptureParam *captureParam;
@property (nonatomic, strong) RongRTCAVCapturer *capturer;
@end

@implementation KKRtcService

static KKRtcService *rongRtcMgr = nil;
static dispatch_once_t onceToken;

#pragma mark - getter/setter
#pragma mark getter
- (RongRTCAVCapturer *)capturer {
    if(!_capturer) {
        _capturer = [RongRTCAVCapturer sharedInstance];
    }
    return _capturer;
}
- (RongRTCVideoCaptureParam *)captureParam {
    if(!_captureParam) {
        _captureParam = [[RongRTCVideoCaptureParam alloc] init];
        _captureParam.turnOnCamera = NO;
    }
    return _captureParam;
    
}

#pragma mark setter
- (void)setMuteAllVoice:(BOOL)mute {
    _muteAllVoice = mute;
    
    for(RongRTCRemoteUser *remoteUser in self.rtcRoom.remoteUsers) {
        for(RongRTCAVInputStream *stream in remoteUser.remoteAVStreams) {
            if(stream.streamType == RTCMediaTypeAudio) {
                stream.disable = mute;
            }
        }
    }
}


#pragma mark - life circle
+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        rongRtcMgr = [[KKRtcService alloc] init];
    });
    return rongRtcMgr;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addNotificationForAudioRouteChange];
    }
    return self;
}

-(void)dealloc {
    //1.移除通知
    [self removeNofifcationForAudioRouteChange];
}

/** 清空 */
- (void)remove{
    
    //释放self
    rongRtcMgr = nil;
    onceToken = 0;
}

#pragma mark - notification
-(void)addNotificationForAudioRouteChange {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:)   name:AVAudioSessionRouteChangeNotification object:nil];
}

-(void)removeNofifcationForAudioRouteChange {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionRouteChangeNotification object:nil];
}

- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *interuptionDict = notification.userInfo;
        NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
        BBLOG(@"KKRtcService --- audioRouteChangeListenerCallback");
        switch (routeChangeReason) {
            case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
               //耳机插入 关闭扬声器播放
                [self useSpeaker:NO];
                break;
            case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
                //耳机拔出 打开扬声器播放
                [self useSpeaker:YES];
                break;
            case AVAudioSessionRouteChangeReasonCategoryChange:
                // called at start - also when other audio wants to play
                BBLOG(@"AVAudioSessionRouteChangeReasonCategoryChange");
                break;
        }
    });
}


/** 判断是否 有耳机  */
- (BOOL)hasHeadphones {
      AVAudioSession *audioSession = [AVAudioSession sharedInstance];
      AVAudioSessionRouteDescription *currentRoute = [audioSession currentRoute];

      for (AVAudioSessionPortDescription *output in currentRoute.outputs) {
            if ([[output portType] isEqualToString:AVAudioSessionPortHeadphones]) {
                  return YES;
            }
      }
      return NO;
}

#pragma mark - rtc
- (void)setRTCRoomDelegate:(id<RongRTCRoomDelegate>)delegate {
    if(!self.rtcRoom) {
        //[CC_Notice show:@"尚未加入房间，无法设置代理"];
        return;
    }
    self.rtcRoom.delegate = delegate;
}

-(void)setRTCEngineDelegate:(id<RongRTCActivityMonitorDelegate>)delegate {
    [RongRTCEngine sharedEngine].monitorDelegate = delegate;
}


#pragma mark 加入/退出 rtc 房间
- (void)joinRoom:(NSString *)roomId success:(void (^)( RongRTCRoom  * _Nullable room))success error:(void (^)(RongRTCCode code))error {
    
    [[RongRTCEngine sharedEngine] joinRoom:roomId completion:^(RongRTCRoom * _Nullable room, RongRTCCode code) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(RongRTCCodeSuccess == code) {
                self.rtcRoom = room;
                if(success) {
                    [self resetUseSpeaker];
                    success(room);
                }
                
            }else if(RongRTCCodeJoinRepeatedRoom == code || RongRTCCodeJoinToSameRoom == code) {
                //当 RTC 出现此类错误时，RTC 不会再下发room对象，只能用上次的room
                if (self.rtcRoom) {
                    if(success) {
                        [self resetUseSpeaker];
                        success(self.rtcRoom);
                    }
                }else{
                    error(code);
                }
                
            }else {
                if(error) {
                    error(code);
                }
            }
            
        });
    }];
}

- (void)leaveRoom:(NSString*)roomId success:(void (^)(void))success error:(void (^)(RongRTCCode code))error {
    
    [[RongRTCEngine sharedEngine] leaveRoom:roomId completion:^(BOOL isSuccess, RongRTCCode code) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            BBLOG(@"离开 RTCRoom ，code = %ld",(long)code);
            
            //成功 或 不再房间中 或 没有匹配的RTC room
            if(isSuccess ||
               RongRTCCodeSuccess == code ||
               RongRTCCodeNotInRoom == code ||
               RongRTCCodeNoMatchedRoom == code ||
               RongRTCCodeInternalError == code) {
                
                self.rtcRoom = nil;
                if(success) {
                    success();
                }
                
            }else {
                if(error) {
                    error(code);
                }
            }
            
        });
    }];
}


#pragma mark 音频流
/** 发布 音视频流 */
- (void)pulishCurrentUserAudioStream {
    if(!self.rtcRoom) {
        //[CC_Notice show:@"尚未加入房间，不能发布音频"];
        return;
    }
    
    //1.采集
    self.captureParam.turnOnCamera = NO;
    [self.capturer setCaptureParam:self.captureParam];
    [self.capturer startCapture];
    
    //2.发布
    [self.rtcRoom publishDefaultAVStream:^(BOOL isSuccess, RongRTCCode desc) {
        BBLOG(@"当前用户发布音频流 %@",@(desc));
    }];
}

/** 取消发布 音视频流 */
- (void)unpublishCurrentUserAudioStream {
    //不在房间
    if(!self.rtcRoom) {
        return;
    }
    //1.关闭采集
    [self.capturer stopCapture];
    
    //2.取消发布
    [self.rtcRoom unpublishDefaultAVStream:^(BOOL isSuccess, RongRTCCode desc) {
        BBLOG(@"当前用户取消发送音视频流 %@",@(desc));
    }];
    
}

/** 订阅 远端音频stream */
- (void)subscribeRemoteUserAudioStream:(NSString *)userId {
     //串行队列,异步处理
    dispatch_queue_t queue = dispatch_queue_create("kk.rtcService.audioStream", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        
        if(!self.rtcRoom) {
            return;
        }
        
        if(userId.length < 1){
            return;
        }
        
        RongRTCRemoteUser *remoteUser = [self getRTCRemoteUser:userId];
        if(remoteUser.remoteAVStreams.count <= 0) {
            //BBLOG(@"subscribe --- user:%@ streams:%@",remoteUser.userId,remoteUser.remoteAVStreams);
            return;
        }
        
        [self.rtcRoom subscribeAVStream:remoteUser.remoteAVStreams tinyStreams:nil completion:^(BOOL isSuccess, RongRTCCode desc) {
            BOOL mute = [KKRtcService shareInstance].muteAllVoice;
            for(RongRTCAVInputStream *stream in remoteUser.remoteAVStreams) {
                if(stream.streamType == RTCMediaTypeAudio) {
                    stream.disable = mute;
                }
            }
            BBLOG(@"subscribe --- 订阅流 %@ success:%@ code:%@",remoteUser.userId,@(isSuccess),@(desc));
        }];
    });
}

/** 取消订阅 远端音频stream */
- (void)unsubscribeRemoteUserAudioStream:(NSString *)userId {
    
    //串行队列,异步处理
    dispatch_queue_t queue = dispatch_queue_create("kk.rtcService.audioStream", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        
        if(!self.rtcRoom) {
            return;
        }
        
        RongRTCRemoteUser *remoteUser = [self getRTCRemoteUser:userId];
        if(remoteUser.remoteAVStreams.count <= 0) {
            BBLOG(@"unsubscribe --- user:%@ streams:%@",remoteUser.userId,remoteUser.remoteAVStreams);
            return;
        }
        
        [self.rtcRoom unsubscribeAVStream:remoteUser.remoteAVStreams completion:^(BOOL isSuccess, RongRTCCode desc) {
            BBLOG(@"unsubscribe %@ success:%@ code:%@",remoteUser.userId,@(isSuccess),@(desc));
        }];
    });
}


#pragma mark - tool
#pragma mark capturer
- (void)setMicrophoneDisable:(BOOL)disable {
    [self.capturer setMicrophoneDisable:disable];
}

- (void)useSpeaker:(BOOL)use {
    [self.capturer useSpeaker:use];
}

-(void)resetUseSpeaker {
    BOOL has = [self hasHeadphones];
    [self useSpeaker:!has];
}

#pragma mark RemoteUser
/** 获取 rtcRemoteUser */
- (RongRTCRemoteUser *)getRTCRemoteUser:(NSString *)userId{
    for (RongRTCRemoteUser *user in self.rtcRoom.remoteUsers) {
        if ([userId isEqualToString:user.userId]) {
            return user;
        }
    }
    return nil;
}

@end
