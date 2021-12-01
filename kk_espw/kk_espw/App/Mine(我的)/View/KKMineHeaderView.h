//
//  KKMineHeaderView.h
//  kk_espw
//
//  Created by 景天 on 2019/7/12.
//  Copyright © 2019年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKUserInfoModel;
NS_ASSUME_NONNULL_BEGIN

@protocol KKMineHeaderViewDelegate <NSObject>

@optional
- (void)didSelectedSetupButton;
- (void)didSelectedEditButton;
- (void)didSelectedHeaderButton;
- (void)didSelectedWalletButton;
- (void)didSelectedCardsButton;
- (void)didSelectedWeeksWorkButton;

@end

@interface KKMineHeaderView : UIView
@property (nonatomic, strong) KKUserInfoModel *mineInfo;
@property (nonatomic, weak) id<KKMineHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
