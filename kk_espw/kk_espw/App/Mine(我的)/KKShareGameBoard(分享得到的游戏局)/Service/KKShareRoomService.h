//
//  KKShareRoomService.h
//  kk_espw
//
//  Created by 景天 on 2019/8/2.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KKHomeRoomListInfo;
@class KKShareGameInfo;
NS_ASSUME_NONNULL_BEGIN
typedef void(^requestShareRoomDataBlockSuccess)(KKShareGameInfo *shareInfo, KKHomeRoomListInfo *info);
typedef void(^requestShareRoomDataBlockFail)(void);


@interface KKShareRoomService : NSObject
@property (nonatomic, copy) requestShareRoomDataBlockSuccess requestShareRoomDataBlockSuccess;
@property (nonatomic, copy) requestShareRoomDataBlockFail requestShareRoomDataBlockFail;
@property (nonatomic, copy) NSString *gameBoradId;
@property (nonatomic, copy) NSString *shareUserId;

+ (instancetype)shareInstance;

/**
 请求开黑房订单
 
 @param success success
 @param fail fail
 */
+ (void)requestShareRoomDataSuccess:(requestShareRoomDataBlockSuccess)success Fail:(requestShareRoomDataBlockFail)fail;

@end


NS_ASSUME_NONNULL_END
