//
//  KKGameOverController.m
//  kk_espw
//
//  Created by hsd on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameOverController.h"
#import "KKPlayerCardCollectionCell.h"
#import "KKGameOverFootView.h"
#import "KKGameOrderTagDetailModel.h"
#import "KKGameRoomContrastModel.h"

static NSInteger kk_game_player_numbers                 = 5;

@interface KKGameOverController ()

@property (nonatomic, strong, nonnull) KKGameOverFootView *footView;
@property (nonatomic, strong, nullable) KKGameOrderTagDetailModel *orderModel;

@end

@implementation KKGameOverController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self p_initPlayerListView];
    [self initFootView];
    [self registerCollectionViewCell];
    [self requestForGameBoardEvaluateDetail];
}

#pragma mark - Init
- (void)initFootView {
    self.footView = [[KKGameOverFootView alloc] init];
    [self.gameSuperImageView addSubview:self.footView];
    [self.footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.gameSuperImageView);
        make.height.mas_equalTo(90);
        make.bottom.mas_equalTo(self.gameSuperImageView).mas_offset(-179);
    }];
}

- (void)registerCollectionViewCell {
    [self.playerListView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(255);
    }];
    [self.playerListView registerNib:[UINib nibWithNibName:NSStringFromClass([KKPlayerCardCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([KKPlayerCardCollectionCell class])];
}

#pragma mark - 刷新
- (void)reloadUI {
    [self reloadGameRoomUI];
    [self reloadFootView];
    [self.playerListView reloadData];
}

- (void)reloadGameRoomUI {
    [self.navBackBtn setTitle:[NSString stringWithFormat:@"ID:%ld", self.orderModel.gameRoomId] forState:UIControlStateNormal];
    self.playerLevelLabel.text = [NSString stringWithFormat:@"%@%@%@%@", @"大区", self.orderModel.platFormType.message, self.orderModel.gameBoardRank.message, @"段位"];
    self.playerNumberLabel.text = self.orderModel.patternType.message;
    self.gameStateLabel.text = self.orderModel.proceedStatus.message;
    self.chargeLabel.text = ([self.orderModel.depositType.name isEqualToString:@"FREE_FOR_BOARD"] ? @"免费" : @"收费");
}

- (void)reloadFootView {
    self.footView.evaluateTitleString = @"被评为";
    self.footView.chargeTitleString = [NSString stringWithFormat:@"支付给房主%ldK币", self.orderModel.purchaseDeposit];
    self.footView.orderNoString = [NSString stringWithFormat:@"订单编号：%@", self.orderModel.orderNo];
    self.footView.gameEndString = [NSString stringWithFormat:@"结束时间：%@", self.orderModel.gmtEvaluateEnd];
    self.footView.userGameTagArr = [self.orderModel.userGameTag copy];
}

#pragma mark - 数据处理
- (void)dealWithEvaluateDetailData:(NSDictionary *)responseDic {
    KKGameOrderTagDetailModel *orderModel = [KKGameOrderTagDetailModel mj_objectWithKeyValues:responseDic];
    
    NSMutableArray<KKGameBoardDetailSimpleModel *> *playerInfos = [NSMutableArray arrayWithCapacity:kk_game_player_numbers];
    
    //填充占位数据
    for (NSInteger index = 0; index < kk_game_player_numbers; index ++) {
        [playerInfos addObject:[[KKGameBoardDetailSimpleModel alloc] init]];
    }
    
    // 遍历
    for (KKGameBoardDetailSimpleModel *simpleModel in orderModel.dataList) {
        
        simpleModel.isRoomOwner = [simpleModel.userId isEqualToString:orderModel.ownerUserId];
        
        // 排序
        NSString *name = simpleModel.gamePosition.firstObject.name;
        if (name && [KKGameRoomContrastModel shareInstance].positionMapDic[name]) {
            simpleModel.playRoadString = [KKGameRoomContrastModel shareInstance].positionMapDic[name].title;
            NSInteger index = [KKGameRoomContrastModel shareInstance].positionMapDic[name].position;
            [playerInfos replaceObjectAtIndex:index withObject:simpleModel];
        }
    }
    
    orderModel.dataList = [playerInfos copy];
    self.orderModel = orderModel;
}

#pragma mark - 网络请求
/// 获取本局游戏对我的评价
- (void)requestForGameBoardEvaluateDetail {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"PURCHASE_ORDER_DETAIL_QUERY" forKey:@"service"];
    [params safeSetObject:self.orderNoStr forKey:@"orderNo"];
    
    WS(weakSelf)
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice show:error atView:weakSelf.view];
        } else {
            [weakSelf dealWithEvaluateDetailData:resModel.resultDic[@"response"]];
            [weakSelf reloadUI];
        }
    }];
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KKPlayerCardCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([KKPlayerCardCollectionCell class]) forIndexPath:indexPath];
    
    cell.forceHiddenJoinBtn = YES;
    cell.dataModel = self.orderModel.dataList[indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


@end
