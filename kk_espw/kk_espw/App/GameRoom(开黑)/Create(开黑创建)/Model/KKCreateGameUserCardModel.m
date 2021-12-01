//
//  KKCreateGameUserCardModel.m
//  kk_espw
//
//  Created by hsd on 2019/8/15.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKCreateGameUserCardModel.h"

@implementation KKCreateGameUserCardModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idStr": @"id"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"positionType": @"KKGameStatusInfoModel"};
}

@end
