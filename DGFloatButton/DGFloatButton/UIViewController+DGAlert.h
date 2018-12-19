//
//  UIViewController+DGAlert.h
//  PaPa
//
//  Created by david on 2018/11/29.
//  Copyright © 2018 万耀辉. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DGAlert)

#pragma mark - 警告框 提醒
-(void)alertWithTitle:(NSString *)title message:(NSString *)message;
-(void)alertWithTitle:(NSString *)title message:(NSString *)message duration:(float)duration;

#pragma mark - 警告框 操作
-(void)alert:(UIAlertControllerStyle)style Title:(NSString *)title message:(NSString *)message actions:(NSArray<UIAlertAction *> *)actions;

-(void)alert:(UIAlertControllerStyle)style Title:(NSString *)title titleFontSize:(float)titleFontSize message:(NSString *)message messageFontSize:(float)messageFontSize actions:(NSArray<UIAlertAction *> *)actions;

@end
