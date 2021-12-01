//
//  KKVoiceRoomSimpleModel.m
//  kk_espw
//
//  Created by david on 2019/10/17.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKVoiceRoomSimpleModel.h"

@implementation KKVoiceRoomSimpleModel
+(NSDictionary *)mj_objectClassInArray {
    return @{@"firstJoinUsers" : @"KKVoiceRoomMicPSimpleModel",
             @"micPSimples" : @"KKVoiceRoomMicPSimpleModel" };
}

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"micPSimples" : @"roomMemberSimples",
             @"idStr" : @"id" };
}
@end
