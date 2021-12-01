//
//  KKLiveStudioSimpleModel.m
//  kk_espw
//
//  Created by david on 2019/7/31.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioSimpleModel.h"

@implementation KKLiveStudioSimpleModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idStr" : @"channelId",
             @"name" : @"channelName",
             @"status" : @"channelStatus" };
}

@end
