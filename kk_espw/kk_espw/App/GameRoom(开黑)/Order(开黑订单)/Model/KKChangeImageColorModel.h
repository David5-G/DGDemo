//
//  KKChangeImageColorModel.h
//  kk_espw
//
//  Created by hsd on 2019/7/19.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KKChangeImageColorModel : NSObject

/** 改变图片颜色 */
+ (UIImage *_Nullable)changeImageToColor:(UIColor *_Nullable)color sourceImage:(UIImage *_Nullable)sourceImage;

@end

