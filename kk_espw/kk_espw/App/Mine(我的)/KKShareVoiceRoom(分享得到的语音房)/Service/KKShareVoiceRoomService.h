//
//  KKShareVoiceRoomService.h
//  kk_espw
//
//  Created by jingtian9 on 2019/10/17.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KKShareGameInfo;
@class KKHomeVoiceRoomModel;
NS_ASSUME_NONNULL_BEGIN

@interface KKShareVoiceRoomService : NSObject
+ (void)requestShareRoomDataWithShareId:(NSString *)shareId roomId:(NSString *)roomId Success:(void(^)(KKShareGameInfo *shareInfo, KKHomeVoiceRoomModel *roomModel))success Fail:(void(^)(void))fail;
@end

NS_ASSUME_NONNULL_END
