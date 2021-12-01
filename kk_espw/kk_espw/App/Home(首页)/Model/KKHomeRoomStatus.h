//
//  KKHomeRoomStatus.h
//  kk_espw
//
//  Created by 景天 on 2019/7/26.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface KKHomeRoomStatus : NSObject
@property (nonatomic, copy) NSString *closeMic;
@property (nonatomic, copy) NSString *channelName;
@property (nonatomic, copy) NSString *inChannelUserCount;
@property (nonatomic, copy) NSString *channelId;
@property (nonatomic, copy) NSString *channelStatus;
@property (nonatomic, copy) NSString *anchorName;
@property (nonatomic, copy) NSString *anchorLogoUrl;
@property (nonatomic, strong) NSMutableArray *channelSimples;


@end

NS_ASSUME_NONNULL_END
