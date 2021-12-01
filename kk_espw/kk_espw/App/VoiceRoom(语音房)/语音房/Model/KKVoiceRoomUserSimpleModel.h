//
//  KKVoiceRoomUserSimpleModel.h
//  kk_espw
//
//  Created by david on 2019/10/17.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKVoiceRoomUserSimpleModel : NSObject
#pragma mark - 基本属性
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *loginName;

@property (nonatomic, copy) NSString *userLogoUrl;

@end

NS_ASSUME_NONNULL_END
