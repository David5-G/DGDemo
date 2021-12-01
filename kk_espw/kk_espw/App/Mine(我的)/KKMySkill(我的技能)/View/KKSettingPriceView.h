//
//  KKSettingPriceView.h
//  kk_espw
//
//  Created by 景天 on 2019/7/17.
//  Copyright © 2019年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKGamePrice;
typedef void(^tapComfirmButtonBlock)(NSString *ids, NSString *priceStr);

NS_ASSUME_NONNULL_BEGIN

@interface KKSettingPriceView : UIView
@property (nonatomic, strong) KKGamePrice *model;
@property (nonatomic, copy) tapComfirmButtonBlock tapComfirmButtonBlock;
@end

NS_ASSUME_NONNULL_END
