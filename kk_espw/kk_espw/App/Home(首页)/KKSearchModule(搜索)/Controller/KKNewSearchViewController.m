//
//  KKNewSearchViewController.m
//  kk_espw
//
//  Created by jingtian9 on 2019/10/16.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKNewSearchViewController.h"
#import "MiSearchBar.h"
#import <CatPager.h>
#import "NoContentReminderView.h"
#import "KKHomeRecommendCell.h"
#import "KKVoiceRoomListCell.h"
#import "KKHomeService.h"
#import "KKCreateCardView.h"
#import "KKCardsSelectView.h"
#import "KKHomeRoomListInfo.h"
#import "KKMyCardService.h"
#import "KKCardTag.h"
#import "KKGameRoomOwnerController.h"
#import "KKAddMyCardViewController.h"
#import "KKVoiceRoomViewModel.h"
#import "KKVoiceRoomVC.h"
#import "KKHomeVoiceRoomModel.h"
#import "KKVoiceRoomRtcMgr.h"
#import "KKRtcService.h"
#import "KKGameRtcMgr.h"
@interface KKNewSearchViewController ()
<UISearchBarDelegate,
CatPagerDelegate,
UIScrollViewDelegate,
UITableViewDelegate,
UITableViewDataSource,
CatDefaultPopDelegate,
MiSearchReturnDelegate
>
@property (nonatomic, strong) MiSearchBar *searchBar; //搜索框
@property (nonatomic, strong) CC_Button *searchButton; //搜索按钮
@property (nonatomic, strong) CatPager *catPager; //分页器
@property (nonatomic, strong) UITableView *gameRoomTableView;
@property (nonatomic, strong) UITableView *voiceTableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *gameRoomArray;
@property (nonatomic, strong) NSMutableArray *voiceRoomArray;
@property (nonatomic, strong) UIView *contentV;
@property (nonatomic, strong) KKHomeService *service;
@property (nonatomic, strong) KKCreateCardView *createCardView;
@property (nonatomic, strong) KKCardsSelectView *cardsSelectView;
@property (nonatomic, strong) KKCardTag *lastCard; /// 上一次的对局名片
@property (nonatomic, strong) CatDefaultPop *pop;
@property (nonatomic, strong) CatDefaultPop *alertExitLiveStudio;
@property (nonatomic, strong) CatDefaultPop *alertExitVoiceWiilJoinGameRoom;
@property (nonatomic, strong) CatDefaultPop *alertExitGameBoardWithVoice; // 语音房
@property (nonatomic, strong) CatDefaultPop *alertExitLiveStudioWithVoice;
@property (nonatomic, strong) CatDefaultPop *alertExitVoiceRoomWithVoice;
@property (nonatomic, strong) KKCheckInfo *checkInfo;
@property (nonatomic, strong) KKHomeRoomStatus *roomStatus;
@property (nonatomic, strong) KKHomeRoomListInfo *currentListInfo;
@property (nonatomic, strong) KKHomeVoiceRoomModel *currentListVoiceInfo;;
@property (nonatomic, strong) NSMutableArray *cardIf;
@property (nonatomic, strong) NoContentReminderView *notDateViewGameRoom; /// 无数据视图
@property (nonatomic, strong) NoContentReminderView *notDateViewVoiceRoom; /// 无数据视图

@end

@implementation KKNewSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUI];
    [self setUI];
    _service = [KKHomeService new];
    //1.调整默认分页器
    [self setDefaultCatPager];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestLasttimeGameboardData];
}

#pragma mark - UI
- (void)setDefaultCatPager {
    if (_type == KKGameRoomType) {
        [self.catPager selectItemAtIndex:0 animated:YES];
        _scrollView.contentOffset = CGPointMake(0, 0);
        return;
    }
    if (_type == KKVoiceRoomType) {
        [self.catPager selectItemAtIndex:1 animated:YES];
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        return;
    }
}

- (void)setUI {
    [self createCatPager];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.gameRoomTableView];
    [self.scrollView addSubview:self.voiceTableView];
}

- (void)setNavUI {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self.naviBar addSubview:self.searchBar];
    [self.naviBar addSubview:self.searchButton];
}

