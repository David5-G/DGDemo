//
//  KKPlayTogeOrderListViewController.m
//  kk_espw
//
//  Created by 景天 on 2019/7/18.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKPlayTogeOrderListViewController.h"
#import "KKPlayTogeListCell.h"
#import "KKPlayTTService.h"
#import "KKOrderListInfo.h"
#import "KKMessage.h"
#import "NoContentReminderView.h"
#import "KKGameWaitEvaluateController.h"
#import "KKGameChargeToolView.h"
#import "KKMyWalletService.h"
#import "KKMyWalletInfo.h"
#import "KKShareWQDView.h"
#import "KKH5Service.h"
#import "KKH5Url.h"
#import <IMUIKit/KKContactsController.h>
#import "KKConversationController.h"
#import "KKGameWaitEvaluateController.h"
#import "KKGameOrderDetailController.h"
#import "KKWeChatShareImageController.h"
@interface KKPlayTogeOrderListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NoContentReminderView *notDateView;
@property (nonatomic, strong) KKPaginator *paginator;
@property (nonatomic, strong) KKGameChargeToolView *payV;
@property (nonatomic, strong) KKOrderListInfo *orderListInfo;
@property (nonatomic, copy) NSString *shareURL;
@property (nonatomic, copy) NSString *config;
@property (nonatomic, copy) NSString *systemDate;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *timerEva;

@end

@implementation KKPlayTogeOrderListViewController
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

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT + RH(5), SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_ADD_NAVIGATIONBARHEIGHT - RH(5)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[KKPlayTogeListCell class] forCellReuseIdentifier:@"KKPlayTogeListCell"];
    }
    return _tableView;
}

#pragma mark - Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setNavUI];
    [self createTimer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - 倒计时
- (void)createTimer {
    self.timer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerEvent) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    self.timerEva = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(timerEvaEventEva) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timerEva forMode:NSRunLoopCommonModes];
}

- (void)timerEvent {
    for (int count = 0; count < _dataArray.count; count++) {
        KKOrderListInfo *model = _dataArray[count];
        [model countDown];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_CELL object:nil];
}

- (void)timerEvaEventEva {
    for (int count = 0; count < _dataArray.count; count++) {
        KKOrderListInfo *model = _dataArray[count];
        [model gameEvaluateEndCountDown];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_TIME_CELL_GAMEEND_EVA object:nil];
}

#pragma mark - UI
- (void)setUI {
    [self.view addSubview:self.tableView];
}

