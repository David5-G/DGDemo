//
//  KKLiveStudioSimpleModel.h
//  kk_espw
//
//  Created by david on 2019/7/31.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKLiveStudioSimpleModel : NSObject
///在线人数
@property (nonatomic, assign) NSInteger inChannelUserCount;

///是否闭麦位
@property (nonatomic, assign) BOOL closeMic;

///直播间id
@property (nonatomic, copy) NSString *idStr;

///直播间名称
@property (nonatomic, copy) NSString *name;

///直播间状态：LIVE-直播中，BREAK-直播结束
@property (nonatomic, copy) NSString *status;

@end

NS_ASSUME_NONNULL_END
