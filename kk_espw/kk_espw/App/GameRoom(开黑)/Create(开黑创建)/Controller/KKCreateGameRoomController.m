//
//  KKCreateGameRoomController.m
//  kk_espw
//
//  Created by hsd on 2019/7/12.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKCreateGameRoomController.h"
#import "KKCollectionViewCustomLayout.h"
#import "UITableView+KKDropDownAmplification.h"
#import "KKGamePortraitCardCell.h"
#import "KKGameModePlayCell.h"
#import "KKGameAmountCell.h"
#import "KKCreateGameTableSectionHeaderView.h"
#import "KKCreateGameTableFooterView.h"
#import "UIView+KKRectCorner.h"
#import "KKGameRoomOwnerController.h"
#import "KKCreateGameRoomController+DataSource.h"
#import "KKCreateGameRoomExternKey.h"
#import "KKAddMyCardViewController.h"
#import "KKMyCardService.h"
#import "KKHomeService.h"
#import "KKGameRoomManager.h"
#import "KKLastCreateGameRoomModel.h"
#import "KKGameRoomContrastModel.h"
#import "KKCreateVoiceCell.h"
#import "KKCreateVoiceService.h"
#import "KKRtcService.h"
#import "KKVoiceRoomRtcMgr.h"
#import "KKVoiceRoomVC.h"
@interface KKCreateGameRoomController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>

@property (nonatomic, strong, nonnull) dispatch_group_t signalGroup;    ///< 信号组

@property (nonatomic, strong, nonnull) CC_Button *backBtn;       ///< 返回按钮
@property (nonatomic, strong, nonnull) CC_Button *gameLogoBtn;   ///< 游戏logo
@property (nonatomic, strong, nonnull) CC_Button *voiceRoomButton;   ///< 语音房
@property (nonatomic, strong, nonnull) CC_Button *beginGameBtn;  ///< 立即发起
@property (nonatomic, strong, nonnull) UIView *gradientView;    ///< 渐变色
@property (nonatomic, strong, nonnull) UITableView *tableView;

@property (nonatomic, copy, nonnull) NSString *payTypeString;       ///< 支付类型
@property (nonatomic, copy, nonnull) NSString *boardTypeString;     ///< 游戏局类型
@property (nonatomic, copy, nullable) NSString *rankString;          ///< 游戏局等级
@property (nonatomic, copy, nullable) NSString *ownerPositionString; ///< 擅长位置
@property (nonatomic, copy, nullable) NSString *roomTitleString;     ///< 局标题
@property (nonatomic, copy, nullable) NSString *platformTypeString;  ///< 游戏局平台
@property (nonatomic, copy, nullable) NSString *depositTypeString;   ///< 是否收费
@property (nonatomic, copy, nullable) NSString *patternTypeString;   ///< 游戏局模式
@property (nonatomic, copy, nullable) NSString *profilesIdString;    ///< 名片id
@property (nonatomic, strong, nonnull) NSNumber *gameId;            ///< 房间id, 写死1
@property (nonatomic, strong, nullable) KKCardTag *selectCard;
@property (nonatomic, strong, nullable) NSNumber *selectPattern;
@property (nonatomic, strong, nullable) KKLastCreateGameRoomModel *lastModel;   ///< 最后一次创建开黑房的模型
@property (nonatomic, strong, nonnull) KKHeaderAmplificationView *headerView; ///< 下拉放大view
@property (nonatomic, assign) KKRoomType roomType;
@property (nonatomic, strong) KKCreateGameTableFooterView *footerView;
@property (nonatomic, copy) NSString *declarationRandomStr;
@property (nonatomic, copy) NSMutableArray *declarationRandomStrArray;
@property (nonatomic, assign) int currentIndex;
@end

@implementation KKCreateGameRoomController

#pragma mark - get
- (dispatch_group_t)signalGroup {
    if (!_signalGroup) {
        _signalGroup = dispatch_group_create();
    }
    return _signalGroup;
}

