//
//  KKLiveStudioViewModel.m
//  kk_espw
//
//  Created by david on 2019/7/31.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioViewModel.h"
#import "KKLiveStudioModel.h"
#import "KKChatRoomMetalSimpleModel.h"

@interface KKLiveStudioViewModel ()
@property (nonatomic, strong) KKLiveStudioModel *model;
@property (nonatomic, assign) BOOL isHostIdentity;//是否有主播权限
@property (nonatomic, assign) BOOL isForbidWordChat;//是否被禁言
@property (nonatomic, copy) NSString *hostId;
@end


@implementation KKLiveStudioViewModel

#pragma mark - request
#pragma mark 招募厅
/** 请求 招募厅信息 */
-(void)requestLiveStudioInfo:(KKLiveStudioBlock)success {
    
    if(self.studioId.length < 1){
        [CC_Notice show:@"未设置招募厅id"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"CHANNEL_INFO_QUERY" forKey:@"service"];
    [params safeSetObject:self.studioId forKey:@"channelId"];
    
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
            weakSelf.isHostIdentity = [responseDic[@"canPreside"] boolValue];
            weakSelf.isForbidWordChat = [responseDic[@"isForbidChat"] boolValue];
            weakSelf.model = [KKLiveStudioModel mj_objectWithKeyValues:responseDic];
            [weakSelf triggerBlock:success byCode:0];
        }
    }];
}



#pragma mark 主播
/** 请求 查看是不是主播身份  */
-(void)requestHostIdentityCheck:(KKLiveStudioBlock)success {
    
    if(self.studioId.length < 1){
        [CC_Notice show:@"未设置招募厅id"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"ANCHOR_IDENTITY_CONSULT" forKey:@"service"];
    [params safeSetObject:self.studioId forKey:@"channelId"];
    
    //2.请求
    WS(weakSelf);
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_Notice show:error atView: [KKRootContollerMgr getCurrentWindow]];
            [weakSelf triggerBlock:success byCode:-1];
            
        }else{
            SS(strongSelf);
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            strongSelf.hostId = [NSString stringWithFormat:@"%@",responseDic[@"anchorId"]];
            strongSelf.isHostIdentity = [responseDic[@"isAnchor"] boolValue];
            [strongSelf triggerBlock:success byCode:strongSelf.isHostIdentity];
        }
    }];
}

/** 请求 设置主播麦的状态 */
-(void)requestHostMicSet:(BOOL)isClose success:(KKLiveStudioBlock)success {
    
    if(self.studioId.length < 1){
        [CC_Notice show:@"未设置招募厅id"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"ANCHOR_CLOSE_MIC" forKey:@"service"];
    [params safeSetObject:self.studioId forKey:@"channelId"];
    [params safeSetObject:@(isClose) forKey:@"closeMic"];
    
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


/** 请求 获得主播mic */
-(void)requestHostMicGet:(KKLiveStudioBlock)success {
    
    if(self.studioId.length < 1){
        [CC_Notice show:@"未设置招募厅id"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"ANCHOR_PRESIDE_LIVE" forKey:@"service"];
    [params safeSetObject:self.studioId forKey:@"channelId"];
    
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

/** 请求 退出主播mic */
-(void)requestHostMicQuit:(KKLiveStudioBlock)success {
    
    if(self.studioId.length < 1){
        [CC_Notice show:@"未设置招募厅id"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"ANCHOR_ENDS_LIVE_BROADCAST" forKey:@"service"];
    [params safeSetObject:self.studioId forKey:@"channelId"];
    
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


#pragma mark 麦位
/** 请求 设置麦位 */
-(void)requestMicSet:(BOOL)isClose success:(KKLiveStudioBlock)success {
    
    if(self.studioId.length < 1){
        [CC_Notice show:@"未设置招募厅id"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"CHANNEL_MIC_CLOSE_SET" forKey:@"service"];
    [params safeSetObject:self.studioId forKey:@"channelId"];
    [params safeSetObject:@(isClose) forKey:@"closeMic"];
    
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

/** 请求 抱某user上麦 */
-(void)requestMicGive:(NSString *)userId success:(KKLiveStudioBlock)success {
    
    if(self.studioId.length < 1){
        [CC_Notice show:@"未设置招募厅id"];
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
    [params setObject:@"CHANNEL_MIC_USER_GIVE_MIC" forKey:@"service"];
    [params safeSetObject:self.studioId forKey:@"channelId"];
    [params safeSetObject:userId forKey:@"userId"];
    
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

/** 请求 下麦 */
-(void)requestMicQuit:(NSString *)userId success:(KKLiveStudioBlock)success {
    
    if(self.studioId.length < 1){
        [CC_Notice show:@"未设置招募厅id"];
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
    [params setObject:@"CHANNEL_MIC_USER_REMOVE" forKey:@"service"];
    [params safeSetObject:self.studioId forKey:@"channelId"];
    [params safeSetObject:userId forKey:@"userId"];
    [params safeSetObject:@(1) forKey:@"removeType"];
    
    //2.请求
    WS(weakSelf);
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        //SS(strongSelf);
        
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

-(void)triggerBlock:(_Nullable KKLiveStudioBlock)block byCode:(NSInteger)code {
    if (block) {
        block(code);
    }
}


#pragma mark - tool
#pragma mark 招募厅
/** 招募厅名字 */
-(NSString *)studioName {
    return self.model.studio.name;
}

-(BOOL)isLiving {
    //直播间状态：LIVE-直播中，BREAK-直播结束
    if ([self.model.studio.status isEqualToString:@"LIVE"]) {
        return YES;
    }
    return NO;
}

-(BOOL)canBeHost {
    return self.isHostIdentity;
}

-(BOOL)cannotSendTextMsg {
    return self.isForbidWordChat;
}

/** 进入直播间时, 已进入直播间的user */
-(NSArray *)firstJoinUsers {
    
    return self.model.firstJoinUsers;
}

/** 在线人数 */
-(NSInteger)onlineUserCount {
    return self.model.studio.inChannelUserCount;
}

#pragma mark 主播位
-(NSString *)getHostId {
    return self.model.host.hostId;
}

/** 获取主播 的userId */
-(NSString *)getHostUserId {
    return self.model.host.userId;
}

/** 获取主播 的name */
-(NSString *)getHostName {
    NSString *name = self.model.host.loginName;
    if (name.length > 8) {
        name = [name substringToIndex:8];
        return [name stringByAppendingString:@"..."];
    }
    return name;
}

/** 获取主播 的logoUrl */
-(NSString *)getHostLogoUrl {
    return self.model.host.userLogoUrl;
}

#pragma mark 麦位
-(BOOL)isMicPostionClosed {
    return self.model.studio.closeMic;
}

-(NSString *)getMicUserId {
    return self.model.micUser.userId;
}

-(NSString *)getMicUserName {
    NSString *name = self.model.micUser.loginName;
    if (name.length > 8) {
        name = [name substringToIndex:8];
        return [name stringByAppendingString:@"..."];
    }
    return name;
}

-(NSString *)getMicUserlogoUrl {
    return self.model.micUser.userLogoUrl;
}





@end
