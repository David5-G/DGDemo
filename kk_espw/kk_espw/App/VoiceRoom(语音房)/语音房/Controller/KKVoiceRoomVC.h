//
//  KKVoiceRoomVCViewController.h
//  kk_espw
//
//  Created by david on 2019/10/14.
//  Copyright © 2019 david. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKVoiceRoomVC : BaseViewController
/** 获取单例 */
+ (instancetype)shareInstance;

/** 房间id */
@property (nonatomic, copy) NSString *roomId;

/** 移除rtc配置 */
-(void)removeRtcConfig;

/** push推出self */
-(void)pushSelfByNavi:(UINavigationController *)navi;

@end

NS_ASSUME_NONNULL_END
