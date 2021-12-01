//
//  KKLiveStudioOnlineUserView.h
//  kk_espw
//
//  Created by david on 2019/7/18.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKLiveStudioOnlineUserView : UIView

/** 设置 头像数组 */
-(void)setUserLogoUrlArray:(NSArray *)logoUrlArray;

/** 设置 总人数 */
-(void)setUserCount:(NSInteger)count;

/** 设置 总人数view的背景色 */
-(void)setOnlineUserCountViewBackgroundColor:(UIColor *)bgColor;

@end

NS_ASSUME_NONNULL_END
