//
//  KKVoiceRoomViewModel.m
//  kk_espw
//
//  Created by david on 2019/10/17.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKVoiceRoomViewModel.h"
//model
#import "KKVoiceRoomModel.h"
#import "KKH5Service.h"
#import "KKH5Url.h"
@interface KKVoiceRoomViewModel ()
@property (nonatomic, strong) KKVoiceRoomModel *model;
@property (nonatomic, copy) NSString *shareUrl;
@property (nonatomic, assign) BOOL needUpdateShareUrl;
@end


@implementation KKVoiceRoomViewModel

#pragma mark - setter
-(void)setRoomId:(NSString *)roomId {
    _roomId = [roomId copy];
    self.needUpdateShareUrl = YES;
}

#pragma mark - 房间信息
-(void)requestVoiceRoomInfo:(KKVoiceRoomBlock)success {
    
    if(self.roomId.length < 1){
        [CC_Notice show:@"未设置语音房id"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"VOICE_CHAT_ROOM_DETAIL_QUERY" forKey:@"service"];
    [params safeSetObject:self.roomId forKey:@"roomId"];
    
    //2.请求
    //MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    WS(weakSelf);
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        //[HUD stop];
        
        if (error) {
            [CC_Notice show:error atView: [KKRootContollerMgr getCurrentWindow]];
            [weakSelf triggerBlock:success byCode:-1];
            
        }else{
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            weakSelf.model = [KKVoiceRoomModel mj_objectWithKeyValues:responseDic];
            [weakSelf triggerBlock:success byCode:0];
            
            //是否需要刷新shareUrl
            if (self.needUpdateShareUrl) {
                [weakSelf requestForShareUrl];
            }
        }
    }];
}

/** 分享查询 */
- (void)requestForShareUrl {
    WS(weakSelf)
    [KKH5Service requestH5URLDataSuccess:^(KKH5Url * _Nonnull modelURL) {
        /// roomId shareHeadUrl roomName type
        NSArray *urls = [modelURL.SHARE_DOWNLOAD componentsSeparatedByString:@"?"];
        NSString *frantStr = urls.firstObject;
        NSString *lastStr = urls.lastObject;
        NSString *shareHeadUrl = weakSelf.model.voiceRoom.ownerUserLogoUrl;
        NSString *roomName = [weakSelf.model.voiceRoom.chatRoomTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSInteger roomId = weakSelf.roomId.integerValue;
        weakSelf.shareUrl = [NSString stringWithFormat:@"%@?shareHeadUrl=%@&roomName=%@&roomId=%zi&type=voice&%@", frantStr, shareHeadUrl, roomName, roomId, lastStr];
        CCLOG(@"语音房分享链接 === %@", weakSelf.shareUrl);
        weakSelf.needUpdateShareUrl = NO;
    } Fail:^{
    }];
}

-(void)requestVoicRoomQuit:(KKVoiceRoomBlock)success {
    
    if(self.roomId.length < 1){
        [CC_Notice show:@"未设置语音房id"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"VOICE_CHAT_ROOM_CLOSE" forKey:@"service"];
    [params safeSetObject:self.roomId forKey:@"roomId"];
    
    //2.请求
    //MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    WS(weakSelf);
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        //[HUD stop];
        
        if (error) {
            [CC_Notice show:error atView: [KKRootContollerMgr getCurrentWindow]];
            [weakSelf triggerBlock:success byCode:-1];
            
        }else{
            //NSDictionary *responseDic = resModel.resultDic[@"response"];
            [weakSelf triggerBlock:success byCode:0];
        }
    }];
}

-(void)requestKickUser:(NSString *)userId success:(KKVoiceRoomBlock)success {
    
    if(self.roomId.length < 1){
        [CC_Notice show:@"未设置语音房id"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    if(userId.length < 1){
        [CC_Notice show:@"用户id有误"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"VOICE_CHAT_ROOM_KICK_PLAYER" forKey:@"service"];
    [params safeSetObject:self.roomId forKey:@"roomId"];
    [params safeSetObject:userId forKey:@"targetUserId"];
    
    //2.请求
    //MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    WS(weakSelf);
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        //[HUD stop];
        
        if (error) {
            [CC_Notice show:error atView: [KKRootContollerMgr getCurrentWindow]];
            [weakSelf triggerBlock:success byCode:-1];
            
        }else{
            //NSDictionary *responseDic = resModel.resultDic[@"response"];
            [CC_Notice show:@"移出成功"];
            [weakSelf triggerBlock:success byCode:0];
        }
    }];
}

#pragma mark - 麦位
/** 请求 设置麦位 */
-(void)requestMicClose:(BOOL)isClose micId:(NSInteger)micId success:(KKVoiceRoomBlock)success {
    
    if(self.roomId.length < 1){
        [CC_Notice show:@"未设置语音房id"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"VOICE_CHAT_ROOM_MIC_CLOSE_SET" forKey:@"service"];
    [params safeSetObject:self.roomId forKey:@"roomId"];
    [params safeSetObject:@(!isClose) forKey:@"enabled"];
    [params safeSetObject:@(micId) forKey:@"micId"];
    
    //2.请求
    WS(weakSelf);
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_Notice show:error atView: [KKRootContollerMgr getCurrentWindow]];
            [weakSelf triggerBlock:success byCode:-1];
            
        }else{
            //NSDictionary *responseDic = resModel.resultDic[@"response"];
            [weakSelf triggerBlock:success byCode:0];
        }
    }];
}


