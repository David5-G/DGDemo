//
//  KKGameOverFootView.h
//  kk_espw
//
//  Created by hsd on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKGameOrderTagDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 游戏结束页面页脚视图
@interface KKGameOverFootView : UIView

@property (nonatomic, strong, nullable) NSArray<KKGameUserGameTagModel *> *userGameTagArr; ///< 评价标签list
@property (nonatomic, copy, nullable) NSString *evaluateTitleString;
@property (nonatomic, copy, nullable) NSString *chargeTitleString;
@property (nonatomic, copy, nullable) NSString *orderNoString;
@property (nonatomic, copy, nullable) NSString *gameEndString;

@end

NS_ASSUME_NONNULL_END
