//
//  KKVoiceRoomMicUserSimpleModel.h
//  kk_espw
//
//  Created by david on 2019/10/17.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKVoiceRoomMicPSimpleModel : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *userLogoUrl;

@property (nonatomic, copy) NSString *userLoginName;

@property (nonatomic, strong) KKNameMsgModel *sex;

///麦位是否可用
@property (nonatomic, assign) BOOL enabled;

@property (nonatomic, assign) NSInteger micId;

@end

NS_ASSUME_NONNULL_END
