//
//  KKHomeViewController.m
//  kk_espw
//
//  Created by jingtian9 on 2019/10/11.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKHomeViewController.h"
#import "KKKingTableView.h"
#import "KKVoiceTableView.h"
#import "KKJTHeaderView.h"
#import "KKNavgationView.h"
#import "KKHomeService.h"
#import "KKCardTag.h"
#import "KKCreateGameRoomController.h"
#import "KKGameRoomManager.h"
#import "KKGameRoomOwnerController.h"
#import "KKCreateCardView.h"
#import "KKBanner.h"
#import "KKDiscoverDetailViewController.h"
#import "KKCardsSelectView.h"
#import "KKMyCardService.h"
#import "KKAddMyCardViewController.h"
#import "KKHomeRoomListInfo.h"
#import "KKLiveStudioRtcMgr.h"
#import "KKLiveStudioVC.h"
#import "KKRankListViewController.h"
#import "KKNewSearchViewController.h"
#import "KKShareVoiceRoomViewController.h"
#import "KKVoiceRoomVC.h"
#import "KKHomeVoiceRoomModel.h"
#import "KKRtcService.h"
#import "KKVoiceRoomViewModel.h"
#import "KKVoiceRoomRtcMgr.h"
#import "KKGameRtcMgr.h"
@interface KKHomeViewController ()
<UIScrollViewDelegate, headerViewDelegate, CatDefaultPopDelegate>
@property (nonatomic, strong) NSMutableArray *dataList;                             /// 数据开黑数据
@property (nonatomic, strong) NSMutableArray *dataVoiceList;                        /// 语音房列表数据
@property (nonatomic, strong) NSMutableArray *bannersData;                          /// 轮播图数据
@property (nonatomic, strong) NSMutableArray *cards;                                /// 名片数据
@property (nonatomic, strong) UIScrollView *verticalContentSrcV;                    /// 横
@property (nonatomic, strong) KKJTHeaderView *headerView;
@property (nonatomic, strong) KKKingTableView *kingPlayTableView;
@property (nonatomic, strong) KKVoiceTableView *voiccTableView;
@property (nonatomic, assign) CGPoint lastContentOffset;
@property (nonatomic, copy) NSString *currentTVIndexStr;                            /// 当前显示的是哪个tab
@property (nonatomic, strong) KKCardTag *lastCard;                                  /// 上一次的对局名片
@property (nonatomic, strong) CatDefaultPop *pop;                                   /// 招募厅,开黑房
@property (nonatomic, strong) CatDefaultPop *alertExitLiveStudio;
@property (nonatomic, strong) CatDefaultPop *alertExitGameGoard;
@property (nonatomic, strong) CatDefaultPop *alertExitLiveWithCreteKH;
@property (nonatomic, strong) CatDefaultPop *alertExitVoiceWiilJoinGameRoom;
@property (nonatomic, strong) CatDefaultPop *alertExitVoiceWiilJoinLiveStudio;
@property (nonatomic, strong) CatDefaultPop *alertExitGameBoardWithVoice;           /// 语音房
@property (nonatomic, strong) CatDefaultPop *alertExitLiveStudioWithVoice;
@property (nonatomic, strong) CatDefaultPop *alertExitVoiceRoomWithVoice;
@property (nonatomic, assign) BOOL isShowAlert;                                     /// 防止弹窗多次弹出
@property (nonatomic, strong) KKCreateCardView *createCardView;                     /// 快捷创建名片
@property (nonatomic, strong) KKPaginator *paginator;                               /// 分页器, 开黑房
@property (nonatomic, strong) KKPaginator *paginatorVoice;                          /// 分页器, 语音房
@property (nonatomic, copy) NSString *rank;                                         /// 点击了 全部, 筛选的标志
@property (nonatomic, strong) NoContentReminderView *notDataView;                   /// 无数据视图
@property (nonatomic, strong) NoContentReminderView *notDataVoiceRoomView;          /// 无数据视图
@property (nonatomic, strong) KKHomeRoomStatus *roomStatusTop;                      /// 招募厅信息
@property (nonatomic, strong) KKCardsSelectView *cardsSelectView;                   /// 名片选择视图
@property (nonatomic, assign) KKTapWherePopCardListFalg tapWherePopCardListFalg;    /// 点击筛选还是房间列表 弹出名片列表的标志
@property (nonatomic, strong) KKHomeRoomListInfo *currentListInfo;                  /// 点击开黑房列表数据获得的当前的Model
@property (nonatomic, strong) KKHomeVoiceRoomModel *currentVoiceModel;              /// 当前的cell的语音房model
@property (nonatomic, assign) KKSearchRoomType type;
@end

