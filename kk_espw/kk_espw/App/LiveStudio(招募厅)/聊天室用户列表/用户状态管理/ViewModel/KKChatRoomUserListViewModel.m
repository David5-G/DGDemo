//
//  KKLiveStudioUserListViewModel.m
//  kk_espw
//
//  Created by david on 2019/7/31.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomUserListViewModel.h"


@interface KKChatRoomUserListViewModel ()

@end

@implementation KKChatRoomUserListViewModel

#pragma mark - lazy load
-(NSMutableArray<KKChatRoomUserSimpleModel *> *)onlineUsers {
    if (!_onlineUsers) {
        _onlineUsers = [NSMutableArray array];
    }
    return _onlineUsers;
}

-(NSMutableArray<KKChatRoomUserSimpleModel *> *)forbidWordUsers {
    if (!_forbidWordUsers) {
        _forbidWordUsers = [NSMutableArray array];
    }
    return _forbidWordUsers;
}

#pragma mark - 在线
/** 请求 在线用户 */
-(void)requestOnlineUsers:(KKChatRoomUserListBlock)success {
    
    //1.未设置studioId过滤
    if(self.channelId.length < 1){
        [CC_Notice show:@"房间id不能为空"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    
    //2.超页过滤
    if (self.onlinePaginator) {
        if (self.onlinePaginator.page > self.onlinePaginator.pages) {
            self.onlinePaginator.page -= 1;
            [self triggerBlock:success byCode:-3];
            return ;
        }
    }
    
    //3.1 参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"CHANNEL_USER_QUERY" forKey:@"service"];
    [params safeSetObject:self.channelId forKey:@"channelId"];
    NSInteger currentP = self.onlinePaginator ? self.onlinePaginator.page : 1;
    [params safeSetObject:@(currentP) forKey:@"currentPage"];
    //[params setObject:@(15) forKey:@"pageSize"];
    
    //3.2 请求
    //MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    WS(weakSelf);
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        SS(strongSelf);
        //[HUD stop];
        
        //4.1 出错
        if (error) {
            [CC_Notice show:error atView: [KKRootContollerMgr getCurrentWindow]];
            //设置paginator
            if (strongSelf.onlinePaginator.page > 1) {
                strongSelf.onlinePaginator.page -= 1;
            }
            //block
            [strongSelf triggerBlock:success byCode:-1];
            return ;
        }
        
        //4.2 成功
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        //设置paginator
        NSDictionary *paginatorDic = responseDic[@"paginator"];
        strongSelf.onlinePaginator = [KKPaginator mj_objectWithKeyValues:paginatorDic];
        
        //设置users
        if (1 == currentP) {
            [strongSelf.onlineUsers removeAllObjects];
        }
        NSArray *dicUsers = responseDic[@"channelUsers"];
        NSArray <KKChatRoomUserSimpleModel *>*modelUsers = [KKChatRoomUserSimpleModel mj_objectArrayWithKeyValuesArray:dicUsers];
        [strongSelf.onlineUsers addObjectsFromArray:modelUsers];
        //总数
        strongSelf.onlineTotalUserCount = [responseDic[@"totalUserCount"] integerValue];
        
        //block
        [strongSelf triggerBlock:success byCode:0];
        
    }];
}


#pragma mark - 排麦
/** 请求 排麦用户 */
-(void)requestMicRankUsers:(KKChatRoomUserListBlock)success {
    
    //1.未设置studioId过滤
    if(self.channelId.length < 1){
        [CC_Notice show:@"房间id不能为空"];
        // block回调
        [self triggerBlock:success byCode:-2];
        return;
    }
    
    //2.请求
    //2.1 参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"CHANNEL_MIC_USER_QUERY" forKey:@"service"];
    [params safeSetObject:self.channelId forKey:@"channelId"];
    
    //2.2 请求
    //MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    WS(weakSelf);
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        SS(strongSelf);
        //[HUD stop];
        
        if (error) {
            [CC_Notice show:error atView: [KKRootContollerMgr getCurrentWindow]];
            // block回调
            [strongSelf triggerBlock:success byCode:-1];
            
        }else{
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            //设置users
            NSArray *dicUsers = responseDic[@"channelMicUsers"];
            strongSelf.micRankUsers = [KKChatRoomUserSimpleModel mj_objectArrayWithKeyValuesArray:dicUsers];
            //是否在mic上
            BOOL isOnMic = responseDic[@"inMicLine"];
            NSInteger rank = 0;
            if (isOnMic) {
               rank = [responseDic[@"mySeq"] integerValue];
            }
            // block回调
            [strongSelf triggerBlock:success byCode:rank];
        }
 
    }];
}

