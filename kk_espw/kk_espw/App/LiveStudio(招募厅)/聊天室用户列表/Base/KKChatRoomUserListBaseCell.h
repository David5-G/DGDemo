//
//  KKChatRoomUserListCell.h
//  kk_espw
//
//  Created by david on 2019/10/22.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KKChatRoomUserListBaseCellDelegate <NSObject>
@optional
/** 禁言/取消禁言 */
-(void)triggerView:(UIView *)view setForbidWord:(BOOL)isForbid;
/** 抱上麦/抱下麦 */
-(void)triggerView:(UIView *)view setMicGive:(BOOL)isGive;
@end

#pragma mark -
@interface KKChatRoomUserListBaseCell : UITableViewCell

@end

NS_ASSUME_NONNULL_END
