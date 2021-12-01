//
//  KKLiveStudioUserMgrPopVC.h
//  kk_espw
//
//  Created by david on 2019/8/7.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomUserListBasePopVC.h"


#define KKLiveStudioUserMgrTitleOnline      @"在线用户"
#define KKLiveStudioUserMgrTitleMicRank     @"排麦用户"
#define KKLiveStudioUserMgrTitleForbidWord  @"禁言用户"

NS_ASSUME_NONNULL_BEGIN

/** 在具体请求中看code的意义 */

@interface KKChatRoomUserMgrPopVC : KKChatRoomUserListBasePopVC

/** 数组的元素是上边的宏定义 KKLiveStudioUserMgrTitleXXX*/
-(instancetype)initWithTitleArray:(NSArray <NSString *>*)titleArray;
/** 默认选中的index */
@property (nonatomic, assign) NSInteger defaultItemIndex;

/** 招募厅的 抱上/下麦的 回调block*/
@property (nonatomic, copy) void(^liveStudioGiveMicBlock)(BOOL isGive, NSString *userId, BOOL isRanking, void(^_Nullable block)(BOOL success));
/** 语音房的 抱上/下麦的 回调block */
@property (nonatomic, copy) void(^voiceRoomGiveMicBlock)(BOOL isGive, NSString *userId, void(^_Nullable block)(BOOL success));
@end

NS_ASSUME_NONNULL_END
