//
//  KKMineVC.m
//  kk_espw
//
//  Created by david on 2019/7/5.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKMineVC.h"
#import "KKMineVCListDoubleCell.h"
#import "KKMineVCListCell.h"
#import "KKMineHeaderView.h"
#import "KKEditUserInfoController.h"
#import "KKMyCardsViewController.h"
#import "KKSystemSettingViewController.h"
#import "KKMySkillViewController.h"
#import "KKLiveStudioHostEnterVC.h"
#import "KKUserFeedbackViewController.h"
#import "KKMyWalletViewController.h"
#import "KKPlayTogeOrderListViewController.h"
#import "KKIntegralWorkViewController.h"
#import "KKH5Service.h"
#import "KKH5Url.h"
#import <bench_ios/CC_FormatDic.h>
#import "LoginLib.h"
//temp
#import "KKVoiceRoomVC.h"
#import "KKVoiceRoomRtcMgr.h"

@interface KKMineVC ()<UITableViewDelegate, UITableViewDataSource, KKMineHeaderViewDelegate, CatDefaultPopDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *dataImageArray;
@property (nonatomic, strong) KKMineHeaderView *kKMineHeaderView;
@property (nonatomic, strong) KKUserInfoModel *mineInfo;
@property (nonatomic, copy) NSString *shareURL;
@property (nonatomic, strong) CatDefaultPop *alertExitGameGoard;
@property (nonatomic, strong) CatDefaultPop *alertExitVoiceWiilJoinLiveStudio;
@end

@implementation KKMineVC
- (KKMineHeaderView *)kKMineHeaderView {
    if (!_kKMineHeaderView) {
        WS(weakSelf)
        _kKMineHeaderView = [[KKMineHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [ccui getRH:236])];
        _kKMineHeaderView.delegate = self;
        /// 点击整个头部都可以编辑资料
        [_kKMineHeaderView addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            [weakSelf pushToEditVC];
        }];
    }
    return _kKMineHeaderView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [ccui getRH:241], SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[KKMineVCListDoubleCell class] forCellReuseIdentifier:@"KKMineVCListDoubleCell"];
        [_tableView registerClass:[KKMineVCListCell class] forCellReuseIdentifier:@"KKMineVCListCell"];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorColor = [UIColor clearColor];
        _tableView.bounces = NO;
    }
    return _tableView;
}

#pragma mark - UI
- (void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeClear];
}

- (void)setupUI {
    [self.view addSubview:self.kKMineHeaderView];
    [self.view addSubview:self.tableView];
}

