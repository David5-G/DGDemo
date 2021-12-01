//
//  KKUserInfoModel.h
//  kk_buluo
//
//  Created by david on 2019/3/19.
//  Copyright © 2019 yaya. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KKNameMsgModel.h"
#import "KKUserMedelInfo.h"
#import "KKHomeRoomStatus.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKUserInfoModel : NSObject


#pragma mark - 基本信息
/** 用户Id */
@property (nonatomic,copy) NSString *userId;

/** 用户名 */
@property (nonatomic, copy) NSString *nickName;

/** 用户头像 */
@property (nonatomic,copy) NSString *userLogoUrl;

/**
 性别
 M => 男
 F => 女
 U => 未知
 */
@property (nonatomic, strong) KKNameMsgModel *sex;

/** 年龄 */
@property (nonatomic, copy) NSString *age;

/** 生日 */
@property (nonatomic, copy) NSString *birthday;

/** 所在地区 */
@property (nonatomic, copy) NSString *userLocation;

/** 是否实名认证 */
@property (nonatomic, assign) BOOL realNameAuthentication;

/** 真实姓名 */
@property (nonatomic, copy) NSString *realName;

/**
 证件类型
 
 IDENTITY_CARD => 身份证
 PASSPORT => 护照
 OFFICER_CARD => 军官证
 SOLDIER_CARD => 士兵证
 BACK_HOMETOWN_CARD => 回乡证
 TEMP_INDENTITY_CARD => 临时身份证
 HOKOU => 户口簿
 POLICE_CARD => 警官证
 TAIWAN_CARD => 台胞证
 BUSINESS_LICENSE => 营业执照
 TW_HK_MC_LICENSE => 港澳台居民大陆通行证
 OTHERS => 其他证件
 */
@property (nonatomic, copy) NSString *certType;

/** 证件号码 */
@property (nonatomic, copy) NSString *certNo;

#pragma mark - 开黑
/** 勋章链接 */
@property (nonatomic, copy) NSString *medalLogoUrl;

/** 用户大神勋章 */
@property (nonatomic, strong) NSArray <KKUserMedelInfo *>*userMedalDetailList;

/** 用户被评价标签 */
@property (nonatomic, strong) NSDictionary *gameTagCountMap;

/** 押金价格 */
@property (nonatomic, copy) NSString *deposit;


#pragma mark - 直播

/** 是否是主播 */
@property (nonatomic, assign) BOOL anchor;

/** 主播id */
@property (nonatomic, copy) NSString *anchorId;

/** 允许直播 的直播厅 */
@property (nonatomic, strong) NSArray <KKHomeRoomStatus *>*channelAllowAnchors;

@end

NS_ASSUME_NONNULL_END
