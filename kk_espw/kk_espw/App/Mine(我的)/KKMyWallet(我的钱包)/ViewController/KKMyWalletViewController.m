//
//  KKMyWalletViewController.m
//  kk_espw
//
//  Created by 景天 on 2019/7/17.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKMyWalletViewController.h"
#import "KKMyWalletRechargeViewController.h"
#import "KKCapitalDetailViewController.h"
#import "KKMyWalletService.h"
#import "KKMyWalletInfo.h"
@interface KKMyWalletViewController ()
@property (nonatomic, strong) UILabel *balanceAccountL;
@property (nonatomic, strong) UILabel *myBalanceAccountL;
@property (nonatomic, strong) UILabel *myIncomeAccountL;
@end


@implementation KKMyWalletViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setNavUI];
    
    [self requestMyWalletInfo];
}

#pragma mark - UI
- (void)setNavUI {
    WS(weakSelf)
    [self setNaviBarWithType:DGNavigationBarTypeClear];
    [self setNaviBarTitle:@"我的钱包"];
    [self setNaviBarTitleColor:[UIColor whiteColor]];
    [self.naviBar.backButton setImage:Img(@"nav_back_white") forState:UIControlStateNormal];
    /// 右侧明细按钮
    CC_Button *detailButton = [CC_Button buttonWithType:UIButtonTypeCustom];
    detailButton.left = SCREEN_WIDTH - RH(35 + 17);
    detailButton.top = STATUS_BAR_HEIGHT + RH(14);
    detailButton.size = CGSizeMake(RH(35), RH(15));
    [detailButton setTitle:@"明细" forState:UIControlStateNormal];
    [detailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    detailButton.titleLabel.font = RF(15);
    [self.naviBar addSubview:detailButton];
    [detailButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        [weakSelf pushToWallatDetailVC];
    }];
}

