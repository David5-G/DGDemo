//
//  KKGameOverController.m
//  kk_espw
//
//  Created by hsd on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameOrderDetailController.h"
#import "KKPlayerCardCollectionCell.h"
#import "KKGameOrderDetailFootView.h"
#import "KKGameOrderDetailViewModel.h"
#import "KKCountDownManager.h"
#import "KKGameTimeConvertModel.h"
#import "KKShareWQDView.h"
#import "KKConversationController.h"
#import "KKWeChatShareImageController.h"
#import "KKGameChargeToolView.h"
#import "KKGameWaitEvaluateController.h"
#import "KKGameRoomContrastModel.h"

static const NSInteger kk_cat_pop_tag_dissolve_room = 9;
static const NSInteger kk_cat_pop_tag_cancel_order = 19;

@interface KKGameOrderDetailController ()<KKGameOrderDetailFootViewDelegate, CatDefaultPopDelegate>

@property (nonatomic, strong, nullable) CatDefaultPop *catPop;  ///< 弹窗
@property (nonatomic, weak, nullable) KKGameChargeToolView *chargeToolView; ///< 充值弹窗
@property (nonatomic, strong, nullable) KKGameOrderDetailFootView *footView;

@property (nonatomic, strong, nonnull) KKGameOrderDetailViewModel *viewModel;

@end

@implementation KKGameOrderDetailController

#pragma mark - get
- (KKGameOrderDetailViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[KKGameOrderDetailViewModel alloc] init];
        _viewModel.orderNoStr = self.orderNoStr;
    }
    return _viewModel;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_initPlayerListView];
    [self initFootView];
    [self resetCollectionView];
    
    WS(weakSelf)
    [self.viewModel requestForGameBoardEvaluateDetail:^{
        [weakSelf reloadUI];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.viewModel requestForShareUrl];
    [[KKFloatViewMgr shareInstance] hiddenGameRoomFloatView];
    [KKFloatViewMgr shareInstance].hiddenFloatView = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[KKFloatViewMgr shareInstance] notHiddenGameRoomFloatView];
    [KKFloatViewMgr shareInstance].hiddenFloatView = NO;

}

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resumeToolViewButtonUserEnable) object:nil];
    CCLOG(@"%s", __func__);
}

#pragma mark - Init
- (void)initFootView {
    
    CGFloat safeHeight = 0;
    if (@available(iOS 11.0, *)) {
        safeHeight = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    }
    
    CGFloat height = (SCREEN_HEIGHT < 667.0) ? 210 : 260;
    
    self.footView = [[KKGameOrderDetailFootView alloc] initWithFrame:CGRectZero bottomDistance:safeHeight];
    self.footView.delegate = self;
    [self.gameSuperView addSubview:self.footView];
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.gameSuperView);
        make.height.mas_equalTo(height + safeHeight);
        make.bottom.mas_equalTo(self.gameSuperView);
    }];
}

