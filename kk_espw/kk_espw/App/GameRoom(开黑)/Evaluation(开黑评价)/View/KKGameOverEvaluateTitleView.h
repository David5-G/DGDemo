//
//  KKGameOverEvaluateTitleView.h
//  kk_espw
//
//  Created by hsd on 2019/7/26.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKGameOverEvaluateTitleView : UIView

@property (nonatomic, copy, nullable) NSString *evaluateTitleStr; ///< 标题
@property (nonatomic, copy, nullable) NSString *countdownStr;     ///< 倒计时
@property (nonatomic, copy, nullable) NSString *descripeStr;      ///< 描述

@end

NS_ASSUME_NONNULL_END
