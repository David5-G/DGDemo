//
//  KKGameRoomOwnerController.m
//  kk_espw
//
//  Created by hsd on 2019/7/31.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameRoomOwnerController.h"
#import "KKPlayerCardCollectionCell.h"
#import "KKGamePrepareToolView.h"
#import "KKGameChargeToolView.h"
#import "KKPlayerGameCardView.h"
#import "KKLiveStudioOnlineUserView.h"
#import "KKShareWQDView.h"
#import "KKPlayerGameCardTool.h"
#import "KKConversationController.h"
#import "KKFloatViewMgr.h"
#import "KKGameRoomViewModel.h"
#import "KKChangeImageColorModel.h"

//controller
#import "KKChatRoomTableVC.h"
#import "KKGameWaitEvaluateController.h"
#import "KKGameReportController.h"
#import "KKConversationController.h"
#import "KKWeChatShareImageController.h"
#import "KKGameOrderDetailController.h"

// MJRefresh
#import "UIScrollView+Refresh.h"
// 升级包修改的底部禁言,禁止语音工具视图
#import "KKVoiceRoomInputView.h"
// rtc
#import "KKRtcService.h"
#import "KKGameStatusInfoModel.h"
// 禁言用户列表
#import "KKUserMgrListViewController.h"
#import "KKLiveStudioVC.h"
#import "KKVoiceRoomVC.h"

static const NSInteger kk_cat_pop_tag_dissolve_room     = 9;
static const NSInteger kk_cat_pop_tag_remove_room       = 19;
static const NSInteger kk_cat_pop_tag_call_led          = 29;
static const NSInteger kk_cat_pop_tag_exit_room         = 39;

@interface KKGameRoomOwnerController ()<CatDefaultPopDelegate, KKVoiceRoomInputViewDelegate,KKChatRoomTableVCDelegate, KKPlayerGameCardToolDelagate, RongRTCRoomDelegate, RongRTCActivityMonitorDelegate>

@property (nonatomic, strong, nullable) CatDefaultPop *catPop;  ///< 弹窗
@property (nonatomic, weak, nullable) KKGameChargeToolView *chargeToolView; ///< 充值弹窗
@property (nonatomic, weak, nullable) KKChatRoomTableVC *conversationController; ///< 聊天列表
@property (nonatomic, strong, nullable) KKGameRoomViewModel *viewModel;      ///< 数据对象
@property (nonatomic, assign) BOOL isMicOpen; //设置麦克风是否可用
@property (nonatomic, assign) BOOL isVoiceOpen; //
@property (nonatomic, copy) NSArray <KKGameBoardDetailSimpleModel *> *currentMicPArray;
@property (nonatomic, assign) BOOL isForbidWord;
@property (nonatomic, strong) UIImageView *gifImageView;
@property (nonatomic, copy) NSString *didSelectedChatCellUserId; /// 当前聊天室被点击的用户Id
@end

@implementation KKGameRoomOwnerController


#pragma mark - 单例
static KKGameRoomOwnerController *_gameRoomController = nil;
static dispatch_once_t onceToken;

+ (instancetype)sharedInstance {
    dispatch_once(&onceToken, ^{
        _gameRoomController = [[super allocWithZone:NULL] init];
    });
    return _gameRoomController;
}

- (void)remove {
    _gameRoomController = nil;
    onceToken = 0;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [KKGameRoomOwnerController sharedInstance];
}

#pragma mark - get
- (instancetype)init {
    if (self = [super init]) {
        self.viewModel = [[KKGameRoomViewModel alloc] init];
    }
    return self;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //1. 配置UI
    [self p_initNavRightView];
    [self p_initPlayerListView];
    [self p_initChatToolView];
    [self p_initPrepareView];
    [self addConversationChildController];
    //[self addTapGestureToView];
    [self addDropDownRefresh];
    [self registerCollectionViewCell];
    [self registerPrepareButtonAction];
    [self registerInputDelegate];
    [self.gameSuperView bringSubviewToFront:self.prepareToolView];
    //2.
    _isVoiceOpen = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        
    [KKFloatViewMgr shareInstance].hiddenFloatView = YES;
    [[KKFloatViewMgr shareInstance] hiddenGameRoomFloatView];
    [self initDefaultGameDatas];
    [self addNotificagtions];
    
    [self.viewModel requestForOwnerKiperLimitTime];
    [self.viewModel checkForLeaveGameRoomTimeConfigQuery];
    
    // 开始下拉刷新
    [self beginRefreshInfoDatas];
}

- (void)setGroupIdStr:(NSString *)groupIdStr {
    [self configRtc];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self removeNotifications];
    [[KKFloatViewMgr shareInstance] notHiddenGameRoomFloatView];
    [KKFloatViewMgr shareInstance].hiddenFloatView = NO;

}

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resumePrepareToolViewButtonUserEnable) object:nil];
    CCLOG(@"%s", __func__);
}

#pragma mark - override
// 本页面已经从父页面中移除
- (void)didMoveToParentViewController:(UIViewController *)parent {
    if (parent == nil) {
        // 取消定时器
        [self.viewModel checkCancelCountDownEnable:YES];

        // 浮窗控制
        if (self.viewModel.isCloseGameRoom) {
            self.viewModel.isCloseGameRoom = NO;
            [KKFloatViewMgr shareInstance].gameRoomModel = nil;
            [KKFloatViewMgr shareInstance].type = KKFloatViewTypeUnknow;

        } else {
            [self setGameModel:self.viewModel];
        }
    }
}

- (void)setGameModel:(KKGameRoomViewModel *)viewModel {
    KKFloatGameRoomModel *model = [[KKFloatGameRoomModel alloc] init];
    model.gameRoomId = viewModel.gameRoomId;
    model.gameProfilesIdStr = viewModel.gameProfilesIdStr;
    model.gameBoardIdStr = viewModel.gameBoardIdStr;
    model.groupIdStr = viewModel.groupIdStr;
    model.ownerLogoUrl = viewModel.ownerLogoUrl;
    model.ownerUserId = viewModel.infoModel.gameBoardClientSimple.ownerUserId;
    model.channelId = viewModel.channelId;
    [KKFloatViewMgr shareInstance].gameRoomModel = model;
    [KKFloatViewMgr shareInstance].type = KKFloatViewTypeGameRoom;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    //[self.chatToolView stopInput];
}

#pragma mark - 初始化
/// 初始化默认数据
- (void)initDefaultGameDatas {
    if (self.viewModel.gameRoomId != self.gameRoomId) {
        self.viewModel.gameRoomId = self.gameRoomId;
        self.viewModel.gameProfilesIdStr = self.gameProfilesIdStr;
        self.viewModel.gameBoardIdStr = self.gameBoardIdStr;
        self.viewModel.groupIdStr = self.groupIdStr;
    }
}

