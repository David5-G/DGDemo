//
//  KKGamePortraitCardCell.h
//  kk_espw
//
//  Created by hsd on 2019/7/17.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKCardTag.h"

typedef void(^KKGamePortraitCardCellBlock)(KKCardTag * _Nonnull editCard, BOOL userAction);

NS_ASSUME_NONNULL_BEGIN

/// 游戏名片cell
@interface KKGamePortraitCardCell : UITableViewCell

@property (nonatomic, copy, nullable) KKGamePortraitCardCellBlock editBlock;    ///< 编辑
@property (nonatomic, copy, nullable) KKGamePortraitCardCellBlock selectBlock; ///< 选中

@property (nonatomic, copy, nullable) NSString *defaultSelectProfileId; ///< 默认选中名片
@property (nonatomic, strong, nonnull) NSArray<KKCardTag *> *dataSourceArray; /// 数据源

@end

NS_ASSUME_NONNULL_END
