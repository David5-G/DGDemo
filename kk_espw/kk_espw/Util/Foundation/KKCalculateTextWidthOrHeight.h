//
//  KKCalculateTextWidthOrHeight.h
//  kk_espw
//
//  Created by 景天 on 2019/7/11.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKCalculateTextWidthOrHeight : NSObject
+ (CGFloat)getWidthWithAttributedText:(NSString *)text
                             fontSize:(CGFloat)fontSize
                               height:(CGFloat)height;

+ (CGFloat)getHeightWithAttributedText:(NSString *)text
                              fontSize:(CGFloat)fontSize
                                 width:(CGFloat)width;

@end

NS_ASSUME_NONNULL_END