- (void)addConversationChildController {
    
    // 聊天窗口的父视图
    UIView *chatBgView = [[UIView alloc] init];
    chatBgView.backgroundColor = KKES_COLOR_BG;
    [self.gameSuperView addSubview:chatBgView];
    [chatBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.gameSuperView);
        make.top.mas_equalTo(self.prepareToolView.mas_bottom);
        make.bottom.mas_equalTo(self.chatToolView.mas_top);
    }];
    
    // 聊天窗
    KKChatRoomTableVC *conversationVC = [[KKChatRoomTableVC alloc] init];
    conversationVC.targetId = self.groupIdStr;
    conversationVC.delegate = self;
    self.conversationController = conversationVC;
    [self addChildViewController:conversationVC];
    [chatBgView addSubview:conversationVC.view];
    [conversationVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

- (void)registerCollectionViewCell {
    [self.playerListView registerNib:[UINib nibWithNibName:NSStringFromClass([KKPlayerCardCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([KKPlayerCardCollectionCell class])];
}

- (void)registerPrepareButtonAction {
    WS(weakSelf)
    self.prepareToolView.tapBlockNoBorder = ^(CC_Button * _Nonnull btn) {
        [weakSelf clickPrepareNoBorderButton];
    };
    self.prepareToolView.tapBlockBorder = ^(CC_Button * _Nonnull btn) {
        [weakSelf clickPrepareBorderButton];
    };
}

- (void)registerInputDelegate {
    self.chatToolView.delegate = self;
}

// 此方法会导致表情无法发送
/*
- (void)addTapGestureToView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDidTrigger)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
 */

// 添加下拉刷新
- (void)addDropDownRefresh {
    WS(weakSelf)
    [self.backgroundScrollView addSimpleHeaderRefresh:^{
        [weakSelf beginRefreshInfoDatas];
    }];
    MJRefreshNormalHeader *header = (MJRefreshNormalHeader *)self.backgroundScrollView.mj_header;
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    header.arrowView.image = [KKChangeImageColorModel changeImageToColor:KKES_COLOR_HEX(0xFFFFFF) sourceImage:header.arrowView.image];
}

- (void)addNotificagtions {
    /*
     ///通知: 开黑房状态改变
     #define REFRESH_GAME_BOARD_ROOM_NOTIFICATION @"REFRESH_GAME_BOARD_ROOM_NOTIFICATION"
     ///通知: 聊天室成员变化
     #define CHAT_ROOM_MEMBER_CHANGE_NOTIFICATION @"CHAT_ROOM_MEMBER_CHANGE_NOTIFICATION"
     ///通知: 直播间麦位变化
     #define LIVE_STUDIO_MIC_POSITION_CHANGE_NOTIFICATION @"LIVE_STUDIO_MIC_POSITION_CHANGE_NOTIFICATION"
     ///通知: 直播间 主播mic变化
     #define LIVE_STUDIO_HOST_MIC_CHANGE_NOTIFICATION @"LIVE_STUDIO_HOST_MIC_CHANGE_NOTIFICATION"
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveGameRoomStatusChangeNotification:) name:REFRESH_GAME_BOARD_ROOM_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveGameRoomDissolveNotification:) name:@"GAME_BOARD_NOT_ONGOING_NOT_EXISTED" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveProfileNotConfirmNotification:) name:@"USER_GAME_PROFILES_NOT_CONFORM" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveForbiddenNotification:) name:CHAT_ROOM_MEMBER_CHANGE_NOTIFICATION object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Button Click
- (void)clickPrepareNoBorderButton {
    WS(weakSelf)
    KKGameStatus gameStatus = self.viewModel.gameStatus;
    if (self.viewModel.loginUserIsRoomOwner) {
        if (gameStatus == KKGameStatusPlayerEnter) {
            [self.viewModel requestForCallLed:^{
                [weakSelf showAlertViewWithTitle:@"提示" subTitle:@"呼叫已发送到直播厅\n小伙伴正在来开黑房的路上" cancel:nil confirm:@"确定" tag:kk_cat_pop_tag_call_led];
            }];
            
        } else if (gameStatus == KKGameStatusAllPlayerReadied) {
            [self.viewModel requestForGameStart:^{
                [weakSelf reloadUI];
            }];
        } else if (gameStatus == KKGameStatusInPlaying) {
            // 进群
            [self.viewModel requestForIntoGameGroupWithWechat:^(NSString * _Nullable urlStr) {
                [weakSelf jumpToShareWechatCodeImg:urlStr];
            } qq:^(NSString * _Nullable urlStr) {
                [weakSelf jumpToQQGroup:urlStr];
            }];;
        }
    } else {
        if (gameStatus == KKGameStatusPlayerJoin) {
            //不管是否收费, 先准备, 准备成功后再查看是否收费
            [self.viewModel requestForGameTogether:^(NSDictionary * _Nonnull responseDic) {
                if (weakSelf.viewModel.depositPrice > 0) {
                    weakSelf.viewModel.orderNoStr = responseDic[@"orderNo"];
                    [weakSelf.viewModel requestForMyWalletInfo:^(KKMyWalletInfo * _Nonnull myWallet) {
                        [weakSelf.viewModel requestForAll:^{
                            [weakSelf reloadUI];
                        }];
                        [weakSelf showChargeToolViewWithBalance:myWallet.accountInfoClientSimple.avaiableAmount];
                    }];
                    
                } else {
                    [weakSelf.viewModel requestForAll:^{
                        [weakSelf reloadUI];
                    }];
                }
            }];
            
        } else if (gameStatus == KKGameStatusPlayerUnPay) {
            [self.viewModel requestForMyWalletInfo:^(KKMyWalletInfo * _Nonnull myWallet) {
                [weakSelf showChargeToolViewWithBalance:myWallet.accountInfoClientSimple.avaiableAmount];
            }];
            
        } else if (gameStatus == KKGameStatusPlayerReadied) {
            [self.viewModel requestForCallLed:^{
                [weakSelf showAlertViewWithTitle:@"提示" subTitle:@"呼叫已发送到直播厅\n小伙伴正在来开黑房的路上" cancel:nil confirm:@"确定" tag:kk_cat_pop_tag_call_led];
            }];
            
        } else if (gameStatus == KKGameStatusInPlaying) {
            [self.viewModel requestForIntoGameGroupWithWechat:^(NSString * _Nullable urlStr) {
                [weakSelf jumpToShareWechatCodeImg:urlStr];
            } qq:^(NSString * _Nullable urlStr) {
                [weakSelf jumpToQQGroup:urlStr];
            }];
        }
    }
}

- (void)clickPrepareBorderButton {
    WS(weakSelf)
    KKGameStatus gameStatus = self.viewModel.gameStatus;
    if (self.viewModel.loginUserIsRoomOwner) {
        if (gameStatus == KKGameStatusPlayerEnter ||
            gameStatus == KKGameStatusAllPlayerReadied) {
            [self showAlertViewWithTitle:@"提示" subTitle:@"确定解散房间吗?" cancel:@"我再想想" confirm:@"确定" tag:kk_cat_pop_tag_dissolve_room];
            
        } else if (gameStatus == KKGameStatusInPlaying) {
            [self.viewModel requestForGameOver:^{
                [weakSelf jumpToEvaluateController];
                [weakSelf.viewModel requestForAll:^{
                    [weakSelf reloadUI];
                }];
            }];
        }
        
    } else {
        if (gameStatus == KKGameStatusPlayerJoin) {
            
            //1. 离开座位
            [self.viewModel requestForCancelSeat:nil success:^{
                [weakSelf reloadUI];
            }];
            
        } else if (gameStatus == KKGameStatusPlayerUnPay ||
                   gameStatus == KKGameStatusPlayerReadied ||
                   gameStatus == KKGameStatusAllPlayerReadied) {
            [self.viewModel requestForCancelOrderNo:nil success:^{
                [weakSelf reloadUI];
            }];
            
        } else if (gameStatus == KKGameStatusInPlaying) {
            [self.viewModel requestForGameOver:^{
                [weakSelf jumpToEvaluateController];
                [weakSelf.viewModel requestForAll:^{
                    [weakSelf reloadUI];
                }];
            }];
        }
    }
}

- (void)gameZoomCloseWithNeedAlert:(BOOL)needAlert {
    if (needAlert) {
        [self p_clickNavCloseButton];
    } else{
        self.viewModel.isCloseGameRoom = YES;
        [self p_clickNavBackButton];
        [self remove];
    }
}

- (void)p_clickNavCloseButton {
    NSString *subTitle = self.viewModel.loginUserIsRoomOwner ? @"确定解散房间吗?" : @"确定退出房间吗?";
    [self showAlertViewWithTitle:@"提示" subTitle:subTitle cancel:@"我再想想" confirm:@"确定" tag:kk_cat_pop_tag_exit_room];
}


- (void)p_clickStudioOnlineView {
    WS(weakSelf)
    //1.创建
    KKUserMgrListViewController *popVC;
    if (self.viewModel.loginUserIsRoomOwner) {
        popVC = [[KKUserMgrListViewController alloc] initWithTitleArray:@[KKLiveStudioUserMgrTitleOnline, KKLiveStudioUserMgrTitleForbidWord]];
        popVC.viewModel = self.viewModel;
    }else {
        popVC = [[KKUserMgrListViewController alloc] initWithTitleArray:@[KKLiveStudioUserMgrTitleOnline]];
        popVC.viewModel = self.viewModel;

    }
    popVC.view.frame = self.view.bounds;
    [popVC setDisplayViewHeight:[ccui getRH:508]+HOME_INDICATOR_HEIGHT];
    popVC.groupIdStr = self.viewModel.groupIdStr;
    popVC.toPushConversationVCBlock = ^(KKGamePlayerCardInfoModel * _Nonnull model) {
        [weakSelf jumpToConversationVC:model];
    };
    //2.添加
    [self.view addSubview:popVC.view];
    [self addChildViewController:popVC];
    //3.show
    [popVC showSelf];
    [popVC beginLoadData];
}

/// 点击手势触发
- (void)tapGestureDidTrigger {
    [self.chatToolView stopInput];
}

#pragma mark - Jump
/// 跳转评价页
- (void)jumpToEvaluateController {
    KKGameWaitEvaluateController *vc = [[KKGameWaitEvaluateController alloc] init];
    vc.gameBoardIdStr = self.viewModel.gameBoardIdStr;
    vc.orderNoStr = self.viewModel.orderNoStr;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 跳转游戏结束页
- (void)jumpToGameOverVC {
    KKGameOrderDetailController *vc = [[KKGameOrderDetailController alloc] init];
    vc.orderNoStr = self.viewModel.orderNoStr;
    vc.gameBoardIdStr = self.viewModel.gameBoardIdStr;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 跳转到举报
- (void)jumpToReportVCWith:(NSString *_Nonnull)userId proId:(NSString *_Nonnull)proId {
    KKGameReportController *vc = [[KKGameReportController alloc]init];
    vc.userId = userId;
    vc.complaintObjectId = proId;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 跳转私聊
-(void)jumpToConversationVC:(KKGamePlayerCardInfoModel *)cardModel {
    //1.conversation
    KKConversation *conversation = [[KKConversation alloc] init];
    conversation.targetId = cardModel.targetUserId;
    conversation.head = cardModel.userLogoUrl;
    conversation.conversationType = KKConversationType_PRIVATE;
    conversation.conversationTitle = cardModel.nickName;
    
    //2.vc
    KKConversationController *vc = [[KKConversationController alloc] initWithConversation:conversation extra:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

/// 展示分享的微信二维码
- (void)jumpToShareWechatCodeImg:(NSString *)url {
    KKWeChatShareImageController *vc = [[KKWeChatShareImageController alloc] init];
    vc.imgUrl = url;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 跳去qq
- (BOOL)jumpToQQGroup:(NSString *)urlStr {
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    } else {
        return NO;
    }
}

/// 跳到自己
- (void)pushSelfByNavi:(UINavigationController *)navi {
        
    //1.移除别的房间
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:navi.viewControllers];
    NSMutableArray *deleteArr = [NSMutableArray arrayWithCapacity:newArr.count];
    for (UIViewController *vc in newArr) {
        if ([vc isMemberOfClass:[KKLiveStudioVC class]]) {
            [deleteArr addObject:vc];
        }else if ([vc isMemberOfClass:[KKVoiceRoomVC class]]) {
            [deleteArr addObject:vc];
        }
    }
    //移除
    [newArr removeObjectsInArray:deleteArr];
    
    //2.self在navi的栈中,就改变vcArr
    if ([newArr containsObject:self]) {
        [newArr removeObject:self];
        [newArr addObject:self];
        [navi setViewControllers:newArr animated:YES];
    }else{
        //3.不在, 直接push
        [navi pushViewController:self animated:YES];
    }
}

#pragma mark - Public
/// 尝试进入开黑房
- (void)joinGameRoomWithGameBoardId:(NSString *_Nullable)gameboardId
                            Success:(void(^_Nullable)(void))successBlock {
    [self.viewModel joinGameRoomWithGameBoardId:gameboardId Success:successBlock];
}
/// 退出开黑房
- (void)exitGameRoomWithSuccess:(void(^_Nullable)(void))successBlock {
    WS(weakSelf)
    [self.viewModel exitGameRoomWithSuccess:^{
        if (successBlock) {
            [weakSelf removeRtcConfig];
            successBlock();
        }
    }];
}

#pragma mark - Action
/// 开始刷新页面
- (void)beginRefreshInfoDatas {
    WS(weakSelf)
    [self.viewModel requestForAll:^{
        //1. 刷新UI
        [weakSelf reloadUI];
    }];
}

- (BOOL)isRoomOwner {
    return [[KKUserInfoMgr shareInstance].userId isEqualToString:self.viewModel.infoModel.gameBoardClientSimple.ownerUserId];
}

/// 刷新聊天室人数
- (void)reloadChatRoomPeople {
    
    //1.总人数
    NSInteger count = self.viewModel.totalOnlinePeopleCount;
    [self.studioOnlineUserView setUserCount:count];
    
    //2.更新头像
    //2.1 获取头像array
    NSInteger maxShowCount = 3;
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:3];
    for (NSInteger index = 0; index < count && index < maxShowCount; index ++) {
        KKChatRoomUserSimpleModel *onlineModel = self.viewModel.onlinePeopleArray[index];
        [mArr addObject:onlineModel.userLogoUrl];
    }
    //2.2 赋值
    [self.studioOnlineUserView setUserLogoUrlArray:mArr];
}

/// 刷新开黑房信息
- (void)reloadGameRoomUI {
    KKGameBoardClientSimpleModel *roomInfo = self.viewModel.infoModel.gameBoardClientSimple;
    [self.navBackBtn setTitle:[NSString stringWithFormat:@"ID:%ld", (long)roomInfo.gameRoomId] forState:UIControlStateNormal];
    self.playerLevelLabel.text = [NSString stringWithFormat:@"%@%@%@%@", @"大区", roomInfo.platformType.message, roomInfo.rank.message, @"段位"];
    self.playerNumberLabel.text = roomInfo.patternType.message;
    self.gameStateLabel.text = roomInfo.proceedStatus.message;
    self.chargeLabel.text = ([roomInfo.depositType.name isEqualToString:@"FREE_FOR_BOARD"] ? @"免费" : @"收费");
    self.rightGameLogoImageView.image = [KKGameRoomContrastModel shareInstance].rankImageMapDic[roomInfo.rank.name ?: @""];
}

- (void)reloadGamePrepareTool {
    if (self.viewModel.loginUserIsRoomOwner) {
        [self reloadGamePrepareToolForOwner];
    } else {
        [self reloadGamePrepareToolForPlayer];
    }
}

/// 房主端准备栏
- (void)reloadGamePrepareToolForOwner {
    
    [self setPrepareToolViewButtonUserEnable:YES duration:0];
    
    switch (self.viewModel.gameStatus) {
        case KKGameStatusPlayerEnter:
        {
            NSInteger depositPrice = self.viewModel.depositPrice;
            if (depositPrice > 0) {
                NSString *patternName = self.viewModel.infoModel.gameBoardClientSimple.patternType.name ?: @"";
                NSInteger playerNumber = [[KKGameRoomContrastModel shareInstance].patternMapDic[patternName] integerValue];
                NSInteger totalCharge = depositPrice * playerNumber;
                self.prepareToolView.titleString = [NSString stringWithFormat:@"本局收入%ldK币", (long)totalCharge];
                [self.prepareToolView setSubTitleString:[NSString stringWithFormat:@"%ldK币/人", (long)depositPrice] attriStr:nil];
            } else {
                self.prepareToolView.titleString = @"等待其他队友准备";
                [self.prepareToolView setSubTitleString:nil attriStr:nil];
            }
            
            [self.prepareToolView setTitle:@"解散" forState:UIControlStateNormal forButtonType:KKGamePrepareToolViewBtnTypeBorder];
            [self.prepareToolView setTitle:@"广播找人" forState:UIControlStateNormal forButtonType:KKGamePrepareToolViewBtnTypeNoBorder];
            self.prepareToolView.showBtnType = KKGamePrepareToolViewBtnTypeAll;
            
        }
            break;
        case KKGameStatusAllPlayerReadied:
        {
            NSInteger depositPrice = self.viewModel.depositPrice;
            if (depositPrice > 0) {
                NSString *patternName = self.viewModel.infoModel.gameBoardClientSimple.patternType.name ?: @"";
                NSInteger playerNumber = [[KKGameRoomContrastModel shareInstance].patternMapDic[patternName] integerValue];
                NSInteger totalCharge = depositPrice * playerNumber;
                self.prepareToolView.titleString = [NSString stringWithFormat:@"本局收入%ldK币", (long)totalCharge];
            } else {
                self.prepareToolView.titleString = @"全员已准备";
            }
            
            NSString *countDownName = self.viewModel.infoModel.gameBoardClientSimple.idStr;
            NSString *maxReadyTime = self.viewModel.infoModel.gameBoardClientSimple.maxGmtPay;
            NSTimeInterval alreadyTime = fabs([KKGameTimeConvertModel timeIntervalBetweenNowWithDateStr:maxReadyTime]);
            NSTimeInterval totalTime = self.viewModel.infoModel.autoDissolutionTimeConfig * 60.00;
            NSTimeInterval leftTime = totalTime - alreadyTime;
            leftTime = leftTime > 0 ? leftTime : 0;
            
            WS(weakSelf)
            [[KKCountDownManager standard] scheduledCountDownWithName:countDownName totalTime:leftTime create:YES countingDown:^(NSTimeInterval timerInterval) {
                
                NSString *leftTimeStr = [KKGameTimeConvertModel timeWithTimeInteval:timerInterval];
                NSString *subTitle = [NSString stringWithFormat:@"%@内未开始游戏，房间自动解散", leftTimeStr];
                [weakSelf.prepareToolView setSubTitleString:subTitle attriStr:leftTimeStr];
                
            } finished:^(NSTimeInterval timerInterval) {
                [weakSelf gameZoomCloseWithNeedAlert:NO];
            }];
            
            [self.prepareToolView setTitle:@"解散" forState:UIControlStateNormal forButtonType:KKGamePrepareToolViewBtnTypeBorder];
            [self.prepareToolView setTitle:@"立即开始" forState:UIControlStateNormal forButtonType:KKGamePrepareToolViewBtnTypeNoBorder];
            self.prepareToolView.showBtnType = KKGamePrepareToolViewBtnTypeAll;
        }
            break;
        case KKGameStatusInPlaying:
        {
            
            CGFloat minFinishTime = self.viewModel.infoModel.allowFinishTimeConfig * 60.00;
            NSString *startTime = self.viewModel.infoModel.gameBoardClientSimple.gmtBoardStart;
            NSTimeInterval alreadyTime = fabs([KKGameTimeConvertModel timeIntervalBetweenNowWithDateStr:startTime]);
            [self setPrepareToolViewButtonUserEnable:(alreadyTime >= minFinishTime) duration:(minFinishTime - alreadyTime)];
            
            self.prepareToolView.titleString = @"开始游戏啦";
            [self.prepareToolView setSubTitleString:@"点击进群，畅玩游戏" attriStr:nil];
            [self.prepareToolView setTitle:@"结束" forState:UIControlStateNormal forButtonType:KKGamePrepareToolViewBtnTypeBorder];
            [self.prepareToolView setTitle:@"进群" forState:UIControlStateNormal forButtonType:KKGamePrepareToolViewBtnTypeNoBorder];
            self.prepareToolView.showBtnType = KKGamePrepareToolViewBtnTypeAll;
        }
            break;
            
        default:
            self.prepareToolView.showBtnType = KKGamePrepareToolViewBtnTypeNone;
            break;
    }
}

/// 其他玩家的准备栏
- (void)reloadGamePrepareToolForPlayer {
    
    [self setPrepareToolViewButtonUserEnable:YES duration:0];
    
    switch (self.viewModel.gameStatus) {
        case KKGameStatusPlayerEnter:
        {
            if (self.viewModel.depositPrice > 0) {
                self.prepareToolView.titleString = @"请通过平台准备下单，任何非平台的交易行为将不受KK电竞安全保障";
            } else {
                self.prepareToolView.titleString = @"聊天内容禁止黄赌毒";
            }
            [self.prepareToolView setSubTitleString:nil attriStr:nil];
            self.prepareToolView.showBtnType = KKGamePrepareToolViewBtnTypeNone;
        }
            break;
        case KKGameStatusPlayerJoin:
        {
            self.prepareToolView.titleString = @"点击准备，等待游戏开始哦";
            if (self.viewModel.depositPrice > 0) {
                [self.prepareToolView setSubTitleString:[NSString stringWithFormat:@"%@%ld%@", @"将支付给房主", (long)self.viewModel.depositPrice, @"K币"] attriStr:nil];
            } else {
                [self.prepareToolView setSubTitleString:nil attriStr:nil];
            }
            [self.prepareToolView setTitle:@"离座" forState:UIControlStateNormal forButtonType:KKGamePrepareToolViewBtnTypeBorder];
            [self.prepareToolView setTitle:@"准备" forState:UIControlStateNormal forButtonType:KKGamePrepareToolViewBtnTypeNoBorder];
            self.prepareToolView.showBtnType = KKGamePrepareToolViewBtnTypeAll;
        }
            break;
        case KKGameStatusPlayerUnPay:
        {
            self.prepareToolView.titleString = [NSString stringWithFormat:@"点击支付，将支付给房主%ldK币", (long)self.viewModel.depositPrice];
            
            NSString *countDownName = [NSString stringWithFormat:@"%@", self.viewModel.orderNoStr];
            NSTimeInterval leftTime = [KKGameTimeConvertModel timeIntervalBetweenNowWithDateStr:self.viewModel.currentSimpleModel.gmtStopPay];
            leftTime = leftTime > 0 ? leftTime : 0;
            
            WS(weakSelf)
            [[KKCountDownManager standard] scheduledCountDownWithName:countDownName totalTime:leftTime create:YES countingDown:^(NSTimeInterval timerInterval) {
                
                NSString *leftTimeStr = [KKGameTimeConvertModel timeWithTimeInteval:timerInterval];
                NSString *subTitle = [NSString stringWithFormat:@"支付剩余时间：%@", leftTimeStr];
                [weakSelf.prepareToolView setSubTitleString:subTitle attriStr:leftTimeStr];
                
            } finished:^(NSTimeInterval timerInterval) {
                if (weakSelf.chargeToolView) {
                    [weakSelf.chargeToolView dismiss];
                }
                [weakSelf.viewModel requestForAll:^{
                    [weakSelf reloadUI];
                }];
            }];

            [self.prepareToolView setTitle:@"去支付" forState:UIControlStateNormal forButtonType:KKGamePrepareToolViewBtnTypeNoBorder];
            self.prepareToolView.showBtnType = KKGamePrepareToolViewBtnTypeNoBorder;
        }
            break;
        case KKGameStatusPlayerReadied:
        {
            if (self.viewModel.depositPrice > 0) {
                self.prepareToolView.titleString = @"支付完成";
                [self.prepareToolView setSubTitleString:@"耐心等待房主开始游戏" attriStr:nil];
            } else {
                self.prepareToolView.titleString = @"耐心等待房主开始游戏";
                [self.prepareToolView setSubTitleString:nil attriStr:nil];
            }
            [self.prepareToolView setTitle:@"离队" forState:UIControlStateNormal forButtonType:KKGamePrepareToolViewBtnTypeBorder];
            [self.prepareToolView setTitle:@"广播找人" forState:UIControlStateNormal forButtonType:KKGamePrepareToolViewBtnTypeNoBorder];
            self.prepareToolView.showBtnType = KKGamePrepareToolViewBtnTypeAll;
        }
            break;
        case KKGameStatusAllPlayerReadied:
        {
            self.prepareToolView.titleString = @"等待房主开始游戏";
            
            NSString *countDownName = self.viewModel.infoModel.gameBoardClientSimple.idStr;
            NSString *maxReadyTime = self.viewModel.infoModel.gameBoardClientSimple.maxGmtPay;
            NSTimeInterval alreadyTime = fabs([KKGameTimeConvertModel timeIntervalBetweenNowWithDateStr:maxReadyTime]);
            NSTimeInterval totalTime = self.viewModel.infoModel.autoDissolutionTimeConfig * 60.00;
            NSTimeInterval leftTime = totalTime - alreadyTime;
            leftTime = leftTime > 0 ? leftTime : 0;
            
            WS(weakSelf)
            [[KKCountDownManager standard] scheduledCountDownWithName:countDownName totalTime:leftTime create:YES countingDown:^(NSTimeInterval timerInterval) {
                
                NSString *leftTimeStr = [KKGameTimeConvertModel timeWithTimeInteval:timerInterval];
                NSString *subTitle = [NSString stringWithFormat:@"%@内未开始游戏，房间自动解散", leftTimeStr];
                [weakSelf.prepareToolView setSubTitleString:subTitle attriStr:leftTimeStr];
                
            } finished:^(NSTimeInterval timerInterval) {
                [weakSelf gameZoomCloseWithNeedAlert:NO];
            }];

            [self.prepareToolView setTitle:@"离队" forState:UIControlStateNormal forButtonType:KKGamePrepareToolViewBtnTypeBorder];
            self.prepareToolView.showBtnType = KKGamePrepareToolViewBtnTypeBorder;
        }
            break;
        case KKGameStatusInPlaying:
        {
            
            CGFloat minFinishTime = self.viewModel.infoModel.allowFinishTimeConfig * 60.00;
            NSString *startTime = self.viewModel.infoModel.gameBoardClientSimple.gmtBoardStart;
            NSTimeInterval alreadyTime = fabs([KKGameTimeConvertModel timeIntervalBetweenNowWithDateStr:startTime]);
            [self setPrepareToolViewButtonUserEnable:(alreadyTime >= minFinishTime) duration:(minFinishTime - alreadyTime)];
            
            self.prepareToolView.titleString = @"开始游戏啦";
            [self.prepareToolView setSubTitleString:@"点击进群，畅玩游戏" attriStr:nil];
            [self.prepareToolView setTitle:@"结束" forState:UIControlStateNormal forButtonType:KKGamePrepareToolViewBtnTypeBorder];
            [self.prepareToolView setTitle:@"进群" forState:UIControlStateNormal forButtonType:KKGamePrepareToolViewBtnTypeNoBorder];
            self.prepareToolView.showBtnType = KKGamePrepareToolViewBtnTypeAll;
        }
            break;
            
        default:
            self.prepareToolView.showBtnType = KKGamePrepareToolViewBtnTypeNone;
            break;
    }
}

/// 展示玩家卡片
- (void)showPlayerCardWithModel:(KKGamePlayerCardInfoModel *)cardModel user:(KKGameBoardDetailSimpleModel *)simpleModel {
    WS(weakSelf)
    NSString *gameNumberStr = [NSString stringWithFormat:@"%@", cardModel.gameBoardCount ?: @"0"];
    if ([cardModel.gameBoardCount integerValue] > kk_player_max_game_count) {
        gameNumberStr = [NSString stringWithFormat:@"%ld+", (long)kk_player_max_game_count];
    }
    
    NSString *gameTogetherNumberStr = [NSString stringWithFormat:@"%@", (cardModel.countWithTargetUser ?: @"0")];
    if ([cardModel.countWithTargetUser integerValue] > kk_player_max_game_time) {
        gameTogetherNumberStr = [NSString stringWithFormat:@"%ld+", (long)kk_player_max_game_time];
    }
    
    NSString *highPriseStr = [NSString stringWithFormat:@"%@", (cardModel.evaluationCountWithTargetUser ?: @"0")];
    if ([cardModel.evaluationCountWithTargetUser integerValue] > kk_player_max_game_time) {
        highPriseStr = [NSString stringWithFormat:@"%ld+", (long)kk_player_max_game_time];
    }
    
    // 是否为好友
    BOOL isFriend = cardModel.isFriend;

    KKPlayerGameCardView *cardView = nil;
    // 自己的名片不做修改
    if ([[KKUserInfoMgr shareInstance].userId isEqualToString:simpleModel.userId]) { // 自己的名片
        cardView = [[KKPlayerGameCardView alloc] initWithButtonType:KKPlayerGameCardViewBtnTypeNone needTeamTitle:NO];
        [cardView setLeftUpBtnHidden:YES];
    } else if (!self.viewModel.loginUserIsRoomOwner) { // 非房主
        //1.观众点击房主
        cardView = [[KKPlayerGameCardView alloc] initWithButtonType:KKPlayerGameCardViewBtnTypeHorizontal needTeamTitle:YES];
        //2.加好友/聊一聊
        CC_Button *chatButtton = [CC_Button buttonWithType:UIButtonTypeCustom];
        [chatButtton setTitle:(isFriend ? @"聊一聊" : @"加好友") forState:UIControlStateNormal];
        [chatButtton setTitleColor:KKES_COLOR_MAIN_YELLOW forState:UIControlStateNormal];
        [chatButtton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            if (isFriend) {
                //1.跳转私聊页面
                [weakSelf jumpToConversationVC:cardModel];
                [cardView dismissWithAnimated:YES];

            } else {
                //2.加好友
                [weakSelf.viewModel requestForAddFriendWith:simpleModel.userId];
                [cardView dismissWithAnimated:YES];
            }
        }];
        //3.添加button数组
        cardView.buttonItems = @[chatButtton];
    } else {
        if (self.viewModel.gameStatus == KKGameStatusInPlaying) { // 游戏中,不能移除开黑房
            cardView = [[KKPlayerGameCardView alloc] initWithButtonType:KKPlayerGameCardViewBtnTypeAll needTeamTitle:YES];
        } else {
        
            //1.房主点击组队中队员头像
            cardView = [[KKPlayerGameCardView alloc] initWithButtonType:KKPlayerGameCardViewBtnTypeHorizontal needTeamTitle:YES];
            //2.加好友/聊一聊
            CC_Button *chatButtton = [CC_Button buttonWithType:UIButtonTypeCustom];
            [chatButtton setTitle:(isFriend ? @"聊一聊" : @"加好友") forState:UIControlStateNormal];
            [chatButtton setTitleColor:KKES_COLOR_MAIN_YELLOW forState:UIControlStateNormal];
            [chatButtton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
                if (isFriend) {
                    //1.跳转私聊页面
                    [weakSelf jumpToConversationVC:cardModel];
                    [cardView dismissWithAnimated:YES];

                } else {
                    //2.加好友
                    [weakSelf.viewModel requestForAddFriendWith:simpleModel.userId];
                    [cardView dismissWithAnimated:YES];

                }
            }];
            //3.请离队
            CC_Button *pleaseLeaveButtton = [CC_Button buttonWithType:UIButtonTypeCustom];
            [pleaseLeaveButtton setTitle:@"请离队" forState:UIControlStateNormal];
            [pleaseLeaveButtton setTitleColor:KKES_COLOR_BLACK_TEXT forState:UIControlStateNormal];
            [pleaseLeaveButtton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
                [cardView dismissWithAnimated:YES];
                weakSelf.viewModel.targetRemoveSimpleModel = simpleModel;
                [weakSelf.viewModel requestPleaseLeavcTeamWithUserId:simpleModel.userId success:^{
                    //3.1之后刷新UI
                    [weakSelf reloadUI];
                } fail:^{ }];
            }];
            //4.移除房间
            CC_Button *removeMemberButton = [CC_Button buttonWithType:UIButtonTypeCustom];
            [removeMemberButton setTitle:@"移出房间" forState:UIControlStateNormal];
            [removeMemberButton setTitleColor:KKES_COLOR_BLACK_TEXT forState:UIControlStateNormal];
            [removeMemberButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
                [cardView dismissWithAnimated:YES];
                weakSelf.viewModel.targetRemoveSimpleModel = simpleModel;
                NSString *content = [NSString stringWithFormat:@"请离后，如支付K币将退回，该用户%.0lf分钟内不能进入该开黑房", weakSelf.viewModel.kiperLimitTime];
                [weakSelf showAlertViewWithTitle:@"确定请TA离开么" subTitle:content cancel:@"取消" confirm:@"确定" tag:kk_cat_pop_tag_remove_room];
            }];
            BOOL isForbindden = cardModel.forbidden;
            //5.禁言
            CC_Button *noSpeakButton = [CC_Button buttonWithType:UIButtonTypeCustom];
            [noSpeakButton setTitle:(isForbindden ? @"解禁言" : @"禁言") forState:UIControlStateNormal];
            [noSpeakButton setTitleColor:KKES_COLOR_BLACK_TEXT forState:UIControlStateNormal];
            [noSpeakButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
                [cardView dismissWithAnimated:YES];
                if (isForbindden) {
                    [weakSelf.viewModel requestGameBoardUserNoForbiddenWithUserId:simpleModel.userId gameBoardRoomId:self.viewModel.gameRoomId Success:^{
                        
                    }];
                }else{
                    [weakSelf.viewModel requestGameBoardUserForbiddenWithUserId:simpleModel.userId gameBoardRoomId:self.viewModel.gameRoomId Success:^{
                        
                    }];
                }
            }];
            cardView.buttonItems = @[chatButtton, pleaseLeaveButtton, removeMemberButton, noSpeakButton];
        }
    }
    
    [cardView setLeftUpBtnTitle:@"举报" forState:UIControlStateNormal];
    [cardView setLeftUpBtnTitleColor:KKES_COLOR_HEX(0x999999) forState:UIControlStateNormal];
    [cardView setNickTitle:cardModel.nickName];
    [cardView setGameNameTitle:@"王者荣耀开黑"];
    [cardView setGameNumbersColor:KKES_COLOR_HEX(0xECC165)];
    [cardView setGameNumbersTitle:gameNumberStr unitTitle:@"局"];
    [cardView setGameTogetherTitle:@"我和他组队"];
    [cardView setGameTogetherNumbersTitle:[NSString stringWithFormat:@"%@次", gameTogetherNumberStr]];
    [cardView setHighPraiseTitle:[NSString stringWithFormat:@"%@次好评", highPriseStr]];
    [cardView.iconImgView sd_setImageWithURL:[NSURL URLWithString:cardModel.userLogoUrl] placeholderImage:Img(@"game_absent")];
    
    // 玩家标签
    NSMutableArray<KKPlayerLabelViewModel *> *labelModels = [NSMutableArray array];
    
    // 勋章
    for (KKPlayerMedalDetailModel *medalModel in cardModel.userMedalDetailList) {
        NSString *imgName = [[KKGameRoomContrastModel shareInstance].medalMapDic objectForKey:medalModel.currentMedalLevelConfigCode];
        if (imgName) {
            KKPlayerLabelViewModel *labelModel = [KKPlayerLabelViewModel createWithType:KKPlayerLabelViewModelTypeBigImage bgColors:nil img:Img(imgName) labelStr:nil];
            [labelModels addObject:labelModel];
        }
    }
    
    // 性别年龄
    NSArray *bgColors = @[KKES_COLOR_HEX(0x17B5FF), KKES_COLOR_HEX(0x21C3EC)];
    if ([cardModel.sex.name isEqualToString:@"F"]) {
        bgColors = @[KKES_COLOR_HEX(0xFF64AA)];
    }
    UIImage *sexImg = [KKGameRoomContrastModel shareInstance].cardSexMapDic[cardModel.sex.name ?: @""];
    NSString *ageStr = nil;
    if (cardModel.age && [cardModel.age integerValue] >= 0) {
        ageStr = [NSString stringWithFormat:@"%@", cardModel.age];
    }
    
    KKPlayerLabelViewModel *labelModel = [KKPlayerLabelViewModel createWithType:KKPlayerLabelViewModelTypeIconImage bgColors:bgColors img:sexImg labelStr:ageStr];
    
    [labelModels addObject:labelModel];
    [cardView setPlayerLabels:[labelModels copy]];
    [cardView showIn:self.view animated:YES];
    
    // 点击回调
    __weak __typeof(cardView) weakCardView = cardView;
    cardView.tapBlock = ^(KKPlayerGameCardViewTapType tapType) {
        
        if (tapType == KKPlayerGameCardViewTapTypeBackground ||
            tapType == KKPlayerGameCardViewTapTypeRightUp) {
            [weakCardView dismissWithAnimated:YES];
            
        } else if (tapType == KKPlayerGameCardViewTapTypeLeftUp) {
            // 举报
            [weakCardView dismissWithAnimated:YES];
            [weakSelf jumpToReportVCWith:simpleModel.userId proId:simpleModel.profilesId];
            
        } else if (tapType == KKPlayerGameCardViewTapTypeNoBorder) {
            [weakCardView dismissWithAnimated:YES];
            if (isFriend) { // 跳转私聊页面
                [weakSelf jumpToConversationVC:cardModel];
            } else { // 加好友
                [weakSelf.viewModel requestForAddFriendWith:simpleModel.userId];
            }
            
        } else if (tapType == KKPlayerGameCardViewTapTypeBorder) { // 移除开黑房
            [weakCardView dismissWithAnimated:YES];
            weakSelf.viewModel.targetRemoveSimpleModel = simpleModel;
            NSString *content = [NSString stringWithFormat:@"请离后，如支付K币将退回，该用户%.0lf分钟内不能进入该开黑房", weakSelf.viewModel.kiperLimitTime];
            [weakSelf showAlertViewWithTitle:@"确定请TA离开么" subTitle:content cancel:@"取消" confirm:@"确定" tag:kk_cat_pop_tag_remove_room];
        }
    };
}

/// 展示底部充值窗口
- (void)showChargeToolViewWithBalance:(NSNumber *)balance {
    
    if (self.chargeToolView) {
        [self.chargeToolView dismiss];
    }
    
    CGFloat safeHeight = 0;
    if (@available(iOS 11.0, *)) {
        safeHeight = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    }
    KKGameChargeToolView *toolView = [[KKGameChargeToolView alloc] initWithSafeBottom:safeHeight];
    [toolView setNickNameString:self.viewModel.roomOwnerSimpleModel.userName];
    [toolView setBalanceCoinString:[NSString stringWithFormat:@"%@", balance ?: @"0"] unit:@"K币"];
    [toolView setChargeToGameRoomOwner:[NSString stringWithFormat:@"%ld", (long)self.viewModel.depositPrice] unit:@"K币"];
    NSString *iconUrlStr = self.viewModel.roomOwnerSimpleModel.userHeaderImgUrl;
    [toolView.iconImgView sd_setImageWithURL:[NSURL URLWithString:iconUrlStr]];
    
    WS(weakSelf)
    toolView.tapBlock = ^(KKGameChargeToolViewTapType tapType) {
        if (tapType == KKGameChargeToolViewTapTypeCertain) {
            [weakSelf.viewModel requestForPayOrderNo:^{
                [weakSelf reloadUI];
            }];
        }
    };
    
    [toolView showIn:self.view];
    self.chargeToolView = toolView;
}

/// 展示弹窗
- (void)showAlertViewWithTitle:(NSString *)title subTitle:(NSString *)subTitle cancel:(NSString *)cancelTitle confirm:(NSString *)confirmTitle tag:(NSInteger)tag {
    
    CatDefaultPop *pop = nil;
    if (!cancelTitle) {
        pop = [[CatDefaultPop alloc] initWithTitle:title content:subTitle confirmTitle:confirmTitle];
    } else {
        pop = [[CatDefaultPop alloc] initWithTitle:title content:subTitle cancelTitle:cancelTitle confirmTitle:confirmTitle];
    }
    pop.delegate = self;
    self.catPop = pop;
    [pop popUpCatDefaultPopView];
    pop.popView.tag = tag;
    pop.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    [pop updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
}

/// 设置准备栏按钮可否交互
- (void)setPrepareToolViewButtonUserEnable:(BOOL)enable duration:(NSTimeInterval)duration {
    if (enable) {
        [self.prepareToolView setButtonEnable:YES forButtonType:KKGamePrepareToolViewBtnTypeBorder];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resumePrepareToolViewButtonUserEnable) object:nil];
    } else {
        [self.prepareToolView setButtonEnable:NO forButtonType:KKGamePrepareToolViewBtnTypeBorder];
        [self performSelector:@selector(resumePrepareToolViewButtonUserEnable) withObject:nil afterDelay:duration];
    }
}

/// 恢复交互
- (void)resumePrepareToolViewButtonUserEnable {
    [self.prepareToolView setButtonEnable:YES forButtonType:KKGamePrepareToolViewBtnTypeBorder];
}

/// 退出聊天室
- (void)leaveIMChatListSuccess:(void(^)(void))successBlock {
    
    // 发送房间解散通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GAME_ROOM_HAS_DISSOLVE_NOTIFICATION" object:nil userInfo:nil];
    
    if (successBlock) {
        successBlock();
    } else {
        self.viewModel.isCloseGameRoom = YES;
        
        // 当前控制器未返回
        if (self.navigationController || self.presentingViewController) {
            [self p_clickNavBackButton];
            
        // 当前控制器已返回, didMoveToParentViewController: 已不能调用, 故这里直接数据赋空
        } else {
            self.viewModel.isCloseGameRoom = NO;
            [KKFloatViewMgr shareInstance].gameRoomModel = nil;
            [KKFloatViewMgr shareInstance].type = KKFloatViewTypeUnknow;
        }
    }
    
    /*
    WS(weakSelf)
    
    [self.conversationController quitChatRoomSuccess:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (successBlock) {
                successBlock();
            } else {
                weakSelf.viewModel.isCloseGameRoom = YES;
                if (weakSelf.navigationController || weakSelf.presentingViewController) {
                    [weakSelf p_clickNavBackButton];
                } else {
                    weakSelf.viewModel.isCloseGameRoom = NO;
                    [KKFloatViewMgr shareInstance].gameRoomModel = nil;
                    [KKFloatViewMgr shareInstance].type = KKFloatViewTypeUnknow;
                }
            }
        });
        
    } error:^(RCErrorCode status) {
        [CC_Notice show:@"退出聊天室失败" atView:weakSelf.view];
    }];
     */
}

#pragma mark - request
- (void)requestForbiddenStatus {
    WS(weakSelf)
    //1. 禁言状态查询
    [self.viewModel requestForbiddenStatusWithUserId:[KKUserInfoMgr shareInstance].userId groupId:self.viewModel.infoModel.groupId success:^(NSInteger status) {
        weakSelf.isForbidWord = status;
    }];
}


#pragma mark - Notification
/// 禁言/解禁通知 自定义消息
- (void)didReceiveForbiddenNotification:(NSNotification *)notification {
    
    NSString *targetId = [notification.userInfo objectForKey:@"targetId"];
    NSString *contentType = [notification.userInfo objectForKey:@"changeType"];
    NSString *changeUserId = [notification.userInfo objectForKey:@"changeUserId"];
    
    //0.过滤非本房间的消息
    if (![targetId isEqualToString:self.conversationController.targetId]) {
        return;
    }
    
    WS(weakSelf)
    if ([contentType isEqualToString:@"CANCEL_FORBID"]) {
        [self requestForbiddenStatus];
    }else if ([contentType isEqualToString:@"FORBID_CHAT"]){
        [self requestForbiddenStatus];
    }else if ([contentType isEqualToString:@"KICK"]){
        if ([changeUserId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
            [CC_Notice show:@"你被踢出开黑房"];
            [self.viewModel requestForLeaveGameChatRoomSuccess:^{
                [weakSelf leaveIMChatListSuccess:nil];
            }];
        }
    }
}


/// 房间状态变更通知
- (void)didReceiveGameRoomStatusChangeNotification:(NSNotification *)notification {
    NSString *contentName = [notification.userInfo objectForKey:@"content"];
    WS(weakSelf)
    
    if ([contentName isEqualToString:@"GAME_BOARD_DISSOLVE"]) { // 解散房间
        dispatch_async(dispatch_get_main_queue(), ^{
            [CC_Notice show:@"房间已解散"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GAME_ROOM_DISSOLVE object:nil];
            [weakSelf leaveIMChatListSuccess:nil];
        });
        
        
    } else if ([contentName isEqualToString:@"GAME_BOARD_EVALUATE"]) { // 游戏结束
        dispatch_async(dispatch_get_main_queue(), ^{
            [CC_Notice show:@"本局游戏已结束"];
            if (weakSelf.viewModel.loginUserIsInGame) {
                [weakSelf jumpToEvaluateController];
            }
            [weakSelf.viewModel requestForAll:^{
                [weakSelf reloadUI];
            }];
        });
        
    } else if ([contentName containsString:@"GAME_BOARD_KICKPLAYER"]) { // 踢人
        NSString *beKickedUserId = [[contentName componentsSeparatedByString:@","] lastObject];
        if ([beKickedUserId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
            [CC_Notice show:@"你被踢出开黑房"];
            [self.viewModel requestForLeaveGameChatRoomSuccess:^{
                [weakSelf leaveIMChatListSuccess:nil];
            }];
        }
        
    } else if ([contentName containsString:@"GAME_BOARD_CANCELSEAT"] ||
               [contentName containsString:@"GAME_BOARD_PURCHASE_CANCEL"]) { // 离座&取消订单
        if (self.viewModel.loginUserIsInGame) {
            [self.viewModel requestForIsInChatRoom:^(BOOL isInCurrentChatRoom) {
                // 占座玩家只是取消了占座
                // 离座 , 下车, 离开座位
                // 只关闭麦克风, 不关闭听筒, 变为观众.
                if (isInCurrentChatRoom) {
                    [weakSelf.viewModel requestForAll:^{
                        weakSelf.isMicOpen = NO;
                        [weakSelf reloadUI];
                    }];
                } else {
                    // 占座玩家退出了聊天室, 这种情况是用户手动点击了关闭按钮,所以这里不再做退出操作了
                }
            }];
        } else {
            [self.viewModel requestForAll:^{
                [weakSelf reloadUI];
            }];
        }
    } else if ([contentName containsString:@"GAME_BOARD_PURCHASE_FAILSOLD"]) { // 流标
        [weakSelf leaveIMChatListSuccess:nil];
        
    } else { // 其他状态一律刷新页面
        [self.viewModel requestForAll:^{
            [weakSelf reloadUI];
        }];
    }
}

/// 解散房间通知
- (void)didReceiveGameRoomDissolveNotification:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [CC_Notice show:@"房间已解散"];
        [self leaveIMChatListSuccess:nil];
    });
}

/// 段位不符通知
- (void)didReceiveProfileNotConfirmNotification:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showAlertViewWithTitle:@"提示" subTitle:@"开黑房与当前段位不符合，你已退出开黑房！" cancel:nil confirm:@"确认" tag:kk_cat_pop_tag_exit_room];
    });
}

