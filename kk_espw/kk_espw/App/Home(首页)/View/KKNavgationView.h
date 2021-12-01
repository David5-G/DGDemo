//
//  KKNavgationVIew.h
//  kk_espw
//
//  Created by jingtian9 on 2019/10/12.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^didNavgationSearchButtonBlock)(void);

@interface KKNavgationView : UIView
@property (nonatomic, copy) didNavgationSearchButtonBlock didNavgationSearchButtonBlock;
@end

NS_ASSUME_NONNULL_END
