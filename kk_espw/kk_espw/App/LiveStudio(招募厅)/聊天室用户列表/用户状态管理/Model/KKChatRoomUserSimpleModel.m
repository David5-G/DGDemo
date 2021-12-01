//
//  KKChatRoomUserSimpleModel.m
//  kk_espw
//
//  Created by david on 2019/7/31.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomUserSimpleModel.h"

@implementation KKChatRoomUserSimpleModel
+(NSDictionary *)mj_objectClassInArray {
    return @{@"userMedalDetails" : @"KKChatRoomMetalSimpleModel"};
}

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"hostId" : @"anchorId" };
}
@end
