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
+ (CGFloat)getHeightWithAttributedText:(NSString *)text
                                  font:(UIFont *)font
                                 width:(CGFloat)width;

+ (CGFloat)getWidthWithAttributedText:(NSString *)text
                                 font:(UIFont *)font
                               height:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
