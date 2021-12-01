//
//  KKGamePlayerCardInfoModel.m
//  kk_espw
//
//  Created by david on 2019/8/9.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGamePlayerCardInfoModel.h"

#pragma mark -
@implementation KKPlayerMedalLevelConfigModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idStr": @"id"};
}
@end


#pragma mark -
@implementation KKGamePlayerCardInfoModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"isFriend": @"friend"};
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"userMedalDetailList": @"KKPlayerMedalDetailModel",
             @"medalLevelConfigList": @"KKPlayerMedalLevelConfigModel"};
}
@end




