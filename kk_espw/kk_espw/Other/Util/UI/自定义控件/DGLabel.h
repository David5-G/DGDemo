//
//  DGLabel.h
//  DGTool
//
//  Created by jczj on 2018/8/23.
//  Copyright © 2018年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DGLabel : UILabel

/** 创建label
 *
 * 左对齐
 */
+ (DGLabel *)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color;

/** 创建 制定text,font,color,isBold的label */
+ (DGLabel *)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color bold:(BOOL)isBold;

@end