@implementation KKHomeViewController
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUI];
    [self setupUI];
    [self loadData];
    //1.点击了关闭招募厅, 刷新头部招募厅的数据
    WS(weakSelf)
    [KKFloatViewMgr shareInstance].tapCloseButtonBlock = ^{
        [weakSelf requestHomeRoomStatusData];
    };
    self.isShowAlert = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:NOTIFICATION_VOICE_ROOM_HOST_LEAVE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:NOTIFICATION_GAME_ROOM_DISSOLVE object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - UI
- (void)setNavUI {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    /// 背景
    UIImageView *navbg = [[UIImageView alloc] initWithFrame:CGRectMake([ccui getRH:161], -[ccui getRH:30], [ccui getRH:214], [ccui getRH:232])];
    navbg.image = Img(@"mine_bg");
    [self.naviBar addSubview:navbg];
    /// 遮罩
    UIView *shadeV = [[UIView alloc] initWithFrame:CGRectMake(0, self.naviBar.bottom, SCREEN_WIDTH, 300)];
    shadeV.backgroundColor = KKES_COLOR_BG;
    [self.view addSubview:shadeV];
    /// KK电竞
    KKNavgationView *navView = [[KKNavgationView alloc] initWithFrame:CGRectMake(0, RH(10) + STATUS_BAR_HEIGHT, SCREEN_WIDTH, RH(23))];
    [self.naviBar addSubview:navView];
    WS(weakSelf)
    navView.didNavgationSearchButtonBlock = ^{
        [weakSelf pushToSearchVC];
    };
}

- (void)setupUI{
    [self.view addSubview:self.verticalContentSrcV];
    [self.verticalContentSrcV addSubview:self.kingPlayTableView];
    [self.verticalContentSrcV addSubview:self.voiccTableView];
    [self.verticalContentSrcV addSubview:self.headerView];
    [self.headerView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(headerPan:)]];
}

/// 进入开黑房后, 将退出上一个开黑房
- (void)showAlert {
    if (self.isShowAlert == NO) {
        self.pop = [self getPopWithTitle:@"是否进入?" content:@"进入开黑房后, 将退出上一个开黑房?" cancelTitle:@"取消" comfirmTitle:@"确定" delegate:self];
    }
    self.isShowAlert = YES;
}

/// 创建开黑的时候展示, 创建黑房, 将退出直播厅
- (void)showAlertExitLiveWithCreteKH {
    self.alertExitLiveWithCreteKH = [self getPopWithTitle:@"提示" content:@"创建开黑房将退出招募厅,是否确定离开招募厅" cancelTitle:@"取消" comfirmTitle:@"确定" delegate:self];
}

/// 进入开黑房后, 将退出招募厅
- (void)showAlertExitLiveStudioAction {
    self.alertExitLiveStudio = [self getPopWithTitle:@"是否进入?" content:@"进入开黑房后, 将退出招募厅?" cancelTitle:@"取消" comfirmTitle:@"确定" delegate:self];
}

/// 进入开黑房后, 将退出语音房
- (void)showAlertExitVoiceWiilJoinGameRoom {
    self.alertExitVoiceWiilJoinGameRoom = [self getPopWithTitle:@"是否进入?" content:@"进入开黑房后, 将退出语音房?" cancelTitle:@"取消" comfirmTitle:@"确定" delegate:self];
}

/// 进入这个直播厅, 将退出当前开黑房
- (void)showAlertExitGameBoard {
    self.alertExitGameGoard = [self getPopWithTitle:@"是否进入?" content:@"进入这个直播厅, 将退出当前开黑房?" cancelTitle:@"取消" comfirmTitle:@"确定" delegate:self];
}

/// 进入这个语音房, 将退出当前开黑房
- (void)showAlertExitGameBoardWithVoiceRoom {
    self.alertExitGameBoardWithVoice = [self getPopWithTitle:@"是否进入?" content:@"进入这个语音房, 将退出当前开黑房?" cancelTitle:@"取消" comfirmTitle:@"确定" delegate:self];
}

/// 进入招募厅, 将退出语音房
- (void)showAlertExitVoiceWiilJoinLiveStudio {
    self.alertExitVoiceWiilJoinLiveStudio = [self getPopWithTitle:@"是否进入?" content:@"进入这个招募厅, 将退出当前语音房?" cancelTitle:@"取消" comfirmTitle:@"确定" delegate:self];
}

/// 进入这个语音房, 将退出当前招募厅
- (void)showAlertExitLiveStudioWithVoiceRoom {
    self.alertExitLiveStudioWithVoice = [self getPopWithTitle:@"是否进入?" content:@"进入这个语音房, 将退出招募厅?" cancelTitle:@"取消" comfirmTitle:@"确定" delegate:self];
}

