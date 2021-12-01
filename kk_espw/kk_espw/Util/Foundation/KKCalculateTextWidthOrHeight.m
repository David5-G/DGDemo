//
//  KKCalculateTextWidthOrHeight.m
//  kk_espw
//
//  Created by 景天 on 2019/7/11.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKCalculateTextWidthOrHeight.h"

@implementation KKCalculateTextWidthOrHeight
+ (CGFloat)getHeightWithAttributedText:(NSString *)text
                              fontSize:(CGFloat)fontSize
                                 width:(CGFloat)width {
    if (!text) {
        return 0;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
//    paragraphStyle.lineSpacing = 5;
    NSDictionary *attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle};
    return [[[NSAttributedString alloc]initWithString:text attributes:attributes] boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
}

+ (CGFloat)getWidthWithAttributedText:(NSString *)text
                             fontSize:(CGFloat)fontSize
                               height:(CGFloat)height{
    if (!text) {
        return 0;
    }
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                                     context:nil];
    return rect.size.width;
}
@end