#pragma mark - Init
- (NSMutableArray *)cardIf {
    if (!_cardIf) {
        _cardIf = [NSMutableArray array];
    }
    return _cardIf;
}

#pragma mark - UI
- (MiSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[MiSearchBar alloc] initWithFrame:CGRectMake(RH(38), STATUS_BAR_HEIGHT - 5, RH(276), RH(50)) placeholder:@"请输入房间ID"];
        _searchBar.keyboardType = UIKeyboardTypeNumberPad;
        _searchBar.resultStrDelegate = self;
    }
    return _searchBar;
}

- (CC_Button *)searchButton {
    if (!_searchButton) {
        WS(weakSelf)
        _searchButton = [CC_Button buttonWithType:UIButtonTypeCustom];
        [_searchButton setTitleColor:KKES_COLOR_HEX(0x666666) forState:UIControlStateNormal];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        _searchButton.frame = CGRectMake(_searchBar.right + RH(15), RH(10) + STATUS_BAR_HEIGHT, RH(35), 25);
        _searchButton.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(16)];
        [_searchButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            if (weakSelf.searchBar.text.length == 0) {
                [CC_Notice show:@"请输入房间ID"];
                return ;
            }
            [weakSelf toSearch];
        }];
    }
    return _searchButton;
}

- (NoContentReminderView *)notDateViewGameRoom{
    if (!_notDateViewGameRoom) {
        _notDateViewGameRoom = [[NoContentReminderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 200)];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"暂无搜索结果!" withColor:[UIColor grayColor]];
        [NoContentReminderView showReminderViewToView:_notDateViewGameRoom imageTopY:(SCREEN_HEIGHT - RH(600)) image:[UIImage imageNamed:@"data_is_null"] remindWords:attribute];
    }
    return _notDateViewGameRoom;
}

- (NoContentReminderView *)notDateViewVoiceRoom{
    if (!_notDateViewVoiceRoom) {
        _notDateViewVoiceRoom = [[NoContentReminderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 200)];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"暂无搜索结果!" withColor:[UIColor grayColor]];
        [NoContentReminderView showReminderViewToView:_notDateViewVoiceRoom imageTopY:(SCREEN_HEIGHT - RH(600)) image:[UIImage imageNamed:@"data_is_null"] remindWords:attribute];
    }
    return _notDateViewVoiceRoom;
}

- (void)createCatPager {
    /// 分页器的容器
    _contentV = [[UIView alloc] init];
    _contentV.left = 0;
    _contentV.width = SCREEN_WIDTH;
    _contentV.top = self.naviBar.bottom;
    _contentV.height = 50;
    [self.view addSubview:_contentV];
    /// 分页器
    self.catPager = [[CatPager alloc] initOn:_contentV theme:CatPagerThemeLineZoom itemArr:@[@"开黑房", @"语音房"] selectedIndex:0];
    self.catPager.delegate = self;
    [self.catPager updateSelectedTextColor:KKES_COLOR_BLACK_TEXT selectedBackColor:[UIColor whiteColor] textColor:KKES_COLOR_BLACK_TEXT backColor:[UIColor whiteColor] bottomLineColor:KKES_COLOR_MAIN_YELLOW];
    [self.catPager updateCatPagerThemeLineSize:CGSizeMake(31, 4)];
    [self.catPager updateCatPagerThemeLineZoom:[KKFont pingfangFontStyle:PFFontStyleSemibold size:RH(17)]];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT + _contentV.height, SCREEN_WIDTH, SCREEN_HEIGHT - (STATUSBAR_ADD_NAVIGATIONBARHEIGHT + _contentV.height))];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        
    }
    return _scrollView;
}

- (UITableView *)gameRoomTableView {
    if (!_gameRoomTableView) {
        _gameRoomTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, SCREEN_HEIGHT - (STATUSBAR_ADD_NAVIGATIONBARHEIGHT + _contentV.height + 5))];
        _gameRoomTableView.delegate = self;
        _gameRoomTableView.dataSource = self;
        _gameRoomTableView.tableFooterView = [UIView new];
        [_gameRoomTableView registerClass:[KKHomeRecommendCell class] forCellReuseIdentifier:@"KKHomeRecommendCell"];
        _gameRoomTableView.backgroundColor = [UIColor clearColor];
        _gameRoomTableView.separatorColor = [UIColor clearColor];
    }
    return _gameRoomTableView;
}