- (NSMutableArray *)declarationRandomStrArray {
    if (!_declarationRandomStrArray) {
        _declarationRandomStrArray = [NSMutableArray arrayWithObjects:@"聊得有趣, 一起打游戏", @"真心话大冒险", @"找走心的长久陪伴#", @"好听的声音来聊天", nil];
    }
    return _declarationRandomStrArray;
}

#pragma mark - lifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initDefaultData];
    [self initTableView];
    [self initHeaderAmplificationView];
    [self initTableHeaderView];
    [self initTableFooterView];
    [self initBackAndGameLogo];
    [self initBeginGameBtn];
    [self addTapGestureToView];
    //1.请求语音房宣言.
    [self requestVoiceChatRoomDeclarationData];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.headerView removeObserverForScroll];
}

#pragma mark - init
- (void)initDefaultData {
    self.boardTypeString = @"TEAM";
    self.payTypeString = @"ACCOUNT";
    self.gameId = @(1);
}

- (void)initTableView {
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= 92;
    
    // 背景
    UIView *bgView = [[UIView alloc] initWithFrame:frame];
    bgView.backgroundColor = KKES_COLOR_HEX(0xECECEC);
    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    
    self.tableView = [[UITableView alloc] initWithFrame:bgView.bounds style: UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = KKES_COLOR_HEX(0xECECEC);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView registerClass:[KKCreateVoiceCell class] forCellReuseIdentifier:@"KKCreateVoiceCell"];
    //防止刷新单个cell时, tableView跳动到其他的cell的位置
    self.tableView.estimatedRowHeight = 0.0;
    self.tableView.estimatedSectionHeaderHeight = 0.0;
    self.tableView.estimatedSectionFooterHeight = 0.0;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [bgView addSubview:self.tableView];
}

- (void)initHeaderAmplificationView {
    KKHeaderAmplificationView *headerView = [[KKHeaderAmplificationView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 182)];
    self.headerView = headerView;
    headerView.image = [UIImage imageNamed:@"game_create_room_bg"];
    [self.tableView kkAddHeaderDropDownAmplificationView:headerView];
}

