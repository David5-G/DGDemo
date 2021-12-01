//
//  KKHomeRoomListInfo.h
//  kk_espw
//
//  Created by 景天 on 2019/7/15.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKUserGameTag : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *gameTagId;
@property (nonatomic, copy) NSString *gameTagCount;
@property (nonatomic, copy) NSString *tagCode;
@property (nonatomic, copy) NSString *orderNumber;
@end

@interface KKHomeRoomListInfo : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userHeaderImgUrl;
@property (nonatomic, strong) KKMessage *sex;
@property (nonatomic, strong) KKMessage *shareUserSex;
@property (nonatomic, copy) NSString *gameBoardId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *onlineCount;
@property (nonatomic, strong) KKMessage *rank; /// 白银
@property (nonatomic, strong) KKMessage *patternType; /// 五人模式
@property (nonatomic, strong) KKMessage *platFormType; /// 微信
@property (nonatomic, copy) NSString *gmtCreate;
@property (nonatomic, copy) NSArray *ownerPosition;
@property (nonatomic, strong) NSArray *lackPosition;
@property (nonatomic, strong) NSArray *userGameTagCountList; /// 标签list
@property (nonatomic, strong) NSArray *medalDetailList;
@property (nonatomic, copy) NSString *reliableScore; // 靠谱分
@property (nonatomic, strong) KKMessage *proceedStatus;
@property (nonatomic, copy) NSString *ownerGameBoardCount;
@property (nonatomic, assign) int gameRoomId;
@property (nonatomic, strong) KKMessage *depositType;
@property (nonatomic, copy) NSString *male;
@property (nonatomic, copy) NSString *female;
@property (nonatomic, assign) CGFloat userNameWidth;
@property (nonatomic, assign) CGFloat ownerGameBoardCountWidth;
@property (nonatomic, assign) CGFloat reliableScoreWidth;

@end

NS_ASSUME_NONNULL_END
