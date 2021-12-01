//
//  KKLastCreateGameRoomModel.h
//  kk_espw
//
//  Created by hsd on 2019/8/14.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKGameBoardClientSimpleModel.h"
#import "KKCardTag.h"

NS_ASSUME_NONNULL_BEGIN

/// 最后一次创建开黑房的model
@interface KKLastCreateGameRoomModel : NSObject

@property (nonatomic, strong, nonnull) KKGameBoardClientSimpleModel *gameBoard;
@property (nonatomic, strong, nonnull) KKCardTag *userGameProfiles;

@end

NS_ASSUME_NONNULL_END