- (void)initBackAndGameLogo {
    
    CGFloat statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    WS(weakSelf)
    
    self.backBtn = [[CC_Button alloc] init];
    [self.backBtn setImage:[UIImage imageNamed:@"game_create_cancel"] forState:UIControlStateNormal];
    [self.backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 9, 0, 9)];
    [self.backBtn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        [weakSelf clickBackButton:button];
    }];
    [self.backBtn addTarget:self action:@selector(clickBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.tableView.backgroundView addSubview:self.backBtn];
    [self.tableView.backgroundView bringSubviewToFront:self.backBtn];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(41);
        make.height.mas_equalTo(23);
        make.left.mas_equalTo(self.tableView.backgroundView).mas_offset(6);
        make.top.mas_equalTo(self.tableView.backgroundView).mas_offset(statusBarHeight + 10);
    }];
    SS(strongSelf)

    //1.王者荣耀
    self.gameLogoBtn = [CC_Button buttonWithType:UIButtonTypeCustom];
    [self.gameLogoBtn setImage:[UIImage imageNamed:@"wangzherongyao_normal"] forState:UIControlStateNormal];
    [self.gameLogoBtn setImage:Img(@"wangzherongyao_selected") forState:UIControlStateSelected];
    [self.gameLogoBtn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {\
        weakSelf.beginGameBtn.enabled = YES;
        weakSelf.voiceRoomButton.selected = NO;
        weakSelf.tableView.scrollEnabled = YES;
        weakSelf.beginGameBtn.backgroundColor = KKES_COLOR_MAIN_YELLOW;
        if (!button.selected) {
            button.selected = !button.selected;
            button.size = CGSizeMake(50 / 1.1, 70 / 1.1);
            [weakSelf toBigger:weakSelf.gameLogoBtn];
            [weakSelf toSmall:weakSelf.voiceRoomButton];
            strongSelf.view.backgroundColor = KKES_COLOR_BG;
        }
        [weakSelf clickGameLogo:button];
        weakSelf.roomType = KKGameType;
        weakSelf.tableView.tableFooterView = weakSelf.footerView;
        
        [weakSelf addKeyboardNotificagtion];
        [weakSelf.headerView addObserverForScroll];
        [weakSelf requestPlayerCardList];
        [weakSelf requestForMyDeposit];
        [weakSelf requestForLastTimeGameBoardInfo];
        
        dispatch_group_notify(weakSelf.signalGroup, dispatch_get_main_queue(), ^{
            
            // 如果最后一次创建的为收费局, 但是获取到该用户已经无权收费, 则改为免费局
            if ([weakSelf.depositTypeString isEqualToString:@"CHARGE_FOR_BOARD"]) {
                if (weakSelf.depositPrice == nil) {
                    weakSelf.depositTypeString = @"FREE_FOR_BOARD";
                }
            }
            
            [weakSelf.tableView reloadData];
        });
        
    }];
    //2.语音房
    self.voiceRoomButton = [CC_Button buttonWithType:UIButtonTypeCustom];
    [self.voiceRoomButton setImage:[UIImage imageNamed:@"voice_chat_normal"] forState:UIControlStateNormal];
    [self.voiceRoomButton setImage:Img(@"voice_chat_selected") forState:UIControlStateSelected];
    [self.voiceRoomButton addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        weakSelf.gameLogoBtn.selected = NO;
        weakSelf.tableView.scrollEnabled = NO;
        if (!button.selected) {
            button.selected = !button.selected;
            strongSelf.view.backgroundColor = [UIColor whiteColor];

            button.size = CGSizeMake(50 / 1.1, 70 / 1.1);
            [weakSelf toBigger:weakSelf.voiceRoomButton];
            [weakSelf toSmall:weakSelf.gameLogoBtn];
        }
        [weakSelf clickGameLogo:button];
        weakSelf.roomType = KKVoiceType;
        weakSelf.tableView.tableFooterView = [[UIView alloc] init];
        [weakSelf.tableView reloadData];
    }];
    [self.tableView.backgroundView addSubview:self.voiceRoomButton];
    [self.tableView.backgroundView addSubview:self.gameLogoBtn];
    [self.tableView.backgroundView bringSubviewToFront:self.gameLogoBtn];

    self.gameLogoBtn.frame = CGRectMake(38, 88 , 41, 66);
    self.voiceRoomButton.frame = CGRectMake(self.gameLogoBtn.right + RH(40), self.gameLogoBtn.top, 50 / 1.1, 70 / 1.1);
    /// 默认是连麦语音
    self.roomType = KKVoiceType;
    self.voiceRoomButton.selected = YES;
    self.tableView.scrollEnabled = NO;
    /// 默认去掉footerV
    if (self.roomType == KKVoiceType) {
        self.tableView.tableFooterView = [[UIView alloc] init];
    }else {
        self.tableView.tableFooterView = self.footerView;
    }
    [self toBigger:self.voiceRoomButton];
    [self.tableView reloadData];
}

- (void)toBigger:(UIButton *)obj {
    [UIView animateWithDuration:0.3 animations:^{
        // transform 使...变形, CGAffineTransformMakeScale(1.3, 1.3) 缩放的比例 缩放为原来的1.3倍
        obj.transform = CGAffineTransformMakeScale(1.3, 1.3);
    } completion:^(BOOL finished) {
    }];
}

- (void)toSmall:(UIButton *)obj {
    [UIView animateWithDuration:0.3 animations:^{
        obj.transform = CGAffineTransformIdentity;
    }];
}

- (void)initTableHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 10)];
    headerView.backgroundColor = [UIColor whiteColor];
    [headerView kkAddRectCorner:(UIRectCornerTopLeft | UIRectCornerTopRight) Radius:8];
    self.tableView.tableHeaderView = headerView;
}

