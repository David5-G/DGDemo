//
//  KKGameEvaluateTagSimpleModel.h
//  kk_espw
//
//  Created by hsd on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 评价标签
@interface KKGameEvaluateTagSimpleModel : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy, nonnull) NSString *tagName;
@property (nonatomic, copy, nonnull) NSString *tagCode;

@end

NS_ASSUME_NONNULL_END
