//
//  KKVoiceRoomModel.m
//  kk_espw
//
//  Created by jingtian9 on 2019/10/15.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKHomeVoiceRoomModel.h"
#import "KKCalculateTextWidthOrHeight.h"
@implementation KKHomeVoiceRoomModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
             @"ID" : @"id"
             };
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"medalDetailList" : @"KKUserMedelInfo"
             };
}

- (void)mj_keyValuesDidFinishConvertingToObject {
    self.userNameWidth = [KKCalculateTextWidthOrHeight getWidthWithAttributedText:self.nickName font:[KKFont pingfangFontStyle:PFFontStyleRegular size:RH(11)] height:RH(21)];
}
@end