#pragma mark - CatDefaultPopDelegate
//取消
- (void)catDefaultPopCancel:(CatDefaultPop*)defualtPop {
    self.catPop = nil;
}
    
//确认
- (void)catDefaultPopConfirm:(CatDefaultPop*)defualtPop {
    WS(weakSelf)
    if (defualtPop.popView.tag == kk_cat_pop_tag_remove_room) {
        [self.viewModel requestForRemoveFromGameRoomWithUserId:self.viewModel.targetRemoveSimpleModel.userId gameBoardId:self.gameBoardIdStr successsuccessBlock:^{
            [weakSelf reloadUI];
        }];
        
    } else if (defualtPop.popView.tag == kk_cat_pop_tag_dissolve_room) {
        [self.viewModel requestForDissolveGameRoomSuccess:^{
            [CC_Notice show:@"解散成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GAME_ROOM_DISSOLVE object:nil];
            [weakSelf leaveIMChatListSuccess:nil];
        }];
    } else if (defualtPop.popView.tag == kk_cat_pop_tag_exit_room) {
        [self.viewModel exitGameRoomWithSuccess:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GAME_ROOM_DISSOLVE object:nil];
            weakSelf.viewModel.isCloseGameRoom = YES;
            [weakSelf p_clickNavBackButton];
            [weakSelf remove];
            [weakSelf removeRtcConfig];
        }];
    }
    self.catPop = nil;
}

