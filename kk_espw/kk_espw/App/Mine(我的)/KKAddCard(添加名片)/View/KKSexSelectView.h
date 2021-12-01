//
//  KKSexSelectView.h
//  kk_espw
//
//  Created by 景天 on 2019/7/16.
//  Copyright © 2019年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didSelectViewWithMaleBlock)(void);
typedef void(^didSelectViewWithFeMaleBlock)(void);

NS_ASSUME_NONNULL_BEGIN

@interface KKSexSelectView : UIView
@property (nonatomic, copy) didSelectViewWithMaleBlock didSelectViewWithMaleBlock;
@property (nonatomic, copy) didSelectViewWithFeMaleBlock didSelectViewWithFeMaleBlock;
@property (nonatomic, copy) NSString *sex;
@end

NS_ASSUME_NONNULL_END