- (void)setUI{
    WS(weakSelf)
    /// 底部背景
    UIImageView *bgV = New(UIImageView);
    bgV.left = 0;
    bgV.top = 0;
    bgV.size = CGSizeMake(SCREEN_WIDTH, RH(259));
    bgV.image = Img(@"my_wallet_bg");
    [self.view addSubview:bgV];
    /// 我的余额
    UILabel *balanceL = New(UILabel);
    balanceL.left = RH(44);
    balanceL.top = RH(40) + STATUS_BAR_HEIGHT;
    balanceL.size = CGSizeMake(RH(60), RH(12));
    balanceL.font = RF(12);
    balanceL.text = @"可用余额";
    balanceL.textColor = KKES_COLOR_GRAY_TEXT;
    [bgV addSubview:balanceL];
    ///
    _balanceAccountL = New(UILabel);
    _balanceAccountL.left = RH(0);
    _balanceAccountL.top = RH(85) + STATUS_BAR_HEIGHT;
    _balanceAccountL.size = CGSizeMake(SCREEN_WIDTH, RH(30));
    _balanceAccountL.font = RF(24);
    _balanceAccountL.textAlignment = NSTextAlignmentCenter;
    _balanceAccountL.textColor = KKES_COLOR_MAIN_YELLOW;
    [bgV addSubview:_balanceAccountL];
    ///
    UILabel *myBalanceL = New(UILabel);
    myBalanceL.left = RH(44);
    myBalanceL.top = RH(42) + _balanceAccountL.bottom;
    myBalanceL.size = CGSizeMake(RH(70), RH(12));
    myBalanceL.font = RF(12);
    myBalanceL.textAlignment = NSTextAlignmentLeft;
    myBalanceL.adjustsFontSizeToFitWidth = YES;
    myBalanceL.text = @"我的总余额";
    myBalanceL.textColor = KKES_COLOR_GRAY_TEXT;
    [bgV addSubview:myBalanceL];
    ///
    _myBalanceAccountL = New(UILabel);
    _myBalanceAccountL.left = RH(44);
    _myBalanceAccountL.top = RH(15) + myBalanceL.bottom;
    _myBalanceAccountL.size = CGSizeMake(RH(120), RH(16));
    _myBalanceAccountL.font = RF(12);
    _myBalanceAccountL.textAlignment = NSTextAlignmentLeft;

    _myBalanceAccountL.textColor = [UIColor whiteColor];
    [bgV addSubview:_myBalanceAccountL];
    /// 我的收入
    UILabel *myIncomeL = New(UILabel);
    myIncomeL.left = RH(228);
    myIncomeL.top = myBalanceL.top;
    myIncomeL.size = CGSizeMake(RH(147), RH(12));
    myIncomeL.adjustsFontSizeToFitWidth = YES;
    myIncomeL.font = RF(12);
    myIncomeL.textAlignment = NSTextAlignmentLeft;
    myIncomeL.text = @"我的收入(无法用于下单)";
    myIncomeL.textColor = KKES_COLOR_GRAY_TEXT;
    [bgV addSubview:myIncomeL];
    /// 我的收入
    _myIncomeAccountL = New(UILabel);
    _myIncomeAccountL.left = myIncomeL.left;
    _myIncomeAccountL.top = RH(15) + myIncomeL.bottom;
    _myIncomeAccountL.size = CGSizeMake(myIncomeL.width, RH(16));
    _myIncomeAccountL.font = RF(12);
    _myIncomeAccountL.textAlignment = NSTextAlignmentLeft;
    _myIncomeAccountL.textColor = [UIColor whiteColor];
    [bgV addSubview:_myIncomeAccountL];
    
    /// 充值
    CC_Button *rechargeButton = [CC_Button buttonWithType:UIButtonTypeCustom];
    rechargeButton.left = RH(30);
    rechargeButton.top = bgV.bottom + RH(34);
    rechargeButton.size = CGSizeMake(SCREEN_WIDTH - 2 * RH(30), RH(48));
    [rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
    [rechargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rechargeButton.titleLabel.font = RF(16);
    rechargeButton.layer.cornerRadius = 5;
    rechargeButton.backgroundColor = KKES_COLOR_MAIN_YELLOW;
//    [self.view addSubview:rechargeButton];
    [rechargeButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        [weakSelf pushWalletRechargeVC];
    }];
}

#pragma mark - Jump
- (void)pushToWallatDetailVC {
    KKCapitalDetailViewController *vc = New(KKCapitalDetailViewController);
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)pushWalletRechargeVC {
    KKMyWalletRechargeViewController *vc = New(KKMyWalletRechargeViewController);
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Net
- (void)requestMyWalletInfo {
    WS(weakSelf)
    [KKMyWalletService requestMyWalletInfoSuccess:^(KKMyWalletInfo * _Nonnull walletInfo) {
        [weakSelf updateAccountInfo:walletInfo];
    } Fail:^{
        
    }];
}

- (void)updateAccountInfo:(KKMyWalletInfo *)info {
    NSString *aviBalance = [NSString stringWithFormat:@"%@K币", info.accountInfoClientSimple.avaiableAmount];
    NSString *totalBalance = [NSString stringWithFormat:@"%@K币", [info.rewardAccountInfoClientSimple.avaiableAmount decimalNumberByAdding:info.accountInfoClientSimple.avaiableAmount]];
    NSString *rewardAvaiableAmount = [NSString stringWithFormat:@"%@K币", info.rewardAccountInfoClientSimple.avaiableAmount];
    _balanceAccountL.attributedText = [self getAttrStr:aviBalance frontFont:40 aFont:20 aIndex:2];
    _myBalanceAccountL.attributedText = [self getAttrStr:totalBalance frontFont:21 aFont:12 aIndex:2];
    _myIncomeAccountL.attributedText = [self getAttrStr:rewardAvaiableAmount frontFont:21 aFont:12 aIndex:2];
}

@end
