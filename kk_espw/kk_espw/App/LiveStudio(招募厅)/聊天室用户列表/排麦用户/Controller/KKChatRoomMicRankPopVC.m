//
//  KKLiveStudioMicRankPopVC.m
//  kk_espw
//
//  Created by david on 2019/8/7.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomMicRankPopVC.h"
//view
#import "KKChatRoomMicRankUserListView.h"
#import "KKChatRoomMicRankCell.h"
#import "KKChatRoomMicRankCurrentRankInfoView.h"

@interface KKChatRoomMicRankPopVC ()
@property (nonatomic, strong) UIButton *rankButton;
@property (nonatomic, strong) KKChatRoomMicRankCurrentRankInfoView *rankInfoView;
@property (nonatomic, strong) KKChatRoomMicRankUserListView *listView;

@end

@implementation KKChatRoomMicRankPopVC

#pragma mark - UI
-(void)setupSubViewsForDisplayView:(UIView *)displayView {
    CGFloat tableViewLeftSpace = [ccui getRH:10];
    CGFloat topSpace = [ccui getRH:10];
    CGFloat titleH = [ccui getRH:40];
    
    //1.rankBtn
    DGButton *rankBtn = [DGButton btnWithFontSize:[ccui getRH:15] title:@"加入排麦" titleColor:UIColor.whiteColor];
    self.rankButton = rankBtn;
    rankBtn.hidden = self.isOnMic;
    [rankBtn setNormalTitle:@"加入排麦" selectedTitle:@"取消排麦"];
    [rankBtn setNormalTitleColor:UIColor.whiteColor selectedTitleColor:KKES_COLOR_YELLOW];
    [rankBtn setNormalBgColor:KKES_COLOR_YELLOW selectedBgColor:UIColor.clearColor];
    rankBtn.layer.cornerRadius = [ccui getRH:5];
    rankBtn.layer.masksToBounds = YES;
    rankBtn.layer.borderWidth = 1.0;
    rankBtn.layer.borderColor = UIColor.clearColor.CGColor;
    
    [displayView addSubview:rankBtn];
    [rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([ccui getRH:16]);
        make.right.mas_equalTo(-[ccui getRH:32]);
        make.height.mas_equalTo([ccui getRH:34]);
        make.width.mas_equalTo([ccui getRH:93]);
    }];
    
    WS(weakSelf);
    [rankBtn addClickWithTimeInterval:0.1 block:^(DGButton *btn) {
        if(btn.selected){
            [weakSelf requestMicRankQuit];
        }else{
            [weakSelf requestMicRankJoin];
        }
    }];
    
    //2.title
    DGLabel *titleL = [DGLabel labelWithText:@"当前排麦顺序" fontSize:[ccui getRH:14] color:KKES_COLOR_GRAY_TEXT];
    titleL.textAlignment = NSTextAlignmentCenter;
    [displayView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:30]);
        make.centerY.mas_equalTo(rankBtn);
    }];
    
    //3.rankInfoView
    KKChatRoomMicRankCurrentRankInfoView *rankInfoV = [[KKChatRoomMicRankCurrentRankInfoView alloc]init];
    self.rankInfoView = rankInfoV;
    rankInfoV.backgroundColor = rgba(255, 250, 240, 1.0);
    [displayView addSubview:rankInfoV];
    [rankInfoV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([ccui getRH:59]);
        make.bottom.mas_equalTo(-HOME_INDICATOR_HEIGHT);
    }];
    
    //4.listV
    KKChatRoomMicRankUserListView *listV = [[KKChatRoomMicRankUserListView alloc]init];
    listV.isHostCheck = NO;
    [listV setConfigBlock:^(KKChatRoomMicRankCell *cell, KKChatRoomUserSimpleModel *model, NSIndexPath *indexPath) {
        cell.nameLabel.text = model.loginName;
        [cell.portraitImageView sd_setImageWithURL:Url(model.userLogoUrl)];
        cell.rankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
        cell.isHostCheck = weakSelf.isHostCheck;
        cell.isOnMic = model.onMic;
        cell.localImageName = [[KKGameRoomContrastModel shareInstance].medalMapDic objectForKey:model.userMedalDetails.firstObject.currentMedalLevelConfigCode];
        
    } selectBlock:^(KKChatRoomUserSimpleModel * model, NSIndexPath *indexPath) {
        [[KKPlayerGameCardTool shareInstance] showUserInfo:model.userId roomId:weakSelf.roomId needKick:weakSelf.playerGameCardNeedKick isHostCheck:NO isOnMic:model.onMic delegate:weakSelf.playerGameCardDelegate];
        
    }];
    self.listView = listV;
    [displayView addSubview:listV];
    [listV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topSpace+titleH);
        make.left.mas_equalTo(tableViewLeftSpace);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(rankInfoV.mas_top);
    }];
    
    //4.1  header refresh
    [listV.tableView addSimpleHeaderRefresh:^{
        //请求
        [weakSelf requestMicRankUsers];
    }];
    [listV.tableView beginHeaderRefresh];
}