#pragma mark - KKGameScrollViewDelegate
/// 点击了子view
- (void)scrollView:(KKGameScrollView *_Nonnull)scrollView didTouchOtherView:(UIView *_Nonnull)view {
    if ([view isKindOfClass:[UIButton class]]) {
        return;
    }
    [self.chatToolView stopInput];
}

#pragma mark KKVoiceRoomInputViewDelegate
-(void)inputView:(KKVoiceRoomInputView *)inputView didClickShare:(UIButton *)button {
    KKShareWQDView *shareV = [[KKShareWQDView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, RH(183))];
    [shareV showPopView];
    WS(weakSelf)
    KKGameRoomInfoModel *infoModel = self.viewModel.infoModel;
    shareV.tapShareKKBlock = ^{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"邀请你进入开黑房" forKey:@"title"];
        [dic setValue:infoModel.gameBoardClientSimple.title forKey:@"subheading"];
        [dic setValue:weakSelf.viewModel.gameBoardIdStr forKey:@"gameBoradId"];
        [dic setValue:infoModel.userLogoUrl forKey:@"ownerUserHeaderImgUrl"];
        [dic setValue:[KKUserInfoMgr shareInstance].userId forKey:@"shareUserId"];

        KKContactsController *vc = [[KKContactsController alloc] initWithType:KKContactsControllerTypeGameRoom extra:dic];
        vc.gameLinkedDidTippedBlock = ^(KKConversation * _Nullable conversation, NSString * _Nullable extra) {
            KKConversationController *controller = [[KKConversationController alloc] initWithConversation:conversation extra:extra];
            controller.view.backgroundColor = [UIColor whiteColor];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [CC_Notice showNoticeStr:@"分享成功" atView:self.view delay:2];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    shareV.tapShareQQBlock = ^{
        [KKShareTool configJShareWithPlatform:JSHAREPlatformQQ title:@"开黑房邀请" text:@"快进开黑房和我一起战斗吧！" url:weakSelf.viewModel.shareURL type:RoomType];
    };
    shareV.tapShareWXBlock = ^{
        [KKShareTool configJShareWithPlatform:JSHAREPlatformWechatSession title:@"开黑房邀请" text:@"快进开黑房和我一起战斗吧！" url:weakSelf.viewModel.shareURL type:RoomType];
        
    };
}

- (void)inputView:(KKVoiceRoomInputView *)inputView openSpeaker:(BOOL)isOpen {
    //1. 是否关闭声音
    self.isVoiceOpen = isOpen;
    //2. notice
    NSString *noticeStr = isOpen ? @"已取消静音" : @"静音中";
    [CC_Notice show:noticeStr atView:self.view];
    //3. 改变按钮状态
    inputView.speakerButton.selected = isOpen;
}

- (void)inputView:(KKVoiceRoomInputView *)inputView openMic:(BOOL)isOpen {
    //1.1 是否关闭麦克风
    self.isMicOpen = isOpen;
    //1.2 notice
    NSString *noticeStr = isOpen ? @"麦克风已打开" : @"麦克风关闭";
    [CC_Notice show:noticeStr atView:self.view];
    //1.3 改变按钮状态
    inputView.micButton.selected = isOpen;
}

- (void)inputView:(KKVoiceRoomInputView *)inputView tryToSendText:(NSString *)text {
    [self.chatToolView stopInput];
    //1.过滤
    //输入超量
    if (text.length > 50) {
        [CC_Notice show:@"最多可输入50个字" atView:self.view];
        return;
    }
    
    //退出键盘
    [self.inputView stopInput];
    
    //没输入
    if (text.length < 1) {
        return;
    }
    
    //被禁言
    if (self.isForbidWord) {
        [CC_Notice show:@"你已被禁言" atView:self.view];
        return;
    }
    
    
    //2.发送文字
    WS(weakSelf);
    __weak __typeof(&*inputView)weakInputView = inputView;
    [self.conversationController sendTextMsg:text success:^(long messageId) {
        [weakInputView clearInputText];
        
    } error:^(RCErrorCode nErrorCode, long messageId) {
        dispatch_main_async_safe(^{
            [CC_Notice show:@"消息发送失败" atView:weakSelf.view];
        });
    }];
}

#pragma mark KKChatRoomTableVCDelegate
- (void)chatRoomWillBeginDragging:(KKChatRoomTableVC *)chatRoomTableVC {
    [self.inputView stopInput];//退出键盘
}

- (void)chatRoom:(KKChatRoomTableVC *)chatRoomTableVC didSelectMsg:(KKChatRoomMessage *)msg {
    [self.inputView stopInput];//退出键盘
    
    NSString *senderId = msg.rcMsg.senderUserId;
    _didSelectedChatCellUserId = msg.rcMsg.senderUserId;
    [self showPlayerCard:senderId];
}

- (void)showPlayerCard:(NSString *)userId {
    NSString *roomId = [NSString stringWithFormat:@"%ld",self.gameRoomId];
    /// 当前点击的用户是不是在组队中队伍中
    BOOL isGame = NO;
    for (int i = 0; i < self.viewModel.infoModel.gameBoardDetailSimpleList.count; i ++) {
        KKGameBoardDetailSimpleModel *model = self.viewModel.infoModel.gameBoardDetailSimpleList[i];
        if (model.userId && [model.userId isEqualToString:userId]) {
            isGame = YES;
            break;
        }
    }
    if (self.viewModel.loginUserIsRoomOwner) {
        
        if (isGame) {
           
            [self showAlertWithIsOwer:YES isOnGame:YES userId:userId roomId:roomId];

        }else {
            
            [self showAlertWithIsOwer:YES isOnGame:NO userId:userId roomId:roomId];
        }
        
    }else{

        [self showAlertWithIsOwer:NO isOnGame:NO userId:userId roomId:roomId];
    }
}

- (void)showAlertWithIsOwer:(BOOL)isOwner isOnGame:(BOOL)isOnGame userId:(NSString *)userId roomId:(NSString *)roomId {
    BOOL game;
    BOOL own;
    if (isOnGame) {
        game = YES;
    }else {
        game = NO;
        
    }
    if (isOwner == NO) {
        own = NO;
    }else {
        own = YES;
    }
        
    [[KKPlayerGameCardTool shareInstance] showUserInfo:userId roomId:roomId needKick:own isHostCheck:own isForGame:YES isOn:game delegate:self];
}

#pragma mark - KKPlayerGameCardToolDelagate
- (void)playerGameCardTool:(KKPlayerGameCardTool *)tool handleMsg:(NSString *)msg targetUserId:(nonnull NSString *)targetUserId{
    WS(weakSelf)
    if ([msg isEqualToString:@"移出房间"]) {
        [self.viewModel requestForRemoveFromGameRoomWithUserId:_didSelectedChatCellUserId gameBoardId:self.gameBoardIdStr successsuccessBlock:^{
            [weakSelf reloadUI];
        }];
        
        return;
    }
    
    if ([msg isEqualToString:@"请离队"]) {
        [self.viewModel requestPleaseLeavcTeamWithUserId:_didSelectedChatCellUserId success:^{
            [weakSelf reloadUI];
        } fail:^{ }];
        return;
    }
    
    if ([msg isEqualToString:@"禁言"]) {
        [weakSelf.viewModel requestGameBoardUserForbiddenWithUserId:_didSelectedChatCellUserId gameBoardRoomId:self.viewModel.gameRoomId Success:^{ }];
        return;
    }
    
    if ([msg isEqualToString:@"解禁"]) {
        [weakSelf.viewModel requestGameBoardUserForbiddenWithUserId:_didSelectedChatCellUserId gameBoardRoomId:self.viewModel.gameRoomId Success:^{ }];
        return;
    }
}
    

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.gamePlayerNumbers;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KKPlayerCardCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KKPlayerCardCollectionCell class]) forIndexPath:indexPath];
    cell.forceHiddenJoinBtn = (self.viewModel.gameStatus == KKGameStatusInPlaying);
    //1. 人数是否已经满
    cell.reachMaxPlayers = self.viewModel.reachMaxPlayers;
    //2. 当前登录用户是否已经在玩家列表
    cell.loginUserIsInGame = self.viewModel.loginUserIsInGame;
    //3. 当前用户是否已经准备
    cell.loginUserIsPrepare = [self.viewModel.currentSimpleModel.userProceedStatus.name isEqualToString:@"PREPARE"];
    //4. 是否是房主
    cell.loginUserIsRoomOwner = self.viewModel.loginUserIsRoomOwner;
    //5. 用户模型
    KKGameBoardDetailSimpleModel *cellModel = self.viewModel.infoModel.gameBoardDetailSimpleList[indexPath.item];
    cell.dataModel = cellModel;
    WS(weakSelf)
    //6. 上车, 成功之后发布音频流
    cell.tapPrepareBlock = ^(KKGameBoardDetailSimpleModel * _Nonnull simpleModel, KKPlayerCardUserActionStatus actionStatus) {
        [weakSelf.viewModel requestForOccupySeat:simpleModel status:actionStatus success:^{
            //1. 打开麦克风
            self.isMicOpen = YES;
            [weakSelf reloadUI];
            
        }];
    };
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    WS(weakSelf)
    [self.viewModel requestForPlayerHeaderIconWith:indexPath showCardBlock:^(NSDictionary * _Nonnull responseDic) {
        KKGamePlayerCardInfoModel *cardInfoModel = [KKGamePlayerCardInfoModel mj_objectWithKeyValues:responseDic];
        KKGameBoardDetailSimpleModel *simpleModel = nil;
        if (indexPath.item < weakSelf.viewModel.infoModel.gameBoardDetailSimpleList.count) {
            simpleModel = weakSelf.viewModel.infoModel.gameBoardDetailSimpleList[indexPath.item];
        }
        //1. simpleModel 当前cell的用户模型
        [weakSelf showPlayerCardWithModel:cardInfoModel user:simpleModel];
    }];
}

