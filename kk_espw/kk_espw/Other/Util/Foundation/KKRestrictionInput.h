//
//  KKRestrictionInput.h
//  kk_espw
//
//  Created by 景天 on 2019/8/3.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKRestrictionInput : NSObject
+ (BOOL)isInputRuleNotBlank:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
