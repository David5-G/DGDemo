//
//  KKLiveStudioGameRoomViewModel.h
//  kk_espw
//
//  Created by david on 2019/8/1.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioBaseViewModel.h"
#import "KKLiveStudioGameRoomSimpleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKLiveStudioGameRoomViewModel : KKLiveStudioBaseViewModel

@property (nonatomic, strong) NSArray <KKLiveStudioGameRoomSimpleModel *>*gameRooms;

/** 请求 推荐开黑房列表 */
-(void)requestGameRoomList:(void(^)(NSArray <KKLiveStudioGameRoomSimpleModel *>*))success;


-(void)checkCanGoGameRoom:(NSString *)gameRoomId boardId:(NSString *)gameBoardId cardId:(NSString *)cardId success:(void(^)(void))success fail:(void(^)(void))fail;

@end

NS_ASSUME_NONNULL_END
