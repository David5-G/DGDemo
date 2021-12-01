//
//  KKGameChatOnlinePeopleModel.h
//  kk_espw
//
//  Created by hsd on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 聊天室在线人数model
@interface KKGameChatOnlinePeopleModel : NSObject

@property (nonatomic, copy, nullable) NSString *idStr;
@property (nonatomic, copy, nullable) NSString *userId;
@property (nonatomic, copy, nullable) NSString *groupId;
@property (nonatomic, copy, nullable) NSString *gmtCreate;
@property (nonatomic, copy, nullable) NSString *gmtFirstJoin;
@property (nonatomic, copy, nullable) NSString *gmtLastQuit;
@property (nonatomic, copy, nullable) NSString *gmtModified;
@property (nonatomic, copy, nullable) NSString *gmtLastJoin;
@property (nonatomic, copy, nullable) NSString *oneAuthId;

@property (nonatomic, assign) NSInteger sequenceValue;
@property (nonatomic, assign) NSInteger lastQuitReason;
@property (nonatomic, assign) NSInteger joined;


@end

NS_ASSUME_NONNULL_END