#pragma mark - 开黑房语音相关
/// 刷新整个页面UI
- (void)reloadUI {
    WS(weakSelf)
    [self.viewModel requestForShareUrl];
    [self.viewModel requestForChatRoomOnlinePeople:^{
        [weakSelf reloadChatRoomPeople];
    }];
    [self.viewModel checkCancelCountDownEnable:NO];
    [self reloadGameRoomUI];
    [self reloadGamePrepareTool];
    [self.playerListView reloadData];
    
    [self.backgroundScrollView.mj_header endRefreshing];
    //1. 第一次加载麦位
    [self updateMicP:self.viewModel.onCarPeopleArray];
    //2. 禁言状态查询
    [self requestForbiddenStatus];
    //3. 是否是麦位用户, 是则显示麦克风按钮
    BOOL isMicUserNow = [self checkIsMicUser:[KKUserInfoMgr shareInstance].userId];
    //3.1 改变rightToolButtons
    if (isMicUserNow) {
        self.chatToolView.rightToolButtons = @[KKInputViewToolButtonSpeaker, KKInputViewToolButtonMic,KKInputViewToolButtonShare];
    }else{
        self.chatToolView.rightToolButtons = @[KKInputViewToolButtonSpeaker,KKInputViewToolButtonShare];
    }
    self.chatToolView.speakerButton.selected = self.isVoiceOpen;
    self.chatToolView.micButton.selected = self.isMicOpen;
    //4.
    [self setGameModel:self.viewModel];
    //5.
    self.conversationController.targetId = self.viewModel.groupIdStr;
}

