//
//  DGLabel.m
//  DGTool
//
//  Created by jczj on 2018/8/23.
//  Copyright © 2018年 david. All rights reserved.
//

#import "DGLabel.h"



@implementation DGLabel

/** 创建 制定text,font,color的label */
+ (DGLabel *)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color {
    return [self labelWithText:text fontSize:fontSize color:color bold:NO];
}

/** 创建 制定text,font,color,isBold的label */
+ (DGLabel *)labelWithText:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color bold:(BOOL)isBold {
    
    DGLabel *label = [[DGLabel alloc]init];
    label.textColor = color;
    label.textAlignment = NSTextAlignmentLeft;
    label.text = text;
    
    if (isBold) {
        label.font = [UIFont boldSystemFontOfSize:fontSize];
    }else{
        label.font = [UIFont systemFontOfSize:fontSize];
    }
    return label;
}

@end
