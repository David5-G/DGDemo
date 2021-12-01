//
//  KKLiveStudioOnlineUserPopVC.m
//  kk_espw
//
//  Created by david on 2019/8/7.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomOnlineUserPopVC.h"
//view
#import "KKChatRoomOnlineUserListView.h"
#import "KKChatRoomOnlineUserCell.h"


@interface KKChatRoomOnlineUserPopVC ()
@property (nonatomic, strong) KKChatRoomOnlineUserListView *listView;
@end

@implementation KKChatRoomOnlineUserPopVC


#pragma mark - UI
-(void)setupSubViewsForDisplayView:(UIView *)displayView {
    CGFloat leftSpace = 0;
    CGFloat topSpace = [ccui getRH:10];
    CGFloat titleH = [ccui getRH:40];
    WS(weakSelf);
    
    //1.title
    DGLabel *titleL = [DGLabel labelWithText:@"在线用户" fontSize:[ccui getRH:18] color:KKES_COLOR_BLACK_TEXT bold:YES];
    titleL.textAlignment = NSTextAlignmentCenter;
    [displayView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftSpace);
        make.top.mas_equalTo(topSpace);
        make.right.mas_equalTo(leftSpace);
        make.height.mas_equalTo(titleH);
    }];
    
    //2.grayLine
    [self addGrayLineToView:titleL];
    
    //3.listV
    KKChatRoomOnlineUserListView *listV = [[KKChatRoomOnlineUserListView alloc]init];
    [listV setConfigBlock:^(KKChatRoomOnlineUserCell *cell, KKChatRoomUserSimpleModel *model, NSIndexPath *indexPath) {
        cell.nameLabel.text = model.loginName;
        [cell.portraitImageView sd_setImageWithURL:Url(model.userLogoUrl)];
        cell.isHostCheck = weakSelf.isHostCheck;
        cell.isOnMic = model.onMic;
        cell.isForbid = model.forbidChat;
        cell.handleViewHidden = [model.userId isEqualToString:weakSelf.hostUserId];
        cell.localImageName = [[KKGameRoomContrastModel shareInstance].medalMapDic objectForKey:model.userMedalDetails.firstObject.currentMedalLevelConfigCode];
        
    } selectBlock:^(KKChatRoomUserSimpleModel *model, NSIndexPath *indexPath) {
        [[KKPlayerGameCardTool shareInstance] showUserInfo:model.userId roomId:weakSelf.roomId needKick:weakSelf.playerGameCardNeedKick isHostCheck:NO isOnMic:model.onMic delegate:weakSelf.playerGameCardDelegate];
    }];
    self.listView = listV;
    [displayView addSubview:listV];
    [listV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topSpace+titleH);
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-HOME_INDICATOR_HEIGHT);
    }];

    //3.1  header refresh
    [listV.tableView addSimpleHeaderRefresh:^{
        //请求
        weakSelf.userListViewModel.onlinePaginator = nil;
        [weakSelf requestOnlineUsers];
    }];
    [listV.tableView beginHeaderRefresh];
    
    //3.2 footer refresh
    [listV.tableView addAutoFooterRefreshWithPercent:0 block:^{
        //请求
        if (weakSelf.userListViewModel.onlinePaginator) {
            weakSelf.userListViewModel.onlinePaginator.page += 1;
        }
        [weakSelf requestOnlineUsers];
    }];
}


-(void)addGrayLineToView:(UIView *)view {
    UIView *grayLine = [[UIView alloc]init];
    grayLine.backgroundColor = rgba(245, 245, 245, 1);
    
    [view addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}


#pragma mark - request

#pragma mark online users
-(void)requestOnlineUsers {
    WS(weakSelf);
    [self.userListViewModel requestOnlineUsers:^(NSInteger code) {
        SS(strongSelf);
        
        //1.停止refresh
        //1.1 请求被拦截, 没有更多数据
        if (-3 == code) {
            [strongSelf.listView.tableView endFooterRefreshWithNoMoreData];
            return ;
        }
        
        [strongSelf.listView.tableView endHeaderRefresh];
        [strongSelf.listView.tableView endFooterRefresh];
        //1.1 请求失败, 或被拦截
        if (code < 0) {
            return;
        }
        
        //2.有数据 刷新tableView
        strongSelf.listView.dataArray = strongSelf.userListViewModel.onlineUsers;
        [strongSelf.listView.tableView reloadData];
        
    }];
}

@end
