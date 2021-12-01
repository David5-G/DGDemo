//
//  KKShareGameBoardViewController.m
//  kk_espw
//
//  Created by 景天 on 2019/8/2.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKShareGameBoardViewController.h"
#import "KKShareRoomView.h"
#import "KKShareRoomService.h"
#import "KKHomeRoomListInfo.h"
#import "KKCreateCardView.h"
#import "KKMyCardService.h"
#import "KKGameRoomBaseController.h"
#import "KKCardTag.h"
#import "KKCardsSelectView.h"
#import "KKHomeService.h"
#import "KKShareGameInfo.h"
#import "KKCalculateTextWidthOrHeight.h"
#import "KKHomeVC.h"
#import "KKGameRoomOwnerController.h"
#import "KKHomeRoomStatus.h"
#import "KKCheckInfo.h"
#import "KKLiveStudioRtcMgr.h"
#import "KKGameRoomManager.h"
#import "KKAddMyCardViewController.h"
#import "KKRtcService.h"
#import "KKGameRtcMgr.h"
@interface KKShareGameBoardViewController ()<CatDefaultPopDelegate>
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nickL;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) KKShareRoomView *shareRoomView;
@property (nonatomic, strong) KKHomeRoomListInfo *currentListInfo;
@property (nonatomic, strong) NSMutableArray *cardIf;
@property (nonatomic, strong) KKCreateCardView *createCardView;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) KKCardsSelectView *cardsSelectView;
@property (nonatomic, strong) KKCardTag *lastCard; /// 上一次的对局名片
@property (nonatomic, strong) CatDefaultPop *pop;
@property (nonatomic, strong) CatDefaultPop *alertExitLiveStudio;
@property (nonatomic, strong) CatDefaultPop *alertExitVoiceWiilJoinGameRoom;
@property (nonatomic, strong) KKShareGameInfo *shareInfo;
@end

@implementation KKShareGameBoardViewController
#pragma mark - Init
- (NSMutableArray *)cardIf {
    if (!_cardIf) {
        _cardIf = [NSMutableArray array];
    }
    return _cardIf;
}

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [NSMutableArray array];
    }
    return _cards;
}

#pragma mark - Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavUI];
    [self setUI];
    
    [self requestShareRoomData];
    [self requestLasttimeGameboardData:^(KKCardTag *lastCard) {}];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [KKFloatViewMgr shareInstance].hiddenFloatView = YES;
    [[KKFloatViewMgr shareInstance] hiddenGameRoomFloatView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [KKFloatViewMgr shareInstance].hiddenFloatView = NO;
    [[KKFloatViewMgr shareInstance] notHiddenGameRoomFloatView];
}


#pragma mark - UI
- (void)setNavUI {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"KK电竞"];
}

