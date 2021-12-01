//
//  KKSearchViewController.m
//  kk_espw
//
//  Created by 景天 on 2019/7/23.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKSearchViewController.h"
#import "MiSearchBar.h"
#import "KKHomeRecommendCell.h"
#import "KKHomeService.h"
#import "KKHomeRoomListInfo.h"
#import "KKMyCardService.h"
#import "KKGameRoomBaseController.h"
#import "KKCreateCardView.h"
#import "KKCardsSelectView.h"
#import "KKCardTag.h"
#import "KKGameRoomOwnerController.h"
#import "KKCheckInfo.h"
#import "KKHomeVC.h"
#import "KKLiveStudioRtcMgr.h"
#import "KKHomeRoomStatus.h"
 
#import "KKAddMyCardViewController.h"
#import "KKGameRoomManager.h"
@interface KKSearchViewController ()
<
UISearchBarDelegate,
UITableViewDelegate,
UITableViewDataSource,
CatDefaultPopDelegate
>
@property (nonatomic, strong) MiSearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;
@property (nonatomic, strong) NSMutableArray *cardIf;
@property (nonatomic, strong) KKCreateCardView *createCardView;
@property (nonatomic, strong) KKCardsSelectView *cardsSelectView;
@property (nonatomic, strong) KKCardTag *lastCard; /// 上一次的对局名片
@property (nonatomic, strong) CatDefaultPop *pop;
@property (nonatomic, strong) CatDefaultPop *alertExitLiveStudio;
@property (nonatomic, strong) KKCheckInfo *checkInfo;
@property (nonatomic, strong) KKHomeRoomStatus *roomStatus;
@property (nonatomic, strong) KKHomeRoomListInfo *currentListInfo;
@property (nonatomic, strong) KKHomeService *service;
@end

@implementation KKSearchViewController
#pragma mark - Init
- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray *)cardIf {
    if (!_cardIf) {
        _cardIf = [NSMutableArray array];
    }
    return _cardIf;
}

- (MiSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[MiSearchBar alloc] initWithFrame:CGRectMake(RH(15), STATUS_BAR_HEIGHT + RH(9), SCREEN_WIDTH - RH(70), RH(35)) placeholder:@"请输入房间ID"];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.searchBar.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - self.searchBar.bottom) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = New(UIView);
        [_tableView registerClass:[KKHomeRecommendCell class] forCellReuseIdentifier:@"KKHomeRecommendCell"];
    }
    return _tableView;
}

#pragma mark - UI
- (void)setUI {
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
}

- (void)setNavUI {
    WS(weakSelf)
    [self setNaviBarWithType:DGNavigationBarTypeClear];
    [self hideBackButton:YES];
    CC_Button *cancel = [CC_Button buttonWithType:UIButtonTypeCustom];
    cancel.left = self.searchBar.right;
    cancel.top = self.searchBar.top + RH(10);
    cancel.size = CGSizeMake(RH(44), RH(14));
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    cancel.titleLabel.font = RF(14);
    cancel.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:cancel];
    [cancel addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        [weakSelf popToHomeVC];
    }];
}

- (UIView *)getHeaderView {
    UIView *v = New(UIView);
    v.left = 0;
    v.top = 0;
    v.size = CGSizeMake(SCREEN_WIDTH, 58);
    v.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(RH(16), RH(25), [ccui getRH:100], [ccui getRH:13])];
    label.numberOfLines = 0;
    label.text = @"ID匹配结果";
    label.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:RH(14)];
    label.textColor = KKES_COLOR_BLACK_TEXT;
    [v addSubview:label];
    return v;
}