- (void)initTableFooterView {
    _footerView = [[KKCreateGameTableFooterView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 130)];
    WS(weakSelf)
    _footerView.textDidChangeBlock = ^(NSString * _Nullable text) {
        weakSelf.roomTitleString = text;
    };
    _footerView.frameDidChangeBlock = ^(KKCreateGameTableFooterView * _Nonnull footerView, BOOL animated) {
        [weakSelf.footerView kkAddRectCorner:(UIRectCornerBottomLeft | UIRectCornerBottomRight) Radius:8];
        weakSelf.tableView.tableFooterView = weakSelf.footerView;
        if (animated) {
            [weakSelf.tableView scrollRectToVisible:footerView.frame animated:animated];
        }
    };
    [_footerView setDefaultState:NO animated:NO];
}

- (void)initBeginGameBtn {
    
    CGFloat safeBottom = 18;
    if (@available(iOS 11.0, *)) {
        if ([UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom > 18) {
            safeBottom = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
        }
    }
    
    self.gradientView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 252, 43)];
    self.gradientView.layer.cornerRadius = 5;
    self.gradientView.layer.masksToBounds = YES;
    [self.view addSubview:self.gradientView];
    [self.gradientView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(252);
        make.height.mas_equalTo(43);
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).mas_offset(-safeBottom);
    }];
    
    CAGradientLayer *gLayer = [CAGradientLayer layer];
    gLayer.frame = self.gradientView.bounds;
    gLayer.startPoint = CGPointMake(0, 0);
    gLayer.endPoint = CGPointMake(1, 1);
    gLayer.colors = @[(__bridge id)KKES_COLOR_HEX(0xF0C765).CGColor, (__bridge id)KKES_COLOR_HEX(0xE5B04A).CGColor];
    gLayer.locations = @[@(0.0), @(1.0)];
    
    [self.gradientView.layer addSublayer:gLayer];
    
    self.beginGameBtn = [[CC_Button alloc] init];
    self.beginGameBtn.layer.cornerRadius = 5;
    self.beginGameBtn.layer.masksToBounds = YES;
    self.beginGameBtn.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:16];
    [self.beginGameBtn setTitle:@"立即发起" forState:UIControlStateNormal];
    [self.beginGameBtn setTitleColor:KKES_COLOR_HEX(0xFFFFFF) forState:UIControlStateNormal];
    [self.beginGameBtn setTitleColor:KKES_COLOR_HEX(0x929292) forState:UIControlStateHighlighted];
    [self.gradientView addSubview:self.beginGameBtn];
    [self.beginGameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.gradientView);
    }];
    
    WS(weakSelf)
    [self.beginGameBtn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        if (weakSelf.roomType == KKGameType) {
            [weakSelf requestForConnectIM];
        }else {
            [weakSelf requestCreateVoiceRoomWithDeclaration:weakSelf.declarationRandomStr];
        }
    }];
}

- (void)addKeyboardNotificagtion {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)addTapGestureToView {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureDidTrigger)];
    tap.cancelsTouchesInView = NO;
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}

/// 设置默认开黑房宣言
- (void)setDefaultGameTitleWithUserAction:(BOOL)userAction {
    KKCardTag *cardTag = self.selectCard;
    
    if (!cardTag) {
        return;
    }
    
    NSString *allPattern = nil;
    NSString *leftPattern = nil;
    NSInteger playerNumber = [self.selectPattern integerValue];
    
    
    
    if (playerNumber == 1) {
        allPattern = @"双人";
        leftPattern = @"1人";
    } else if (playerNumber == 2) {
        allPattern = @"三人";
        leftPattern = @"2人";
    } else if (playerNumber == 4) {
        allPattern = @"五人";
        leftPattern = @"4人";
    } else {
        
    }
    
    if (!self.roomTitleString || userAction) {
        self.roomTitleString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@",@"大区", cardTag.platformType.message, cardTag.rank.message, @"段位", allPattern, @"组队", @"缺", leftPattern, @"快来"];
        KKCreateGameTableFooterView *footerView = (KKCreateGameTableFooterView *)self.tableView.tableFooterView;
        [footerView setDefaultTitle:self.roomTitleString];
    }
}

