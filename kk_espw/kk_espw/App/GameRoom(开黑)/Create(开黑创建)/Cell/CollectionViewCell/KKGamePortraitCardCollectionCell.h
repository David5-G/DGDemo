//
//  KKGamePortraitCardCollectionCell.h
//  kk_espw
//
//  Created by hsd on 2019/7/17.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KKGamePortraitCardEidtBlock)(void);

NS_ASSUME_NONNULL_BEGIN
/// 名片
@interface KKGamePortraitCardCollectionCell : UICollectionViewCell

@property (nonatomic, strong, nullable) UIImage *sexImage;                   ///< 性别
@property (nonatomic, strong, nullable) NSString *nickNameString;            ///< 昵称
@property (nonatomic, strong, nullable) NSString *accountSourceString;       ///< 账号来源
@property (nonatomic, strong, nullable) NSString *levelString;               ///< 等级

@property (nonatomic, copy, nullable) KKGamePortraitCardEidtBlock editBlock; ///< 编辑

/// 设置cell是否选中
- (void)resetViewBorder:(BOOL)isSelect;

@end

NS_ASSUME_NONNULL_END
