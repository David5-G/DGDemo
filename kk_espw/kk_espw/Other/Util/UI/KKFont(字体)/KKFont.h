//
//  KKFont.h
//  
//
//  Created by david on 2019/4/25.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, PFFontStyle) {
    PFFontStyleMedium,     // 中黑体
    PFFontStyleSemibold,   // 中粗体
    PFFontStyleLight,      // 细体
    PFFontStyleUltralight, // 极细体
    PFFontStyleRegular,    // 常规体
    PFFontStyleThin,       // 纤细体
};//PingFang SC 苹方简体


typedef NS_ENUM(NSInteger, KKFontStyle) {
    KKFontStyleFestivoLettersNo19,//Festivo Letters No19
    KKFontStyleREEJIHonghuangLiMedium, //REEJI-HonghuangLi-MediumGB1.0
};//指定字体


@interface KKFont : UIFont

#pragma mark - convenience
/**
 苹方简体
 @param fontStyle 字体类型
 @param fontSize 字体大小
 @param italicAngle 倾斜角度 (=0时候, fontSize在方法内部会屏幕自适应缩放)
 @return 返回指定字重大小的苹方简体
 */
+ (UIFont *)pingfangFontStyle:(PFFontStyle)fontStyle size:(CGFloat)fontSize italicAngle:(NSInteger)italicAngle;

+ (UIFont *)pingfangFontStyle:(PFFontStyle)fontStyle size:(CGFloat)fontSize;




/**
 指定字体
 @param fontStyle 字体类型
 @param fontSize 字体大小
 @param italicAngle 倾斜角度 
 @return 返回指定的字体
 */
+ (UIFont *)kkFontStyle:(KKFontStyle)fontStyle size:(CGFloat)fontSize italicAngle:(NSInteger)italicAngle;

+ (UIFont *)kkFontStyle:(KKFontStyle)fontStyle size:(CGFloat)fontSize;



#pragma mark - core
/**
 指定字体
 @param fontName 字体名
 @param fontSize 字体大小
 @param italicAngle 倾斜角度
 @return 返回指定的字体
 */
+ (UIFont *)fontWithName:(NSString *)fontName size:(CGFloat)fontSize italicAngle:(NSInteger)italicAngle;

@end

NS_ASSUME_NONNULL_END
