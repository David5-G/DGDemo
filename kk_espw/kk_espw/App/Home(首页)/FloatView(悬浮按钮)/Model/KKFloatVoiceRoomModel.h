//
//  KKFloatVoiceRoomModel.h
//  kk_espw
//
//  Created by david on 2019/10/17.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKFloatVoiceRoomModel : NSObject
//1.房间id
@property (nonatomic, assign) NSInteger roomId;
//2.房主名字
@property (nonatomic, copy) NSString *ownerName;
//3.房主头像
@property (nonatomic, copy) NSString *ownerLogoUrl;
//4.房主Id
@property (nonatomic, copy) NSString *ownerUserId;
//5.channelId
@property (nonatomic, copy) NSString *channelId;

@end

NS_ASSUME_NONNULL_END
