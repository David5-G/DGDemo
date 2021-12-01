//
//  KKChatRoomMetalSimpleModel.m
//  kk_espw
//
//  Created by david on 2019/7/31.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomMetalSimpleModel.h"

@implementation KKChatRoomMetalSimpleModel
+(NSDictionary *)mj_objectClassInArray {
    return @{@"medalLabelConfigList" : @"KKChatRoomMetalLabelConfigSimpleModel"};
}

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idStr" : @"id" };
}
@end



@implementation KKChatRoomMetalLabelConfigSimpleModel

@end



@implementation KKChatRoomMetalConfigSimpleModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idStr" : @"id" };
}
@end
