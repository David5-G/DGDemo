//
//  KKLiveStudioUserSimpleModel.m
//  kk_espw
//
//  Created by david on 2019/7/31.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioUserSimpleModel.h"

@implementation KKLiveStudioUserSimpleModel
+(NSDictionary *)mj_objectClassInArray {
    return @{@"userMedalDetails" : @"KKLiveStudioMetalSimpleModel"};
}

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"hostId" : @"anchorId" };
}
@end
