//
//  KKLiveStudioMetalSimpleModel.m
//  kk_espw
//
//  Created by david on 2019/7/31.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioMetalSimpleModel.h"

@implementation KKLiveStudioMetalSimpleModel
+(NSDictionary *)mj_objectClassInArray {
    return @{@"medalLabelConfigList" : @"KKLiveStudioMetalLabelConfigSimpleModel"};
}

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idStr" : @"id" };
}
@end



@implementation KKLiveStudioMetalLabelConfigSimpleModel

@end



@implementation KKLiveStudioMetalConfigSimpleModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idStr" : @"id" };
}
@end