- (void)setNavUI {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"我的开黑房"];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RH(167);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKPlayTogeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKPlayTogeListCell"];
    KKOrderListInfo *model = [[KKOrderListInfo alloc] init];
    if (indexPath.row < self.dataArray.count) {
        model = self.dataArray[indexPath.row];
    }
    cell.model = model;
    [cell setConfig:_config systemDate:_systemDate];
    WS(weakSelf)
    cell.tapJoinGroupButtonBlock = ^(KKOrderListInfo * _Nonnull model) {
        [weakSelf requestForIntoGameGroupGameBoardId:model.gameBoardId];
    };
    cell.tapOperationButtonBlock = ^(UIButton * _Nonnull btn, KKOrderListInfo * _Nonnull model, NSString * _Nonnull can) {
        weakSelf.orderListInfo = model;
        if ([btn.currentTitle isEqualToString:@"结束并评价"]) {
            if ([can isEqualToString:@"can"]) {
                [weakSelf requestEndGameBoard];
            }
        }else if ([btn.currentTitle isEqualToString:@"解散对局"]) {
            [weakSelf requestDissolveGameBoardData:model.gameBoardId];
        }else if ([btn.currentTitle isEqualToString:@"立即支付"]) {
            [weakSelf requestForMyWalletInfo];
        }else if ([btn.currentTitle isEqualToString:@"立即评价"]) {
            [weakSelf pushWaitEvaluateVC];
        }
    };
    cell.tapShareButtonBlock = ^(KKOrderListInfo * _Nonnull model) {
        weakSelf.orderListInfo = model;
        
        NSArray *urls = [weakSelf.shareURL componentsSeparatedByString:@"?"];
        NSString *frantStr = urls.firstObject;
        NSString *lastStr = urls.lastObject;
        NSString *shareHeadUrl = [NSString stringWithFormat:@"%@", weakSelf.orderListInfo.ownerUserHeaderImgUrl];
        NSString *roomName = [weakSelf.orderListInfo.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *platFormType = weakSelf.orderListInfo.platFormType.name;
        NSString *rank = weakSelf.orderListInfo.gameRank.name;
        NSString *roomId = weakSelf.orderListInfo.gameRoomId;
        NSString *gameBoardId = weakSelf.orderListInfo.gameBoardId;
        
        weakSelf.shareURL = [NSString stringWithFormat:@"%@?shareHeadUrl=%@&roomName=%@&platFormType=%@&rank=%@&roomId=%@&gameBoardId=%@&%@", frantStr, shareHeadUrl, roomName, platFormType, rank, roomId, gameBoardId, lastStr];
        CCLOG(@"%@", weakSelf.shareURL);
        
        KKShareWQDView *shareV = [[KKShareWQDView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, RH(183))];
        [shareV showPopView];
        shareV.tapShareKKBlock = ^{
            [weakSelf pushContactVC];
        };
        shareV.tapShareQQBlock = ^{
            [KKShareTool configJShareWithPlatform:JSHAREPlatformQQ title:@"开黑房邀请" text:@"快进开黑房和我一起战斗吧！" url:weakSelf.shareURL type:RoomType];
        };
        shareV.tapShareWXBlock = ^{
            [KKShareTool configJShareWithPlatform:JSHAREPlatformWechatSession title:@"开黑房邀请" text:@"快进开黑房和我一起战斗吧！" url:weakSelf.shareURL type:RoomType];
            
        };
    };
    cell.didSelectCollectionCellBlock = ^(KKOrderListInfo * _Nonnull model) {
        if (model) {
            [weakSelf pushDetailVC:model];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    KKPlayTogeListCell *tmpCell = (KKPlayTogeListCell *)cell;
    tmpCell.m_isDisplayed = YES;
    [tmpCell loadData:_dataArray[indexPath.row] indexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KKOrderListInfo *model = [[KKOrderListInfo alloc] init];
    if (indexPath.row < self.dataArray.count) {
        model = self.dataArray[indexPath.row];
    }
    [self pushDetailVC:model];
}

- (void)pushDetailVC:(KKOrderListInfo *)model {
    if ([model.proceedStatus.name isEqualToString:@"EVALUATE"]) {
        KKGameWaitEvaluateController *vc = New(KKGameWaitEvaluateController);
        if (model.orderNo.length == 0) {
            return;
        }
        vc.orderNoStr = model.orderNo;
        vc.gameBoardIdStr = model.gameBoardId;
        [self.navigationController pushViewController:vc animated:YES];
        
    } else {
        if (model.orderNo.length == 0) {
            return;
        }
        KKGameOrderDetailController *vc = New(KKGameOrderDetailController);
        vc.orderNoStr = model.orderNo;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Net
- (void)loadData {
    WS(weakSelf)
    [self.tableView addSimpleHeaderRefresh:^{
        weakSelf.paginator.page = 1;
        [weakSelf.dataArray removeAllObjects];
        [weakSelf requestOrderListData];
        [weakSelf requestCanEvaTime];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        SS(strongSelf)
        if (strongSelf->_paginator.page < strongSelf->_paginator.pages) {
            strongSelf->_paginator.page++;
            if (strongSelf->_paginator.page >= 4) {
                [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }else {
                [strongSelf requestOrderListData] ;
            }
        }else{
            [strongSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)requestOrderListData {
    WS(weakSelf)
    [KKPlayTTService shareInstance].pageSize = @"10";
    [KKPlayTTService shareInstance].currentPage = self.paginator?@(self.paginator.page):@(1);
    [KKPlayTTService requestOrderListSuccess:^(NSMutableArray * _Nonnull dataList, KKPaginator * _Nonnull paginator) {
        [weakSelf.dataArray addObjectsFromArray:dataList];
        if (weakSelf.dataArray.count > 0) {
            [weakSelf.tableView reloadData];
            [weakSelf requestH5URLData];
        }
        if (weakSelf.dataArray.count == 0) {
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

/// 解散对局
- (void)requestDissolveGameBoardData:(NSString *)gameBoardId {
    WS(weakSelf)
    [KKPlayTTService requestDissolveGameBoardId:gameBoardId Success:^{
        
        [weakSelf loadData];
    } Fail:^{
        
    }];
}

/// 结束对局
- (void)requestEndGameBoard {
    WS(weakSelf)
    [KKPlayTTService requestEndGameBoardId:_orderListInfo.gameBoardId userId:[KKUserInfoMgr shareInstance].userId Success:^{
        [weakSelf pushWaitEvaluateVC];
    } Fail:^{
        
    }];
}

- (void)requestForMyWalletInfo {
    WS(weakSelf)
    [KKMyWalletService requestMyWalletInfoSuccess:^(KKMyWalletInfo * _Nonnull walletInfo) {
        [weakSelf showChargeToolViewWithBalance:walletInfo.accountInfoClientSimple.avaiableAmount];
    } Fail:^{
    }];
}

/// 余额支付
- (void)requestForPayOrderNo {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"PURCHASE_ORDER_PAY" forKey:@"service"];
    [params safeSetObject:self.orderListInfo.orderNo forKey:@"orderNo"];
    [params safeSetObject:@"ACCOUNT" forKey:@"payType"];
    [params safeSetObject:self.orderListInfo.deposit forKey:@"paidFee"];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error atView:weakSelf.view];
        }else {
            [CC_Notice show:@"支付成功" atView:weakSelf.view];
            [weakSelf loadData];
        }
    }];
}

/// 分享的链接
- (void)requestH5URLData {
    WS(weakSelf)
    [KKH5Service requestH5URLDataSuccess:^(KKH5Url * _Nonnull modelURL) {
        weakSelf.shareURL = modelURL.SHARE_DOWNLOAD;
    } Fail:^{
    }];
}

/// 可以结束配置时间
- (void)requestCanEvaTime{
    WS(weakSelf)
    [KKPlayTTService requestCanEvaluateTimeSuccess:^(NSString * _Nonnull config, NSString * _Nonnull systmeDate) {
        weakSelf.config = config;
        weakSelf.systemDate = systmeDate;
    } Fail:^{
    }];
}

/// 进群查询
- (void)requestForIntoGameGroupGameBoardId:(NSString *)gameBoardId {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_GROUP_QRCODEURL_QUERY" forKey:@"service"];
    [params safeSetObject:gameBoardId forKey:@"gameBoardId"];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error atView:weakSelf.view];
        } else {
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            if ([responseDic[@"groupType"] isEqualToString:@"WEIXIN"]) {
                [weakSelf jumpToShareWechatCodeImg:responseDic[@"url"]];
            } else {
                [weakSelf jumpToQQGroup:responseDic[@"gameGroupLink"]];
            }
        }
    }];
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

#pragma mark - Jump
- (void)pushWaitEvaluateVC {
    KKGameWaitEvaluateController *vc = New(KKGameWaitEvaluateController);
    vc.orderNoStr = self.orderListInfo.orderNo;
    vc.gameBoardIdStr = self.orderListInfo.gameBoardId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushContactVC {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"开黑房邀请" forKey:@"title"];
    [dic setValue:@"快进开黑房和我一起战斗吧！" forKey:@"subheading"];
    [dic setValue:self.orderListInfo.gameBoardId forKey:@"gameBoradId"];
    [dic setValue:[KKUserInfoMgr shareInstance].userId forKey:@"shareUserId"];
    [dic setValue:self.orderListInfo.ownerUserHeaderImgUrl forKey:@"ownerUserHeaderImgUrl"];
    WS(weakSelf)
    KKContactsController *vc = [[KKContactsController alloc] initWithType:KKContactsControllerTypeGameRoom extra:dic];
    vc.gameLinkedDidTippedBlock = ^(KKConversation * _Nullable conversation, NSString * _Nullable extra) {
        KKConversationController *controller = [[KKConversationController alloc] initWithConversation:conversation extra:extra];
        controller.view.backgroundColor = [UIColor whiteColor];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [CC_Notice showNoticeStr:@"分享成功" atView:self.view delay:2];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showChargeToolViewWithBalance:(NSNumber *)balance {
    CGFloat safeHeight = 0;
    if (@available(iOS 11.0, *)) {
        safeHeight = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    }
    _payV = [[KKGameChargeToolView alloc] initWithSafeBottom:safeHeight];
    [_payV setNickNameString:self.orderListInfo.ownerUserName];
    [_payV setBalanceCoinString:[NSString stringWithFormat:@"%@", balance ?: @"0"] unit:@"K币"];
    [_payV setChargeToGameRoomOwner:[NSString stringWithFormat:@"%@", self.orderListInfo.deposit] unit:@"K币"];
    NSString *iconUrlStr = [NSString stringWithFormat:@"%@", self.orderListInfo.ownerUserHeaderImgUrl];
    [_payV.iconImgView sd_setImageWithURL:[NSURL URLWithString:iconUrlStr]];
    
    WS(weakSelf)
    _payV.tapBlock = ^(KKGameChargeToolViewTapType tapType) {
        if (tapType == KKGameChargeToolViewTapTypeCertain) {
            [weakSelf requestForPayOrderNo];
            
        } else if (tapType == KKGameChargeToolViewTapTypeCancel ||
                   tapType == KKGameChargeToolViewTapTypeBackground) {
        }
    };
    [_payV showIn:self.view];
}
@end