/// 检查是不是麦位用户
- (BOOL)checkIsMicUser:(NSString *)userId {
    //1.过滤空
    if (userId.length < 1) {
        return NO;
    }
    
    //2.遍历查询
    for (KKGameBoardDetailSimpleModel *model in self.currentMicPArray) {
        if ([userId isEqualToString:model.userId]) {
            return YES;
        }
    }
    
    //3.没查到
    return NO;
}

/** 配置Rtc */
- (void)configRtc {
    [[KKRtcService shareInstance] setMuteAllVoice:NO];
    [[KKRtcService shareInstance] setMicrophoneDisable:NO];
    [[KKRtcService shareInstance] setRTCRoomDelegate:self];
    [[KKRtcService shareInstance] setRTCEngineDelegate:self];
}

/** 移除Rtc */
- (void)removeRtcConfig {
    //1.关闭麦克风,声音
    [[KKRtcService shareInstance] setMuteAllVoice:YES];
    [[KKRtcService shareInstance] setMicrophoneDisable:YES];
    //2.取消发布
    [[KKRtcService shareInstance] unpublishCurrentUserAudioStream];
    //3.取消订阅
    [self unsubscribeRemoteAudioStream:self.currentMicPArray];
    //4.数组清空
    self.currentMicPArray = nil;
}