- (void)initCardView {
    WS(weakSelf)
    _createCardView = [[KKCreateCardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:_createCardView];
    _createCardView.addCardSuccessBlock = ^{
        [weakSelf requestLasttimeGameboardData];
    };
}

- (void)initCardListView {
    WS(weakSelf)
    self.cardsSelectView = [[KKCardsSelectView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.cardsSelectView.didSelectTableViewCellBlock = ^(KKCardTag * _Nonnull card) {
        /// 点击开黑房列表
        if ([card.nickName isEqualToString:@"添加名片"]) {
            /// 点击了添加名片.
            [weakSelf pushAddCardVC];
        }else {
            /// 选择的入局名片
            weakSelf.lastCard = card;
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
                
                if ([errorName isEqualToString:@"USER_GAME_PROFILES_NOT_CONFORM"]) {
                    
                    if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId > 0) {
                        
                        [[KKFloatViewMgr shareInstance] tryToLeaveGameRoom:^{
                            [CC_Notice show:@"开黑房段位不符合，你已退出开黑房"];
                            [[KKFloatViewMgr shareInstance] removeFloatGameBoardView];
                        }];
                        
                    }else {
                        [CC_Notice show:errorMsg];

                    }
                    return ;
                }else if ([errorName isEqualToString:@"PURCHASE_ORDER_IS_EXISTED"] || [errorName isEqualToString:@"GAME_BOARD_JOIN_HAS_OCCUPY"]) {
                    
                    [weakSelf showAlert];
                }else {
                    
                    [CC_Notice show:errorMsg];
                }
            }];
        }
        /// 移除
        [weakSelf.cardsSelectView removeFromSuperview];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:self.cardsSelectView];
}


