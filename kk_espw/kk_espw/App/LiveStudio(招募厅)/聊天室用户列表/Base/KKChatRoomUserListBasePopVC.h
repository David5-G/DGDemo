//
//  KKLiveStudioBasePopVC.h
//  kk_espw
//
//  Created by david on 2019/8/7.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKBottomPopVC.h"
//viewModel
#import "KKChatRoomUserListViewModel.h"
#import "KKLiveStudioViewModel.h"
//tool
#import "KKPlayerGameCardTool.h"
#import "KKGameRoomContrastModel.h"


NS_ASSUME_NONNULL_BEGIN

/** 聊天室用户列表PopVC */
@interface KKChatRoomUserListBasePopVC : KKBottomPopVC

/** 房间id */
@property (nonatomic, copy) NSString *roomId;
/** 主播/房主 的id */
@property (nonatomic, copy) NSString *hostUserId;
/** 是否是 主播/房主查看 */
@property (nonatomic, assign) BOOL isHostCheck;

/** 是否需要跳过权限校验 true为跳过
 *  语音房 要设为true
 *  招募厅 要设为false
 */
@property (nonatomic, assign) BOOL canForbidConsult;


/** 用户列表的viewModel */
@property (nonatomic, strong) KKChatRoomUserListViewModel *userListViewModel;

/** playerGameCardDelegate */
@property (nonatomic, strong) id<KKPlayerGameCardToolDelagate> playerGameCardDelegate;

/** playerGameCard 是否需要踢出房间 */
@property (nonatomic, assign) BOOL playerGameCardNeedKick;
@end

NS_ASSUME_NONNULL_END
