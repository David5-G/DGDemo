//
//  KKLiveStudioOnlineUserListView.h
//  kk_espw
//
//  Created by david on 2019/7/24.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomUserListBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKChatRoomOnlineUserListView : KKChatRoomUserListBaseView
@property (nonatomic, strong, readonly) UITableView *tableView;
@end

NS_ASSUME_NONNULL_END
