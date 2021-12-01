//
//  KKGameOverEvaluateCell.h
//  kk_espw
//
//  Created by hsd on 2019/7/26.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKGameEvaluateUserSimpleModel.h"
#import "KKGameEvaluateTagSimpleModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 单项勾选队友优势cell
@interface KKGameOverEvaluateCell : UITableViewCell

@property (nonatomic, strong, nullable) KKGameEvaluateUserSimpleModel *userModel;
@property (nonatomic, strong, nullable) NSArray<KKGameEvaluateTagSimpleModel *> *tagArray;

/// 选中/取消选中 框框回调
@property (nonatomic, copy, nullable) void(^boxSelectBlock)(BOOL isSelect, NSString * _Nullable evaluateStr);

@end

NS_ASSUME_NONNULL_END