- (UITableView *)voiceTableView {
    if (!_voiceTableView) {
        _voiceTableView  = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 10, SCREEN_WIDTH, SCREEN_HEIGHT - (STATUSBAR_ADD_NAVIGATIONBARHEIGHT + _contentV.height + 5))];
        _voiceTableView.delegate = self;
        _voiceTableView.dataSource = self;
        _voiceTableView.tableFooterView = [UIView new];
        [_voiceTableView registerClass:[KKVoiceRoomListCell class] forCellReuseIdentifier:@"KKVoiceRoomListCell"];
        _voiceTableView.backgroundColor = [UIColor clearColor];
        _voiceTableView.separatorColor = [UIColor clearColor];
    }
    return _voiceTableView;
}

- (void)initCardView {
    WS(weakSelf)
    _createCardView = [[KKCreateCardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:_createCardView];
    _createCardView.addCardSuccessBlock = ^{
        [weakSelf requestLasttimeGameboardData];
    };
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

/// 进入开黑房后, 将退出语音房
- (void)showAlertExitVoiceWiilJoinGameRoom {
    self.alertExitVoiceWiilJoinGameRoom = [[CatDefaultPop alloc] initWithTitle:@"是否进入?" content:@"进入开黑房后, 将退出语音房?" cancelTitle:@"取消" confirmTitle:@"确定"];
    self.alertExitVoiceWiilJoinGameRoom.delegate = self;
    [self.alertExitVoiceWiilJoinGameRoom popUpCatDefaultPopView];
    self.alertExitVoiceWiilJoinGameRoom.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    [self.alertExitVoiceWiilJoinGameRoom updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
}

/// 进入这个语音房, 将退出当前开黑房
- (void)showAlertExitGameBoardWithVoiceRoom {
    self.alertExitGameBoardWithVoice = [[CatDefaultPop alloc] initWithTitle:@"是否进入?" content:@"进入这个语音房, 将退出当前开黑房?" cancelTitle:@"取消" confirmTitle:@"确定"];
    self.alertExitGameBoardWithVoice.delegate = self;
    [self.alertExitGameBoardWithVoice popUpCatDefaultPopView];
    self.alertExitGameBoardWithVoice.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    [self.alertExitGameBoardWithVoice updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
}

/// 进入这个语音房, 将退出当前招募厅
- (void)showAlertExitLiveStudioWithVoiceRoom {
    self.alertExitLiveStudioWithVoice = [[CatDefaultPop alloc] initWithTitle:@"是否进入?" content:@"进入这个语音房, 将退出招募厅?" cancelTitle:@"取消" confirmTitle:@"确定"];
    self.alertExitLiveStudioWithVoice.delegate = self;
    [self.alertExitLiveStudioWithVoice popUpCatDefaultPopView];
    self.alertExitLiveStudioWithVoice.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    [self.alertExitLiveStudioWithVoice updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
}

/// 进入这个语音房, 将退出上一个语音房
- (void)showAlertExitVoiceWithVoiceRoom {
    self.alertExitVoiceRoomWithVoice = [[CatDefaultPop alloc] initWithTitle:@"是否进入?" content:@"进入这个语音房, 将退出上一个语音房?" cancelTitle:@"取消" confirmTitle:@"确定"];
    self.alertExitVoiceRoomWithVoice.delegate = self;
    [self.alertExitVoiceRoomWithVoice popUpCatDefaultPopView];
    self.alertExitVoiceRoomWithVoice.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    [self.alertExitVoiceRoomWithVoice updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
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
                
                if ([KKFloatViewMgr shareInstance].liveStudioModel.studioId.length > 1) {
                    //1. 展示是否离开招募厅的弹窗
                    [weakSelf showAlertExitLiveStudioAction];
                    
                }else if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId > 0) {
                    if ([KKFloatViewMgr shareInstance].voiceRoomModel.roomId > 0) {
                        //2. 展示是否离开语音房的弹窗
                        [weakSelf showAlertExitVoiceWiilJoinGameRoom];
                    }
                    if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId == weakSelf.currentListInfo.gameRoomId) {
                        [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:card.ID groupId:weakSelf.currentListInfo.groupId channelId:weakSelf.currentListInfo.channelId];
                    }else {
                        [weakSelf showAlert];
                    }
                    
                }else {
                    [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:card.ID groupId:weakSelf.currentListInfo.groupId channelId:weakSelf.currentListInfo.channelId];
                    
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

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.gameRoomTableView) {
        return self.gameRoomArray.count;
    }
    return self.voiceRoomArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.gameRoomTableView) {
        KKHomeRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKHomeRecommendCell"];
        cell.info = self.gameRoomArray[indexPath.row];
        return cell;
    }
    KKVoiceRoomListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKVoiceRoomListCell"];
    cell.isSearch = YES;
    cell.model = self.voiceRoomArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.gameRoomTableView) {
        return RH(153);
    }
    return RH(128);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //1.这里是点击开黑房
    if (tableView == self.gameRoomTableView) {
        KKHomeRoomListInfo *info = self.gameRoomArray[indexPath.row];
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
                [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:weakSelf.lastCard.ID groupId:weakSelf.currentListInfo.groupId channelId:weakSelf.currentListInfo.channelId];
            }showAlertVoiceRoom:^{
                [weakSelf showAlertExitVoiceWiilJoinGameRoom];
            }];
        }
    }else if (tableView == self.voiceTableView) {
        KKHomeVoiceRoomModel *info = self.voiceRoomArray[indexPath.row];
        _currentListVoiceInfo = info;
        [self pushToVoiceVC:info.ID.integerValue channelId:info.channelId];
    }
}

