//
//  KKGameWaitEvaluateController.m
//  kk_espw
//
//  Created by hsd on 2019/7/26.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameWaitEvaluateController.h"
#import "KKGameWaitEvaluateTitleView.h"
#import "KKGameWaitEvaluateFooterView.h"
#import "KKGameOverEvaluateCell.h"
#import "KKGameEvaluateDetailQueryModel.h"
#import "KKCountDownManager.h"
#import "KKGameTimeConvertModel.h"
#import "KKGameOrderDetailController.h"
#import "KKGameRoomContrastModel.h"

@interface KKGameWaitEvaluateController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong, nonnull) UITableView *tableView;
@property (nonatomic, strong, nonnull) KKGameWaitEvaluateTitleView *headerView;
@property (nonatomic, strong, nonnull) KKGameWaitEvaluateFooterView *footerView;
@property (nonatomic, strong, nonnull) CC_Button *evaluateBtn;

@property (nonatomic, strong, nullable) KKGameEvaluateDetailQueryModel *queryModel; ///< 数据模板
@property (nonatomic, strong, nonnull) NSMutableDictionary<NSString *, NSString *> *evaluateMutDic; ///< 评价信息

@end

@implementation KKGameWaitEvaluateController
#pragma mark - get
- (NSMutableDictionary<NSString *,NSString *> *)evaluateMutDic {
    if (!_evaluateMutDic) {
        _evaluateMutDic = [NSMutableDictionary dictionary];
    }
    return _evaluateMutDic;
}

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self initTableHeaderView];
    [self initTableFooterView];
    [self initBeginGameBtn];
    [self requestForEvaluateDetail];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[KKFloatViewMgr shareInstance] hiddenGameRoomFloatView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[KKFloatViewMgr shareInstance] notHiddenGameRoomFloatView];
}

#pragma mark - override
// 本页面已经从父页面中移除
- (void)didMoveToParentViewController:(UIViewController *)parent {
    if (parent == nil) {
        [self cancelCountDownEnable];
    }
}

#pragma mark - init
- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style: UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.delaysContentTouches = NO;
    self.tableView.bounces = NO;
    
    //防止刷新单个cell时, tableView跳动到其他的cell的位置
    self.tableView.estimatedRowHeight = 0.0;
    self.tableView.estimatedSectionHeaderHeight = 0.0;
    self.tableView.estimatedSectionFooterHeight = 0.0;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self.gameSuperView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameSuperView).mas_offset(16);
        make.right.mas_equalTo(self.gameSuperView).mas_offset(-22);
        make.top.mas_equalTo(self.playerNumberLabel.mas_bottom).mas_offset(27);
        make.bottom.mas_equalTo(self.gameSuperView).mas_offset(-160);
    }];
}

- (void)initTableHeaderView {
    self.headerView = [[KKGameWaitEvaluateTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 47)];
    self.tableView.tableHeaderView = self.headerView;
}

- (void)initTableFooterView {
    self.footerView = [[KKGameWaitEvaluateFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 27)];
    self.tableView.tableFooterView = self.footerView;
}

- (void)initBeginGameBtn {
    self.evaluateBtn = [[CC_Button alloc] init];
    self.evaluateBtn.backgroundColor = KKES_COLOR_HEX(0xECC165);
    self.evaluateBtn.layer.cornerRadius = 5;
    self.evaluateBtn.layer.masksToBounds = YES;
    self.evaluateBtn.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:16];
    [self.evaluateBtn setTitle:@"提交评价" forState:UIControlStateNormal];
    [self.evaluateBtn setTitleColor:KKES_COLOR_HEX(0xFFFFFF) forState:UIControlStateNormal];
    [self.evaluateBtn setTitleColor:KKES_COLOR_HEX(0x929292) forState:UIControlStateHighlighted];
    [self.gameSuperView addSubview:self.evaluateBtn];
    [self.evaluateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameSuperView).mas_offset(56);
        make.right.mas_equalTo(self.gameSuperView).mas_offset(-72);
        make.height.mas_equalTo(38);
        make.bottom.mas_equalTo(self.gameSuperView).mas_offset(-52);
    }];
    
    WS(weakSelf)
    [self.evaluateBtn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        [weakSelf requestForEvaluateOtherPlayers];
    }];
}

#pragma mark - Action
/// 取消定时器
- (void)cancelCountDownEnable {
    NSString *countDownName = [NSString stringWithFormat:@"%@+%@", self.orderNoStr, self.gameBoardIdStr];
    [[KKCountDownManager standard] removeTaskWithName:countDownName];
}

- (void)reloadUI {
    [self reloadGameRoomUI];
    [self reloadTableHeaderView];
    [self reloadTableFooterView];
    [self.tableView reloadData];
}

- (void)reloadGameRoomUI {
    KKGameBoardClientSimpleModel *roomInfo = self.queryModel.gameBoard;
    [self.navBackBtn setTitle:[NSString stringWithFormat:@"ID:%ld", (long)roomInfo.gameRoomId] forState:UIControlStateNormal];
    self.playerLevelLabel.text = [NSString stringWithFormat:@"%@%@%@%@", @"大区", roomInfo.platformType.message, roomInfo.rank.message, @"段位"];
    self.playerNumberLabel.text = roomInfo.patternType.message;
    self.gameStateLabel.text = roomInfo.proceedStatus.message;
    self.chargeLabel.text = ([roomInfo.depositType.name isEqualToString:@"FREE_FOR_BOARD"] ? @"免费" : @"收费");
    self.rightGameLogoImageView.image = [KKGameRoomContrastModel shareInstance].rankImageMapDic[roomInfo.rank.name ?: @""];
}

