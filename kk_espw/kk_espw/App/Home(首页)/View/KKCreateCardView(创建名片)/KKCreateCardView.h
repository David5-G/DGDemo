//
//  KKCreateCardView.h
//  kk_espw
//
//  Created by 景天 on 2019/7/11.
//  Copyright © 2019年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^addCardSuccessBlock)(void);
@interface KKCreateCardView : UIView
@property (nonatomic, copy) addCardSuccessBlock addCardSuccessBlock;
@end

NS_ASSUME_NONNULL_END