- (void)requestLeaveRtcRoomByLoginElse:(void (^)(void))success {
    
    //1.离开rtc
    [[KKRtcService shareInstance] leaveRoom:self.viewModel.channelId success:^{
        
        if (success) {
            success();
        }
    } error:^(RongRTCCode code) {
        dispatch_main_async_safe(^{
            [CC_Notice show:@"退出语音房失败！"];
        });
    }];
    
    //2.移除rtc配置
    [self removeRtcConfig];
}

#pragma mark 麦位管理
-(void)updateMicP:(NSArray <KKGameBoardDetailSimpleModel *>*)newMicPArray {
    //1.第一次加载
    if (!self.currentMicPArray) {
        //1.1 赋值
        self.currentMicPArray = newMicPArray;
        //1.3 更新rtc
        //新上麦, 发布音频流
        [self publishAudioStream:newMicPArray];
        //新上麦, 订阅
        [self subscribeRemoteAudioStream:newMicPArray];
        return;
    }
    
    //2.更新
    //新上麦model的数组
    NSMutableArray *addMicPArr = [NSMutableArray arrayWithCapacity:5];
    //要下麦model的数组
    NSMutableArray *removeMicPArr = [NSMutableArray arrayWithCapacity:5];
    //匹配的当前麦位userId的数组
    NSMutableArray *matchCurrentMicPUserIdArr = [NSMutableArray arrayWithCapacity:5];
    //是否(newMicPArr和self.currentMicPArray)是相同的麦位信息
    BOOL isSameMicPArr = self.currentMicPArray.count == newMicPArray.count;
    
    //2.1 循环找新增
    for (NSInteger n=0; n<newMicPArray.count; n++) {
        KKGameBoardDetailSimpleModel *nModel = newMicPArray[n];
        
        //2.1.1 新的此麦位 没人
        if(nModel.userId.length < 1){
            continue;
        }
        
        //2.1.2 新的此麦位 有人
        //是否是新增上麦
        BOOL isAdd = YES;
        //是否是同一个user在同一个麦位
        BOOL isSameUserAtSameMicP = NO;
        
        for (NSInteger c=0; c<self.currentMicPArray.count; c++) {
            KKGameBoardDetailSimpleModel *cModel = self.currentMicPArray[c];
            //新的此麦位的userId,在当前麦位数组中, 则不是添加
            if ([nModel.userId isEqualToString:cModel.userId]) {
                isSameUserAtSameMicP = nModel.joinId == cModel.joinId;
                isAdd = NO;
                [matchCurrentMicPUserIdArr addObject:cModel.userId];
                break;
            }
            
            //目前麦位没检测到变化 && 同麦位
            if (isSameMicPArr && nModel.joinId == cModel.joinId) {
                isSameMicPArr = [nModel.userId isEqualToString:cModel.userId];
            }
        }
        //是新增上麦
        if (isAdd) {
            isSameMicPArr = NO;
            [addMicPArr addObject:nModel];
        }else {
            //不是新增上麦 & 不是同一个user在同一个麦位, 则不是同一个micP数组
            if (!isSameUserAtSameMicP){
                isSameMicPArr = NO;
            }
        }
    }
    
    //2.2 如果是同一个micP数组(麦位无变化),则直接return
    if(isSameMicPArr){
        return;
    }
    
    //2.3 找出要离开麦位的model
    for(NSInteger c=0; c<self.currentMicPArray.count; c++){
        KKGameBoardDetailSimpleModel *cModel = self.currentMicPArray[c];
        //麦位有人 & 此userId没被匹配过 => 是要下麦的model
        if (cModel.userId.length > 0 &&
            ![matchCurrentMicPUserIdArr containsObject:cModel.userId]) {
            [removeMicPArr addObject:cModel];
        }
    }
    
    //2.4 开始刷新
    //2.4.1 赋值
    self.currentMicPArray = newMicPArray;
    //2.4.3 更新rtc
    //要下麦, 取消发布音频流
    [self unpublishAudioStream:removeMicPArr];
    //要下麦, 取消订阅
    [self unsubscribeRemoteAudioStream:removeMicPArr];
    //新上麦, 发布音频流
    [self publishAudioStream:addMicPArr];
    //新上麦, 订阅
    [self subscribeRemoteAudioStream:addMicPArr];
    
}

