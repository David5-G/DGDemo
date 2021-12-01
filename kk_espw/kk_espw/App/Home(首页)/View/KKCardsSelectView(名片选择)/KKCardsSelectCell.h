//
//  KKCardsSelectCell.h
//  kk_espw
//
//  Created by 景天 on 2019/7/11.
//  Copyright © 2019年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKCardTag;
NS_ASSUME_NONNULL_BEGIN

@interface KKCardsSelectCell : UITableViewCell
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UIImageView *selectImageView;
@property (nonatomic, strong) KKCardTag *model;
@end

NS_ASSUME_NONNULL_END