/// 进入这个语音房, 将退出上一个语音房
- (void)showAlertExitVoiceWithVoiceRoom {
    self.alertExitVoiceRoomWithVoice = [self getPopWithTitle:@"是否进入?" content:@"进入这个语音房, 将退出上一个语音房?" cancelTitle:@"取消" comfirmTitle:@"确定" delegate:self];
}

- (CatDefaultPop *)getPopWithTitle:(NSString *)title content:(NSString *)content cancelTitle:(NSString *)cancelTitle comfirmTitle:(NSString *)comfirmTitle delegate:(id)delegate {
    CatDefaultPop *pop = [[CatDefaultPop alloc] initWithTitle:title content:content cancelTitle:cancelTitle confirmTitle:comfirmTitle];
    pop.delegate = self;
    [pop popUpCatDefaultPopView];
    pop.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    [pop updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
    return pop;
}

/// 快捷创建名片视图
- (void)initCardView {
    WS(weakSelf)
    _createCardView = [[KKCreateCardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:_createCardView];
    _createCardView.addCardSuccessBlock = ^{
        [weakSelf requestLasttimeGameboardData:^(KKCardTag *lastCard) {
        }];
    };
}

/// 初始化名片列表
- (void)initCardListView {
    WS(weakSelf)
    self.cardsSelectView = [[KKCardsSelectView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.cardsSelectView.didSelectTableViewCellBlock = ^(KKCardTag * _Nonnull card) {
        /// 点击筛选
        if (weakSelf.tapWherePopCardListFalg == KKTapedSelectType) {
            if ([card.nickName isEqualToString:@"全部"]) {
                [KKHomeService shareInstance].rank = @"";
                [KKHomeService shareInstance].platFormType = @"";
                weakSelf.rank = @"全部";
                /// 点击了全部.
                [KKHomeService shareInstance].page = @(1);
                [weakSelf.dataList removeAllObjects];
                [weakSelf requestHomeListData];
                /// 赋值title为全部
                weakSelf.headerView.selectViewTitle = @"全部";
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
                /// 赋值筛选的title
                weakSelf.headerView.selectViewTitle = weakSelf.rank;
            }
            /// 移除
            [weakSelf.cardsSelectView removeFromSuperview];
            return ;
        }
        /// 点击开黑房列表
        if (weakSelf.tapWherePopCardListFalg == KKTapedRoomListType) {
            if ([card.nickName isEqualToString:@"添加名片"]) {
                /// 点击了添加名片.
                [weakSelf pushAddCardVC];
            }else {
                /// 选择的入局名片
                weakSelf.lastCard = card;
                if ([KKFloatViewMgr shareInstance].voiceRoomModel.roomId > 0) {
                    [weakSelf showAlertExitVoiceWiilJoinGameRoom];
                }else if ([KKFloatViewMgr shareInstance].liveStudioModel.studioId.length > 0) {
                    [weakSelf showAlertExitLiveStudioAction];
                }else {
                    [KKHomeService request_game_board_join_consult_dataWithProfilesId:card.ID gameRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId success:^{
                        
                        if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId <= 0) {
                            
                            [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:card.ID groupId:weakSelf.currentListInfo.groupId channelId:weakSelf.currentListInfo.channelId];
                            
                        }else {
                            if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId == weakSelf.currentListInfo.gameRoomId) {
                                [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:card.ID groupId:weakSelf.currentListInfo.groupId channelId:weakSelf.currentListInfo.channelId];
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

#pragma mark - Init
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        /// 点击tab 开黑按钮时
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToCreateGameVC) name:NOTIFICATION_PUSH_CREATEGAME_VC object:nil];
    }
    return self;
}

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (NSMutableArray *)dataVoiceList {
    if (!_dataVoiceList) {
        _dataVoiceList = [NSMutableArray array];
    }
    return _dataVoiceList;
}

- (NSMutableArray *)bannersData {
    if (!_bannersData) {
        _bannersData = [NSMutableArray array];
    }
    return _bannersData;
}

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [NSMutableArray array];
    }
    return _cards;
}

- (KKJTHeaderView *)headerView{
    WS(weakSelf)
    if (!_headerView) {
        _headerView = [[KKJTHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, RH(313))];
        _headerView.backgroundColor = [UIColor whiteColor];
        _headerView.didTapSelectViewBlock = ^{
            weakSelf.tapWherePopCardListFalg = KKTapedSelectType;
            [weakSelf requestCardListInfo];
            [weakSelf initCardListView];
        };
        _headerView.delegate = self;
    }
    return _headerView;
}

- (UIScrollView *)verticalContentSrcV{
    if (!_verticalContentSrcV) {
        _verticalContentSrcV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _verticalContentSrcV.delegate = self;
        _verticalContentSrcV.pagingEnabled = YES;
        _verticalContentSrcV.backgroundColor = KKES_COLOR_BG;
        _verticalContentSrcV.showsVerticalScrollIndicator = NO;
        _verticalContentSrcV.showsHorizontalScrollIndicator = NO;
        _verticalContentSrcV.contentSize = CGSizeMake(SCREEN_WIDTH * 2, 0);
    }
    return _verticalContentSrcV;
}

- (KKKingTableView *)kingPlayTableView {
    WS(weakSelf)
    if (!_kingPlayTableView) {
        _kingPlayTableView = [[KKKingTableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.verticalContentSrcV.height  - NAV_BAR_HEIGHT - TAB_BAR_HEIGHT - 10 - HOME_INDICATOR_HEIGHT)];
        _kingPlayTableView.showsHorizontalScrollIndicator = NO;
        _kingPlayTableView.showsVerticalScrollIndicator = NO;
        _kingPlayTableView.backgroundColor = [UIColor clearColor];
        _kingPlayTableView.separatorColor = [UIColor clearColor];
        _kingPlayTableView.tableFooterView = [[UIView alloc] init];
        _kingPlayTableView.headerView = self.headerView;
        _kingPlayTableView.didSelectRowAtIndexPathBlock = ^(KKHomeRoomListInfo * _Nonnull info) {
            weakSelf.currentListInfo = info;
            [weakSelf didSelectedTableViewCell];
        };
    }
    return _kingPlayTableView;
}

- (KKVoiceTableView *)voiccTableView {
    if (!_voiccTableView) {
        WS(weakSelf)
        _voiccTableView = [[KKVoiceTableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.verticalContentSrcV.height - NAV_BAR_HEIGHT - TAB_BAR_HEIGHT - 10 - HOME_INDICATOR_HEIGHT)];
        _voiccTableView.showsHorizontalScrollIndicator = NO;
        _voiccTableView.showsVerticalScrollIndicator = NO;
        _voiccTableView.backgroundColor = [UIColor clearColor];
        _voiccTableView.separatorColor = [UIColor clearColor];
        _voiccTableView.tableFooterView = [[UIView alloc] init];
        _voiccTableView.headerView = self.headerView;
        _voiccTableView.didSelectRowVoiceAtIndexPathBlock = ^(KKHomeVoiceRoomModel * _Nonnull model) {
            weakSelf.currentVoiceModel = model;
            [weakSelf pushToVoiceVC:model.ID.integerValue channelId:model.channelId];
        };
    }
    return _voiccTableView;
}

- (NoContentReminderView *)notDataView{
    if (!_notDataView) {
        _notDataView = [[NoContentReminderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 200)];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"暂无开黑房!" withColor:[UIColor grayColor]];
        [NoContentReminderView showReminderViewToView:_notDataView imageTopY:(100) image:[UIImage imageNamed:@"data_is_null"] remindWords:attribute];
    }
    return _notDataView;
}

- (NoContentReminderView *)notDataVoiceRoomView{
    if (!_notDataVoiceRoomView) {
        _notDataVoiceRoomView = [[NoContentReminderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 200)];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"暂无语音房!" withColor:[UIColor grayColor]];
        [NoContentReminderView showReminderViewToView:_notDataVoiceRoomView imageTopY:(SCREEN_HEIGHT - RH(600)) image:[UIImage imageNamed:@"data_is_null"] remindWords:attribute];
    }
    return _notDataVoiceRoomView;
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.verticalContentSrcV) {
        self.headerView.left = scrollView.contentOffset.x;
        int index = 0;
        if (self.lastContentOffset.x < scrollView.contentOffset.x) {
            //往右滑动，向上取整
            index = ceil((scrollView.contentOffset.x / SCREEN_WIDTH));
            _currentTVIndexStr = @"right";
        }else if (self.lastContentOffset.x > scrollView.contentOffset.x){
            //往左滑动，向下取整
            index = floor((scrollView.contentOffset.x / SCREEN_WIDTH));
            _currentTVIndexStr = @"left";
        }else{
            //没动
            index = (scrollView.contentOffset.x / SCREEN_WIDTH);
        }
        CGFloat mobileDistance = -self.headerView.top;
        switch (index) {
            case 0:{
                if (self.kingPlayTableView.contentOffset.y < mobileDistance) {
                    [self.kingPlayTableView setContentOffset:CGPointMake(0, mobileDistance) animated:NO];
                }
            }
                break;
            case 1:{
                if (self.voiccTableView.contentOffset.y < mobileDistance) {
                    [self.voiccTableView setContentOffset:CGPointMake(0, mobileDistance) animated:NO];
                }
            }
                break;
            default:
                break;
        }
        self.lastContentOffset = scrollView.contentOffset;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    static int lastIndex = 0;
    int index = 0;
    if (self.lastContentOffset.x < scrollView.contentOffset.x) {
        //往右滑动，向上取整
        index = ceil((scrollView.contentOffset.x / SCREEN_WIDTH));
    }else if (self.lastContentOffset.x > scrollView.contentOffset.x){
        //往左滑动，向下取整
        index = floor((scrollView.contentOffset.x / SCREEN_WIDTH));
    }else{
        //没动
        index = (scrollView.contentOffset.x / SCREEN_WIDTH);
    }
    self.headerView.selectIndex = index;
    lastIndex = index;
}

#pragma mark - headerViewDelegate
- (void)headerView:(KKJTHeaderView *)headerView SelectionIndex:(NSInteger)index{
    //1. 让scrollView滚动到指定位置
    [self.verticalContentSrcV setContentOffset:CGPointMake(self.verticalContentSrcV.width * index, 0) animated:YES];
    if (index == 0) {
        _type = KKGameRoomType;
    }else {
        _type = KKVoiceRoomType;
    }
}

- (void)headerViewIndex:(NSInteger)index {
    if (index == 0) {
        _type = KKGameRoomType;
    }else {
        _type = KKVoiceRoomType;
    }
}

- (void)didSelectedLeftView {
    [self pushRankListVC];
}

/// 点击头部视图的招募厅
- (void)didSelectedRightView {
    if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId > 0) { /// 在开黑房
        [self showAlertExitGameBoard];
    }else if([KKFloatViewMgr shareInstance].voiceRoomModel.roomId > 0){ /// 在招募厅
        [self showAlertExitVoiceWiilJoinLiveStudio];
    }else{
        [self tryToJoinLiveStudio:self.roomStatusTop.channelId];
    }
}

- (void)tryToJoinLiveStudio:(NSString *)studioId {
    WS(weakSelf)
    [[KKLiveStudioRtcMgr shareInstance] requestJoinStudio:studioId success:^{
        [weakSelf pushToLiveStudioVCWithStudioId:studioId];
        [KKFloatViewMgr shareInstance].liveStudioModel = nil;
    }];
}

#pragma mark - KKHomeHeaderViewDelegate
- (void)didSelectedSDCycleScrollViewIndex:(NSInteger)index {
    KKBanner *banner = self.bannersData[index];
    if (banner.linkUrl) {
        KKDiscoverDetailViewController *vc = New(KKDiscoverDetailViewController);
        vc.linkUrl = banner.linkUrl;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        KKDiscoverDetailViewController *vc = New(KKDiscoverDetailViewController);
        vc.bodyId = banner.ID;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - catDefaultPopCancel, catDefaultPopConfirm
- (void)catDefaultPopCancel:(CatDefaultPop *)defaultPop {
    if (defaultPop == self.alertExitLiveStudio) {
        self.alertExitLiveStudio = nil;
    }else if (defaultPop == self.pop) {
        self.pop = nil;
    }else if (defaultPop == self.alertExitGameGoard) {
        self.alertExitGameGoard = nil;
    }else if(defaultPop == self.alertExitLiveWithCreteKH) {
        self.alertExitLiveWithCreteKH = nil;
    }else if(defaultPop == self.alertExitGameBoardWithVoice) {
        self.alertExitGameBoardWithVoice = nil;
    }else if(defaultPop == self.alertExitVoiceRoomWithVoice) {
        self.alertExitVoiceRoomWithVoice = nil;
    }else if(defaultPop == self.alertExitLiveStudioWithVoice) {
        self.alertExitLiveStudioWithVoice = nil;
    }else if (defaultPop == self.alertExitVoiceWiilJoinGameRoom) {
        self.alertExitVoiceWiilJoinGameRoom = nil;
    }else if (defaultPop == self.alertExitVoiceWiilJoinLiveStudio) {
        self.alertExitVoiceWiilJoinLiveStudio = nil;
    }
    self.isShowAlert = NO;
}

- (void)catDefaultPopConfirm:(CatDefaultPop*)defaultPop{
    WS(weakSelf)
    if (defaultPop == self.alertExitLiveStudio) { /// 退出招募厅, 进入开黑房
        [KKHomeService request_game_board_join_consult_dataWithProfilesId:_lastCard.ID gameRoomId:_currentListInfo.gameRoomId gameBoardId:_currentListInfo.gameBoardId success:^{
            //1. 离开招募厅
            [[KKFloatViewMgr shareInstance] tryToLeaveLiveStudio:^{
                [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:weakSelf.lastCard.ID groupId:weakSelf.currentListInfo.groupId channelId:weakSelf.currentListInfo.channelId];
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
                
                [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:weakSelf.lastCard.ID groupId:weakSelf.currentListInfo.groupId channelId:weakSelf.currentListInfo.channelId];
                
            } fail:^(NSString * _Nonnull errorMsg, NSString * _Nonnull errorName) {
                [CC_Notice show:errorMsg];
            }];
        }];
    }else if (defaultPop == self.alertExitGameGoard) { /// 进入直播厅退出当前开黑房
        [[KKFloatViewMgr shareInstance] tryToLeaveGameRoom:^{
            [weakSelf tryToJoinLiveStudio:weakSelf.roomStatusTop.channelId];
        }];
    }else if(defaultPop == self.alertExitLiveWithCreteKH) { /// 离开招募厅, 再去创建开黑
        [[KKFloatViewMgr shareInstance] tryToLeaveLiveStudio:^{
            [weakSelf pushToCreateGameVC];
        }];
    }else if (defaultPop == self.alertExitLiveStudioWithVoice) { /// 离开招募厅, 在进入语音房
        [[KKVoiceRoomRtcMgr shareInstance] checkRoomStatus:weakSelf.currentVoiceModel.ID success:^{
            
            [[KKFloatViewMgr shareInstance] tryToLeaveLiveStudio:^{
                [weakSelf jumpVoiceVCWithRoomId:weakSelf.currentVoiceModel.ID.integerValue channelId:weakSelf.currentVoiceModel.channelId];
            }];
        }];
        
    }else if (defaultPop == self.alertExitGameBoardWithVoice) { /// 离开开黑房, 在进入语音房
        [[KKVoiceRoomRtcMgr shareInstance] checkRoomStatus:weakSelf.currentVoiceModel.ID success:^{

            [[KKFloatViewMgr shareInstance] tryToLeaveGameRoom:^{
                [weakSelf jumpVoiceVCWithRoomId:weakSelf.currentVoiceModel.ID.integerValue channelId:weakSelf.currentVoiceModel.channelId];
            }];
        }];
    }else if (defaultPop == self.alertExitVoiceRoomWithVoice) { /// 离开旧, 在进入新语音房
        [[KKVoiceRoomRtcMgr shareInstance] checkRoomStatus:weakSelf.currentVoiceModel.ID success:^{
            
            [[KKFloatViewMgr shareInstance] tryLeaveVoiceRoom:^{
                [weakSelf jumpVoiceVCWithRoomId:weakSelf.currentVoiceModel.ID.integerValue channelId:weakSelf.currentVoiceModel.channelId];
            }];
        }];
        
    }else if (defaultPop == self.alertExitVoiceWiilJoinGameRoom) { /// 进入开黑将退出语音房
        [KKHomeService request_game_board_join_consult_dataWithProfilesId:_lastCard.ID gameRoomId:_currentListInfo.gameRoomId gameBoardId:_currentListInfo.gameBoardId success:^{
            //1. 离开语音房
            [[KKFloatViewMgr shareInstance] tryLeaveVoiceRoom:^{
                [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:weakSelf.lastCard.ID groupId:weakSelf.currentListInfo.groupId channelId:weakSelf.currentListInfo.channelId];
            }];
        } fail:^(NSString * _Nonnull errorMsg, NSString * _Nonnull errorName) {
            [[KKFloatViewMgr shareInstance] tryLeaveVoiceRoom:^{
                [CC_Notice show:errorMsg];
            }];
        }];
        
    }else if (defaultPop == self.alertExitVoiceWiilJoinLiveStudio) { /// 退出语音房进入招募厅
        [[KKFloatViewMgr shareInstance] tryLeaveVoiceRoom:^{
            [weakSelf tryToJoinLiveStudio:weakSelf.roomStatusTop.channelId];
        }];
    }
    self.isShowAlert = NO;
}

#pragma mark - Action
/// 头部的一个拖拽手势
- (void)headerPan:(UIPanGestureRecognizer *)pan{
    ///  触点移动的绝对距离
    ///  CGPoint location = [pan locationInView:self.view];
    ///  移动两点之间的相对距离
    CGPoint translation = [pan translationInView:self.view];
    UIScrollView *scrollView;
    if ([_currentTVIndexStr isEqualToString:@"right"]) {
        scrollView = self.voiccTableView;
    }else {
        scrollView = self.kingPlayTableView;
    }
    CGFloat offsetY = scrollView.contentOffset.y - translation.y;
    ///  模仿一下scrollView下拉回弹(0 到 -313)
    if (offsetY > -RH(84)){
        [scrollView setContentOffset:CGPointMake(0, offsetY)];
    }
    if (pan.state == UIGestureRecognizerStateEnded && offsetY < 0) {
        [scrollView setContentOffset:CGPointZero animated:YES];
    }
    [pan setTranslation:CGPointZero inView:self.view];
    if (offsetY < -RH(64)) {
        if ([_currentTVIndexStr isEqualToString:@"right"]) {
            [self.voiccTableView beginHeaderRefresh];
        }else {
            [self.kingPlayTableView beginHeaderRefresh];
        }
    }
}

#pragma mark - Jump
/// 进入招募厅
- (void)pushToLiveStudioVCWithStudioId:(NSString *)studioId {
    KKLiveStudioVC *liveStudioVC = [KKLiveStudioVC shareInstance];
    liveStudioVC.studioId = studioId;
    [liveStudioVC pushSelfByNavi:[KKRootContollerMgr getRootNav]];
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

// 进入搜索
- (void)pushToSearchVC {
    KKNewSearchViewController *vc = [[KKNewSearchViewController alloc] init];
    vc.type = _type;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 创建开黑
- (void)pushToCreateGameVC {
    WS(weakSelf)
    //1. 在招募厅
    if ([KKFloatViewMgr shareInstance].liveStudioModel.studioId.length != 0) {
        [self showAlertExitLiveWithCreteKH];
        return;
    }
    //2. 在语音房
    if ([KKFloatViewMgr shareInstance].voiceRoomModel.roomId > 0) {
        [self pushToVoiceVC:[KKFloatViewMgr shareInstance].voiceRoomModel.roomId channelId:[KKFloatViewMgr shareInstance].voiceRoomModel.channelId];
        return;
    }
    //3.. 在开黑房
    if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId > 0){
        
        [KKHomeService request_game_board_join_consult_dataWithProfilesId:[KKFloatViewMgr shareInstance].gameRoomModel.gameProfilesIdStr gameRoomId:[KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId gameBoardId:[KKFloatViewMgr shareInstance].gameRoomModel.gameBoardIdStr success:^{
            
            /// 有黑框都允许进入
            [weakSelf pushGameBoardDetailRoomId:[KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId gameBoardId:[KKFloatViewMgr shareInstance].gameRoomModel.gameBoardIdStr gameProfilesId:[KKFloatViewMgr shareInstance].gameRoomModel.gameProfilesIdStr groupId:[KKFloatViewMgr shareInstance].gameRoomModel.groupIdStr channelId:[KKFloatViewMgr shareInstance].gameRoomModel.channelId];
            
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

/// 点击了开黑列表
- (void)didSelectedTableViewCell {
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
                [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:weakSelf.lastCard.ID groupId:weakSelf.currentListInfo.groupId channelId:weakSelf.currentListInfo.channelId];
            }
        } isCreateCradList:^{
            weakSelf.tapWherePopCardListFalg = KKTapedRoomListType;
            /// 名片不一致, 弹出名片列表
            [weakSelf requestCardListInfo];
            [weakSelf initCardListView];
        } showAlertGoNewGameBoard:^{
            weakSelf.isShowAlert = NO;
            [weakSelf showAlert];
            
        } showAlertLiveStudio:^{
            [weakSelf showAlertExitLiveStudioAction];
        } showAlertLeaveVoiceRoom:^{
            [weakSelf showAlertExitVoiceWiilJoinGameRoom];
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
                                showAlertLeaveVoiceRoom:(void(^)(void))showAlertLeaveVoiceRoom
{
    /// 有名片
    if (_lastCard.ID.length != 0) {
        /// 没有未完成的局
        if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId <= 0) {
            /// 也不再招募厅
            if ([KKFloatViewMgr shareInstance].liveStudioModel.studioId.length == 0) {
                /// 也不在语音房
                if ([KKFloatViewMgr shareInstance].voiceRoomModel.roomId <= 0) {
                    
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
                    /// 退出语音房在进入
                    if ([_rank isEqualToString:@"全部"]) {
                        isCreateCradList();
                    }else if (_rank != nil) {
                        showAlertLeaveVoiceRoom();
                    }
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
                        
                        [weakSelf pushGameBoardDetailRoomId:weakSelf. currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:proId groupId:weakSelf.currentListInfo.groupId channelId:weakSelf.currentListInfo.channelId];
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

/// 进入开黑房详情
- (void)pushGameBoardDetailRoomId:(NSInteger)roomid gameBoardId:(NSString *)gameBoardId gameProfilesId:(NSString *)gameProfilesId groupId:(NSString *)groupId channelId:(NSString *)channelId {
    //1. 悬浮窗管理
    [[KKFloatViewMgr shareInstance] hiddenGameRoomFloatView];
    //2. 进入房间
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

#pragma mark - Net
/// 上拉加载, 下拉刷新
- (void)loadData {
    //1.开黑房刷新
    WS(weakSelf)
    [self.kingPlayTableView addSimpleHeaderRefresh:^{
        [weakSelf.dataList removeAllObjects];
        [weakSelf requestHomeRoomStatusData];
        [weakSelf requestBannerData];
        [weakSelf requestLasttimeGameboardData:^(KKCardTag *lastCard) {}];
        [[KKFloatViewMgr shareInstance] requestFloatRoomViewTypeInfoSuccess:^(NSString * _Nonnull type) {
        }];
     }];
    
    [self.kingPlayTableView.mj_header beginRefreshing];
    self.kingPlayTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        SS(strongSelf)
        if (strongSelf->_paginator.page < strongSelf->_paginator.pages) {
            weakSelf.paginator.page++;
            [strongSelf requestHomeListData] ;
        }else{
            [strongSelf.kingPlayTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    //2.语音房刷新
    [self.voiccTableView addSimpleHeaderRefresh:^{
        [weakSelf.dataVoiceList removeAllObjects];
        [weakSelf requestVoiceRoomListData];
     }];
    [self.voiccTableView.mj_header beginRefreshing];
    self.voiccTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        SS(strongSelf)
        if (strongSelf->_paginatorVoice.page < strongSelf->_paginatorVoice.pages) {
            weakSelf.paginatorVoice.page++;
            [strongSelf requestVoiceRoomListData];
        }else{
            [strongSelf.voiccTableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

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
        weakSelf.bannersData = dataList;
        weakSelf.headerView.banners = banners;
    } Fail:^{
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
        weakSelf.headerView.selectViewTitle = weakSelf.rank;
        [weakSelf requestHomeListData];
        completeLastCard(lastCard);
    } Fail:^{
    }];
}

/// 请求开黑房间列表
- (void)requestHomeListData {
    WS(weakSelf)
    [KKHomeService shareInstance].page = (self.paginator.page != 0)?@(self.paginator.page):@(1);
    CCLOG(@"%@", [KKHomeService shareInstance].page);
    [KKHomeService requestHomeListSuccess:^(NSMutableArray * _Nonnull dataList, KKPaginator * _Nonnull paginator) {
        [weakSelf.dataList addObjectsFromArray:dataList];
        weakSelf.kingPlayTableView.dataList = weakSelf.dataList;
        
        if (weakSelf.dataList.count == 0) {
            weakSelf.kingPlayTableView.tableFooterView = weakSelf.notDataView;
        }else {
            weakSelf.kingPlayTableView.tableFooterView = New(UIView);
        }
        weakSelf.paginator = paginator;
        [weakSelf.kingPlayTableView.mj_footer endRefreshing];
        [weakSelf.kingPlayTableView.mj_header endRefreshing];
    } Fail:^{
        [weakSelf.kingPlayTableView.mj_footer endRefreshing];
        [weakSelf.kingPlayTableView.mj_header endRefreshing];
    }];
}

/// 请求首页的房间状态
- (void)requestHomeRoomStatusData {
    WS(weakSelf)
    [KKHomeService requestHomeRoomStatusDataSuccess:^(NSMutableArray * _Nonnull dataList) {
        weakSelf.roomStatusTop = dataList.lastObject;
        weakSelf.headerView.status = dataList.lastObject;
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

/// 点击筛选, 没有名片的时候是 @[@"全部", @"添加名片"]. 有名片的时候 @[@"全部", @"名片列表List", @"添加名片"]
- (void)dealData {
    /// 数据处理, 筛选的时候才有全部, 点击开黑房列表的时候, 只是单纯的选择名片
    if (_tapWherePopCardListFalg == KKTapedSelectType) {
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

/// 语音房相关
- (void)requestVoiceRoomListData {
    WS(weakSelf)
    NSNumber *currentPage = (self.paginatorVoice.page != 0)?@(self.paginatorVoice.page):@(1);
    [KKHomeService requesHomeVoiceRoomListWithCurrentPage:currentPage success:^(NSMutableArray * _Nonnull dataList, KKPaginator * _Nonnull paginator) {
        [weakSelf.dataVoiceList addObjectsFromArray:dataList];
        weakSelf.voiccTableView.dataList = weakSelf.dataVoiceList;
        if (weakSelf.dataVoiceList.count == 0) {
            weakSelf.voiccTableView.tableFooterView = weakSelf.notDataVoiceRoomView;
        }else {
            weakSelf.voiccTableView.tableFooterView = New(UIView);
        }
        weakSelf.paginatorVoice = paginator;
        [weakSelf.voiccTableView.mj_footer endRefreshing];
        [weakSelf.voiccTableView.mj_header endRefreshing];
            
    } fail:^{
        [weakSelf.voiccTableView.mj_footer endRefreshing];
        [weakSelf.voiccTableView.mj_header endRefreshing];
    }];
}
@end
