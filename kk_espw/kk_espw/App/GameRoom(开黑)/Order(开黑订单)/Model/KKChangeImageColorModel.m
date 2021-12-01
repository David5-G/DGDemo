//
//  KKChangeImageColorModel.m
//  kk_espw
//
//  Created by hsd on 2019/7/19.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChangeImageColorModel.h"

@implementation KKChangeImageColorModel

/** 改变图片颜色 */
+ (UIImage *_Nullable)changeImageToColor:(UIColor *_Nullable)color sourceImage:(UIImage *_Nullable)sourceImage {
    
    if (!sourceImage || !color) {
        return nil;
    }
    
    UIGraphicsBeginImageContextWithOptions(sourceImage.size, NO, sourceImage.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, sourceImage.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height);
    CGContextClipToMask(context, rect, sourceImage.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
