//
//  KKCheckInfo.h
//  kk_espw
//
//  Created by 景天 on 2019/8/1.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKCheckInfo : NSObject

@property (nonatomic, copy) NSString *gameProfilesId;
@property (nonatomic, copy) NSString *gameBoardId;
@property (nonatomic, assign) NSInteger gameRoomId;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *orderNo;
@property (nonatomic, copy) NSString *ownerUserId;
@property (nonatomic, copy) NSString *joined;

@property (nonatomic, copy) NSString *groupOwnerType;
@property (nonatomic, copy) NSString *gameJoinId;

@end

NS_ASSUME_NONNULL_END
