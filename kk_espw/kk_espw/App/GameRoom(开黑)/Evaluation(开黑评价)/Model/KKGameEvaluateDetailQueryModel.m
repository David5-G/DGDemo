//
//  KKGameEvaluateDetailQueryModel.m
//  kk_espw
//
//  Created by hsd on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameEvaluateDetailQueryModel.h"

@implementation KKGameEvaluateDetailQueryModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"userGameBoardEvaluateClientSimpleList": @"KKGameEvaluateUserSimpleModel",
             @"gameTagClientSimpleList": @"KKGameEvaluateTagSimpleModel"
             };
}

@end
