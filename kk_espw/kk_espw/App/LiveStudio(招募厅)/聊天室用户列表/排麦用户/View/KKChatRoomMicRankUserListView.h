//
//  KKLiveStudioMicRankListView.h
//  kk_espw
//
//  Created by david on 2019/7/24.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomUserListBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKChatRoomMicRankUserListView : KKChatRoomUserListBaseView

@property (nonatomic, strong, readonly) UITableView *tableView;

/** 是否是 主播/房主 查看 */
@property (nonatomic, assign) BOOL isHostCheck;

@end

NS_ASSUME_NONNULL_END
