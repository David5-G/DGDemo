//
//  KKCreateGameUserCardModel.h
//  kk_espw
//
//  Created by hsd on 2019/8/15.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKGameStatusInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 玩家上一次使用的名片
@interface KKCreateGameUserCardModel : NSObject

@property (nonatomic, copy, nullable) NSString *userId;
@property (nonatomic, copy, nullable) NSString *profilesId;
@property (nonatomic, copy, nullable) NSString *gameBoardId;
@property (nonatomic, copy, nullable) NSString *idStr;
@property (nonatomic, strong, nonnull) KKGameStatusInfoModel *userProceedStatus;
@property (nonatomic, strong, nonnull) KKGameStatusInfoModel *payStatus;
@property (nonatomic, strong, nullable) NSArray<KKGameStatusInfoModel *> *positionType;

@end

NS_ASSUME_NONNULL_END
