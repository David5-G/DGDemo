//
//  KKWangZhePlayHeaderView.h
//  kk_espw
//
//  Created by 景天 on 2019/7/11.
//  Copyright © 2019年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didTapSelectButtonBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface KKKingHeaderView : UIView
@property (nonatomic, copy) didTapSelectButtonBlock didTapSelectButtonBlock;
@property (nonatomic, strong) CC_Button *selectButton;
@end

NS_ASSUME_NONNULL_END