- (void)reloadTableHeaderView {
    NSString *countDownName = [NSString stringWithFormat:@"%@+%@", self.orderNoStr, self.gameBoardIdStr];
    NSString *maxEvaluateTime = self.queryModel.gmtEvaluateEnd;
    NSTimeInterval leftTime = [KKGameTimeConvertModel timeIntervalBetweenNowWithDateStr:maxEvaluateTime];
    leftTime = leftTime > 0 ? leftTime : 0;
    
    WS(weakSelf)
    [[KKCountDownManager standard] scheduledCountDownWithName:countDownName totalTime:leftTime create:YES countingDown:^(NSTimeInterval timerInterval) {
        NSString *leftTimeStr = [KKGameTimeConvertModel timeWithTimeInteval:timerInterval];
        weakSelf.headerView.countdownStr = leftTimeStr;
        
    } finished:^(NSTimeInterval timerInterval) {
        [weakSelf jumpToGameOverVC];
    }];
}

- (void)reloadTableFooterView {
    self.footerView.titleString = [NSString stringWithFormat:@"订单编号：%@", self.orderNoStr];
}

- (void)jumpToGameOverVC {
    KKGameOrderDetailController *vc = [[KKGameOrderDetailController alloc] init];
    vc.orderNoStr = self.orderNoStr;
    vc.gameBoardIdStr = self.gameBoardIdStr;
    [self.navigationController pushViewController:vc animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.navigationController.viewControllers containsObject:self]) {
            NSMutableArray *mutArr = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [mutArr removeObject:self];
            self.navigationController.viewControllers = [mutArr copy];
        }
    });
}

#pragma mark - 处理数据
- (void)checkBoxSelect:(BOOL)isSelect evaluateStr:(NSString * _Nullable)evaluateStr indexPath:(NSIndexPath * _Nonnull)indexPath {
    NSString *indexPathStr = [NSString stringWithFormat:@"[%ld,%ld]", indexPath.section, indexPath.row];
    if (isSelect) {
        [self.evaluateMutDic safeSetObject:evaluateStr forKey:indexPathStr];
    } else {
        [self.evaluateMutDic removeObjectForKey:indexPathStr];
    }
}

- (void)dealWithEvaluateDdetailSimpleData:(NSDictionary *)responseDic {
    KKGameEvaluateDetailQueryModel *queryModel = [KKGameEvaluateDetailQueryModel mj_objectWithKeyValues:responseDic];
    
    NSMutableArray <KKGameEvaluateUserSimpleModel *> *userArr = [NSMutableArray array];
    for (KKGameEvaluateUserSimpleModel *userModel in queryModel.userGameBoardEvaluateClientSimpleList) {
        if (userModel.userId && ![userModel.userId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
            userModel.isRoomOwner = [userModel.userId isEqualToString:queryModel.gameBoard.ownerUserId];
            [userArr addObject:userModel];
        }
    }
    
    queryModel.userGameBoardEvaluateClientSimpleList = [userArr copy];
    self.queryModel = queryModel;
}

#pragma mark - 网络请求
/// 获取评价列表模板
- (void)requestForEvaluateDetail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_EVALUATE_DETAIL_QUERY" forKey:@"service"];
    [params safeSetObject:self.gameBoardIdStr forKey:@"gameBoardId"];
    [params safeSetObject:self.orderNoStr forKey:@"orderNo"];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error atView:weakSelf.view];
        } else {
            [weakSelf dealWithEvaluateDdetailSimpleData:resModel.resultDic[@"response"]];
            [weakSelf reloadUI];
        }
    }];
}

/// 提交评价
- (void)requestForEvaluateOtherPlayers {
    
    NSString *evaluateStr = [self.evaluateMutDic.allValues componentsJoinedByString:@","];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"USER_GAME_BOARD_EVALUATE_CREATE" forKey:@"service"];
    [params safeSetObject:self.gameBoardIdStr forKey:@"gameBoardId"];
    [params safeSetObject:self.orderNoStr forKey:@"orderNo"];
    [params safeSetObject:evaluateStr forKey:@"userEvaluateInfo"];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error atView:weakSelf.view];
        } else {
            [CC_Notice show:@"评价成功" atView:weakSelf.view];
            [weakSelf jumpToGameOverVC];
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.queryModel.userGameBoardEvaluateClientSimpleList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKGameOverEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([KKGameOverEvaluateCell class])];
    if (!cell) {
        cell = [[KKGameOverEvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([KKGameOverEvaluateCell class])];
    }
    cell.backgroundColor = KKES_COLOR_HEX(0x100D15);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userModel = self.queryModel.userGameBoardEvaluateClientSimpleList[indexPath.section];
    cell.tagArray = self.queryModel.gameTagClientSimpleList;
    
    WS(weakSelf)
    cell.boxSelectBlock = ^(BOOL isSelect, NSString * _Nullable evaluateStr) {
        [weakSelf checkBoxSelect:isSelect evaluateStr:evaluateStr indexPath:indexPath];
    };
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 3 ? 0.01 : 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [UIView new];
    footerView.backgroundColor = tableView.backgroundColor;
    return footerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
