//
//  KKGameModePlayCell.h
//  kk_espw
//
//  Created by hsd on 2019/7/17.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KKGameModePlayCellSelectBlock)(NSString * _Nonnull textString, BOOL userAction);

NS_ASSUME_NONNULL_BEGIN

/// 模式选择/想打位置
@interface KKGameModePlayCell : UITableViewCell

/// 一行显示几个, 默认全部显示在第一行
@property (nonatomic, assign) NSInteger maxShowOneLine;

/// 内边距
@property (nonatomic, assign) UIEdgeInsets sectionInsets;

/// 默认模式
@property (nonatomic, copy, nullable) NSString *defaultSelectTypeString;

/// 数据源
@property (nonatomic, strong, nonnull) NSArray<NSDictionary *> *dataSourceArray;

@property (nonatomic, copy, nullable) KKGameModePlayCellSelectBlock selectBlock; ///< 选中回调

@end

NS_ASSUME_NONNULL_END