/// 进入开黑房后, 将退出上一个开黑房
- (void)showAlert {
    self.pop = [[CatDefaultPop alloc] initWithTitle:@"是否进入?" content:@"进入开黑房后, 将退出上一个开黑房?" cancelTitle:@"取消" confirmTitle:@"确定"];
    self.pop.delegate = self;
    [self.pop popUpCatDefaultPopView];
    self.pop.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    [self.pop updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
}

/// 进入开黑房后, 将退出招募厅
- (void)showAlertExitLiveStudioAction {
    self.alertExitLiveStudio = [[CatDefaultPop alloc] initWithTitle:@"是否进入?" content:@"进入开黑房后, 将退出招募厅?" cancelTitle:@"取消" confirmTitle:@"确定"];
    self.alertExitLiveStudio.delegate = self;
    [self.alertExitLiveStudio popUpCatDefaultPopView];
    self.alertExitLiveStudio.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    [self.alertExitLiveStudio updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RH(142);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKHomeRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKHomeRecommendCell"];
    cell.info = self.dataList[indexPath.row];
    cell.isSearch = YES;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return RH(58);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self getHeaderView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KKHomeRoomListInfo *info = self.dataList[indexPath.row];
    _currentListInfo = info;
    if ([info.proceedStatus.name isEqualToString:@"PROCESSING"]) {
        [CC_Notice show:@"比赛正在进行中"];
        return;
    }
    
    if ([info.proceedStatus.name isEqualToString:@"FINISH"]) {
        [CC_Notice show:@"比赛已结束"];
        return;
    }
    
    if ([info.proceedStatus.name isEqualToString:@"CANCEL"]) {
        [CC_Notice show:@"比赛关闭"];
        return;
    }
    WS(weakSelf)
    if ([info.proceedStatus.name isEqualToString:@"RECRUIT"]) {
        [self judgeCurrentTableViewCellInfoCurrentIsCreateCradList:^{
            /// 名片不一致, 弹出名片列表
            [weakSelf requestCardListInfo];
            [weakSelf initCardListView];
        } showAlertLiveStudio:^{
            [weakSelf showAlertExitLiveStudioAction];
        }canPush:^{
            [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:weakSelf.lastCard.ID groupId:weakSelf.currentListInfo.groupId];
        }];
    }
}

- (void)judgeCurrentTableViewCellInfoCurrentIsCreateCradList:(void(^)(void))isCreateCradList
                                    showAlertLiveStudio:(void(^)(void))showAlertLiveStudio
                                                     canPush:(void(^)(void))canPush
{
    /// 有名片
    if (_lastCard.ID.length != 0) {
        /// 没有未完成的局
        if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId <= 0) {
            
            /// 也不再招募厅
            if ([KKFloatViewMgr shareInstance].liveStudioModel.studioId.length == 0) {
                /// 弹出名片列表
                isCreateCradList();
            }else {
                /// 退出招募厅在进入
                showAlertLiveStudio();
            }
        }else {
            [KKHomeService request_game_board_join_consult_dataWithProfilesId:_lastCard.ID gameRoomId:self.currentListInfo.gameRoomId gameBoardId:self.currentListInfo.gameBoardId success:^{
                if (self.currentListInfo.gameRoomId == [KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId) {
                    
                    canPush();
                    return ;
                }else {
                    
                    [self showAlert];
                }
            } fail:^(NSString * _Nonnull errorMsg, NSString * _Nonnull errorName) {
                isCreateCradList();
            }];
            
        }
    }else {
        [self initCardView];
    }
}

#pragma mark - catDefaultPopConfirm
- (void)catDefaultPopConfirm:(CatDefaultPop*)defaultPop{
    WS(weakSelf)
    if (defaultPop == self.alertExitLiveStudio) { /// 退出招募厅, 进入开黑房
        [[KKFloatViewMgr shareInstance] tryToLeaveLiveStudio:^{
            
            [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:weakSelf.lastCard.ID groupId:weakSelf.currentListInfo.groupId];
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
    }
}

- (void)catDefaultPopCancel:(CatDefaultPop *)defaultPop {
    if (defaultPop == self.alertExitLiveStudio) {
        self.alertExitLiveStudio = nil;
    }else if (defaultPop == self.pop) {
        self.pop = nil;
    }
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if ([searchBar.text isEqualToString:@"0"]) {
        [CC_Notice show:@"无搜索结果"];
    }else {    
        [self requestSearchDataKey:searchBar.text];
    }
    [self.searchBar resignFirstResponder];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([self is0_9Num:text] || [text isEqualToString:@""]) {
        return YES;
    }else {
        [CC_Notice show:@"房间ID只能是数字"];
        return NO;
    }
}

- (BOOL)is0_9Num:(NSString *)string{
    NSString *rule = @"^[0-9]";
    NSPredicate *numJudge = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule];
    return [numJudge evaluateWithObject:string];
}

#pragma mark - Jump
- (void)pushGameBoardDetailRoomId:(NSInteger)roomid gameBoardId:(NSString *)gameBoardId gameProfilesId:(NSString *)gameProfilesId groupId:(NSString *)groupId {
    
    [KKFloatViewMgr shareInstance].gameRoomModel = nil;
    [KKFloatViewMgr shareInstance].liveStudioModel = nil;
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

- (void)popToHomeVC {
    [self.navigationController popViewControllerAnimated:YES];
}

/// 进入添加名片
- (void)pushAddCardVC {
    KKAddMyCardViewController *vc = [[KKAddMyCardViewController alloc] init];
    vc.isEdit = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Net
- (void)requestSearchDataKey:(NSString *)key {
    WS(weakSelf)
    _service.gameRoomId = key;
    [_service requestHomeListSuccess:^(NSMutableArray * _Nonnull dataList, KKPaginator * _Nonnull paginator) {
        weakSelf.dataList = dataList;
        if (weakSelf.dataList.count != 0) {
            [weakSelf.tableView reloadData];
        }
        if (weakSelf.dataList.count == 0) {
            [weakSelf.tableView reloadData];
            [CC_Notice show:@"无搜索结果"];
        }
    } Fail:^{ }];
}

/// 请求名片列表
- (void)requestCardListInfo {
    [self.cardIf removeAllObjects];
    WS(weakSelf)
    [KKMyCardService requestCardTagListSuccess:^(NSMutableArray * _Nonnull dataList) {
        weakSelf.cardIf = dataList;
        [weakSelf dealData];
    } Fail:^{
    }];
}

/// 请求上一次的对局
- (void)requestLasttimeGameboardData {
    WS(weakSelf)
    [_service requestLastTimeGameBoadDataSuccess:^(KKCardTag * _Nonnull lastCard, KKMessage * _Nonnull message) {
        weakSelf.lastCard = lastCard;
    } Fail:^{
    }];
}

- (void)dealData {
    /// 添加名片
    KKCardTag *addCard = New(KKCardTag);
    addCard.nickName = @"添加名片";
    [self.cardIf addObject:addCard];
    self.cardsSelectView.dataList = self.cardIf;
}

#pragma mark - Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavUI];
    [self setUI];

    _service = [KKHomeService new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestLasttimeGameboardData];
}
@end
