//
//  KKVoiceRoomModel.m
//  kk_espw
//
//  Created by david on 2019/10/17.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKVoiceRoomModel.h"

@implementation KKVoiceRoomModel
+(NSDictionary *)mj_objectClassInArray {
    return @{@"firstJoinUsers" : @"KKVoiceRoomUserSimpleModel"};
}
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"voiceRoom" : @"voiceChatRoomDetailSimple"};
}
@end
