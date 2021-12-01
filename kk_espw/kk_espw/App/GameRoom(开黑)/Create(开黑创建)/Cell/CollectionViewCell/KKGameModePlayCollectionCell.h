//
//  KKGameModePlayCollectionCell.h
//  kk_espw
//
//  Created by hsd on 2019/7/17.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/// 游戏模式
@interface KKGameModePlayCollectionCell : UICollectionViewCell

@property (nonatomic, strong, nullable) UIImage *mainImage;     ///< 图片
@property (nonatomic, copy, nullable) NSString *titleString;    ///< 标题

/// 设置cell是否选中
- (void)resetViewBorder:(BOOL)isSelect;

@end

NS_ASSUME_NONNULL_END
