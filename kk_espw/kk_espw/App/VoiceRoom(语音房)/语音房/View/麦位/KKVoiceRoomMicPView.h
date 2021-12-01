//
//  KKVoiceRoomMicPView.h
//  kk_espw
//
//  Created by david on 2019/10/16.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KKVoiceRoomMicPItemView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKVoiceRoomMicPView : UIView

@property (nonatomic, copy) void(^tapMicPItemBlock)(NSInteger index, KKVoiceRoomMicPItemView *itemView);

/** 根据添加到self中的循序index获取micPItemView */
-(KKVoiceRoomMicPItemView *)getItemViewAtIndex:(NSInteger)index;

/** 根据tag获取micPItemView */
-(KKVoiceRoomMicPItemView *)getItemViewWithTag:(NSInteger)tag;

/**
 * 根据tag获取micPItemView, 并改变它的状态
 * tag及对应KKVoiceRoomMicPSimpleModel的micId
 */
-(KKVoiceRoomMicPItemView *)changeMicPItemStatus:(KKVoiceRoomMicPStatus)status tag:(NSInteger)tag;


@end

NS_ASSUME_NONNULL_END
