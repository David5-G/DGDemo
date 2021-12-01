//
//  KKVoiceRoomModel.h
//  kk_espw
//
//  Created by jingtian9 on 2019/10/15.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KKMessage;
NS_ASSUME_NONNULL_BEGIN

@interface KKHomeVoiceRoomModel : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *ownerUserLogoUrl;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *medalLogoUrl;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *chatRoomTitle;
@property (nonatomic, strong) KKMessage *ownerUserSex;
@property (nonatomic, assign) NSInteger enabled;
@property (nonatomic, copy) NSString *male;
@property (nonatomic, copy) NSString *female;
@property (nonatomic, copy) NSString *ownerUserId;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, strong) KKMessage *roomStatus;
@property (nonatomic, strong) NSArray *medalDetailList; /// 标签list
@property (nonatomic, assign) CGFloat userNameWidth;
@end

NS_ASSUME_NONNULL_END
