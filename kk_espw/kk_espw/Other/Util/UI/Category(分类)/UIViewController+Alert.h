//
//  UIViewController+Alert.h
//
//  Created by david on 2018/11/29.
//  Copyright © 2018 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DGAlert)

#pragma mark - 警告框 提醒
-(void)alertWithTitle:(NSString *)title message:(NSString *)message;
-(void)alertWithTitle:(NSString *)title message:(NSString *)message duration:(float)duration;

#pragma mark - 警告框 操作
/** 设定title msg */
-(void)alert:(UIAlertControllerStyle)style title:(NSString *)title msg:(NSString *)msg actions:(NSArray<UIAlertAction *> *)actions;

/** 设定title msg 及其font */
-(void)alert:(UIAlertControllerStyle)style title:(NSString *)title titleFont:(UIFont *)titleFont msg:(NSString *)msg msgFont:(UIFont *)msgFont actions:(NSArray<UIAlertAction *> *)actions;

/** 设定title msg 及其font,color */
-(void)alert:(UIAlertControllerStyle)style title:(NSString *)title titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor msg:(NSString *)msg msgFont:(UIFont *)msgFont msgColor:(UIColor *)msgColor actions:(NSArray<UIAlertAction *> *)actions;

#pragma mark - other

/**
 得到一串文字大小不同的字符串

 @param originalStr 目标字符串
 @param frontFont 前面的字体
 @param aFont 后面的字体
 @param aIndex 改变字体Index
 @return 返回Attr
 */
- (NSMutableAttributedString *)getAttrStr:(NSString *)originalStr
                                frontFont:(float)frontFont
                                    aFont:(float)aFont
                                   aIndex:(float)aIndex;
@end
