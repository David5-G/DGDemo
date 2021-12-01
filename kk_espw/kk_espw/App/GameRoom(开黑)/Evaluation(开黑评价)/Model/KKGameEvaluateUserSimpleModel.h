//
//  KKGameEvaluateUserSimpleModel.h
//  kk_espw
//
//  Created by hsd on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKGameStatusInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 待评价玩家信息
@interface KKGameEvaluateUserSimpleModel : NSObject

@property (nonatomic, strong, nullable) KKGameStatusInfoModel *sex;
@property (nonatomic, copy, nullable) NSString *nickName;
@property (nonatomic, copy, nullable) NSString *userId;
@property (nonatomic, copy, nullable) NSString *userLogoUrl;
@property (nonatomic, strong, nonnull) KKGameStatusInfoModel *positionType;

@property (nonatomic, assign) BOOL isRoomOwner;                    ///< 该玩家是否为房主

@end

NS_ASSUME_NONNULL_END