-(void)requestMicGet:(NSInteger)micId oldMicId:(NSInteger)oldMicId success:(KKVoiceRoomBlock)success {
    
    if(self.roomId.length < 1){
        [CC_Notice show:@"未设置语音房id"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"VOICE_CHAT_ROOM_ADD_MIC" forKey:@"service"];
    [params safeSetObject:self.roomId forKey:@"roomId"];
    [params safeSetObject:@(micId) forKey:@"newMicId"];
    [params safeSetObject:@(oldMicId) forKey:@"oldMicId"];
    
    //2.请求
    WS(weakSelf);
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_Notice show:error atView: [KKRootContollerMgr getCurrentWindow]];
            [weakSelf triggerBlock:success byCode:-1];
            
        }else{
            //NSDictionary *responseDic = resModel.resultDic[@"response"];
            [weakSelf triggerBlock:success byCode:0];
        }
    }];
}


-(void)requestMicQuit:(KKVoiceRoomBlock)success {
    
    if(self.roomId.length < 1){
        [CC_Notice show:@"未设置语音房id"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"VOICE_CHAT_ROOM_REMOVE_MIC" forKey:@"service"];
    [params safeSetObject:self.roomId forKey:@"roomId"];
    
    //2.请求
    WS(weakSelf);
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_Notice show:error atView: [KKRootContollerMgr getCurrentWindow]];
            [weakSelf triggerBlock:success byCode:-1];
            
        }else{
            //NSDictionary *responseDic = resModel.resultDic[@"response"];
            [weakSelf triggerBlock:success byCode:0];
        }
    }];
}


-(void)requestMicGive:(NSString *)userId micId:(NSInteger)micId success:(KKVoiceRoomBlock)success {
    
    if(self.roomId.length < 1){
        [CC_Notice show:@"未设置语音房id"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    if(userId.length < 1){
        [CC_Notice show:@"用户id有误"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"VOICE_CHAT_ROOM_GIVE_MIC" forKey:@"service"];
    [params safeSetObject:self.roomId forKey:@"roomId"];
    [params safeSetObject:userId forKey:@"targetUserId"];
    [params safeSetObject:@(micId) forKey:@"micId"];
    
    //2.请求
    WS(weakSelf);
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_Notice show:error atView: [KKRootContollerMgr getCurrentWindow]];
            [weakSelf triggerBlock:success byCode:-1];
            
        }else{
            //NSDictionary *responseDic = resModel.resultDic[@"response"];
            [weakSelf triggerBlock:success byCode:0];
        }
    }];
}

-(void)requestMicTakeAway:(NSString *)userId success:(KKVoiceRoomBlock)success {
    
    if(self.roomId.length < 1){
        [CC_Notice show:@"未设置语音房id"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    if(userId.length < 1){
        [CC_Notice show:@"用户id有误"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"VOICE_CHAT_ROOM_TAKEAWAY_MIC" forKey:@"service"];
    [params safeSetObject:self.roomId forKey:@"roomId"];
    [params safeSetObject:userId forKey:@"targetUserId"];
    
    //2.请求
    WS(weakSelf);
    [CC_Mask getInstance];
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_Notice show:error atView: [KKRootContollerMgr getCurrentWindow]];
            [weakSelf triggerBlock:success byCode:-1];
            
        }else{
            //NSDictionary *responseDic = resModel.resultDic[@"response"];
            [weakSelf triggerBlock:success byCode:0];
        }
    }];
}



#pragma mark tool
-(void)triggerBlock:(_Nullable KKVoiceRoomBlock)block byCode:(NSInteger)code {
    if (block) {
        block(code);
    }
}

#pragma mark - tool
/** 进入直播间时, 已进入直播间的user */
-(NSArray *)firstJoinUsers {
    return self.model.firstJoinUsers;
}

/** 在线人数 */
-(NSInteger)onlineUserCount {
    return self.model.inChannelUserCount;
}

/** 麦位users */
-(NSArray *)micPSimples {
    return self.model.voiceRoom.micPSimples;
}

-(BOOL)isForbidWord {
    return self.model.isForbidChat;
}

/** 语音房样例model */
-(KKVoiceRoomSimpleModel *)voiceRoomSimple {
    return self.model.voiceRoom;
}



@end
