//
//  KKGameOverController.h
//  kk_espw
//
//  Created by hsd on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameRoomBaseController.h"
#import "KKGameRoomInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 游戏结束
@interface KKGameOverController : KKGameRoomBaseController

@property (nonatomic, copy, nonnull) NSString *orderNoStr;      ///< 订单号

@end

NS_ASSUME_NONNULL_END