/// 进入这个直播厅, 将退出当前开黑房
- (void)showAlertExitGameBoard {
    self.alertExitGameGoard = [[CatDefaultPop alloc] initWithTitle:@"是否进入?" content:@"进入这个直播厅, 将退出当前开黑房?" cancelTitle:@"取消" confirmTitle:@"确定"];
    self.alertExitGameGoard.delegate = self;
    [self.alertExitGameGoard popUpCatDefaultPopView];
    self.alertExitGameGoard.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    [self.alertExitGameGoard updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
}

/// 进入招募厅, 将退出语音房
- (void)showAlertExitVoiceWiilJoinLiveStudio {
    self.alertExitVoiceWiilJoinLiveStudio = [[CatDefaultPop alloc] initWithTitle:@"是否进入?" content:@"进入这个招募厅, 将退出当前语音房?" cancelTitle:@"取消" confirmTitle:@"确定"];
    self.alertExitVoiceWiilJoinLiveStudio.delegate = self;
    [self.alertExitVoiceWiilJoinLiveStudio popUpCatDefaultPopView];
    self.alertExitVoiceWiilJoinLiveStudio.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    [self.alertExitVoiceWiilJoinLiveStudio updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
}

- (KKMineVCListCell *)getMineVCListCellIndex:(NSInteger)index tableView:(UITableView *)tableView idf:(NSString *)idf {
    KKMineVCListCell *cell = [tableView dequeueReusableCellWithIdentifier:idf];
    cell.titleLabel.text = _dataArray[index];
    cell.icon.image = _dataImageArray[index];
    return cell;
}

- (KKMineVCListDoubleCell *)getMineVCListDoubleCellIndex1:(NSInteger)index1 index2:(NSInteger)index2 tableView:(UITableView *)tableView idf:(NSString *)idf {
    KKMineVCListDoubleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKMineVCListDoubleCell"];
    cell.titleLabel.text = _dataArray[index1];
    cell.titleLabelCopy.text = _dataArray[index2];
    cell.icon.image = _dataImageArray[index1];
    cell.iconCopy.image = _dataImageArray[index2];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        if (_mineInfo.userMedalDetailList.count == 0) {
            return RH(60);
        }else {
            return RH(110);
        }
    }else if(indexPath.row == 1) {
        if (_mineInfo.anchor == NO && _mineInfo.channelAllowAnchors.count == 0) {
            return RH(60);
        }else {
            return RH(110);
        }
    }else if (indexPath.row == 2){
        return RH(60);
    }
    return [ccui getRH:0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    if (indexPath.row == 0) {
        if (_mineInfo.userMedalDetailList.count == 0) {
            KKMineVCListCell *cell = [self getMineVCListCellIndex:1 tableView:tableView idf:@"KKMineVCListCell"];
            cell.tapRowBlock = ^{
                [weakSelf pushToPlayTogeOrderListVC];
            };
            return cell;
        }else {
            KKMineVCListDoubleCell *cell = [self getMineVCListDoubleCellIndex1:0 index2:1 tableView:tableView idf:@"KKMineVCListDoubleCell"];
            cell.tapRowTopBlock = ^{
                [weakSelf pushToMySkillVC];
            };
            cell.tapRowBottomBlock = ^{
                [weakSelf pushToPlayTogeOrderListVC];
            };
            return cell;
        }

    }else if (indexPath.row == 1){
        if (_mineInfo.anchor == NO) {
            KKMineVCListCell *cell = [self getMineVCListCellIndex:3 tableView:tableView idf:@"KKMineVCListCell"];
            cell.tapRowBlock = ^{
                [weakSelf requestActivityURL];
            };
            return cell;
        }else {
            WS(weakSelf)
            KKMineVCListDoubleCell *cell = [self getMineVCListDoubleCellIndex1:2 index2:3 tableView:tableView idf:@"KKMineVCListDoubleCell"];
            cell.tapRowTopBlock = ^{
                if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId > 0) {
                    [weakSelf showAlertExitGameBoard];
                }else if ([KKFloatViewMgr shareInstance].voiceRoomModel.roomId > 0){
                    [weakSelf showAlertExitVoiceWiilJoinLiveStudio];
                }else {
                    [weakSelf pushToStartLiveStudioVC];
                }
            };
            cell.tapRowBottomBlock = ^{
                [weakSelf requestActivityURL];
            };
            return cell;
        }

    }else if(indexPath.row == 2) {
        KKMineVCListCell *cell = [self getMineVCListCellIndex:4 tableView:tableView idf:@"KKMineVCListCell"];
        cell.tapRowBlock = ^{
            [weakSelf pushToUserFeedbackVC];
        };
        return cell;
    }
    return nil;
}

#pragma mark - KKMineHeaderViewDelegate
- (void)didSelectedSetupButton {
    [self pushToSettingVC];
}

- (void)didSelectedEditButton {
    [self pushToEditVC];
}

- (void)didSelectedHeaderButton {

}

- (void)didSelectedWalletButton {
    [self pushToMyWalletVC];
}

- (void)didSelectedCardsButton {
    [self pushToMyCardsVC];
}

- (void)didSelectedWeeksWorkButton {
    [self pushToWeekendsWorkVC];
}

- (void)catDefaultPopConfirm:(CatDefaultPop*)defaultPop{
    WS(weakSelf)
    if (defaultPop == self.alertExitGameGoard) { /// 进入直播厅退出当前开黑房
        [[KKFloatViewMgr shareInstance] tryToLeaveGameRoom:^{
            [weakSelf pushToStartLiveStudioVC];
        }];
        
    }else if (defaultPop == self.alertExitVoiceWiilJoinLiveStudio){
        [[KKFloatViewMgr shareInstance] tryLeaveVoiceRoom:^{
            [weakSelf pushToStartLiveStudioVC];
        }];
    }
}

#pragma mark - jump
- (void)pushToWeekendsWorkVC {
    KKIntegralWorkViewController *vc = New(KKIntegralWorkViewController);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToEditVC {
    KKEditUserInfoController *vc = New(KKEditUserInfoController);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToSettingVC {
    KKSystemSettingViewController *vc = New(KKSystemSettingViewController);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToMyCardsVC {
    KKMyCardsViewController *vc = New(KKMyCardsViewController);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToMySkillVC {
    KKMySkillViewController *vc = New(KKMySkillViewController);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToStartLiveStudioVC {
    KKLiveStudioHostEnterVC *vc = New(KKLiveStudioHostEnterVC);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToUserFeedbackVC {
    KKUserFeedbackViewController *vc = New(KKUserFeedbackViewController);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToMyWalletVC {
    KKMyWalletViewController *vc = New(KKMyWalletViewController);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushToPlayTogeOrderListVC {
    KKPlayTogeOrderListViewController *vc = New(KKPlayTogeOrderListViewController);
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Net
- (void)requestMyInfo {
    WS(weakSelf)
    [[KKUserInfoMgr shareInstance] requestUserInfoSuccess:^{
        weakSelf.mineInfo = [KKUserInfoMgr shareInstance].userInfoModel;
        weakSelf.kKMineHeaderView.mineInfo = weakSelf.mineInfo;
        if (weakSelf.mineInfo) {
            [weakSelf.tableView reloadData];
        }
    } fail:nil];
}

- (void)requestActivityURL {
    [[LoginLib getInstance] activityUrlCreate:@"espw" extraParamDic:nil atView:self.view mask:YES block:^(NSDictionary * _Nullable modifiedDic, ResModel * _Nonnull resModel) {
        if (resModel.resultDic[@"response"][@"url"]) {
            NSString *title = [NSString stringWithFormat:@"KK电竞邀请链接%@活动, 加入KK电竞, 一起组队上分吧", resModel.resultDic[@"response"][@"activityTitle"]];
            [KKShareTool configJShareWithPlatform:JSHAREPlatformWechatSession title:title text:@"加入KK电竞, 一起组队上分吧" url:resModel.resultDic[@"response"][@"url"] type:ActivityType];
        }
    }];
}

#pragma mark - 声明周期
- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = @[@"我的技能", @"开黑局订单", @"主持直播", @"邀请好友", @"用户反馈"];
    _dataImageArray = @[Img(@"mine_skill"), Img(@"mine_play"), Img(@"mine_live_ streaming"), Img(@"mine_invite_friend"), Img(@"mine_user_ feedback")];
    [self setupNavi];
    [self setupUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestMyInfo];
}

- (UIStatusBarStyle)getStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end
