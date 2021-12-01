//
//  KKCardInfo.h
//  kk_espw
//
//  Created by 景天 on 2019/7/24.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KKMessage;
NS_ASSUME_NONNULL_BEGIN

@interface KKCardInfo : NSObject
/*
 {
 "userId" : "10034004936981048100290980081957",
 "gameId" : 1,
 "evaluationProfileIds" : [
 
 ],
 "id" : "10034004982507920315990970015754",
 "serviceArea" : "33",
 "platformType" : {
 "name" : "WE_CHART",
 "message" : "微信"
 },
 "rank" : {
 "name" : "BRONZE",
 "message" : "青铜"
 },
 "reliableScore" : 100,
 "nickName" : "AppTest",
 "preferLocations" : [
 {
 "name" : "TOP",
 "message" : "上路"
 },
 {
 "name" : "ADC",
 "message" : "下路"
 }
 ]
 }
 */
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *gameId;
@property (nonatomic, copy) NSString *serviceArea;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, strong) KKMessage *platformType;
@property (nonatomic, strong) KKMessage *rank;
@property (nonatomic, copy) NSString *reliableScore;
@property (nonatomic, copy) NSString *nickName;
@end

NS_ASSUME_NONNULL_END
