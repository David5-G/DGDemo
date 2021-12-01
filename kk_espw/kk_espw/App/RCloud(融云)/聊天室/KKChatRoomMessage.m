//
//  KKChatRoomMessage.m
//  kk_espw
//
//  Created by 阿杜 on 2019/8/9.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomMessage.h"
#import "KKChatRoomCustomMsg.h"

@implementation KKChatRoomMessage

+(KKChatRoomMessage *)messageWithRCMgr:(RCMessage *)rcMsg {
    return [self messageWithRCMgr:rcMsg dark:NO];
}


+(KKChatRoomMessage *)messageWithRCMgr:(RCMessage *)rcMsg dark:(BOOL)isDark {
    
    UIColor *nameTextColor = isDark ? rgba(168, 168, 168, 1) : rgba(153, 153, 153, 1);
    UIColor *contentTextColor = isDark ? UIColor.whiteColor : rgba(51, 51, 51, 1);
    
    //1.创建KKChatRoomMessage
    KKChatRoomMessage *uiMsg = [KKChatRoomMessage new];
    uiMsg.rcMsg = rcMsg;
    
    //2.设置attributeContent
    NSMutableAttributedString *mutAtt;
    //2.1 是RCTextMessage
    if ([rcMsg.content isKindOfClass:[RCTextMessage class]]) {
        //RCTextMessage需要记录UI样式
        uiMsg.isDark = isDark;
        //2.1.1 名字: 内容
        RCTextMessage *textMsg = (RCTextMessage *)rcMsg.content;
        NSString *name = [NSString stringWithFormat:@"%@：",textMsg.senderUserInfo.name];
        NSString *text = [NSString stringWithFormat:@"%@%@",name,textMsg.content];
        mutAtt = [[NSMutableAttributedString alloc] initWithString:text attributes:@{     NSFontAttributeName:[KKFont pingfangFontStyle:PFFontStyleMedium size:13], NSForegroundColorAttributeName:contentTextColor}];
        [mutAtt addAttribute:NSForegroundColorAttributeName value:nameTextColor range:[text rangeOfString:name]];
        //2.1.2 勋章
        NSString *currentMedalLevelConfigCode = textMsg.senderUserInfo.extra;
        if (currentMedalLevelConfigCode) {
            //img
            UIImage *levelImg = Img([KKDataDealTool returnImageStr:[currentMedalLevelConfigCode stringByReplacingOccurrencesOfString:@"#" withString:@"_"]]);
            //color
            UIColor *mostColor = [CC_GColor getImageMayColor:levelImg];
            [mutAtt addAttribute:NSForegroundColorAttributeName value:mostColor range:[text rangeOfString:name]];
            //富文本
            NSTextAttachment *levelAtt = [[NSTextAttachment alloc] init];
            levelAtt.image = levelImg;
            float h = [ccui getRH:15];
            float w = levelImg.size.width/levelImg.size.height*h;
            levelAtt.bounds = CGRectMake(0, -[ccui getRH:3], w, h);
            [mutAtt insertAttributedString:[NSAttributedString attributedStringWithAttachment:levelAtt] atIndex:0];
        }
    }
    //2.2 是KKChatRoomCustomMsg
    else if ([rcMsg.content isKindOfClass:[KKChatRoomCustomMsg class]]){
        KKChatRoomCustomMsg *chatRoomMsg = (KKChatRoomCustomMsg *)rcMsg.content;
        mutAtt = [[NSMutableAttributedString alloc] initWithString:chatRoomMsg.content attributes:@{NSFontAttributeName:[KKFont pingfangFontStyle:PFFontStyleMedium size:13],NSForegroundColorAttributeName:rgba(185, 116, 81, 1)}];
        uiMsg.backGroundColor = rgba(244, 234, 227, 1);
    }

    //赋值
    uiMsg.attributeContent = mutAtt;
    
    //3.size
    CGFloat maxW = SCREEN_WIDTH- 2 * [ccui getRH:28];
    CGRect rect = [mutAtt boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil];
    
    //ios13特殊处理
    if (@available(iOS 13.0, *)) {
        CGFloat w = rect.size.width * 1.02;
        rect.size.width = w>maxW ? maxW : w;
    }
    
    uiMsg.contentSize = rect.size;
    
    //4.return
    return uiMsg;
}

@end
