//
//  KKLiveStudioModel.m
//  kk_espw
//
//  Created by david on 2019/7/31.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioModel.h"

@implementation KKLiveStudioModel
+(NSDictionary *)mj_objectClassInArray {
    return @{@"firstJoinUsers" : @"KKChatRoomUserSimpleModel"};
}

+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"studio" : @"channel",
             @"host" : @"anchor",
             @"chatRoom" : @"group"
             };
}
@end


#pragma mark -

@implementation KKLiveStudioChatRoomSimpleModel
+(NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"idStr" : @"id",
             @"name" : @"groupName",
             @"code" : @"groupCode"
             };
}
@end