#pragma mark - Action
- (void)clickBackButton:(UIButton *)sender {
    if(self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)clickGameLogo:(UIButton *)sender {
    NSLog(@"%s", __func__);
}

/// 点击手势触发
- (void)tapGestureDidTrigger {
    [self.tableView endEditing:YES];
}

/// 跳转到名片编辑页面
- (void)toPushEditCardVC:(KKCardTag *)cardInfo {
    KKAddMyCardViewController *editCardVC = New(KKAddMyCardViewController);
    editCardVC.isEdit = @"YES";
    editCardVC.cardInfo = cardInfo;
    [self.navigationController pushViewController:editCardVC animated:YES];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    if (self.roomType == KKVoiceType) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *userInfo = [notification userInfo];
        CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGRect rect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        CGFloat nextBtnToBottom = 2 + rect.size.height;
        
        [UIView animateWithDuration:duration animations:^{
            
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, rect.size.height, 0);
            
            [self.gradientView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.view).mas_offset(-nextBtnToBottom);
            }];
            
            [self.view layoutIfNeeded];
            
        }];
    });
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (self.roomType == KKVoiceType) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *userInfo = [notification userInfo];
        CGFloat duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        CGFloat safeBottom = 18;
        if (@available(iOS 11.0, *)) {
            if ([UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom > 18) {
                safeBottom = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
            }
        }
        
        [UIView animateWithDuration:duration animations:^{
            
            self.tableView.contentInset = self.tableView.originContentInset;
            
            [self.gradientView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.view).mas_offset(-safeBottom);
            }];
            
            [self.view layoutIfNeeded];
        }];
    });
}

#pragma mark - 处理数据
- (void)dealWithLastTimeGameBoardInfo:(NSDictionary *)responseDic {
    
    KKLastCreateGameRoomModel *lastModel = [KKLastCreateGameRoomModel mj_objectWithKeyValues:responseDic];
    
    self.rankString = lastModel.gameBoard.rank.name;
    self.ownerPositionString = lastModel.gameBoard.dataList.lastObject.positionType.lastObject.name;
    self.platformTypeString = lastModel.gameBoard.platformType.name;
    self.depositTypeString = lastModel.gameBoard.depositType.name;
    self.patternTypeString = lastModel.gameBoard.patternType.name;
    self.profilesIdString = lastModel.userGameProfiles.ID;
    
    self.lastModel = lastModel;
    
    [self.tableView reloadData];
}

#pragma mark - 网络请求

/// 请求创建语音房
- (void)requestCreateVoiceRoomWithDeclaration:(NSString *)declaration {
    WS(weakSelf)
    [KKCreateVoiceService requestCreateVoiceRoomWithDeclaration:declaration Success:^(NSString * _Nonnull roomId, NSString * _Nonnull channelId) {
        [[KKVoiceRoomRtcMgr shareInstance] requestJoinRoom:roomId channel:channelId success:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                KKVoiceRoomVC *vc = [KKVoiceRoomVC shareInstance];
                vc.roomId = roomId;
                [weakSelf.navigationController pushViewController:vc animated:YES];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([weakSelf.navigationController.viewControllers containsObject:weakSelf]) {
                        NSMutableArray *mutArr = [NSMutableArray arrayWithArray:weakSelf.navigationController.viewControllers];
                        [mutArr removeObject:weakSelf];
                        weakSelf.navigationController.viewControllers = [mutArr copy];
                    }
                });
                
            });
        }];
    } fail:^{ }];
}

