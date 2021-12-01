//
//  KKGameBoardClientSimpleModel.m
//  kk_espw
//
//  Created by hsd on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameBoardClientSimpleModel.h"

@implementation KKGameBoardClientSimpleModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idStr": @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"ownerPosition": @"KKGameStatusInfoModel",
             @"dataList": @"KKCreateGameUserCardModel",
             };
}

@end
