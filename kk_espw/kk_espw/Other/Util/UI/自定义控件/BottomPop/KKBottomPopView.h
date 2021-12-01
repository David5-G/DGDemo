//
//  KKBottomPopView.h
//  kk_espw
//
//  Created by david on 2019/7/24.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKBottomPopView : UIView
/** 是否禁止 tap点击hide操作 */
@property (nonatomic, assign) BOOL forbidTapHidden;

/** 子类重写此方法, 布局displayView的subView */
-(void)setupSubViewsForDisplayView:(UIView *)displayView;

-(void)showPopView;

-(void)hidePopView;

@end

NS_ASSUME_NONNULL_END
