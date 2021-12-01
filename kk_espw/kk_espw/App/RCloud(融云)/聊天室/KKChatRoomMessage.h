//
//  KKChatRoomMessage.h
//  kk_espw
//
//  Created by 阿杜 on 2019/8/9.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKChatRoomMessage : NSObject

@property (nonatomic,strong) RCMessage *rcMsg;

@property (nonatomic,strong) NSAttributedString *attributeContent;

@property (nonatomic,assign) CGSize contentSize;
/** 用于cell的背景色 */
@property (nonatomic,strong) UIColor *backGroundColor;
/** 是否是dark模式的UI数据 */
@property (nonatomic, assign) BOOL isDark;

#pragma mark -
/**
  @brief 根据RCMessage构建KKChatRoomMessage
  @param rcMsg 融云的RCMessage
 
  @discussion 内部调用messageWithRCMgr:dark:方法(isDark=NO)
 */
+(KKChatRoomMessage *)messageWithRCMgr:(RCMessage *)rcMsg;

/**
  @brief 根据RCMessage构建KKChatRoomMessage
  @param rcMsg 融云的RCMessage
  @param isDark 是否是dark模式的UI数据
*/
+(KKChatRoomMessage *)messageWithRCMgr:(RCMessage *)rcMsg dark:(BOOL)isDark;

@end

NS_ASSUME_NONNULL_END
