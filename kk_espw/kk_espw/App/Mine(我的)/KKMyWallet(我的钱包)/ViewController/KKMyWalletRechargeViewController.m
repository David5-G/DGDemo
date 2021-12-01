//
//  KKMyWalletRechargeViewController.m
//  kk_espw
//
//  Created by 景天 on 2019/7/18.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKMyWalletRechargeViewController.h"
#import "KKKCoinCollectionViewCell.h"
#import "KKMyWalletService.h"
#import "KKRechargeInfo.h"
#import "KKRechargeRate.h"
#import "KKIAPManager.h"

@interface KKMyWalletRechargeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel *balanceAccountL;
@property (nonatomic, strong) KKRechargeRate *defaultModel;
@property (nonatomic, copy) NSString *fundChannelId;

@end

@implementation KKMyWalletRechargeViewController
#pragma mark - Init
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setNavUI];
    
    [self requestWalletRecharge];
}

#pragma mark - UI
- (void)setNavUI {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"K币充值"];
}

- (void)setUI {
    /// 底部白色V
    UIView *whiteV = New(UIView);
    whiteV.left = 0;
    whiteV.top = STATUSBAR_ADD_NAVIGATIONBARHEIGHT;
    whiteV.size = CGSizeMake(SCREEN_WIDTH, RH(69));
    whiteV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteV];
    /// 可用余额
    UILabel *balanceL = New(UILabel);
    balanceL.left = RH(15);
    balanceL.top = RH(27);
    balanceL.size = CGSizeMake(RH(63), RH(14));
    balanceL.text = @"可用余额:";
    balanceL.font = RF(15);
    balanceL.textColor = KKES_COLOR_BLACK_TEXT;
    [whiteV addSubview:balanceL];
    ///
    _balanceAccountL = New(UILabel);
    _balanceAccountL.left = RH(10) + balanceL.right;
    _balanceAccountL.top = RH(22);
    _balanceAccountL.size = CGSizeMake(RH(150), RH(14));
    _balanceAccountL.textColor = KKES_COLOR_MAIN_YELLOW;
    [whiteV addSubview:_balanceAccountL];
    
    /// 底部白色V2
    UIView *whiteV2 = New(UIView);
    whiteV2.left = 0;
    whiteV2.top = whiteV.bottom + RH(10);
    whiteV2.size = CGSizeMake(SCREEN_WIDTH, RH(242));
    whiteV2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteV2];
    /// 选择充值金额
    UILabel *selectBalanceL = New(UILabel);
    selectBalanceL.left = RH(15);
    selectBalanceL.top = RH(19);
    selectBalanceL.size = CGSizeMake(RH(90), RH(14));
    selectBalanceL.text = @"选择充值金额";
    selectBalanceL.font = RF(15);
    selectBalanceL.textColor = KKES_COLOR_BLACK_TEXT;
    [whiteV2 addSubview:selectBalanceL];
    /// 金额
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView =
    [[UICollectionView alloc] initWithFrame:CGRectMake(0, RH(51), SCREEN_WIDTH - RH(37), RH(190)) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView registerClass:[KKKCoinCollectionViewCell class]
        forCellWithReuseIdentifier:@"KKKCoinCollectionViewCell"];
    [whiteV2 addSubview:_collectionView];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    _collectionView.bounces = YES;
    
    /// 充值
    WS(weakSelf)
    CC_Button *commit = [CC_Button buttonWithType:UIButtonTypeCustom];
    commit.left = RH(30);
    commit.bottom = SCREEN_HEIGHT - RH(26) - HOME_INDICATOR_HEIGHT - RH(48);
    commit.size = CGSizeMake(SCREEN_WIDTH - 2 * RH(30), RH(48));
    [commit setTitle:@"确定" forState:UIControlStateNormal];
    [commit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commit.titleLabel.font = RF(16);
    commit.layer.cornerRadius = 5;
    commit.backgroundColor = KKES_COLOR_MAIN_YELLOW;
    [self.view addSubview:commit];
    
    [commit addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        [weakSelf requestRecharge];
    }];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(RH(95), RH(70));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KKKCoinCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"KKKCoinCollectionViewCell"
                                              forIndexPath:indexPath];
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    cell.rate = self.dataArray[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.defaultModel = self.dataArray[indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Net
- (void)requestWalletRecharge {
    WS(weakSelf)
    [KKMyWalletService requestMyWalletRechargeInfoSuccess:^(KKRechargeInfo * _Nonnull rechargeInfo) {
        for (NSInteger i = 0; i < rechargeInfo.priceList.count; i ++) {
            KKRechargeRate *rate = [[KKRechargeRate alloc] init];
            NSString *rmb = rechargeInfo.priceList[i];
            rate.rmb = rmb;
            rate.kCoin = [NSString stringWithFormat:@"%.1fK币", rmb.floatValue * rechargeInfo.iosExchangeRate.floatValue];
            [weakSelf.dataArray addObject:rate];
        }
        if (weakSelf.dataArray.count > 0) {
            [weakSelf.collectionView reloadData];
        }
        /// 充值通道ID
        KKChannels *channels = New(KKChannels);
        channels = rechargeInfo.fundChannels.firstObject;
        weakSelf.fundChannelId = channels.ID;
        /// 充值默认金额
        weakSelf.defaultModel = weakSelf.dataArray.firstObject;
        weakSelf.balanceAccountL.attributedText = [self getAttrStr:[NSString stringWithFormat:@"%@K币", rechargeInfo.userBaseInfo.avaiableAmount] frontFont:25 aFont:15 aIndex:2];
    } Fail:^{
        
    }];
}

- (void)requestRecharge {
    [KKMyWalletService shareInstance].fundChannelId = _fundChannelId;
    [KKMyWalletService shareInstance].amount = _defaultModel.rmb;
    [KKMyWalletService requestToRechargeInfoSuccess:^(KKRechargeInfo * _Nonnull rechargeInfo) {
        
    } Fail:^{
        
    }];
}

- (void)dealloc {
    [KKMyWalletService destroyInstance];
}
@end