/// 获取玩家名片列表
- (void)requestPlayerCardList {
    dispatch_group_enter(self.signalGroup);
    WS(weakSelf)
    [KKMyCardService requestCardTagListSuccess:^(NSMutableArray * _Nonnull dataList) {
        weakSelf.cardList = dataList;
        if (weakSelf.signalGroup) {
            dispatch_group_leave(weakSelf.signalGroup);
        }
        
    } Fail:^{
        if (weakSelf.signalGroup) {
            dispatch_group_leave(weakSelf.signalGroup);
        }
    }];
}

/// 上一次游戏信息
- (void)requestForLastTimeGameBoardInfo {
    
    // 已经加载过
    if (self.lastModel.userGameProfiles.ID) {
        return;
    }
    
    dispatch_group_enter(self.signalGroup);

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"LAST_TIME_GAME_BOARD_DETAIL_QUERY" forKey:@"service"];

    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {

        NSDictionary *responseDic = resModel.resultDic[@"response"];
        if (error) {
            [CC_Notice show:error atView:weakSelf.view];
        }else {
            [weakSelf dealWithLastTimeGameBoardInfo:responseDic];
        }
        
        if (weakSelf.signalGroup) {
            dispatch_group_leave(weakSelf.signalGroup);
        }
    }];
}

/// 查询收费价格
- (void)requestForMyDeposit {
    dispatch_group_enter(self.signalGroup);
    WS(weakSelf)
    [[KKUserInfoMgr shareInstance] requestUserInfoSuccess:^{
        
        KKUserInfoModel *mineInfo = [KKUserInfoMgr shareInstance].userInfoModel;
        
        if (mineInfo.userMedalDetailList.count > 0) {
            weakSelf.depositPrice = [NSString stringWithFormat:@"%@", mineInfo.deposit];
            weakSelf.depositTypeString = weakSelf.depositTypeString ?: @"CHARGE_FOR_BOARD";
        } else {
            weakSelf.depositPrice = nil;
            weakSelf.depositTypeString = weakSelf.depositTypeString ?: @"FREE_FOR_BOARD";
        }
        
        if (weakSelf.signalGroup) {
            dispatch_group_leave(weakSelf.signalGroup);
        }
        
    } fail:^{
        if (weakSelf.signalGroup) {
            dispatch_group_leave(weakSelf.signalGroup);
        }
    }];
}

/// 连接融云
- (void)requestForConnectIM {
    WS(weakSelf)
    [[KKIMMgr shareInstance] checkAndConnectRCSuccess:^{
        [weakSelf requestForGameCreate];
        
    } error:^(RCConnectErrorCode status) {
        [CC_Notice show:@"聊天室未连接"];
    }];
}

