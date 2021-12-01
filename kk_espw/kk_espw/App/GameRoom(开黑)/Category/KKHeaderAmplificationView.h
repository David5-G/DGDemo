//
//  KKHeaderAmplificationView.h
//  kk_espw
//
//  Created by hsd on 2019/7/15.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKHeaderAmplificationView : UIImageView

@property (nonatomic, assign) CGFloat kkHeaderViewHeight;   ///< 头部自动下拉放大视图高度, 默认 182pt
@property (nonatomic, assign) CGFloat kkBottomCoverHeight;  ///< 底部被遮盖的高度, 默认 10pt
@property (nonatomic, assign) CGRect kkOriginFrame;         ///< 初始frame

@property (nonatomic, weak, nullable) UIScrollView *weakScrollView; ///< 父视图, 无需手动设置

/// 添加监听
- (void)addObserverForScroll;

/// 移除监听
- (void)removeObserverForScroll;

@end

