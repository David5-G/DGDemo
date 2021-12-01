//
//  KKGameAmountCell.h
//  kk_espw
//
//  Created by hsd on 2019/7/17.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KKGameAmountCellSelectBlock)(NSString * _Nonnull textString);

NS_ASSUME_NONNULL_BEGIN

@interface KKGameAmountCell : UITableViewCell

/// 数据源
@property (nonatomic, strong, nonnull) NSArray<NSDictionary *> *dataSourceArray;
@property (nonatomic, copy, nullable) NSString *defaultDepositString; ///< 默认收费标准

@property (nonatomic, copy, nullable) KKGameAmountCellSelectBlock selectBlock; ///< 选中回调

@end

NS_ASSUME_NONNULL_END
