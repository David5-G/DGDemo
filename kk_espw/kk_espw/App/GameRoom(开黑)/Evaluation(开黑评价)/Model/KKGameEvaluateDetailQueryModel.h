//
//  KKGameEvaluateDetailQueryModel.h
//  kk_espw
//
//  Created by hsd on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKGameBoardClientSimpleModel.h"
#import "KKGameEvaluateTagSimpleModel.h"
#import "KKGameEvaluateUserSimpleModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 待评价查询 model
@interface KKGameEvaluateDetailQueryModel : NSObject

@property (nonatomic, copy, nonnull) NSString *userId;
@property (nonatomic, copy, nonnull) NSString *gameBoardId;
@property (nonatomic, copy, nonnull) NSString *gmtEvaluateEnd;
@property (nonatomic, strong, nonnull) KKGameBoardClientSimpleModel *gameBoard;
@property (nonatomic, strong, nonnull) NSArray<KKGameEvaluateUserSimpleModel *> *userGameBoardEvaluateClientSimpleList;
@property (nonatomic, strong, nonnull) NSArray<KKGameEvaluateTagSimpleModel *> *gameTagClientSimpleList;

@end

NS_ASSUME_NONNULL_END