/// 进入语音房
- (void)pushToVoiceVC:(NSInteger)roomId channelId:(NSString *)channelId{
    NSString *roomIdStr = [NSString stringWithFormat:@"%ld", roomId];
    [[KKVoiceRoomRtcMgr shareInstance] checkRoomStatus:roomIdStr success:^{
        
        if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId > 0) {
            //1. 进入语音房, 将退出开黑房
            [self showAlertExitGameBoardWithVoiceRoom];
            return;
        }
        
        if ([KKFloatViewMgr shareInstance].liveStudioModel.studioId.length != 0) {
            //2. 进入语音房, 将退出招募厅
            [self showAlertExitLiveStudioWithVoiceRoom];
            return;
        }
        
        if ([KKFloatViewMgr shareInstance].voiceRoomModel.roomId > 0) {
            //3. 同样的语音房直接进入
            if ([KKFloatViewMgr shareInstance].voiceRoomModel.roomId == roomId) {
                [self jumpVoiceVCWithRoomId:roomId channelId:channelId];
                
                return;
            }else {
                //4. 不同的语音房, 退出上一个语音房.
                [self showAlertExitVoiceWithVoiceRoom];
                return;
            }
            
        }
        
        //5. 检测是否被踢出
        [self jumpVoiceVCWithRoomId:roomId channelId:channelId];
    }];
}

/// 尝试加入语音室
- (void)jumpVoiceVCWithRoomId:(NSInteger )roomId channelId:(NSString *)channelId{
    NSString *roomIdStr = [NSString stringWithFormat:@"%ld", roomId];
    //1. 检测是否被踢出
    [[KKVoiceRoomRtcMgr shareInstance] requestJoinRoom:roomIdStr channel:channelId success:^{
        KKVoiceRoomVC *vc = [KKVoiceRoomVC shareInstance];
        vc.roomId = roomIdStr;
        [vc pushSelfByNavi:[KKRootContollerMgr getRootNav]];
    }];
}

