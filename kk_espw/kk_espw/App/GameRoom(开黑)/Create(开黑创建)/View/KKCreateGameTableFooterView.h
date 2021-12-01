//
//  KKCreateGameTableFooterView.h
//  kk_espw
//
//  Created by hsd on 2019/7/17.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKCreateGameTableFooterView;

NS_ASSUME_NONNULL_BEGIN

typedef void(^KKTableFooterViewFrameDidChangeBlock)(KKCreateGameTableFooterView *footerView, BOOL animated);

/// 创建开黑房表尾视图
@interface KKCreateGameTableFooterView : UIView

@property (nonatomic, copy, nullable) void(^textDidChangeBlock)(NSString * _Nullable text);
@property (nonatomic, copy, nullable) KKTableFooterViewFrameDidChangeBlock frameDidChangeBlock;

/// 设置默认view显示模式
- (void)setDefaultState:(BOOL)isSelect animated:(BOOL)animated;

/// 设置默认标题
- (void)setDefaultTitle:(NSString * _Nullable)title;

@end

NS_ASSUME_NONNULL_END
