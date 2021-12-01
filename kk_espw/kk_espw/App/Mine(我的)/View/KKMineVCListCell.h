//
//  KKMineVCListCell.h
//  kk_espw
//
//  Created by 景天 on 2019/7/12.
//  Copyright © 2019年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^tapRowBlock)(void);

@interface KKMineVCListCell : UITableViewCell
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *directionImageView;
@property (nonatomic, copy) tapRowBlock tapRowBlock;

@end

NS_ASSUME_NONNULL_END
