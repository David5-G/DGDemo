//
//  KKMineVCListDoubleCell.h
//  kk_espw
//
//  Created by 景天 on 2019/7/12.
//  Copyright © 2019年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^tapRowTopBlock)(void);
typedef void(^tapRowBottomBlock)(void);

@interface KKMineVCListDoubleCell : UITableViewCell
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *directionImageView;

@property (nonatomic, strong) UIImageView *iconCopy;
@property (nonatomic, strong) UILabel *titleLabelCopy;
@property (nonatomic, strong) UIImageView *directionImageViewCopy;

@property (nonatomic, copy) tapRowTopBlock tapRowTopBlock;
@property (nonatomic, copy) tapRowBottomBlock tapRowBottomBlock;

@end

NS_ASSUME_NONNULL_END
