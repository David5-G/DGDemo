//
//  KKLiveStudioVC.h
//  kk_espw
//
//  Created by david on 2019/7/18.
//  Copyright © 2019 david. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKLiveStudioVC : BaseViewController

/** 获取单例 */
+ (instancetype)shareInstance;

/** 招募厅id */
@property (nonatomic, copy) NSString *studioId;

/** 进来的时候是否想成为主播 */
@property (nonatomic, assign) BOOL wantAsHost;

/** 移除rtc配置 */
-(void)removeRtcConfig;

/** push推出self */
-(void)pushSelfByNavi:(UINavigationController *)navi;

@end

NS_ASSUME_NONNULL_END
