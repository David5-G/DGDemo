//
//  KKFloatViewMgr.h
//  kk_espw
//
//  Created by david on 2019/8/14.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
//model
#import "KKFloatLiveStudioModel.h"
#import "KKFloatGameRoomModel.h"
#import "KKFloatVoiceRoomModel.h"


NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KKFloatViewType) {
    KKFloatViewTypeUnknow=1,
    KKFloatViewTypeLiveStudio,
    KKFloatViewTypeGameRoom,
    KKFloatViewTypeVoiceRoom,
};


typedef void(^tapCloseButtonBlock)(void);

@interface KKFloatViewMgr : NSObject

+ (instancetype)shareInstance;
/** 悬浮类型 */
@property (nonatomic, assign) KKFloatViewType type;
@property (nonatomic, copy) tapCloseButtonBlock tapCloseButtonBlock;
@property (nonatomic, assign) BOOL hiddenFloatView;

- (void)checkShowFloatView;

#pragma mark - liveStudio
/** 招募厅信息 */
@property (nonatomic, strong, nullable) KKFloatLiveStudioModel *liveStudioModel;
/// 尝试离开招募厅
- (void)tryToLeaveLiveStudio:(void(^)(void))success;

- (void)cleanLiveData;

- (void)hiddenLiveStudioFloatView;

- (void)notHiddenLiveStudioFloatView;

#pragma mark - gameRoom
/** 开黑房 */
@property (nonatomic, strong, nullable) KKFloatGameRoomModel *gameRoomModel;

- (void)requestFloatRoomViewTypeInfoSuccess:(void(^)(NSString *type))success;

- (void)tryToLeaveGameRoom:(void(^)(void))success;

- (void)cleanGameData;

- (void)hiddenGameRoomFloatView;

- (void)notHiddenGameRoomFloatView;

- (void)removeFloatGameBoardView;

#pragma mark - voiceRoom
@property (nonatomic, strong, nullable) KKFloatVoiceRoomModel *voiceRoomModel;
/// 尝试离开语音房
- (void)tryLeaveVoiceRoom:(void(^)(void))success;
@end

NS_ASSUME_NONNULL_END