/// 请求创建开黑房
- (void)requestForGameCreate {
    
    NSString *roomTitle = [self.roomTitleString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (roomTitle.length < 1) {
        [CC_Notice show:@"请输入房间名"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_CREATE" forKey:@"service"];
    [params safeSetObject:self.payTypeString forKey:@"payType"];
    [params safeSetObject:self.boardTypeString forKey:@"boardType"];
    [params safeSetObject:self.rankString forKey:@"rank"];
    [params safeSetObject:self.ownerPositionString forKey:@"ownerPosition"];
    [params safeSetObject:self.roomTitleString forKey:@"title"];
    [params safeSetObject:self.platformTypeString forKey:@"platformType"];
    [params safeSetObject:self.depositTypeString forKey:@"depositType"];
    [params safeSetObject:self.patternTypeString forKey:@"patternType"];
    [params safeSetObject:self.profilesIdString forKey:@"profilesId"];
    [params safeSetObject:self.gameId forKey:@"gameId"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"userId"];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {

        if (error) {
            [CC_Notice show:error atView:weakSelf.view];
        } else {
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            
            [[KKGameRoomManager sharedInstance] joinGameRoomWithGameBoardId:responseDic[@"gameBoardId"] Success:^{
                
                NSString *groupId = responseDic[@"groupId"];
                NSString *gameProfilesId = responseDic[@"profilesId"];
                NSString *gameBoardId = responseDic[@"gameBoardId"];
                NSInteger roomid = [responseDic[@"gameRoomId"] integerValue];
                NSString *channelId = [NSString stringWithFormat:@"%@", responseDic[@"channelId"]];

                //3. 链接rtc房间
                [[KKRtcService shareInstance] joinRoom:channelId success:^(RongRTCRoom * _Nonnull room) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [KKGameRoomOwnerController sharedInstance].gameProfilesIdStr = gameProfilesId;
                        [KKGameRoomOwnerController sharedInstance].gameBoardIdStr = gameBoardId;
                        [KKGameRoomOwnerController sharedInstance].gameRoomId = roomid;
                        [KKGameRoomOwnerController sharedInstance].groupIdStr = groupId;
                        [[KKRootContollerMgr getRootNav] pushViewController:[KKGameRoomOwnerController sharedInstance] animated:YES];
                        
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            if ([weakSelf.navigationController.viewControllers containsObject:weakSelf]) {
                                NSMutableArray *mutArr = [NSMutableArray arrayWithArray:weakSelf.navigationController.viewControllers];
                                [mutArr removeObject:weakSelf];
                                weakSelf.navigationController.viewControllers = [mutArr copy];
                            }
                        });
                        
                    });
                } error:^(RongRTCCode code) {
                    dispatch_main_async_safe(^{
                        [CC_Notice show:@"进入开黑房失败！"];
                    });
                }];
            }];
        }
    }];
}
/****************************************** **** ******************************************************/
/****************************************** 语音房 ******************************************************/
/****************************************** **** ******************************************************/
- (void)requestVoiceChatRoomDeclarationData {
    WS(weakSelf)
    [KKCreateVoiceService requestVoiceChatRoomDeclarationDataWithSuccess:^(NSMutableArray * _Nonnull dataList) {
        //1.获取一个随机整数范围在：[0,dataList.count]
        weakSelf.declarationRandomStrArray = dataList;
        weakSelf.declarationRandomStr = [weakSelf getArcrandStr];
        if (weakSelf.roomType == KKVoiceType) {
            [weakSelf.tableView reloadData];
        }
    } fail:^{
        
    }];
}

- (NSString *)getArcrandStr {
    int count = (int)(_declarationRandomStrArray.count - 1);
    int index = (arc4random() % count);
    _currentIndex = index;
    NSString *str = _declarationRandomStrArray[index];
    return str;
}

