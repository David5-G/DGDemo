//
//  KKHomeRoomListInfo.m
//  kk_espw
//
//  Created by 景天 on 2019/7/15.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKHomeRoomListInfo.h"
#import "KKCalculateTextWidthOrHeight.h"

@implementation KKUserGameTag

@end


@implementation KKHomeRoomListInfo
- (void)mj_keyValuesDidFinishConvertingToObject {
    self.userNameWidth = [KKCalculateTextWidthOrHeight getWidthWithAttributedText:self.userName font:[KKFont pingfangFontStyle:PFFontStyleRegular size:RH(15)] height:RH(21)];
    
    self.ownerGameBoardCount = [NSString stringWithFormat:@"局数%@", self.ownerGameBoardCount];
    self.ownerGameBoardCountWidth = [KKCalculateTextWidthOrHeight getWidthWithAttributedText:self.ownerGameBoardCount font:[KKFont kkFontStyle:KKFontStyleREEJIHonghuangLiMedium size:RH(9)] height:RH(14)] + 6;
    
    self.reliableScore = [NSString stringWithFormat:@"靠谱%@", self.reliableScore];
    self.reliableScoreWidth = [KKCalculateTextWidthOrHeight getWidthWithAttributedText:self.reliableScore font:[KKFont kkFontStyle:KKFontStyleREEJIHonghuangLiMedium size:RH(9)] height:RH(14)] + 6;
}

+ (NSDictionary *)mj_objectClassInArray {
    return @{
             @"lackPosition" : @"KKMessage",
             @"userGameTagCountList" : @"KKUserGameTag",
             @"medalDetailList" : @"KKUserMedelInfo"
             };
}

@end
