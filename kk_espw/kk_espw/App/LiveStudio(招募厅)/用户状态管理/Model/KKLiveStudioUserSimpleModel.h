//
//  KKLiveStudioUserSimpleModel.h
//  kk_espw
//
//  Created by david on 2019/7/31.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKLiveStudioMetalSimpleModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKLiveStudioUserSimpleModel : NSObject

#pragma mark - 基本属性
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *userLogoUrl;


#pragma mark - 主播独有
@property (nonatomic, copy) NSString *hostId;


#pragma mark - 状态属性
///是否在麦上
@property (nonatomic, assign) BOOL onMic;

///是否被禁言
@property (nonatomic, assign) BOOL forbidChat;

///用户佩戴的勋章
@property (nonatomic, strong) NSArray <KKLiveStudioMetalSimpleModel *>*userMedalDetails;
///是不是房主
@property (nonatomic, assign) BOOL isOwn;

@end

NS_ASSUME_NONNULL_END