#pragma mark - UIGestureRecognizeDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_roomType == KKGameType) {
        return [self defaultSectionDataSource].count;
    }else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_roomType == KKGameType) {
        
        WS(weakSelf)
        if (indexPath.section == 0) {
            KKGamePortraitCardCell *portraitCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([KKGamePortraitCardCell class])];
            if (!portraitCell) {
                portraitCell = [[KKGamePortraitCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([KKGamePortraitCardCell class])];
            }
            
            portraitCell.editBlock = ^(KKCardTag *editCard, BOOL userAction) {
                [weakSelf toPushEditCardVC:editCard];
            };
            portraitCell.selectBlock = ^(KKCardTag * _Nonnull editCard, BOOL userAction) {
                weakSelf.platformTypeString = editCard.platformType.name;
                weakSelf.profilesIdString = editCard.ID;
                weakSelf.rankString = editCard.rank.name;
                weakSelf.selectCard = editCard;
                [weakSelf setDefaultGameTitleWithUserAction:userAction];
            };
            portraitCell.defaultSelectProfileId = self.profilesIdString;
            portraitCell.dataSourceArray = [self dataSourceForSection:indexPath.section];
            
            return portraitCell;
            
        } else if (indexPath.section == 1) {
            KKGameModePlayCell *modeCell = [tableView dequeueReusableCellWithIdentifier:@"modeCell1"];
            if (!modeCell) {
                modeCell = [[KKGameModePlayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"modeCell1"];
            }
            
            modeCell.selectBlock = ^(NSString * _Nonnull textString, BOOL userAction) {
                weakSelf.patternTypeString = textString;
                weakSelf.selectPattern = [KKGameRoomContrastModel shareInstance].patternMapDic[weakSelf.patternTypeString];
                [weakSelf setDefaultGameTitleWithUserAction:userAction];
            };
            modeCell.defaultSelectTypeString = self.patternTypeString;
            modeCell.dataSourceArray = [self dataSourceForSection:indexPath.section];
            
            return modeCell;
            
        } else if (indexPath.section == 2) {
            KKGameModePlayCell *modeCell = [tableView dequeueReusableCellWithIdentifier:@"modeCell2"];
            if (!modeCell) {
                modeCell = [[KKGameModePlayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"modeCell2"];
                modeCell.maxShowOneLine = 4;
                modeCell.sectionInsets = UIEdgeInsetsMake(1, 18, 18, 18);
            }
            
            modeCell.selectBlock = ^(NSString * _Nonnull textString, BOOL userAction) {
                weakSelf.ownerPositionString = textString;
            };
            modeCell.defaultSelectTypeString = self.ownerPositionString;
            modeCell.dataSourceArray = [self dataSourceForSection:indexPath.section];
            
            return modeCell;
            
        } else if (indexPath.section == 3) {
            KKGameAmountCell *amountCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([KKGameAmountCell class])];
            if (!amountCell) {
                amountCell = [[KKGameAmountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([KKGameAmountCell class])];
            }
            
            amountCell.selectBlock = ^(NSString * _Nonnull textString) {
                weakSelf.depositTypeString = textString;
            };
            amountCell.defaultDepositString = self.depositTypeString;
            amountCell.dataSourceArray = [self dataSourceForSection:indexPath.section];
            
            return amountCell;
            
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            }
            cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.section];
            return cell;
        }
    }else {
        WS(weakSelf)
        KKCreateVoiceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKCreateVoiceCell"];
        cell.declarationStr = self.declarationRandomStr;
        cell.tfInputBlock = ^(NSString * _Nonnull text) {
            if (text.length == 0) {
                weakSelf.beginGameBtn.enabled = NO;
                weakSelf.beginGameBtn.backgroundColor = KKES_COLOR_GRAY_TEXT;
                weakSelf.declarationRandomStr = text;
            }else {
                weakSelf.beginGameBtn.enabled = YES;
                weakSelf.beginGameBtn.backgroundColor = KKES_COLOR_MAIN_YELLOW;
                weakSelf.declarationRandomStr = text;
            }
        };
        //1.点击了随机按钮
        cell.tapRandomNumButttonBlock = ^{
            weakSelf.currentIndex ++;
            if (weakSelf.currentIndex >= weakSelf.declarationRandomStrArray.count) {
                weakSelf.currentIndex = 0;
            }
            weakSelf.declarationRandomStr  = weakSelf.declarationRandomStrArray[weakSelf.currentIndex];
            [weakSelf.tableView reloadData];
        };
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (_roomType == KKGameType) {
        return 50;
    }else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_roomType == KKGameType) {
        
        if (indexPath.section == 0) {
            return 71;
        } else if (indexPath.section == 1) {
            return 70;
        } else if (indexPath.section == 2) {
            return 154;
        } else if (indexPath.section == 3) {
            return 70;
        }
        return 44;
    }else {
        return RH(600);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (_roomType == KKGameType) {
        KKCreateGameTableSectionHeaderView *headerView = [[KKCreateGameTableSectionHeaderView alloc] init];
        headerView.backgroundColor = KKES_COLOR_HEX(0xFFFFFF);
        
        NSArray *titleArr = [self defaultSectionDataSource];
        NSDictionary *dataDic = titleArr[section];
        [headerView setTitle:dataDic[kkCreateGameRoom_title] attriStr:dataDic[kkCreateGameRoom_attribute_title]];
        
        return headerView;
    }else {
        return [UIView new];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.tableView endEditing:YES];
}

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - dealloc
- (void)dealloc {
    CCLOG(@"%s", __func__);
}

@end
