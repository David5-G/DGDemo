//
//  KKLiveStreamService.h
//  kk_espw
//
//  Created by 景天 on 2019/7/26.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^requestAnchorPresidChannelBlockSuccess)(NSMutableArray *dataList);
typedef void(^requestAnchorPresidChannelBlockFail)(void);
@interface KKLiveStreamService : NSObject
@property (nonatomic, copy) requestAnchorPresidChannelBlockSuccess requestAnchorPresidChannelBlockSuccess;
@property (nonatomic, copy) requestAnchorPresidChannelBlockFail requestAnchorPresidChannelBlockFail;

/**
 初始化
 
 @return 实例
 */
+ (instancetype)shareInstance;

/**
 主播主持的直播间查询
 
 @param success success
 @param fail fail
 */
+ (void)requestAnchorPresidChannelDataSuccess:(requestAnchorPresidChannelBlockSuccess)success Fail:(requestAnchorPresidChannelBlockFail)fail;

+ (void)destroyInstance;
@end

NS_ASSUME_NONNULL_END
