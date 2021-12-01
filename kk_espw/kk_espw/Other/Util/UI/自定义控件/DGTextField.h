//
//  DGTextField.h
//  DGTool
//
//  Created by David.G on 16/7/20.
//  Copyright © 2016年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGTextField : UITextField

/** 上移后，textField需要额外高于键盘顶部的距离，默认为0 */
@property (nonatomic, assign) CGFloat spaceY;

/** 需要向上移动的view，默认为keyWindow */
@property (nonatomic, weak) UIView *movingView;

/**
 * ① 默认不设置,会在willShowKeyboard中自动获取movingView的frame
 * ② 设置, 就不会再自动获取
 */
@property (nonatomic, assign) CGRect movingViewOriginalFrame;

/** 设置字体,textColor, agignment */
-(void)setFont:(CGFloat)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment;

/** 设置InputAccessoryView, 用于点击"完成"撤销键盘 */
-(void)setDoneInputAccessoryView;


#pragma mark - range
@property (nonatomic, assign) NSRange selectedRange;

@end

NS_ASSUME_NONNULL_END