#pragma mark publisth/subscribe
- (void)publishAudioStream:(NSArray <KKGameBoardDetailSimpleModel *>*)micPArray {
    NSString *myUserId = [KKUserInfoMgr shareInstance].userId;
    for (KKGameBoardDetailSimpleModel *model in micPArray) {
        //1.新上麦的人中的有自己,就发布音频流
        if ([myUserId isEqualToString:model.userId]) {
            self.isMicOpen = YES;
            [[KKRtcService shareInstance] pulishCurrentUserAudioStream];
            break;
        }
    }
}

- (void)unpublishAudioStream:(NSArray <KKGameBoardDetailSimpleModel *>*)micPArray {
    NSString *myUserId = [KKUserInfoMgr shareInstance].userId;
    for (KKGameBoardDetailSimpleModel *model in micPArray) {
        //1.下麦的人中的有自己,就取消发布音频流
        if ([myUserId isEqualToString:model.userId]) {
            self.isMicOpen = NO;
            [[KKRtcService shareInstance] unpublishCurrentUserAudioStream];
            break;
        }
    }
}

- (void)subscribeRemoteAudioStream:(NSArray <KKGameBoardDetailSimpleModel *>*)micPArray {
    
    NSString *myUserId = [KKUserInfoMgr shareInstance].userId;
    for (KKGameBoardDetailSimpleModel *model in micPArray) {
        //1.不是自己,就订阅
        if (model.userId.length > 0 && ![myUserId isEqualToString:model.userId]) {
            [[KKRtcService shareInstance] subscribeRemoteUserAudioStream:model.userId];
            continue;
        }
    }
}

- (void)unsubscribeRemoteAudioStream:(NSArray <KKGameBoardDetailSimpleModel *>*)micPArray {
    for (KKGameBoardDetailSimpleModel *model in micPArray) {
        //1.userId有值, 就取消订阅
        if (model.userId.length > 0) {
            [[KKRtcService shareInstance] unsubscribeRemoteUserAudioStream:model.userId];
            continue;
        }
    }
}

- (void)trySubscribeRemoteUserStream:(NSString *)userId {
    if (![userId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
        [[KKRtcService shareInstance] subscribeRemoteUserAudioStream:userId];
    }
}

- (void)tryUnsubscribeRemoteUserStream:(NSString *)userId {
    [[KKRtcService shareInstance] unsubscribeRemoteUserAudioStream:userId];
}

#pragma mark RongRTCActivityMonitorDelegate
- (void)didReportStatForm:(RongRTCStatisticalForm *)form {
    //1.发送
    for(RongRTCStreamStat *streamStat in form.sendStats){
        //只处理音频
        //处理发送的音频 动画
        if ([streamStat.mediaType isEqualToString:RongRTCMediaTypeAudio]) {
            //关闭了麦克风
            [self updateMicPositionSpeaking:streamStat.trackId audioLevel:streamStat.audioLevel];
        }
    }
    
    //2.接收
    for(RongRTCStreamStat *streamStat in form.recvStats){
        //只处理音频
        //处理接收的音频 动画
        if ([streamStat.mediaType isEqualToString:RongRTCMediaTypeAudio]) {
             [self updateMicPositionSpeaking:streamStat.trackId audioLevel:streamStat.audioLevel];
        }
    }
}

- (void)updateMicPositionSpeaking:(NSString *)userId audioLevel:(NSInteger)audioLevel {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (KKPlayerCardCollectionCell *cell in self.playerListView.visibleCells) {
            if (cell.dataModel.userId.length > 0 && [userId containsString:cell.dataModel.userId]) {
                if (self.isMicOpen == YES) {
                    cell.isSpeaking = audioLevel > 0;
                }else {
                    if ([userId containsString:[KKUserInfoMgr shareInstance].userId]) {
                        cell.isSpeaking = NO;
                    }
                }
            }
        }
    });
}

/// 设置麦克风开启已经关闭
- (void)setIsMicOpen:(BOOL)isMicOpen {
    _isMicOpen = isMicOpen;
    //1. 按钮状态
    self.chatToolView.micButton.selected = isMicOpen;
    //2.rtc关闭mic
    [[KKRtcService shareInstance] setMicrophoneDisable:!isMicOpen];
}

/// 设置扬声器/听筒 是否开启
-(void)setIsVoiceOpen:(BOOL)isVoiceOpen {
    _isVoiceOpen = isVoiceOpen;
    //1. 按钮状态
    self.chatToolView.speakerButton.selected = isVoiceOpen;
    //2. 关闭声音
    [KKRtcService shareInstance].muteAllVoice = !isVoiceOpen;
}

#pragma mark - RongRTCRoomDelegate
/// 有用户加入的回调
- (void)didJoinUser:(RongRTCRemoteUser *)user {
    CCLOG(@"KKGameRoom ************************************didLeaveUser userId:%@",user.userId)
}

/// 有用户离开的时候
- (void)didLeaveUser:(RongRTCRemoteUser *)user {
    CCLOG(@"KKGameRoom ************************************didLeaveUser userId:%@",user.userId)
}

///
- (void)didReportFirstKeyframe:(RongRTCAVInputStream *)stream {
    BBLOG(@"\n\n KKVoiceRoom ************************************didReportFirstKeyframe userId:%@ streamID:%@ \n",stream.userId,stream.userId);
}

/// 取消推流
- (void)didUnpublishStreams:(NSArray<RongRTCAVInputStream *>*)streams {
    BBLOG(@"\n\n KKVoiceRoom ************************************didUnpublishStreams userId:%@  \n",streams.firstObject.userId);
    NSString *pUserId = streams.firstObject.userId;
    [self tryUnsubscribeRemoteUserStream:pUserId];
}

/// 当有用户发布资源的时候，通过此方法回调用户发布的流
- (void)didPublishStreams:(NSArray <RongRTCAVInputStream *>*)streams {
    BBLOG(@"\n\n KKVoiceRoom ************************************didPublishStreams userId:%@ \n ",streams.firstObject.userId);
    NSString *pUserId = streams.firstObject.userId;
    [self trySubscribeRemoteUserStream:pUserId];
}

- (void)didConnectToStream:(RongRTCAVInputStream *)stream {
    CCLOG(@"didConnectToStream === %@", stream.userId);
}

/// 接收到其他人发送到 room 里的消息
- (void)didReceiveMessage:(RCMessage *)message {
    BBLOG(@"\n\n KKVoiceRoom ************************************didReceiveMessage:%@ \n",message.content);
}

/** 音频状态改变
 @param stream 流信息
 @param mute 当前流是否可用
 */
- (void)stream:(RongRTCAVInputStream *)stream didAudioMute:(BOOL)mute {
    BBLOG(@"\n\n KKVoiceRoom ************************************didAudioMute stream:%@ didAudioMute:%d \n",stream.userId, mute);
}
@end

