//
//  UIView+KKRectCorner.m
//  kk_espw
//
//  Created by hsd on 2019/7/17.
//  Copyright © 2019 david. All rights reserved.
//

#import "UIView+KKRectCorner.h"

@implementation UIView (KKRectCorner)

/** 切除view指定的角让其变为圆角,  rectCorner 一共四种可复选,  cornerRadius 圆角半径 */
- (void)kkAddRectCorner:(UIRectCorner)rectCorner Radius:(CGFloat)cornerRadius {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/** 切除view指定的角让其变为圆角,
 @param rectCorner 一共四种可复选,
 @param cornerRadius 圆角半径,
 @param lineColor 环绕自身的一圈线的颜色
 @param lineWidth 线宽度
 */
- (void)kkAddRectCorner:(UIRectCorner)rectCorner Radius:(CGFloat)cornerRadius LineColor:(UIColor *)lineColor LineWidth:(CGFloat)lineWidth {
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.path = maskPath.CGPath;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = lineColor.CGColor;
    borderLayer.lineWidth = lineWidth;
    borderLayer.frame = self.bounds;
    
    self.layer.mask = maskLayer;
    [self.layer addSublayer:borderLayer];
}

@end
