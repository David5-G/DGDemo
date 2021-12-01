//
//  KKShareGameInfo.h
//  kk_espw
//
//  Created by 景天 on 2019/8/2.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKMessage.h"
NS_ASSUME_NONNULL_BEGIN

@interface KKShareGameInfo : NSObject
@property (nonatomic, strong) KKMessage *shareUserSex;
@property (nonatomic, copy) NSString *shareUserLoginName;
@property (nonatomic, copy) NSString *shareUserLogoUrl;
@property (nonatomic, copy) NSString *shareUserId;
@property (nonatomic, copy) NSString *groupId;
@end

NS_ASSUME_NONNULL_END