- (void)setUI {
    _bgView = New(UIImageView);
    _bgView.left = 0;
    _bgView.top = STATUSBAR_ADD_NAVIGATIONBARHEIGHT;
    _bgView.size = CGSizeMake(SCREEN_WIDTH, RH(150));
    _bgView.image = Img(@"share_room_bg_jt");
    [self.view addSubview:_bgView];
    
    _headerImageView = New(UIImageView);
    _headerImageView.centerX = self.view.centerX - RH(38.5);
    _headerImageView.top = _bgView.top + RH(111);
    _headerImageView.size = CGSizeMake(RH(77), RH(77));
    _headerImageView.clipsToBounds = YES;
    _headerImageView.layer.cornerRadius = RH(38.5);
    _headerImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerImageView];
    
    _nickL = New(UILabel);
    _nickL.top = _headerImageView.bottom + RH(10);
    _nickL.height = RH(20);
    _nickL.text = @"张楚岚";
    _nickL.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:RH(17)];
    _nickL.textColor = KKES_COLOR_BLACK_TEXT;
    [self.view addSubview:_nickL];
    
    _sexImageView = New(UIImageView);
    _sexImageView.top = _nickL.top + RH(6);
    [self.view addSubview:_sexImageView];
    
    UILabel *title = New(UILabel);
    title.left = 0;
    title.top = _nickL.bottom + RH(50);
    title.size = CGSizeMake(SCREEN_WIDTH, 14);
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:RH(15)];
    title.textColor = KKES_COLOR_DARK_GRAY_TEXT;
    title.text = @"邀请你加入开黑房";
    [self.view addSubview:title];
    
    UIImageView *down = New(UIImageView);
    down.left = RH(182);
    down.top = RH(11) + title.bottom;
    down.size = CGSizeMake(RH(13), RH(13));
    down.image = Img(@"share_room_down_jt");
    [self.view addSubview:down];
    WS(weakSelf)
    _shareRoomView = [[KKShareRoomView alloc] initWithFrame:CGRectMake(RH(15), down.bottom + RH(18), SCREEN_WIDTH - RH(30), RH(139))];
    [self.view addSubview:_shareRoomView];
    
    UIButton *join = [UIButton buttonWithType:UIButtonTypeCustom];
    join.left = RH(52);
    join.top = _shareRoomView.bottom + RH(20);
    join.size = CGSizeMake(SCREEN_WIDTH - RH(104), RH(45));
    join.backgroundColor = [UIColor whiteColor];
    join.layer.borderWidth = 1;
    join.layer.borderColor = [UIColor colorWithRed:236/255.0 green:193/255.0 blue:101/255.0 alpha:1.0].CGColor;
    join.layer.cornerRadius = 22.5;
    [join setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    join.backgroundColor = KKES_COLOR_MAIN_YELLOW;
    [join setTitle:@"立即加入" forState:UIControlStateNormal];
    [self.view addSubview:join];
    [join addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        if (![KKUserInfoMgr isLogin]) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            
            return ;
        }
        
        [weakSelf push];
    }];
    
    UIButton *toHomeVC = [UIButton buttonWithType:UIButtonTypeCustom];
    toHomeVC.left = RH(52);
    toHomeVC.top = join.bottom + RH(25);
    toHomeVC.size = CGSizeMake(SCREEN_WIDTH - RH(104), RH(45));
    toHomeVC.backgroundColor = [UIColor whiteColor];
    toHomeVC.layer.borderWidth = 1;
    toHomeVC.layer.borderColor = [UIColor colorWithRed:236/255.0 green:193/255.0 blue:101/255.0 alpha:1.0].CGColor;
    toHomeVC.layer.cornerRadius = 22.5;
    [toHomeVC setTitleColor:KKES_COLOR_MAIN_YELLOW forState:UIControlStateNormal];
    [toHomeVC setTitle:@"去首页看看" forState:UIControlStateNormal];
    [self.view addSubview:toHomeVC];
    [toHomeVC addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        self.navigationController.tabBarController.selectedIndex = 0;
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
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
                    
                    [weakSelf showAlertExitLiveStudioAction];
                }else if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId <= 0) {
                    
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
                    [weakSelf showAlert];
                }else {
                    if ([errorName isEqualToString:@"GAME_BOARD_STATUS_ERROR"]) {
                        [CC_Notice show:@"开黑房不见了，去首页看看！"];
                    }else {
                        [CC_Notice show:errorMsg];
                    }
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

/// 进入开黑房后, 将退出语音房
- (void)showAlertExitVoiceWiilJoinGameRoom {
    self.alertExitVoiceWiilJoinGameRoom = [[CatDefaultPop alloc] initWithTitle:@"是否进入?" content:@"进入开黑房后, 将退出语音房?" cancelTitle:@"取消" confirmTitle:@"确定"];
    self.alertExitVoiceWiilJoinGameRoom.delegate = self;
    [self.alertExitVoiceWiilJoinGameRoom popUpCatDefaultPopView];
    self.alertExitVoiceWiilJoinGameRoom.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    [self.alertExitVoiceWiilJoinGameRoom updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
}

#pragma mark - Net
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
- (void)requestLasttimeGameboardData:(void(^)(KKCardTag *lastCard))completeLastCard {
    WS(weakSelf)
    [KKHomeService requestLastTimeGameBoadDataSuccess:^(KKCardTag * _Nonnull lastCard, KKMessage * _Nonnull message) {
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

- (void)requestShareRoomData {
    WS(weakSelf)
    [KKShareRoomService shareInstance].gameBoradId = self.gameBoradId;
    [KKShareRoomService shareInstance].shareUserId = self.shareUserId;
    [KKShareRoomService requestShareRoomDataSuccess:^(KKShareGameInfo * _Nonnull shareInfo, KKHomeRoomListInfo * _Nonnull info) {
        weakSelf.shareRoomView.info = info;
        weakSelf.shareRoomView.shareInfo = shareInfo;
        weakSelf.currentListInfo = info;
        weakSelf.shareInfo = shareInfo;
        [weakSelf.headerImageView sd_setImageWithURL:Url(shareInfo.shareUserLogoUrl)];
        weakSelf.nickL.width = [KKCalculateTextWidthOrHeight getWidthWithAttributedText:shareInfo.shareUserLoginName font:[KKFont pingfangFontStyle:PFFontStyleSemibold size:17] height:RH(15)];
        weakSelf.nickL.left = SCREEN_WIDTH / 2 - weakSelf.nickL.width / 2;
        weakSelf.nickL.text = shareInfo.shareUserLoginName;
        weakSelf.sexImageView.left = weakSelf.nickL.right + RH(5);
        if ([shareInfo.shareUserSex.name isEqualToString:@"F"]) {
            weakSelf.sexImageView.image = Img(@"home_female_pink");
            weakSelf.sexImageView.size = CGSizeMake(RH(10), RH(10));
        }else {
            weakSelf.sexImageView.image = Img(@"home_male_blue");
            weakSelf.sexImageView.size = CGSizeMake(RH(10), RH(10));
        }
    } Fail:^{
    }];
}

#pragma mark - Jump
- (void)push {
    [KKShareRoomService shareInstance].gameBoradId = self.gameBoradId;
    [KKShareRoomService shareInstance].shareUserId = self.shareUserId;
    [KKShareRoomService requestShareRoomDataSuccess:^(KKShareGameInfo * _Nonnull shareInfo, KKHomeRoomListInfo * _Nonnull info) {
        
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
        if ([KKFloatViewMgr shareInstance].voiceRoomModel.roomId > 0) {
            [self showAlertExitVoiceWiilJoinGameRoom];
        }else if ([info.proceedStatus.name isEqualToString:@"RECRUIT"]) {
            
            [self judgeCurrentTableViewCellInfoCurrentIsCreateCradList:^{
                /// 名片不符合, 弹出名片列表
                [weakSelf initCardListView];
                [weakSelf requestCardListInfo];
            } showAlertLiveStudio:^{
                [weakSelf showAlertExitLiveStudioAction];
            }canPush:^{
                [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:weakSelf.lastCard.ID groupId:weakSelf.currentListInfo.groupId channelId:weakSelf.currentListInfo.channelId];
            }showAlertVoiceRoom:^{
                [weakSelf showAlertExitVoiceWiilJoinGameRoom];
            }];
        }
        
    } Fail:^{}];
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

#pragma mark - catDefaultPopConfirm
- (void)catDefaultPopConfirm:(CatDefaultPop*)defaultPop{
    WS(weakSelf)
    if (defaultPop == self.alertExitLiveStudio) { /// 退出招募厅, 进入开黑房
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

    }else if (defaultPop == self.pop) { /// 退出上一个开黑房 进入当前开黑房
        [[KKFloatViewMgr shareInstance] tryToLeaveGameRoom:^{
            
            /// 退出开黑房之后, 校验名片
            [KKHomeService request_game_board_join_consult_dataWithProfilesId:weakSelf.lastCard.ID gameRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId success:^{
                
                [weakSelf pushGameBoardDetailRoomId:weakSelf.currentListInfo.gameRoomId gameBoardId:weakSelf.currentListInfo.gameBoardId gameProfilesId:weakSelf.lastCard.ID groupId:weakSelf.currentListInfo.groupId channelId:weakSelf.currentListInfo.channelId];
            } fail:^(NSString * _Nonnull errorMsg, NSString * _Nonnull errorName) {
                if ([errorName isEqualToString:@"PURCHASE_ORDER_IS_EXISTED"] || [errorName isEqualToString:@"GAME_BOARD_JOIN_HAS_OCCUPY"]) {
                    [weakSelf showAlert];
                }else {
                    if ([errorName isEqualToString:@"GAME_BOARD_STATUS_ERROR"]) {
                        [CC_Notice show:@"开黑房不见了，去首页看看！"];
                    }else {
                        [CC_Notice show:errorMsg];
                    }
                }
            }];
        }];
    }else if (defaultPop == self.alertExitVoiceWiilJoinGameRoom) { /// 进入开黑将退出语音房
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
    }
}

- (void)catDefaultPopCancel:(CatDefaultPop *)defaultPop {
    if (defaultPop == self.alertExitLiveStudio) { /// 退出招募厅, 进入开黑房
        self.alertExitLiveStudio = nil;
    }else if (defaultPop == self.pop) { /// 退出上一个开黑房 进入当前开黑房
        self.pop = nil;
    }
}

#pragma mark - Jump
- (void)pushGameBoardDetailRoomId:(NSInteger)roomid gameBoardId:(NSString *)gameBoardId gameProfilesId:(NSString *)gameProfilesId groupId:(NSString *)groupId channelId:(NSString *)channelId {
    [KKFloatViewMgr shareInstance].gameRoomModel = nil;
    [KKFloatViewMgr shareInstance].liveStudioModel = nil;
    [KKGameRoomOwnerController sharedInstance].gameProfilesIdStr = gameProfilesId;
    [KKGameRoomOwnerController sharedInstance].gameBoardIdStr = gameBoardId;
    [KKGameRoomOwnerController sharedInstance].gameRoomId = roomid;
    [KKGameRoomOwnerController sharedInstance].groupIdStr = groupId;
    [[KKGameRtcMgr shareInstance] requestJoinGameRoomGameBoardId:gameBoardId channelId:channelId success:^{
        dispatch_async(dispatch_get_main_queue(), ^{
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
@end
