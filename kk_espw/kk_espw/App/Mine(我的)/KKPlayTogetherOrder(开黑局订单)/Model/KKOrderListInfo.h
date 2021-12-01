//
//  KKOrderListInfo.h
//  kk_espw
//
//  Created by 景天 on 2019/7/29.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KKMessage;

NS_ASSUME_NONNULL_BEGIN

@interface KKOrderListInfo : NSObject

@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, strong) KKMessage *proceedStatus;
@property (nonatomic, strong) KKMessage *payType;
@property (nonatomic, copy) NSString *purchaseOrderGmtCreate;
@property (nonatomic, copy) NSString *gmtBoardStart;
@property (nonatomic, copy) NSString *gmtStopPay;
@property (nonatomic, copy) NSString *nowDate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *gmtPay;
@property (nonatomic, copy) NSString *deposit;
@property (nonatomic, copy) NSString *gameBoardId;
@property (nonatomic, copy) NSString *ownerUserId;
@property (nonatomic, copy) NSString *ownerUserName;
@property (nonatomic, copy) NSString *ownerUserHeaderImgUrl;
@property (nonatomic, strong) NSArray *gamePosition;
@property (nonatomic, strong) KKMessage *gameRank;
@property (nonatomic, strong) KKMessage *platFormType;
@property (nonatomic, strong) KKMessage *patternType; /// 双人模式
@property (nonatomic, assign) BOOL purchaseDeposit;
@property (nonatomic, assign) BOOL redemption;
@property (nonatomic, copy) NSString *gameRoomId;
@property (nonatomic, strong) KKMessage *depositType;
@property (nonatomic, strong) NSArray *userGameTagCountList;
@property (nonatomic, assign) NSTimeInterval countNum;
@property (nonatomic, copy) NSString *gameEvaluateEnd;
@property (nonatomic, assign) NSTimeInterval gameEvaluateEndCountNum;



/**
 *  计数减1(countdownTime - 1)
 */
- (void)countDown;

/**
 *  将当前的countdownTime信息转换成字符串
 */
- (NSString *)currentTimeString;

- (void)gameEvaluateEndCountDown;

- (NSString*)currentGameEvaluateEndTimeString;
@end

NS_ASSUME_NONNULL_END
