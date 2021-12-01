//
//  KKBottomPopVC.h
//  kk_espw
//
//  Created by david on 2019/10/22.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKBottomPopVC : UIViewController
/** 是否禁止 tap点击调remoeSelf操作 */
@property (nonatomic, assign) BOOL forbidTapHidden;

/** self将被移除的block回调 */
@property (nonatomic, copy) void(^willRomoveSelfBlock)(void);

/** 先调UIView动画隐藏displayView, 后removeSelf和self.view */
-(void)removeSelf;

/** 先调setupSubViewsForDisplayView设置displayView, UIView动画展示displayView */
-(void)showSelf;

#pragma mark displayView
/** 设置disPlayView的高度 */
-(void)setDisplayViewHeight:(CGFloat)height;

/** 子类重写此方法, 布局subView */
-(void)setupSubViewsForDisplayView:(UIView *)displayView;

@end

NS_ASSUME_NONNULL_END
