//
//  KKLiveStudioBasePopVC.m
//  kk_espw
//
//  Created by david on 2019/8/7.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomUserListBasePopVC.h"

@implementation KKChatRoomUserListBasePopVC

 
-(KKChatRoomUserListViewModel *)userListViewModel {
    if (!_userListViewModel) {
        _userListViewModel = [[KKChatRoomUserListViewModel alloc]init];
        _userListViewModel.channelId = self.roomId;
        _userListViewModel.canForbidConsult = self.canForbidConsult;
    }
    return _userListViewModel;
}

@end
