//
//  KKHomeVC.m
//  kk_espw
//
//  Created by david on 2019/7/5.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKHomeVC.h"
#import "KKHomeHeaderView.h"
#import "KKSelectHeaderView.h"
#import "KKHomeRecommendCell.h"
#import "KKCardsSelectView.h"
#import "KKCreateCardView.h"
#import "KKHomeService.h"
#import "NoContentReminderView.h"
#import "KKSearchViewController.h"
#import "KKQRCodeViewController.h"
#import "DGFloatButton.h"
#import "KKFloatLiveStudioView.h"
#import "KKFloatGameRoomView.h"
#import "KKMyCardService.h"
#import "KKCardTag.h"
#import "KKMessage.h"
#import "KKCreateGameRoomController.h"
#import "KKGameRoomOwnerController.h"
#import "KKHomeRoomListInfo.h"
#import "KKGameRoomBaseController.h"
#import "KKRankListViewController.h"
#import "KKShareGameBoardViewController.h"
#import "KKBanner.h"
#import "KKDiscoverDetailViewController.h"
#import "KKTabBadgeValueManager.h"
#import "KKLiveStudioVC.h"
#import "KKLiveStudioRtcMgr.h"
#define kStudioId @"200003"
#import "KKHomeTeachView.h"
#import "KKHomeRoomStatus.h"
#import "KKLiveStudioRtcMgr.h"
#import "KKPlayTTService.h"
#import "KKAddMyCardViewController.h"
#import "KKGameRoomManager.h"
@interface KKHomeVC ()<UITableViewDelegate, UITableViewDataSource, KKHomeHeaderViewDelegate, CatDefaultPopDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) KKHomeHeaderView *homeHeaderView; /// 头部师徒
@property (nonatomic, strong) KKCardsSelectView *cardsSelectView; /// 名片选择视图
@property (nonatomic, strong) KKCreateCardView *createCardView; /// 快捷创建名片
@property (nonatomic, strong) NSMutableArray *dataList; /// 开黑房列表数据源
@property (nonatomic, strong) NoContentReminderView *notDateView; /// 无数据视图
@property (nonatomic, strong) KKUserInfoModel *mineInfo; /// 个人信息Model
@property (nonatomic, strong) KKPaginator *paginator; /// 分页器
@property (nonatomic, strong) NSMutableArray *cards; /// 名片数据数组
@property (nonatomic, strong) NSMutableArray *bannerIds; /// Banner
@property (nonatomic, strong) KKCardTag *lastCard; /// 上一次的对局名片
@property (nonatomic, assign) KKTapWherePopCardListFalg1 tapWherePopCardListFalg; /// 点击筛选还是房间列表 弹出名片列表的标志
@property (nonatomic, strong) CatDefaultPop *pop;
@property (nonatomic, strong) CatDefaultPop *alertExitLiveStudio;
@property (nonatomic, strong) CatDefaultPop *alertExitGameGoard;
@property (nonatomic, strong) CatDefaultPop *alertExitLiveWithCreteKH;
@property (nonatomic, strong) KKHomeRoomStatus *roomStatusTop; /// 招募厅信息
@property (nonatomic, strong) KKHomeRoomListInfo *currentListInfo; /// 点击列表数据获得的当前的Model
@property (nonatomic, strong) KKSelectHeaderView *selectHeaderView; /// 筛选的头部视图
@property (nonatomic, copy) NSString *rank; /// 点击了 全部, 筛选的标志
@property (nonatomic, assign) BOOL didSelectCreateGameRoomVC;
@property (nonatomic, assign) BOOL isShowAlert; /// 防止弹窗多次弹出
@end

@implementation KKHomeVC
#pragma mark - Init
- (NoContentReminderView *)notDateView{
    if (!_notDateView) {
        _notDateView = [[NoContentReminderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 200)];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"暂无开黑房!" withColor:[UIColor grayColor]];
        [NoContentReminderView showReminderViewToView:_notDateView imageTopY:(SCREEN_HEIGHT - 300) / 2 image:[UIImage imageNamed:@"data_is_null"] remindWords:attribute];
        _notDateView.hidden = YES;
    }
    return _notDateView;
}

