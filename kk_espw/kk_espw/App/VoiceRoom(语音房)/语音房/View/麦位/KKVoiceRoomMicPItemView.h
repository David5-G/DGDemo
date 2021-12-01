//
//  KKVoiceRoomMicPItemView.h
//  kk_espw
//
//  Created by david on 2019/10/16.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, KKVoiceRoomMicPStatus) {
    KKVoiceRoomMicPStatusAbsent = 1,//虚以待位
    KKVoiceRoomMicPStatusPresent,//在位
    KKVoiceRoomMicPStatusClose,//关闭
};

typedef NS_ENUM(NSUInteger, KKVoiceRoomMicPSexType) {
    KKVoiceRoomMicPSexTypeUnknown = 1,//未知
    KKVoiceRoomMicPSexTypeMale,//男
    KKVoiceRoomMicPSexTypeFemale,//女
};

@interface KKVoiceRoomMicPItemView : UIView

///点击回调block
@property (nonatomic, copy) void(^tapPortraitBlock)(KKVoiceRoomMicPItemView *itemView);

/**
 麦位状态,
 注意:麦位状态设置会清空其他属性(包含:portraitUrlStr,name,sexType,isSpeaking,isHost,userId)
 */
@property (nonatomic, assign) KKVoiceRoomMicPStatus status;

///头像图片
@property (nonatomic, copy) NSString *portraitUrlStr;
///名字
@property (nonatomic, copy) NSString *name;
///性别
@property (nonatomic, assign) KKVoiceRoomMicPSexType sexType;
///是否 正在说话(是否触发动效)
@property (nonatomic, assign) BOOL isSpeaking;
///是否是房主
@property (nonatomic, assign) BOOL isHost;

#pragma mark - 工具属性,用于存值
//tag存了micId

//用户id
@property (nonatomic, copy) NSString *userId;

@end

NS_ASSUME_NONNULL_END
