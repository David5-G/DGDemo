//
//  KKGameBoardDetailSimpleModel.m
//  kk_espw
//
//  Created by hsd on 2019/8/13.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameBoardDetailSimpleModel.h"

@implementation KKGameBoardDetailSimpleModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"evaluationProfileIds": @"KKPlayerEvaluationProfileIdModel",
             @"medalDetailList": @"KKPlayerMedalDetailModel",
             @"gamePosition": @"KKGameStatusInfoModel",
             @"preferLocations": @"KKGameStatusInfoModel"
             };
}

@end

