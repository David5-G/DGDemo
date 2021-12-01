//
//  KKFont.m
//
//
//  Created by david on 2019/4/25.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKFont.h"

@implementation KKFont


#pragma mark - convenience

+ (UIFont *)pingfangFontStyle:(PFFontStyle)fontStyle
                         size:(CGFloat)fontSize
                  italicAngle:(NSInteger)italicAngle {
    
    NSString *fontName = @"PingFangSC-Regular";
    switch (fontStyle) {
        case PFFontStyleMedium:
            fontName = @"PingFangSC-Medium";
            break;
        case PFFontStyleSemibold:
            fontName = @"PingFangSC-Semibold";
            break;
        case PFFontStyleLight:
            fontName = @"PingFangSC-Light";
            break;
        case PFFontStyleUltralight:
            fontName = @"PingFangSC-Ultralight";
            break;
        case PFFontStyleRegular:
            fontName = @"PingFangSC-Regular";
            break;
        case PFFontStyleThin:
            fontName = @"PingFangSC-Thin";
            break;
    }
    
    return [self fontWithName:fontName size:fontSize italicAngle:italicAngle];
}

+ (UIFont *)pingfangFontStyle:(PFFontStyle)fontStyle size:(CGFloat)fontSize{
    return [KKFont pingfangFontStyle:fontStyle size:fontSize italicAngle:0];
}



+ (UIFont *)kkFontStyle:(KKFontStyle)fontStyle size:(CGFloat)fontSize italicAngle:(NSInteger)italicAngle {
    
    //1.字体名
    NSString *fontName = @"PingFangSC-Regular";
    switch (fontStyle) {
        case KKFontStyleFestivoLettersNo19:
            fontName = @"Festivo Letters No19";
            break;
        case KKFontStyleREEJIHonghuangLiMedium:
            fontName = @"REEJI-Honghuangli-MediumGB1.0";
            break;
    }
    
    return [self fontWithName:fontName size:fontSize italicAngle:italicAngle];
}

+ (UIFont *)kkFontStyle:(KKFontStyle)fontStyle size:(CGFloat)fontSize {
    return [KKFont kkFontStyle:fontStyle size:fontSize italicAngle:0];
}


#pragma mark - core
+(UIFont *)fontWithName:(NSString *)fontName
                          size:(CGFloat)fontSize
                   italicAngle:(NSInteger)italicAngle {
    
    //1.不需要斜体处理
    if (italicAngle == 0) {
        return [UIFont fontWithName:fontName size:fontSize];
    }
    
    //2.斜体处理
    //在ios中英文字体可以设置斜体，但是对中文字符无效，所以要对中文设置斜体得另外做处理。
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(italicAngle * (CGFloat)M_PI / 180), 1, 0, 0);//设置反射。倾斜角度。
    UIFontDescriptor *fontDesc = [UIFontDescriptor fontDescriptorWithName:fontName matrix:matrix];//获取带反射的指定fontDesc。
    fontDesc = fontDesc ? fontDesc : [UIFontDescriptor fontDescriptorWithName:[UIFont systemFontOfSize:10].fontName matrix:matrix];//保证fonDesc有值
    return [UIFont fontWithDescriptor:fontDesc size :fontSize];
}

@end
