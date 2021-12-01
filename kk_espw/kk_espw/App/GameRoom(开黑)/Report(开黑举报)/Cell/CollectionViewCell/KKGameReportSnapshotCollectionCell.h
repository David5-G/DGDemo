//
//  KKGameReportSnapshotCollectionCell.h
//  kk_espw
//
//  Created by hsd on 2019/7/25.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KKGameReportSnapshotCollectionCellType) {
    KKGameReportSnapshotCollectionCellTypeAdd              = 0,    ///< 展示一个"+", default
    KKGameReportSnapshotCollectionCellTypeSnapshot         = 1,    ///< 展示一张截图和右上角的"x"图标
};

typedef void(^KKGameReportSnapshotDeleteBlock)(void);

NS_ASSUME_NONNULL_BEGIN

/// 截图collectionCell
@interface KKGameReportSnapshotCollectionCell : UICollectionViewCell

@property (nonatomic, assign) KKGameReportSnapshotCollectionCellType cellType;      ///< cell类型
@property (nonatomic, copy, nullable) KKGameReportSnapshotDeleteBlock deleteBlock;

/// 设置图片, 只有在 cellType == .snapshot 时才有效
- (void)setMainImage:(UIImage * _Nullable)mainImg;

@end

NS_ASSUME_NONNULL_END