-(void)addGrayLineToView:(UIView *)view {
    UIView *grayLine = [[UIView alloc]init];
    grayLine.backgroundColor = rgba(219, 219, 219, 1);
    
    [view addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}

#pragma mark tool
-(void)setRankInfoViewWithRank:(NSInteger)rank model:(KKChatRoomUserSimpleModel *)model{
    self.rankInfoView.nameLabel.text = model.loginName;
    [self.rankInfoView.portraitImageView sd_setImageWithURL:Url(model.userLogoUrl)];
    self.rankInfoView.rankLabel.text = [NSString stringWithFormat:@"%ld",rank];
    self.rankInfoView.localImageName = [[KKGameRoomContrastModel shareInstance].medalMapDic objectForKey:model.userMedalDetails.firstObject.currentMedalLevelConfigCode];
}


#pragma mark - request
#pragma mark mic rank
/** 请求排麦列表 */
-(void)requestMicRankUsers {
    WS(weakSelf);
    [self.userListViewModel requestMicRankUsers:^(NSInteger code) {
        SS(strongSelf);
        
        //1.停止refresh
        [strongSelf.listView.tableView endHeaderRefresh];
        //过滤请求失败
        if (code < 0) {
            return ;
        }
        //2.是否在mic上
        NSInteger totolUserCount = self.userListViewModel.micRankUsers.count;
        strongSelf.ranking = code>0;
        if (code>0 && code <= totolUserCount) {
            KKChatRoomUserSimpleModel *model = self.userListViewModel.micRankUsers[code-1];
            [strongSelf setRankInfoViewWithRank:code model:model];
        }else{
            self.rankInfoView.rankInfoLabel.text = [NSString stringWithFormat:@"目前%ld个人正在排麦，赶快加入队伍上麦吧",totolUserCount];
        }
        
        //3.有数据 刷新tableView
        strongSelf.listView.dataArray = strongSelf.userListViewModel.micRankUsers;
        [strongSelf.listView.tableView reloadData];
    }];
}


/** 请求 加入排麦 */
-(void)requestMicRankJoin {
    WS(weakSelf);
    [self.userListViewModel requestMicRankJoin:^(NSInteger code) {
        SS(strongSelf);
        if (code >= 0 ) {
            strongSelf.rankButton.selected = YES;
            [strongSelf.listView.tableView beginHeaderRefresh];
        }
    }];
}

/** 请求 取消排麦 */
-(void)requestMicRankQuit{
    WS(weakSelf);
    NSString *myUserId = [KKUserInfoMgr shareInstance].userId;
    [self.userListViewModel requestMicRankQuit:myUserId success:^(NSInteger code) {
        SS(strongSelf);
        if (code >= 0 ) {
            strongSelf.rankButton.selected = YES;
            [strongSelf.listView.tableView beginHeaderRefresh];
        }
    }];
}


#pragma mark - setter
-(void)setRanking:(BOOL)ranking{
    _ranking =  ranking;
    
    //1.rankBtn
    self.rankButton.selected = ranking;
    self.rankButton.layer.borderColor = ranking ? KKES_COLOR_YELLOW.CGColor : UIColor.clearColor.CGColor;
    
    //2.rankInfo
    self.rankInfoView.ranking = ranking;
}


-(void)setIsOnMic:(BOOL)isOnMic {
    _isOnMic = isOnMic;
    self.rankButton.hidden = YES;
}
@end