- (NSMutableArray *)bannerIds {
    if (!_bannerIds) {
        _bannerIds = [NSMutableArray array];
    }
    return _bannerIds;
}

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [NSMutableArray array];
    }
    return _cards;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TAB_BAR_HEIGHT + STATUS_BAR_HEIGHT - RH(20)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[KKHomeRecommendCell class] forCellReuseIdentifier:@"KKHomeRecommendCell"];
        _tableView.tableFooterView = New(UIView);
        _tableView.tableHeaderView = self.homeHeaderView;
    }
    return _tableView;
}

- (KKHomeHeaderView *)homeHeaderView {
    if (!_homeHeaderView) {
        _homeHeaderView = [[KKHomeHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [ccui getRH:320])];
        _homeHeaderView.delegate = self;
    }
    return _homeHeaderView;
}

#pragma mark - UI
- (void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeClear];
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
}

/// 进入开黑房后, 将退出上一个开黑房
- (void)showAlert {
    if (self.isShowAlert == NO) {
        self.pop = [[CatDefaultPop alloc] initWithTitle:@"是否进入?" content:@"进入开黑房后, 将退出上一个开黑房?" cancelTitle:@"取消" confirmTitle:@"确定"];
        self.pop.delegate = self;
        [self.pop popUpCatDefaultPopView];
        self.pop.popView.contentLb.textAlignment = NSTextAlignmentCenter;
        [self.pop updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
    }
    self.isShowAlert = YES;
}

/// 创建开黑的时候展示, 创建黑房, 将退出直播厅
- (void)showAlertExitLiveWithCreteKH {
    self.alertExitLiveWithCreteKH = [[CatDefaultPop alloc] initWithTitle:@"提示" content:@"创建开黑房将退出招募厅,是否确定离开招募厅" cancelTitle:@"取消" confirmTitle:@"确定"];
    self.alertExitLiveWithCreteKH.delegate = self;
    [self.alertExitLiveWithCreteKH popUpCatDefaultPopView];
    self.alertExitLiveWithCreteKH.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    [self.alertExitLiveWithCreteKH updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
}

/// 进入开黑房后, 将退出招募厅
- (void)showAlertExitLiveStudioAction {
    self.alertExitLiveStudio = [[CatDefaultPop alloc] initWithTitle:@"是否进入?" content:@"进入开黑房后, 将退出招募厅?" cancelTitle:@"取消" confirmTitle:@"确定"];
    self.alertExitLiveStudio.delegate = self;
    [self.alertExitLiveStudio popUpCatDefaultPopView];
    self.alertExitLiveStudio.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    [self.alertExitLiveStudio updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
}

/// 进入这个直播厅, 将退出当前开黑房
- (void)showAlertExitGameBoard {
    self.alertExitGameGoard = [[CatDefaultPop alloc] initWithTitle:@"是否进入?" content:@"进入这个直播厅, 将退出当前开黑房?" cancelTitle:@"取消" confirmTitle:@"确定"];
    self.alertExitGameGoard.delegate = self;
    [self.alertExitGameGoard popUpCatDefaultPopView];
    self.alertExitGameGoard.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    [self.alertExitGameGoard updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
}

/// 初始化名片列表
- (void)initCardListView {
    WS(weakSelf)
    self.cardsSelectView = [[KKCardsSelectView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.cardsSelectView.didSelectTableViewCellBlock = ^(KKCardTag * _Nonnull card) {
        /// 点击筛选
        if (weakSelf.tapWherePopCardListFalg == KKTapedSelect) {
            if ([card.nickName isEqualToString:@"全部"]) {
                [KKHomeService shareInstance].rank = @"";
                [KKHomeService shareInstance].platFormType = @"";
                weakSelf.rank = @"全部";
                /// 点击了全部.
                [KKHomeService shareInstance].page = @(1);
                [weakSelf.dataList removeAllObjects];
                [weakSelf requestHomeListData];
            }else if ([card.nickName isEqualToString:@"添加名片"]) {
                /// 点击了添加名片.
                [weakSelf pushAddCardVC];
            }else {
                /// 开黑房筛选, 段位和区
                [KKHomeService shareInstance].rank = card.rank.name;
                [KKHomeService shareInstance].platFormType = card.platformType.name;
                [weakSelf.dataList removeAllObjects];
                [KKHomeService shareInstance].page = @(1);
                [weakSelf requestHomeListData];
                weakSelf.rank = [NSString stringWithFormat:@"%@-%@", card.platformType.message, card.rank.message];
                /// 名片修改
                weakSelf.lastCard = card;
            }
            /// 移除
            [weakSelf.cardsSelectView removeFromSuperview];
            return ;
        }
        /// 点击开黑房列表
        if (weakSelf.tapWherePopCardListFalg == KKTapedRoomList) {
            if ([card.nickName isEqualToString:@"添加名片"]) {
                /// 点击了添加名片.
                [weakSelf pushAddCardVC];
            }else {
                /// 选择的入局名片
                weakSelf.lastCard = card;
                if ([KKFloatViewMgr shareInstance].liveStudioModel.studioId.length > 0) {
                    [weakSelf showAlertExitLiveStudioAction];
                }else {
                    [KKHomeService request_game_board_join_consult_dataWithProfilesId:card.ID gameRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId success:^{
                        
                        if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId <= 0) {
                            
                            [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:card.ID groupId:weakSelf.currentListInfo.groupId];
                        }else {
                            if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId == weakSelf.currentListInfo.gameRoomId) {
                                [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:card.ID groupId:weakSelf.currentListInfo.groupId];
                            }else {
                                
                                [weakSelf showAlert];
                            }
                        }
                    } fail:^(NSString * _Nonnull errorMsg, NSString * _Nonnull errorName) {
                        if ([errorName isEqualToString:@"PURCHASE_ORDER_IS_EXISTED"] || [errorName isEqualToString:@"GAME_BOARD_JOIN_HAS_OCCUPY"]) {
                            weakSelf.isShowAlert = NO;
                            [weakSelf showAlert];
                        }else {
                            [CC_Notice show:errorMsg];
                        }
                    }];
                }
            }
            /// 移除
            [weakSelf.cardsSelectView removeFromSuperview];
        }
    };
    [[UIApplication sharedApplication].keyWindow addSubview:self.cardsSelectView];
}

- (void)initCardView {
    WS(weakSelf)
    _createCardView = [[KKCreateCardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:_createCardView];
    _createCardView.addCardSuccessBlock = ^{
        [weakSelf requestLasttimeGameboardData:^(KKCardTag *lastCard) {
        }];
    };
}

- (void)showTeachView {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"showTeachViewKey%@",[KKNetworkConfig shareInstance].oneAuth_id]]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"showTeachViewKey%@",[KKNetworkConfig shareInstance].oneAuth_id]];
        KKHomeTeachView *teachView = [[KKHomeTeachView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [self.tabBarController.view addSubview:teachView];
    }
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ccui getRH:142];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKHomeRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKHomeRecommendCell"];
    if (indexPath.row < self.dataList.count) {
        cell.info = self.dataList[indexPath.row];
    }
    cell.isSearch = NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _currentListInfo = self.dataList[indexPath.row];
    if ([_currentListInfo.proceedStatus.name isEqualToString:@"PROCESSING"]) {
        [CC_Notice show:@"比赛正在进行中"];
        return;
    }
    if ([_currentListInfo.proceedStatus.name isEqualToString:@"FINISH"]) {
        [CC_Notice show:@"比赛已结束"];
        return;
    }
    if ([_currentListInfo.proceedStatus.name isEqualToString:@"CANCEL"]) {
        [CC_Notice show:@"比赛关闭"];
        return;
    }
    WS(weakSelf)
    if ([_currentListInfo.proceedStatus.name isEqualToString:@"RECRUIT"]) {
        
        [self judgeCurrentTableViewCellInfoCurrentGameBoardId:_currentListInfo.gameBoardId currentRoomId:_currentListInfo.gameRoomId proId:_lastCard.ID canPush:^{
            if ([KKFloatViewMgr shareInstance].liveStudioModel.studioId.length != 0) {
                [weakSelf showAlertExitLiveStudioAction];
            }else {
                /// 可以进入
                [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:weakSelf.lastCard.ID groupId:weakSelf.currentListInfo.groupId];
            }
        } isCreateCradList:^{
            weakSelf.tapWherePopCardListFalg = KKTapedRoomList;
            /// 名片不一致, 弹出名片列表
            [weakSelf requestCardListInfo];
            [weakSelf initCardListView];
        } showAlertGoNewGameBoard:^{
            weakSelf.isShowAlert = NO;
            [weakSelf showAlert];
            
        } showAlertLiveStudio:^{
            [weakSelf showAlertExitLiveStudioAction];
        }];
    }
}

/// 判断条件
- (void)judgeCurrentTableViewCellInfoCurrentGameBoardId:(NSString *)currentGameBoardId
                              currentRoomId:(NSInteger)currentRoomId
                                           proId:(NSString *)proId
                                         canPush:(void(^)(void))canPush
                                isCreateCradList:(void(^)(void))isCreateCradList
                         showAlertGoNewGameBoard:(void(^)(void))showAlertGoNewGameBoard
                             showAlertLiveStudio:(void(^)(void))showAlertLiveStudio
{
    /// 有名片
    if (_lastCard.ID.length != 0) {
        /// 没有未完成的局
            if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId <= 0) {
                /// 也不再招募厅
                if ([KKFloatViewMgr shareInstance].liveStudioModel.studioId.length == 0) {
                    
                    if ([_rank isEqualToString:@"全部"]) {
                    isCreateCradList();
                    
                }else if (_rank != nil) {
                    
                    [KKHomeService request_game_board_join_consult_dataWithProfilesId:proId gameRoomId:self.currentListInfo.gameRoomId gameBoardId:self.currentListInfo.gameBoardId success:^{
                        canPush();
                    } fail:^(NSString * _Nonnull errorMsg, NSString * _Nonnull errorName) {
                        [CC_Notice show:errorMsg];
                    }];
                }

            }else {
                /// 退出招募厅在进入
                if ([_rank isEqualToString:@"全部"]) {
                    
                    isCreateCradList();
                    
                }else if (_rank != nil) {
                    
                    showAlertLiveStudio();
                }
            }
            
        }else {
            WS(weakSelf)
            if ([_rank isEqualToString:@"全部"]) {
                
                [KKHomeService request_game_board_join_consult_dataWithProfilesId:proId gameRoomId:self.currentListInfo.gameRoomId gameBoardId:self.currentListInfo.gameBoardId success:^{
                    if (weakSelf.currentListInfo.gameRoomId == [KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId) {
                        
                        canPush();
                        return ;
                    }else {
                        
                        [weakSelf showAlert];
                    }
                } fail:^(NSString * _Nonnull errorMsg, NSString * _Nonnull errorName) {
                    isCreateCradList();
                }];
                
            }else if (_rank != nil) {
                [KKHomeService request_game_board_join_consult_dataWithProfilesId:proId gameRoomId:self.currentListInfo.gameRoomId gameBoardId:self.currentListInfo.gameBoardId success:^{
                    if (weakSelf.currentListInfo.gameRoomId == [KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId) {
                        
                        [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:proId groupId:weakSelf.currentListInfo.groupId];
                        return ;
                    }else {
                        
                        [weakSelf showAlert];
                    }
                    
                    
                } fail:^(NSString * _Nonnull errorMsg, NSString * _Nonnull errorName) {
                    if ([errorName isEqualToString:@"USER_GAME_PROFILES_NOT_CONFORM"]) {
                        
                        [[KKFloatViewMgr shareInstance] tryToLeaveGameRoom:^{
                            [CC_Notice show:@"开黑房段位不符合，你已退出开黑房"];
                            [[KKFloatViewMgr shareInstance] removeFloatGameBoardView];
                        }];
                        return ;
                    }else if ([errorName isEqualToString:@"PURCHASE_ORDER_IS_EXISTED"] || [errorName isEqualToString:@"GAME_BOARD_JOIN_HAS_OCCUPY"]) {
                        
                        [weakSelf showAlert];
                    }else {
                        
                        [CC_Notice show:errorMsg];
                    }
                    
                }];
            }
        }
    }else {
        [self initCardView];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WS(weakSelf)
    _selectHeaderView = [[KKSelectHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [ccui getRH:39])];
    /// 点击了筛选, 有名片的时候弹出名片列表
    _selectHeaderView.didTapSelectButtonBlock = ^{
        weakSelf.tapWherePopCardListFalg = KKTapedSelect;
        [weakSelf requestCardListInfo];
        [weakSelf initCardListView];
    };
    _selectHeaderView.selectViewTitle = _rank;
    return _selectHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return [ccui getRH:39];
}

#pragma mark - KKHomeHeaderViewDelegate
- (void)didSelectedSDCycleScrollViewIndex:(NSInteger)index {
    KKBanner *banner = self.bannerIds[index];
    if (banner.linkUrl) {
        NSLog(@"打开网页");
        KKDiscoverDetailViewController *vc = New(KKDiscoverDetailViewController);
        vc.linkUrl = banner.linkUrl;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        KKDiscoverDetailViewController *vc = New(KKDiscoverDetailViewController);
        vc.bodyId = banner.ID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)didSelectedSearchButton {
    [self pushToSearchVC];
}

- (void)didSelectedLeftView {
    [self pushRankListVC];
}

- (void)didSelectedScanButton {
//    [KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId = 1;
}

/// 点击头部视图的招募厅
- (void)didSelectedRightView {
    if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId > 0) { /// 在开黑房
        [self showAlertExitGameBoard];
    }else {
        [self tryToJoinLiveStudio:self.roomStatusTop.channelId];
    }
}

- (void)catDefaultPopCancel:(CatDefaultPop *)defaultPop {
    if (defaultPop == self.alertExitLiveStudio) {
        self.alertExitLiveStudio = nil;
        
    }else if (defaultPop == self.pop) {
        self.pop = nil;
        
    }else if (defaultPop == self.alertExitGameGoard) {
        self.alertExitGameGoard = nil;
        
    }else if(defaultPop == self.alertExitLiveWithCreteKH) {
        self.alertExitLiveWithCreteKH = nil;
    }
    self.isShowAlert = NO;
}

#pragma mark - catDefaultPopConfirm
- (void)catDefaultPopConfirm:(CatDefaultPop*)defaultPop{
    WS(weakSelf)
    if (defaultPop == self.alertExitLiveStudio) { /// 退出招募厅, 进入开黑房
        
        [KKHomeService request_game_board_join_consult_dataWithProfilesId:_lastCard.ID gameRoomId:_currentListInfo.gameRoomId gameBoardId:_currentListInfo.gameBoardId success:^{
            
            
            [[KKFloatViewMgr shareInstance] tryToLeaveLiveStudio:^{
                
                [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:weakSelf.lastCard.ID groupId:weakSelf.currentListInfo.groupId];
            }];
            
        } fail:^(NSString * _Nonnull errorMsg, NSString * _Nonnull errorName) {
            [[KKFloatViewMgr shareInstance] tryToLeaveLiveStudio:^{
                
                [CC_Notice show:errorMsg];
            }];
        }];
        
        
        
    }else if (defaultPop == self.pop) { /// 退出上一个开黑房 进入当前开黑房
        [[KKFloatViewMgr shareInstance] tryToLeaveGameRoom:^{
            
            /// 退出开黑房之后, 校验名片
            [KKHomeService request_game_board_join_consult_dataWithProfilesId:weakSelf.lastCard.ID gameRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId success:^{
                
                [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:weakSelf.lastCard.ID groupId:weakSelf.currentListInfo.groupId];
            } fail:^(NSString * _Nonnull errorMsg, NSString * _Nonnull errorName) {
                [CC_Notice show:errorMsg];
            }];
        }];
        
    }else if (defaultPop == self.alertExitGameGoard) { /// 进入直播厅退出当前开黑房
        [[KKFloatViewMgr shareInstance] tryToLeaveGameRoom:^{
            [weakSelf tryToJoinLiveStudio:weakSelf.roomStatusTop.channelId];
        }];
        
    }else if(defaultPop == self.alertExitLiveWithCreteKH) { /// 离开招募厅, 再去创建开黑
        /// 离开成功, 判断名片, 并清空缓存[studioId]
        WS(weakSelf)
        [[KKFloatViewMgr shareInstance] tryToLeaveLiveStudio:^{
            [weakSelf pushToCreateGameVC];
        }];
    }
    self.isShowAlert = NO;
}


#pragma mark - Jump
/// 进入招募厅
- (void)pushToLiveStudioVCWithStudioId:(NSString *)studioId {
    KKLiveStudioVC *liveStudioVC = [KKLiveStudioVC shareInstance];
    liveStudioVC.studioId = studioId;
    [liveStudioVC pushSelfByNavi:[KKRootContollerMgr getRootNav]];
}

/// 进入扫一扫
- (void)pushToQRCodeVC {
//    KKQRCodeViewController *vc = [[KKQRCodeViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}

// 进入搜索
- (void)pushToSearchVC {
    KKSearchViewController *vc = [[KKSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

/// 进入添加名片
- (void)pushAddCardVC {
    KKAddMyCardViewController *vc = [[KKAddMyCardViewController alloc] init];
    vc.isEdit = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 进入排行榜
- (void)pushRankListVC {
    KKRankListViewController *vc = New(KKRankListViewController);
    [self.navigationController pushViewController:vc animated:YES];
}

/// 进入开黑房详情
- (void)pushGameBoardDetailRoomId:(NSInteger)roomid gameBoardId:(NSString *)gameBoardId gameProfilesId:(NSString *)gameProfilesId groupId:(NSString *)groupId {

    [[KKFloatViewMgr shareInstance] hiddenGameRoomFloatView];
    [[KKIMMgr shareInstance] checkAndConnectRCSuccess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [KKGameRoomOwnerController sharedInstance].gameProfilesIdStr = gameProfilesId;
            [KKGameRoomOwnerController sharedInstance].gameBoardIdStr = gameBoardId;
            [KKGameRoomOwnerController sharedInstance].gameRoomId = roomid;
            [KKGameRoomOwnerController sharedInstance].groupIdStr = groupId;
            [[KKRootContollerMgr getRootNav] pushViewController:[KKGameRoomOwnerController sharedInstance] animated:YES];
        });
    } error:^(RCConnectErrorCode status) {
        [CC_Notice show:@"聊天室连接失败"];
    }];
}

/// 创建开黑
- (void)pushToCreateGameVC {
    if (self.didSelectCreateGameRoomVC == NO) {
        self.didSelectCreateGameRoomVC = YES;
        [self performSelector:@selector(avoidRePush) withObject:nil afterDelay:1.0f];
    }
}

- (void)avoidRePush {
    self.didSelectCreateGameRoomVC = NO;
    WS(weakSelf)
    /// 在招募厅
    if ([KKFloatViewMgr shareInstance].liveStudioModel.studioId.length != 0) {
        [self showAlertExitLiveWithCreteKH];
        return;
    }
    CCLOG(@"[KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId = %lu", [KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId);
    
    /// 在开黑房
    if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId > 0){
        
        [KKHomeService request_game_board_join_consult_dataWithProfilesId:[KKFloatViewMgr shareInstance].gameRoomModel.gameProfilesIdStr gameRoomId:[KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId gameBoardId:[KKFloatViewMgr shareInstance].gameRoomModel.gameBoardIdStr success:^{
            /// 有黑框都允许进入
            [[KKGameRoomManager sharedInstance] joinGameRoomWithGameBoardId:[KKFloatViewMgr shareInstance].gameRoomModel.gameBoardIdStr Success:^{
                [weakSelf pushGameBoardDetailRoomId:[KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId gameBoardId:[KKFloatViewMgr shareInstance].gameRoomModel.gameBoardIdStr gameProfilesId:[KKFloatViewMgr shareInstance].gameRoomModel.gameProfilesIdStr groupId:[KKFloatViewMgr shareInstance].gameRoomModel.groupIdStr];
                
            }];
        } fail:^(NSString * _Nonnull errorMsg, NSString * _Nonnull errorName) {
            if ([errorName isEqualToString:@"USER_GAME_PROFILES_NOT_CONFORM"]) {
                [[KKFloatViewMgr shareInstance] tryToLeaveGameRoom:^{
                    [CC_Notice show:@"开黑房段位不符合，你已退出开黑房"];
                    [[KKFloatViewMgr shareInstance] removeFloatGameBoardView];
                }];
                return ;
            }
            
            [[KKFloatViewMgr shareInstance] tryToLeaveGameRoom:^{
                [CC_Notice show:errorMsg];
                [[KKFloatViewMgr shareInstance] removeFloatGameBoardView];
            }];
        }];
        return;
    }else if(_lastCard.ID.length != 0) {
        /// 创建开黑
        KKCreateGameRoomController *vc = [[KKCreateGameRoomController alloc] init];
        [[KKRootContollerMgr getRootNav] pushViewController:vc animated:YES];
        /// 有未完成的局
    }else {
        [self initCardView];
    }
}

#pragma mark - Net
/// 请求Banner轮播信息
- (void)requestBannerData {
    WS(weakSelf)
    [KKHomeService requestBannerDataSuccess:^(NSMutableArray * _Nonnull dataList) {
        NSMutableArray *banners = [NSMutableArray array];
        for (NSInteger i = 0; i < dataList.count; i ++) {
            KKBanner *banner = dataList[i];
            NSString *imgStr = [NSString stringWithFormat:@"%@%@", banner.imageUrl, banner.ID];
            [banners addObject:imgStr];
        }
        weakSelf.bannerIds = dataList;
        weakSelf.homeHeaderView.imagesURLStrings = banners;
    } Fail:^{
    }];
}

- (void)loadData {
    WS(weakSelf)
    [self.tableView addSimpleHeaderRefresh:^{
           weakSelf.paginator.page = 1;
           [weakSelf.dataList removeAllObjects];
           [weakSelf requestHomeRoomStatusData];
           [weakSelf requestBannerData];
           [weakSelf requestLasttimeGameboardData:^(KKCardTag *lastCard) {}];
//           [[KKFloatViewMgr shareInstance] requestGameRoomGroupInfo:^(bool success) {}];
     }];
    
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        SS(strongSelf)
        if (strongSelf->_paginator.page < strongSelf->_paginator.pages) {
            weakSelf.paginator.page++;
            [strongSelf requestHomeListData] ;
        }else{
            [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

/// 请求开黑房间列表
- (void)requestHomeListData {
    WS(weakSelf)
    [KKHomeService shareInstance].page = self.paginator?@(self.paginator.page):@(1);
    [KKHomeService requestHomeListSuccess:^(NSMutableArray * _Nonnull dataList, KKPaginator * _Nonnull paginator) {
        [weakSelf.dataList addObjectsFromArray:dataList];
        [weakSelf.tableView reloadData];
        if (weakSelf.dataList.count == 0) {
            weakSelf.tableView.tableFooterView = weakSelf.notDateView;
            weakSelf.notDateView.hidden = NO;
        }else {
            weakSelf.tableView.tableFooterView = New(UIView);
            weakSelf.notDateView.hidden = YES;
        }
        weakSelf.paginator = paginator;
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    } Fail:^{
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

/// 请求首页的房间状态
- (void)requestHomeRoomStatusData {
    WS(weakSelf)
    [KKHomeService requestHomeRoomStatusDataSuccess:^(NSMutableArray * _Nonnull dataList) {
        weakSelf.roomStatusTop = dataList.firstObject;
        weakSelf.homeHeaderView.status = dataList.firstObject;
    } Fail:^{
    }];
}

/// 请求名片列表
- (void)requestCardListInfo {
    [self.cards removeAllObjects];
    [[CC_Mask getInstance] startAtView:self.cardsSelectView.whiteView];
    WS(weakSelf)
    [KKMyCardService requestCardTagListSuccess:^(NSMutableArray * _Nonnull dataList) {
        [[CC_Mask getInstance] stop];
        weakSelf.cards = dataList;
        [weakSelf dealData];
    } Fail:^{
        [[CC_Mask getInstance] stop];
    }];
}

/// 请求上一次的对局
- (void)requestLasttimeGameboardData:(void(^)(KKCardTag *lastCard))completeLastCard {
    WS(weakSelf)
    [KKHomeService requestLastTimeGameBoadDataSuccess:^(KKCardTag * _Nonnull lastCard, KKMessage * _Nonnull message) {
        weakSelf.rank = [NSString stringWithFormat:@"%@-%@", lastCard.platformType.message, lastCard.rank.message];
        weakSelf.lastCard = lastCard;
        if (lastCard.ID.length != 0) {
            [KKHomeService shareInstance].rank = lastCard.rank.name;
            [KKHomeService shareInstance].platFormType = lastCard.platformType.name;
        }else {
            [KKHomeService shareInstance].rank = @"";
            [KKHomeService shareInstance].platFormType = @"";
            weakSelf.rank = @"全部";
        }
        [self requestHomeListData];
        [weakSelf.tableView reloadData];
        completeLastCard(lastCard);
    } Fail:^{
    }];
}

/// 点击筛选, 没有名片的时候是 @[@"全部", @"添加名片"]. 有名片的时候 @[@"全部", @"名片列表List", @"添加名片"]
- (void)dealData {
    /// 数据处理, 筛选的时候才有全部, 点击开黑房列表的时候, 只是单纯的选择名片
    if (_tapWherePopCardListFalg == KKTapedSelect) {
        KKCardTag *card = New(KKCardTag);
        card.nickName = @"全部";
        [self.cards insertObject:card atIndex:0];
    }
    /// 添加名片
    KKCardTag *addCard = New(KKCardTag);
    addCard.nickName = @"添加名片";
    [self.cards addObject:addCard];
    self.cardsSelectView.dataList = self.cards;
}

-(void)tryToJoinLiveStudio:(NSString *)studioId {
    WS(weakSelf)
    [[KKLiveStudioRtcMgr shareInstance] requestJoinStudio:studioId success:^{
        [weakSelf pushToLiveStudioVCWithStudioId:studioId];
        [KKFloatViewMgr shareInstance].liveStudioModel = nil;
    }];
}

#pragma mark - Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    UIImageView *headerBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [ccui getRH:146])];
    headerBg.image = Img(@"home_top_yellow_bg");
    [self.view addSubview:headerBg];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self setupNavi];
    [self setupUI];
    [self loadData];
    /// 显示引导图
    [self showTeachView];
    /// 创建开黑房防止重复点击
    self.didSelectCreateGameRoomVC = NO;
    /// 点击了关闭招募厅, 刷新招募厅的数据
    WS(weakSelf)
    [KKFloatViewMgr shareInstance].tapCloseButtonBlock = ^{
        [weakSelf requestHomeRoomStatusData];
    };
    self.isShowAlert = NO;
    
    [[KKFloatViewMgr shareInstance] addObserver:self forKeyPath:@"gameRoomModel" options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"GAME_ROOM_HAS_DISSOLVE_NOTIFICATION" object:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{

}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        /// 点击tab 开黑按钮时
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToCreateGameVC) name:NOTIFICATION_PUSH_CREATEGAME_VC object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestHomeRoomStatusData];
    /// 检查开黑房, 招募厅的状态
    [[KKFloatViewMgr shareInstance] checkShowFloatView];
}

- (void)dealloc {
    CCLOG(@"dealloc-----------------------");
    [[KKFloatViewMgr shareInstance] removeObserver:self forKeyPath:@"gameRoomModel"];
}
@end
