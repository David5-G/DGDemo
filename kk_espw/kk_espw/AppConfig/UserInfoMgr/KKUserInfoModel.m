//
//  KKUserInfoModel.m
//  kk_buluo
//
//  Created by david on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import "KKUserInfoModel.h"

@implementation KKUserInfoModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"userMedalDetailList" : @"KKUserMedelInfo",
             @"channelAllowAnchors" : @"KKHomeRoomStatus",
             };
}

@end