- (void)resetCollectionView {
    
    CGFloat height = 275;
    
    // 调整高度
    [self.playerListView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    
    // 调整 cell 大小
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.playerListView.collectionViewLayout;
    CGSize itemSize = flowLayout.itemSize;
    itemSize.height = height;
    flowLayout.itemSize = itemSize;
    
    [self.playerListView registerNib:[UINib nibWithNibName:NSStringFromClass([KKPlayerCardCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([KKPlayerCardCollectionCell class])];
}

#pragma mark - override
// 本页面已经从父页面中移除
- (void)didMoveToParentViewController:(UIViewController *)parent {
    if (parent == nil) {
        // 取消定时器
        [self.viewModel checkCancelCountDownEnable:YES];
    }
}

#pragma mark - Action
- (void)shareGameRoom {
    KKShareWQDView *shareV = [[KKShareWQDView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, RH(183))];
    [shareV showPopView];
    WS(weakSelf)
    KKGameOrderTagDetailModel *infoModel = self.viewModel.orderModel;
    shareV.tapShareKKBlock = ^{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"邀请你进入开黑房" forKey:@"title"];
        [dic setValue:infoModel.title forKey:@"subheading"];
        [dic setValue:infoModel.gameBoardId forKey:@"gameBoradId"];
        [dic setValue:infoModel.ownerUserLogoUrl forKey:@"ownerUserHeaderImgUrl"];
        
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
    NSString *iconUrlStr =  self.viewModel.roomOwnerSimpleModel.userHeaderImgUrl;
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
- (void)setToolViewButtonUserEnable:(BOOL)enable duration:(NSTimeInterval)duration {
    if (enable) {
        [self.footView setButtonEnable:YES forButtonType:KKGameOrderDetailButtonTypeBorder];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(resumeToolViewButtonUserEnable) object:nil];
    } else {
        [self.footView setButtonEnable:NO forButtonType:KKGameOrderDetailButtonTypeBorder];
        [self performSelector:@selector(resumeToolViewButtonUserEnable) withObject:nil afterDelay:duration];
    }
}

/// 恢复交互
- (void)resumeToolViewButtonUserEnable {
    [self.footView setButtonEnable:YES forButtonType:KKGameOrderDetailButtonTypeBorder];
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

/// 跳转评价页
- (void)jumpToEvaluateController {
    KKGameWaitEvaluateController *vc = [[KKGameWaitEvaluateController alloc] init];
    vc.gameBoardIdStr = self.viewModel.orderModel.gameBoardId;
    vc.orderNoStr = self.viewModel.orderNoStr;
    [self.navigationController pushViewController:vc animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.navigationController.viewControllers containsObject:self]) {
            NSMutableArray *mutArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [mutArr removeObject:self];
            self.navigationController.viewControllers = [mutArr copy];
        }
    });
}

#pragma mark - 刷新
- (void)reloadUI {
    [self reloadGameRoomUI];
    [self reloadFootView];
    [self.playerListView reloadData];
}

- (void)reloadGameRoomUI {
    [self.navBackBtn setTitle:[NSString stringWithFormat:@"ID:%ld", self.viewModel.orderModel.gameRoomId] forState:UIControlStateNormal];
    self.playerLevelLabel.text = [NSString stringWithFormat:@"%@%@%@%@", @"大区", self.viewModel.orderModel.platFormType.message, self.viewModel.orderModel.gameBoardRank.message, @"段位"];
    self.playerNumberLabel.text = self.viewModel.orderModel.patternType.message;
    self.gameStateLabel.text = [self.viewModel proceedStatusMsg];
    self.chargeLabel.text = ([self.viewModel.orderModel.depositType.name isEqualToString:@"FREE_FOR_BOARD"] ? @"免费" : @"收费");
    self.rightGameLogoImageView.image = [KKGameRoomContrastModel shareInstance].rankImageMapDic[self.viewModel.orderModel.gameBoardRank.name ?: @""];
}

- (void)reloadFootView {
    if (self.viewModel.loginUserIsRoomOwner) {
        [self reloadFootViewForOwner];
    } else {
        [self reloadFootViewForPlayer];
    }
}

/// 房主端
- (void)reloadFootViewForOwner {
    
    NSString *keyName = @"";
    if (self.viewModel.orderModel.patternType.name) {
        keyName = self.viewModel.orderModel.patternType.name;
    }
    NSInteger totalNumber = [[KKGameRoomContrastModel shareInstance].patternMapDic[keyName] integerValue];
    NSInteger totalAmount = totalNumber * self.viewModel.depositPrice;
    
    switch (self.viewModel.gameStatus) {
        case KKGameStatusPlayerEnter:
        {
            self.footView.hiddenTopView = YES;
            self.footView.hiddenBottomView = NO;
            
            if (self.viewModel.depositPrice > 0) {
                self.footView.titleString = [NSString stringWithFormat:@"本局收入%ldK币", (long)totalAmount];
            } else {
                self.footView.titleString = @"等待队友加入";
            }
            
            self.footView.subTitleString = [NSString stringWithFormat:@"订单编号：%@", self.viewModel.orderNoStr];
            [self.footView setTitle:@"分享" forState:UIControlStateNormal forButtonType:KKGameOrderDetailButtonTypeBorder];
            [self.footView setTitle:@"解散" forState:UIControlStateNormal forButtonType:KKGameOrderDetailButtonTypeNoBorder];
        }
            break;
        case KKGameStatusInPlaying:
        {
            self.footView.hiddenTopView = NO;
            self.footView.hiddenBottomView = NO;
            
            self.footView.evaluateTitleString = nil;
            self.footView.userGameTagArr = nil;
            self.footView.chargeTitleString = nil;
            if (self.viewModel.depositPrice > 0) {
                self.footView.chargeTitleString = [NSString stringWithFormat:@"收入%ldK币", (long)totalAmount];
            }
            self.footView.orderNoString = [NSString stringWithFormat:@"订单编号：%@", self.viewModel.orderNoStr];
            self.footView.gameEndString = [NSString stringWithFormat:@"开始时间：%@", self.viewModel.orderModel.gameGmtStart];
            self.footView.titleString = @"开始游戏啦";
            self.footView.subTitleString = @"点击进群，去一起游戏吧";
            [self.footView setTitle:@"结束" forState:UIControlStateNormal forButtonType:KKGameOrderDetailButtonTypeBorder];
            [self.footView setTitle:@"进群" forState:UIControlStateNormal forButtonType:KKGameOrderDetailButtonTypeNoBorder];
            
            // 设置不可交互倒计时
            CGFloat minFinishTime = self.viewModel.orderModel.allowFinishTimeConfig * 60.00;
            NSString *startTime = self.viewModel.orderModel.gameGmtStart;
            NSTimeInterval alreadyTime = fabs([KKGameTimeConvertModel timeIntervalBetweenNowWithDateStr:startTime]);
            [self setToolViewButtonUserEnable:(alreadyTime >= minFinishTime) duration:(minFinishTime - alreadyTime)];
        }
            break;
        case KKGameStatusGameOver:
        {
            self.footView.hiddenTopView = NO;
            self.footView.hiddenBottomView = YES;
            
            if ((NSInteger)self.viewModel.orderModel.userGameTag.count > 0) {
                self.footView.evaluateTitleString = @"被评为";
            } else {
                self.footView.evaluateTitleString = nil;
            }
            
            self.footView.userGameTagArr = self.viewModel.orderModel.userGameTag;
            self.footView.chargeTitleString = nil;
            if (self.viewModel.depositPrice > 0) {
                self.footView.chargeTitleString = [NSString stringWithFormat:@"收入%ldK币", (long)totalAmount];
            }
            self.footView.orderNoString = [NSString stringWithFormat:@"订单编号：%@", self.viewModel.orderNoStr];
            self.footView.gameEndString = [NSString stringWithFormat:@"结束时间：%@",
                                           self.viewModel.orderModel.purchaseEnd ?: self.viewModel.orderModel.gmtEvaluateEnd];
            
        }
            break;
        case KKGameStatusGameCancel:
        {
            self.footView.hiddenTopView = NO;
            self.footView.hiddenBottomView = YES;
            
            self.footView.evaluateTitleString = [NSString stringWithFormat:@"关闭原因：%@", self.viewModel.orderModel.properties.memo];
            self.footView.userGameTagArr = nil;
            self.footView.chargeTitleString = nil;
            if (self.viewModel.depositPrice > 0) {
                self.footView.chargeTitleString = @"队友支付的金额，已退回";
            }
            self.footView.orderNoString = [NSString stringWithFormat:@"订单编号：%@", self.viewModel.orderNoStr];
            self.footView.gameEndString = [NSString stringWithFormat:@"结束时间：%@",
                                           self.viewModel.orderModel.purchaseEnd ?: self.viewModel.orderModel.gmtEvaluateEnd];
        }
            break;
        case KKGameStatusGameFailSold:
        {
            self.footView.hiddenTopView = NO;
            self.footView.hiddenBottomView = YES;
            
            self.footView.evaluateTitleString = [NSString stringWithFormat:@"关闭原因：%@", self.viewModel.orderModel.properties.memo];
            self.footView.userGameTagArr = nil;
            self.footView.chargeTitleString = nil;
            if (self.viewModel.depositPrice > 0) {
                self.footView.chargeTitleString = @"队友支付的金额，已退回";
            }
            self.footView.orderNoString = [NSString stringWithFormat:@"订单编号：%@", self.viewModel.orderNoStr];
            self.footView.gameEndString = [NSString stringWithFormat:@"结束时间：%@",
                                           self.viewModel.orderModel.purchaseEnd ?: self.viewModel.orderModel.gmtEvaluateEnd];
        }
            break;
        default:
        {
            self.footView.hiddenTopView = YES;
            self.footView.hiddenBottomView = YES;
        }
            break;
    }
}

/// 普通玩家端
- (void)reloadFootViewForPlayer {
    switch (self.viewModel.gameStatus) {
        case KKGameStatusPlayerUnPay:
        {
            self.footView.hiddenTopView = YES;
            self.footView.hiddenBottomView = NO;
            
            self.footView.titleString = [NSString stringWithFormat:@"你将支付给房主%ldK币", (long)self.viewModel.depositPrice];
            
            NSString *countDownName = self.viewModel.orderNoStr;
            NSString *maxEvaluateTime = self.viewModel.orderModel.gmtStopPay;
            NSTimeInterval leftTime = [KKGameTimeConvertModel timeIntervalBetweenNowWithDateStr:maxEvaluateTime];
            leftTime = leftTime > 0 ? leftTime : 0;
            
            WS(weakSelf)
            [[KKCountDownManager standard] scheduledCountDownWithName:countDownName totalTime:leftTime create:YES countingDown:^(NSTimeInterval timerInterval) {
                NSString *leftTimeStr = [KKGameTimeConvertModel timeWithTimeInteval:timerInterval];
                weakSelf.footView.subTitleString = [NSString stringWithFormat:@"剩余支付时间：%@", leftTimeStr];
                
            } finished:^(NSTimeInterval timerInterval) {
                if (weakSelf.chargeToolView) {
                    [weakSelf.chargeToolView dismiss];
                }
                [weakSelf.viewModel requestForGameBoardEvaluateDetail:^{
                    [weakSelf reloadUI];
                }];
            }];
            
            [self.footView setTitle:@"取消" forState:UIControlStateNormal forButtonType:KKGameOrderDetailButtonTypeBorder];
            [self.footView setTitle:@"立即支付" forState:UIControlStateNormal forButtonType:KKGameOrderDetailButtonTypeNoBorder];
            
        }
            break;
        case KKGameStatusPlayerEnter:
        {
            self.footView.hiddenTopView = NO;
            self.footView.hiddenBottomView = YES;
            
            self.footView.evaluateTitleString = @"待房主开始游戏";
            self.footView.userGameTagArr = nil;
            
            if (self.viewModel.orderModel.gmtPay && self.viewModel.depositPrice > 0) {
                self.footView.chargeTitleString = [NSString stringWithFormat:@"已支付给房主（%@）%ldK币", self.viewModel.roomOwnerSimpleModel.userName, (long)self.viewModel.depositPrice];
                self.footView.gameEndString = [NSString stringWithFormat:@"支付时间：%@", self.viewModel.orderModel.gmtPay];
                
            } else {
                self.footView.chargeTitleString = nil;
                self.footView.gameEndString = [NSString stringWithFormat:@"创建时间：%@", self.viewModel.orderModel.purchaseCreate];
            }
            self.footView.orderNoString = [NSString stringWithFormat:@"订单编号：%@", self.viewModel.orderNoStr];
        }
            break;
        case KKGameStatusInPlaying:
        {
            self.footView.hiddenTopView = NO;
            self.footView.hiddenBottomView = NO;
            
            self.footView.evaluateTitleString = nil;
            self.footView.userGameTagArr = nil;
            self.footView.chargeTitleString = nil;
            if (self.viewModel.depositPrice > 0) {
                self.footView.chargeTitleString = [NSString stringWithFormat:@"已支付给房主（%@）%ldK币", self.viewModel.roomOwnerSimpleModel.userName, (long)self.viewModel.depositPrice];
            }
            self.footView.orderNoString = [NSString stringWithFormat:@"订单编号：%@", self.viewModel.orderNoStr];
            self.footView.gameEndString = [NSString stringWithFormat:@"开始时间：%@", self.viewModel.orderModel.gameGmtStart];
            self.footView.titleString = @"开始游戏啦";
            self.footView.subTitleString = @"点击进群，去一起游戏吧";
            [self.footView setTitle:@"结束" forState:UIControlStateNormal forButtonType:KKGameOrderDetailButtonTypeBorder];
            [self.footView setTitle:@"进群" forState:UIControlStateNormal forButtonType:KKGameOrderDetailButtonTypeNoBorder];
            
            // 设置不可交互倒计时
            CGFloat minFinishTime = self.viewModel.orderModel.allowFinishTimeConfig * 60.00;
            NSString *startTime = self.viewModel.orderModel.gameGmtStart;
            NSTimeInterval alreadyTime = fabs([KKGameTimeConvertModel timeIntervalBetweenNowWithDateStr:startTime]);
            [self setToolViewButtonUserEnable:(alreadyTime >= minFinishTime) duration:(minFinishTime - alreadyTime)];
            
        }
            break;
        case KKGameStatusGameOver:
        {
            self.footView.hiddenTopView = NO;
            self.footView.hiddenBottomView = YES;
            
            if ((NSInteger)self.viewModel.orderModel.userGameTag.count > 0) {
                self.footView.evaluateTitleString = @"被评为";
            } else {
                self.footView.evaluateTitleString = nil;
            }
            
            self.footView.userGameTagArr = self.viewModel.orderModel.userGameTag;
            self.footView.chargeTitleString = nil;
            if (self.viewModel.depositPrice > 0) {
                self.footView.chargeTitleString = [NSString stringWithFormat:@"已支付给房主（%@）%ldK币", self.viewModel.roomOwnerSimpleModel.userName, (long)self.viewModel.depositPrice];
            }
            self.footView.orderNoString = [NSString stringWithFormat:@"订单编号：%@", self.viewModel.orderNoStr];
            self.footView.gameEndString = [NSString stringWithFormat:@"结束时间：%@",
                                           self.viewModel.orderModel.purchaseEnd ?: self.viewModel.orderModel.gmtEvaluateEnd];
        }
            break;
        case KKGameStatusGameCancel:
        {
            self.footView.hiddenTopView = NO;
            self.footView.hiddenBottomView = YES;
            
            self.footView.evaluateTitleString = [NSString stringWithFormat:@"关闭原因：%@", self.viewModel.orderModel.properties.memo];
            self.footView.userGameTagArr = nil;
            self.footView.chargeTitleString = nil;
            if (self.viewModel.orderModel.gmtPay && self.viewModel.depositPrice > 0) {
                self.footView.chargeTitleString = [NSString stringWithFormat:@"支付给房主（%@）%ldK币！已退回余额", self.viewModel.roomOwnerSimpleModel.userName, (long)self.viewModel.depositPrice];
            }
            self.footView.orderNoString = [NSString stringWithFormat:@"订单编号：%@", self.viewModel.orderNoStr];
            self.footView.gameEndString = [NSString stringWithFormat:@"结束时间：%@",
                                           self.viewModel.orderModel.purchaseEnd ?: self.viewModel.orderModel.gmtEvaluateEnd];
        }
            break;
        case KKGameStatusGameFailSold:
        {
            self.footView.hiddenTopView = NO;
            self.footView.hiddenBottomView = YES;
            
            self.footView.evaluateTitleString = [NSString stringWithFormat:@"关闭原因：%@", self.viewModel.orderModel.properties.memo];
            self.footView.userGameTagArr = nil;
            self.footView.chargeTitleString = nil;
            if (self.viewModel.orderModel.gmtPay && self.viewModel.depositPrice > 0) {
                self.footView.chargeTitleString = [NSString stringWithFormat:@"支付给房主（%@）%ldK币！已退回余额", self.viewModel.roomOwnerSimpleModel.userName, (long)self.viewModel.depositPrice];
            }
            self.footView.orderNoString = [NSString stringWithFormat:@"订单编号：%@", self.viewModel.orderNoStr];
            self.footView.gameEndString = [NSString stringWithFormat:@"结束时间：%@",
                                           self.viewModel.orderModel.purchaseEnd ?: self.viewModel.orderModel.gmtEvaluateEnd];
        }
            break;
            
        default:
        {
            self.footView.hiddenTopView = YES;
            self.footView.hiddenBottomView = YES;
        }
            break;
    }
}

#pragma mark - CatDefaultPopDelegate
//取消
- (void)catDefaultPopCancel:(CatDefaultPop*)defualtPop {
    self.catPop = nil;
}

//确认
- (void)catDefaultPopConfirm:(CatDefaultPop*)defualtPop {
    WS(weakSelf)
    if (defualtPop.popView.tag == kk_cat_pop_tag_dissolve_room) {
        [self.viewModel requestForDissolveGameRoomSuccess:^{
            [CC_Notice show:@"解散成功"];
            [KKFloatViewMgr shareInstance].gameRoomModel = nil;
            [KKFloatViewMgr shareInstance].type = KKFloatViewTypeUnknow;
            [weakSelf p_clickNavBackButton];
        }];
    }
    //取消订单
    else if (defualtPop.popView.tag == kk_cat_pop_tag_cancel_order) {
        [self.viewModel requestForCancelOrderNo:nil success:^{
            [weakSelf reloadUI];
        }];
    }
    self.catPop = nil;
}

#pragma mark - KKGameOrderDetailFootViewDelegate
- (void)footViewDidClickBorderButton {
    
    KKGameStatus gameStatus = self.viewModel.gameStatus;
    WS(weakSelf)
    
    /// 房主
    if (self.viewModel.loginUserIsRoomOwner) {
        
        if (gameStatus == KKGameStatusPlayerEnter) {
            [self shareGameRoom];
            
        } else if (gameStatus == KKGameStatusInPlaying) {
            [self.viewModel requestForGameOver:^{
                [weakSelf jumpToEvaluateController];
                [weakSelf.viewModel requestForGameBoardEvaluateDetail:^{
                    [weakSelf reloadUI];
                }];
            }];
        }
        
        /// 非房主
    } else {
        if (gameStatus == KKGameStatusPlayerUnPay) {
            [self showAlertViewWithTitle:@"提示" subTitle:@"确定取消订单吗？" cancel:@"再想想" confirm:@"确定" tag:kk_cat_pop_tag_cancel_order];

        } else if (gameStatus == KKGameStatusInPlaying) {
            [self.viewModel requestForGameOver:^{
                [weakSelf jumpToEvaluateController];
                [weakSelf.viewModel requestForGameBoardEvaluateDetail:^{
                    [weakSelf reloadUI];
                }];
            }];
        }
    }
}

- (void)footViewDidClickNoBorderButton {
    
    KKGameStatus gameStatus = self.viewModel.gameStatus;
    WS(weakSelf)
    
    /// 房主
    if (self.viewModel.loginUserIsRoomOwner) {
        
        if (gameStatus == KKGameStatusPlayerEnter) {
            [self showAlertViewWithTitle:@"提示" subTitle:@"确定解散房间吗?" cancel:@"我再想想" confirm:@"确定" tag:kk_cat_pop_tag_dissolve_room];
            
        } else if (gameStatus == KKGameStatusInPlaying) {
            [self.viewModel requestForIntoGameGroupWithWechat:^(NSString * _Nullable urlStr) {
                [weakSelf jumpToShareWechatCodeImg:urlStr];
            } qq:^(NSString * _Nullable urlStr) {
                [weakSelf jumpToQQGroup:urlStr];
            }];
        }
        
        /// 非房主
    } else {
        if (gameStatus == KKGameStatusPlayerUnPay) {
            [self.viewModel requestForMyWalletInfo:^(KKMyWalletInfo * _Nonnull myWallet) {
                [weakSelf showChargeToolViewWithBalance:myWallet.accountInfoClientSimple.avaiableAmount];
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

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.gamePlayerNumbers;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KKPlayerCardCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KKPlayerCardCollectionCell class]) forIndexPath:indexPath];
    
    cell.forceHiddenJoinBtn = YES;
    cell.reachMaxPlayers = self.viewModel.reachMaxPlayers;
    cell.loginUserIsRoomOwner = self.viewModel.loginUserIsRoomOwner;
    cell.dataModel = self.viewModel.orderModel.dataList[indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


@end
