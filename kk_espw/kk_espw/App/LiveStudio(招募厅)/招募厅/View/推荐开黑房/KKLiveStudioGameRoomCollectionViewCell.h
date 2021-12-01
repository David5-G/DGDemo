//
//  KKLiveStudioGameRoomCollectionViewCell.h
//  kk_espw
//
//  Created by david on 2019/7/18.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKLiveStudioGameRoomCollectionViewCell : UICollectionViewCell
/** 开黑房的id */
@property (nonatomic, weak) UILabel *idLabel;
/** 开黑房的title */
@property (nonatomic, weak) UILabel *titleLabel;
/** 开黑房的msg */
@property (nonatomic, weak) UILabel *msgLabel;
/** 男生人数 */
@property (nonatomic, weak) UILabel *maleCountLabel;
/** 女生人数 */
@property (nonatomic, weak) UILabel *femaleCountLabel;
/** 统计*/
@property (nonatomic, weak) UILabel *statisticLabel;
@end

NS_ASSUME_NONNULL_END
