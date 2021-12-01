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

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KKFloatViewType) {
    KKFloatViewTypeUnknow=1,
    KKFloatViewTypeLiveStudio,
    KKFloatViewTypeGameRoom,
};

@interface KKFloatViewMgr : NSObject

+(instancetype)shareInstance;

/** 悬浮类型 */
@property (nonatomic, assign) KKFloatViewType type;

/** 招募厅信息 */
@property (nonatomic, strong, nullable) KKFloatLiveStudioModel *liveStudioModel;

/** 开黑房 */
@property (nonatomic, strong, nullable) KKFloatGameRoomModel *gameRoomModel;

-(void)tryToLeaveLiveStudio:(void(^)(void))success;

- (void)tryToLeaveGameRoom:(void(^)(void))success;

- (void)cleanLiveData;

- (void)cleanGameData;


-(void)checkShowFloatView;

@end

NS_ASSUME_NONNULL_END
