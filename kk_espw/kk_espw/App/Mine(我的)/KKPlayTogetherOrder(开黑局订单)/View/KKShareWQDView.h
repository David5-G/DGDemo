//
//  KKShareWQDView.h
//  kk_espw
//
//  Created by 景天 on 2019/8/11.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKBottomPopView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^tapShareKKBlock)(void);
typedef void(^tapShareWXBlock)(void);
typedef void(^tapShareQQBlock)(void);

@interface KKShareWQDView : KKBottomPopView
@property (nonatomic, copy) tapShareKKBlock tapShareKKBlock;
@property (nonatomic, copy) tapShareWXBlock tapShareWXBlock;
@property (nonatomic, copy) tapShareQQBlock tapShareQQBlock;

@end

NS_ASSUME_NONNULL_END
