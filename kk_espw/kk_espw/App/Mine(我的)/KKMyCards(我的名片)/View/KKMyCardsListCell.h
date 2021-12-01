//
//  KKMyCardsListCell.h
//  kk_espw
//
//  Created by 景天 on 2019/7/15.
//  Copyright © 2019年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKCardTag;
NS_ASSUME_NONNULL_BEGIN

typedef void(^tapEditCardBlock)(KKCardTag *cardInfo);
@interface KKMyCardsListCell : UITableViewCell
@property (nonatomic, strong) KKCardTag *model;
@property (nonatomic, copy) tapEditCardBlock tapEditCardBlock;
@end

NS_ASSUME_NONNULL_END