- (void)judgeCurrentTableViewCellInfoCurrentIsCreateCradList:(void(^)(void))isCreateCradList
                                    showAlertLiveStudio:(void(^)(void))showAlertLiveStudio
                                                     canPush:(void(^)(void))canPush
                                          showAlertVoiceRoom:(void(^)(void))showAlertVoiceRoom {
    /// 有名片
    if (_lastCard.ID.length != 0) {
        /// 没有未完成的局
        if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId <= 0) {
            
            /// 也不再招募厅
            if ([KKFloatViewMgr shareInstance].liveStudioModel.studioId.length == 0) {
                /// 弹出名片列表
                
                if ([KKFloatViewMgr shareInstance].voiceRoomModel.roomId > 0) {
                    
                    showAlertVoiceRoom();
                }else {
                    isCreateCradList();
                }
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

#pragma mark -
- (void)searchTfChanged:(NSString *)text {
    if (text.length == 0) {
        _searchButton.enabled = NO;
        [_searchButton setTitleColor:KKES_COLOR_HEX(0x999999) forState:UIControlStateNormal];
    }else {
        _searchButton.enabled = YES;
        [_searchButton setTitleColor:KKES_COLOR_HEX(0x666666) forState:UIControlStateNormal];
    }
}

#pragma mark - catDefaultPopConfirm
- (void)catDefaultPopConfirm:(CatDefaultPop*)defaultPop{
    WS(weakSelf)
    if (defaultPop == self.alertExitLiveStudio) { /// 退出招募厅, 进入开黑房
        //1. 名片校验
        [KKHomeService request_game_board_join_consult_dataWithProfilesId:_lastCard.ID gameRoomId:_currentListInfo.gameRoomId gameBoardId:_currentListInfo.gameBoardId success:^{
            //2. 离开招募厅
            [[KKFloatViewMgr shareInstance] tryToLeaveLiveStudio:^{
                 [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:weakSelf.lastCard.ID groupId:weakSelf.currentListInfo.groupId channelId:weakSelf.currentListInfo.channelId];
            }];
        } fail:^(NSString * _Nonnull errorMsg, NSString * _Nonnull errorName) {
            [[KKFloatViewMgr shareInstance] tryToLeaveLiveStudio:^{
                [CC_Notice show:errorMsg];
            }];
        }];
        
    }else if (defaultPop == self.pop) { /// 退出上一个开黑房 进入新开黑房
        [[KKFloatViewMgr shareInstance] tryToLeaveGameRoom:^{
            //1. 每次进入开黑房都进行名片的校验
            [KKHomeService request_game_board_join_consult_dataWithProfilesId:weakSelf.lastCard.ID gameRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId success:^{
                
                [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:weakSelf.lastCard.ID groupId:weakSelf.currentListInfo.groupId channelId:weakSelf.currentListInfo.channelId];
                
            } fail:^(NSString * _Nonnull errorMsg, NSString * _Nonnull errorName) {
                [CC_Notice show:errorMsg];
            }];
        }];
    }else if (defaultPop == self.alertExitLiveStudioWithVoice) { /// 离开招募厅, 在进入语音房
        [[KKVoiceRoomRtcMgr shareInstance] checkRoomStatus:weakSelf.currentListVoiceInfo.ID success:^{
            
            [[KKFloatViewMgr shareInstance] tryToLeaveLiveStudio:^{
                [weakSelf jumpVoiceVCWithRoomId:weakSelf.currentListVoiceInfo.ID.integerValue channelId:weakSelf.currentListVoiceInfo.channelId];
            }];
        }];
            
        
    }else if (defaultPop == self.alertExitGameBoardWithVoice) { /// 离开开黑房, 在进入语音房
        [[KKVoiceRoomRtcMgr shareInstance] checkRoomStatus:weakSelf.currentListVoiceInfo.ID success:^{
            
            [[KKFloatViewMgr shareInstance] tryToLeaveGameRoom:^{
                [weakSelf jumpVoiceVCWithRoomId:weakSelf.currentListVoiceInfo.ID.integerValue channelId:weakSelf.currentListVoiceInfo.channelId];
            }];
        }];
    }else if (defaultPop == self.alertExitVoiceRoomWithVoice) { /// 离开旧语音房, 在进入新语音房
        [[KKVoiceRoomRtcMgr shareInstance] checkRoomStatus:weakSelf.currentListVoiceInfo.ID success:^{
            
            [[KKFloatViewMgr shareInstance] tryLeaveVoiceRoom:^{
                [weakSelf jumpVoiceVCWithRoomId:weakSelf.currentListVoiceInfo.ID.integerValue channelId:weakSelf.currentListVoiceInfo.channelId];
            }];
        }];
    }else if (defaultPop == self.alertExitVoiceWiilJoinGameRoom) { /// 进入开黑房将退出语音房
        //1. 只要进入开黑就检查名片
        [KKHomeService request_game_board_join_consult_dataWithProfilesId:_lastCard.ID gameRoomId:_currentListInfo.gameRoomId gameBoardId:_currentListInfo.gameBoardId success:^{
            //2. 离开语音房
            [[KKFloatViewMgr shareInstance] tryLeaveVoiceRoom:^{
                [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:weakSelf.lastCard.ID groupId:weakSelf.currentListInfo.groupId channelId:weakSelf.currentListInfo.channelId];
            }];
        } fail:^(NSString * _Nonnull errorMsg, NSString * _Nonnull errorName) {
            //3. 离开语音房
            [[KKFloatViewMgr shareInstance] tryLeaveVoiceRoom:^{
                //4. 提示错误信息
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

#pragma mark - CatPagerDelegate
- (void)catPager:(CatPager*)catPager didSelectRowAtIndex:(NSInteger)index {
    if (index == 0) {
        _scrollView.contentOffset = CGPointMake(0, 0);
        _type = KKGameRoomType;
    }else {
        _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
        _type = KKVoiceRoomType;
    }
}

#pragma mark - scrollViewDidEndDecelerating
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UITableView class]]) {
        int index = scrollView.contentOffset.x / SCREEN_WIDTH;
        [self.catPager selectItemAtIndex:index animated:YES];
        index == 0 ? (_type = KKGameRoomType) : (_type = KKVoiceRoomType);
        if (_searchBar.text.length == 0) {
            return;
        }
        [self requestSearchDataKey:_searchBar.text];
    }
}

#pragma mark - Action
- (void)toSearch {
    [self requestSearchDataKey:_searchBar.text];
    [self.searchBar resignFirstResponder];
}

#pragma mark - Jump
- (void)pushGameBoardDetailRoomId:(NSInteger)roomid gameBoardId:(NSString *)gameBoardId gameProfilesId:(NSString *)gameProfilesId groupId:(NSString *)groupId channelId:(NSString *)channelId {
    [KKFloatViewMgr shareInstance].gameRoomModel = nil;
    [KKFloatViewMgr shareInstance].liveStudioModel = nil;
    [[KKGameRtcMgr shareInstance] requestJoinGameRoomGameBoardId:gameBoardId channelId:channelId success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [KKGameRoomOwnerController sharedInstance].gameProfilesIdStr = gameProfilesId;
            [KKGameRoomOwnerController sharedInstance].gameBoardIdStr = gameBoardId;
            [KKGameRoomOwnerController sharedInstance].gameRoomId = roomid;
            [KKGameRoomOwnerController sharedInstance].groupIdStr = groupId;
            [[KKGameRoomOwnerController sharedInstance] pushSelfByNavi:[KKRootContollerMgr getRootNav]];
        });
    }];
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
    //1.搜索开黑房
    if (_type == KKGameRoomType) {
        _service.gameRoomId = key;
        [_service requestHomeListSuccess:^(NSMutableArray * _Nonnull dataList, KKPaginator * _Nonnull paginator) {
            weakSelf.gameRoomArray = dataList;
            if (weakSelf.gameRoomArray.count != 0) {
                weakSelf.gameRoomTableView.tableFooterView = [[UIView alloc] init];
                [weakSelf.gameRoomTableView reloadData];
            }
            if (weakSelf.gameRoomArray.count == 0) {
                weakSelf.gameRoomTableView.tableFooterView = self.notDateViewGameRoom;
                [weakSelf.gameRoomTableView reloadData];
            }
        } Fail:^{ }];
    }
    //2.搜索语音房
    if (_type == KKVoiceRoomType) {
        [KKHomeService requesHomeVoiceRoomListWithRoomId:key success:^(NSMutableArray * _Nonnull dataList) {
            weakSelf.voiceRoomArray = dataList;
            if (weakSelf.voiceRoomArray.count != 0) {
                weakSelf.voiceTableView.tableFooterView = [[UIView alloc] init];
                [weakSelf.voiceTableView reloadData];
            }
            if (weakSelf.voiceRoomArray.count == 0) {
                weakSelf.voiceTableView.tableFooterView = self.notDateViewVoiceRoom;
                [weakSelf.voiceTableView reloadData];
            }
        } fail:^{ }];
    }
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
@end