/** 请求 加入排麦 */
-(void)requestMicRankJoin:(KKChatRoomUserListBlock)success {
    
    if(self.channelId.length < 1){
        [CC_Notice show:@"房间id不能为空"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"CHANNEL_MIC_USER_ADD" forKey:@"service"];
    [params safeSetObject:self.channelId forKey:@"channelId"];
    
    //2.请求
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    WS(weakSelf);
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        SS(strongSelf);
        [HUD stop];
        
        if (error) {
            [CC_Notice show:error atView: [KKRootContollerMgr getCurrentWindow]];
            [strongSelf triggerBlock:success byCode:-1];
            
        }else{
            //NSDictionary *responseDic = resModel.resultDic[@"response"];
            [strongSelf triggerBlock:success byCode:0];
        }
    }];
}


/** 请求 取消排麦/下麦 */
-(void)requestMicRankQuit:(NSString *)userId success:(KKChatRoomUserListBlock)success {
    
    if(self.channelId.length < 1){
        [CC_Notice show:@"房间id不能为空"];
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
    [params safeSetObject:self.channelId forKey:@"channelId"];
    [params safeSetObject:userId forKey:@"userId"];
    [params safeSetObject:@(0) forKey:@"removeType"];
    
    //2.请求
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    WS(weakSelf);
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        SS(strongSelf);
        [HUD stop];
        
        if (error) {
            [CC_Notice show:error atView: [KKRootContollerMgr getCurrentWindow]];
            [strongSelf triggerBlock:success byCode:-1];
            
        }else{
            //NSDictionary *responseDic = resModel.resultDic[@"response"];
            [strongSelf triggerBlock:success byCode:0];
        }
    }];
}



#pragma mark - 禁言
/** 请求 禁言用户 */
-(void)requestForbidWordUsers:(KKChatRoomUserListBlock)success {
    
    //1.未设置studioId过滤
    if(self.channelId.length < 1){
        [CC_Notice show:@"房间id不能为空"];
        [self triggerBlock:success byCode:-2];
        return;
    }
    
    //2.超页过滤
    if (self.forbidWordPaginator) {
        if (self.forbidWordPaginator.page > self.forbidWordPaginator.pages) {
            self.forbidWordPaginator.page -= 1;
            [self triggerBlock:success byCode:-3];
            return ;
        }
    }
    
    
    //3.1 参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"CHANNEL_FORBID_CHAT_USER_QUERY" forKey:@"service"];
    [params safeSetObject:self.channelId forKey:@"channelId"];
    NSInteger currentP = self.forbidWordPaginator ? self.forbidWordPaginator.page : 1;
    [params safeSetObject:@(currentP) forKey:@"currentPage"];
    //[params setObject:@(15) forKey:@"pageSize"];
    
    //3.2 请求
    //MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    WS(weakSelf);
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        SS(strongSelf);
        //[HUD stop];
        
        //4.1 出错
        if (error) {
            [CC_Notice show:error atView: [KKRootContollerMgr getCurrentWindow]];
            //设置paginator
            if (strongSelf.forbidWordPaginator.page > 1) {
                strongSelf.forbidWordPaginator.page -= 1;
            }
            //block
            [strongSelf triggerBlock:success byCode:-1];
            return ;
        }
        
        //4.2 成功
        NSDictionary *responseDic = resModel.resultDic[@"response"];
        //设置paginator
        NSDictionary *paginatorDic = responseDic[@"paginator"];
        strongSelf.forbidWordPaginator = [KKPaginator mj_objectWithKeyValues:paginatorDic];
        
        //设置users
        if (currentP == 1) {
            [strongSelf.forbidWordUsers removeAllObjects];
        }
        NSArray *dicUsers = responseDic[@"channelForbidChatUsers"];
        NSArray <KKChatRoomUserSimpleModel *>*modelUsers = [KKChatRoomUserSimpleModel mj_objectArrayWithKeyValuesArray:dicUsers];
        [strongSelf.forbidWordUsers addObjectsFromArray:modelUsers];
        
        //block
        [strongSelf triggerBlock:success byCode:0];
    }];
}


