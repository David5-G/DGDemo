//
//  KKLiveStudioGameRoomViewModel.m
//  kk_espw
//
//  Created by david on 2019/8/1.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioGameRoomViewModel.h"

@implementation KKLiveStudioGameRoomViewModel



/** 请求 推荐开黑房列表 */
-(void)requestGameRoomList:(void(^)(NSArray <KKLiveStudioGameRoomSimpleModel *>*))success; {
    
    if(self.studioId.length < 1){
        [CC_Notice show:@"未设置招募厅id"];
        return;
    }
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"GAME_BOARD_RECOMMEND_QUERY" forKey:@"service"];
    [params safeSetObject:self.studioId forKey:@"recommendObjectId"];
    [params safeSetObject:@"LIVE_HALL_RECOMMEND" forKey:@"recommendType"];
    
    //2.请求
    
    WS(weakSelf);
    //MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        //[HUD stop];
        
        if (error) {
            [CC_Notice show:error atView: [KKRootContollerMgr getCurrentWindow]];
            
        }else{
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            weakSelf.gameRooms = [KKLiveStudioGameRoomSimpleModel mj_objectArrayWithKeyValuesArray:responseDic[@"dataList"]];
            if (success) {
                success(weakSelf.gameRooms);
            }
        }
    }];
}


-(void)checkCanGoGameRoom:(NSString *)gameRoomId boardId:(NSString *)gameBoardId cardId:(NSString *)cardId success:(void(^)(void))success fail:(void(^)(void))fail  {
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"GAME_BOARD_JOIN_CONSULT_QUERY" forKey:@"service"];
    [params safeSetObject:gameRoomId forKey:@"gameRoomId"];
    [params safeSetObject:gameBoardId forKey:@"gameBoardId"];
    [params safeSetObject:cardId forKey:@"profilesId"];
    
    //2.请求
    //WS(weakSelf);
    //MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        //[HUD stop];
        
        if (error) {
            [CC_Notice show:error atView: [KKRootContollerMgr getCurrentWindow]];
            if (fail) {
                fail();
            }
            
        }else{
            //NSDictionary *responseDic = resModel.resultDic[@"response"];
            if (success) {
                success();
            }
        }
    }];
}

@end