/** 请求 禁言某用户 */
-(void)requestForbidWord:(NSString *)userId success:(KKChatRoomUserListBlock)success {
    
    if(self.channelId.length < 1){
        [CC_Notice show:@"房间id不能为空"];
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
    [params setObject:@"CHANNEL_USER_FORBIDDEN_CHAT_SET" forKey:@"service"];
    [params safeSetObject:self.channelId forKey:@"channelId"];
    [params safeSetObject:userId forKey:@"userId"];
    [params safeSetObject:@(self.canForbidConsult) forKey:@"canForbidConsult"];
    
    //2.请求
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    WS(weakSelf);
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        SS(strongSelf);
        [HUD stop];
        
        if (error) {
            [CC_Notice show:error atView: [KKRootContollerMgr getCurrentWindow]];
            [strongSelf triggerBlock:success byCode:-1];
            
        }else{
            //NSDictionary *responseDic = resModel.resultDic[@"response"];
            [CC_Notice show:@"禁言成功"];
            [strongSelf triggerBlock:success byCode:0];
        }
    }];
}

/** 请求 取消禁言某用户 */
-(void)requestForbidWordCancel:(NSString *)userId success:(KKChatRoomUserListBlock)success {
    
    if(self.channelId.length < 1){
        [CC_Notice show:@"房间id不能为空"];
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
    [params setObject:@"CHANNEL_USER_FORBIDDEN_CHAT_CANCEL" forKey:@"service"];
    [params safeSetObject:self.channelId forKey:@"channelId"];
    [params safeSetObject:userId forKey:@"userId"];
    [params safeSetObject:@(self.canForbidConsult) forKey:@"canForbidConsult"];
    
    //2.请求
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    WS(weakSelf);
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        SS(strongSelf);
        [HUD stop];
        
        if (error) {
            [CC_Notice show:error atView: [KKRootContollerMgr getCurrentWindow]];
            [strongSelf triggerBlock:success byCode:-1];
            
        }else{
            //NSDictionary *responseDic = resModel.resultDic[@"response"];
            [CC_Notice show:@"解禁成功"];
            [strongSelf triggerBlock:success byCode:0];
        }
    }];
}


-(void)requestForbidWordCheck:(NSString *)userId success:(KKChatRoomUserListBlock)success {
    
    if(self.channelId.length < 1){
        [CC_Notice show:@"房间id不能为空"];
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
    [params setObject:@"USER_CHAT_FORBID_CONSULT" forKey:@"service"];
    [params safeSetObject:self.channelId forKey:@"channelId"];
    [params safeSetObject:userId forKey:@"userId"];
    
    //2.请求
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    WS(weakSelf);
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        SS(strongSelf);
        [HUD stop];
        
        if (error) {
            [CC_Notice show:error atView: [KKRootContollerMgr getCurrentWindow]];
            [strongSelf triggerBlock:success byCode:-1];
            
        }else{
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            BOOL isForbidChat = [responseDic[@"isForbidChat"] boolValue];
            if (isForbidChat) {
                [strongSelf triggerBlock:success byCode:1];
            }else{
                [strongSelf triggerBlock:success byCode:0];
            }
            
        }
    }];
}


#pragma mark - tool
-(void)triggerBlock:(_Nullable KKChatRoomUserListBlock)block byCode:(NSInteger)code {
    if (block) {
        block(code);
    }
}

@end
