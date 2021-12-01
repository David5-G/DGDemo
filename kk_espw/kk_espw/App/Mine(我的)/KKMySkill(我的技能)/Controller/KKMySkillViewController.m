//
//  KKMySkillViewController.m
//  kk_espw
//
//  Created by 景天 on 2019/7/17.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKMySkillViewController.h"
#import "KKSettingPriceView.h"
#import "KKAboutMySkillService.h"
#import "KKGamePrice.h"
#import "KKUserMedelInfo.h"
@interface KKMySkillViewController()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *detailDataArray;
@property (nonatomic, strong) KKSettingPriceView *settingPriceView;
@property (nonatomic, strong) KKGamePrice *price;
@property (nonatomic, strong) UIImageView *godTag;
@property (nonatomic, strong) UILabel *priceLabel;

@end

@implementation KKMySkillViewController

- (NSMutableArray *)detailDataArray {
    if (!_detailDataArray) {
        _detailDataArray = [NSMutableArray array];
    }
    return _detailDataArray;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, RH(10) + STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, RH(49) * _dataArray.count) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (KKSettingPriceView *)settingPriceView {
    WS(weakSelf)
    if (!_settingPriceView) {
        _settingPriceView = [[KKSettingPriceView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _settingPriceView.tapComfirmButtonBlock = ^(NSString *ids, NSString *priceStr) {
            [weakSelf requestUpdateGamePriceIds:ids priceStr:priceStr];
        };
    }
    return _settingPriceView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = @[@"游戏", @"官方标签", @"价格"];

    [self setUI];
    [self setNavUI];
    
    [self requestGamePriceInfo];
}

- (void)setNavUI {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"我的技能"];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RH(49);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idr = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idr];
    }
    cell.textLabel.font = RF(15);
    cell.textLabel.textColor = KKES_COLOR_BLACK_TEXT;
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.detailTextLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:14];
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = @"王者荣耀";
    }else if (indexPath.row == 1) {
        _godTag = New(UIImageView);
        _godTag.left = RH(327);
        _godTag.top = RH(20);
        _godTag.size = CGSizeMake(RH(32), RH(13));
        [cell.contentView addSubview:_godTag];
    }else if (indexPath.row == 2) {
        _priceLabel = New(UILabel);
        _priceLabel.left = RH(277);
        _priceLabel.top = RH(18);
        _priceLabel.size = CGSizeMake(RH(65), RH(13));
        _priceLabel.textAlignment = NSTextAlignmentRight;
        _priceLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:14];
        _priceLabel.textColor = KKES_COLOR_GRAY_TEXT;
        [cell.contentView addSubview:_priceLabel];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        [self.view addSubview:self.settingPriceView];
        self.settingPriceView.model = self.price;
    }
}

#pragma mark - Net
- (void)requestGamePriceInfo {
    WS(weakSelf)
    [KKAboutMySkillService requestGamePriceSuccess:^(KKGamePrice * _Nonnull price) {
        /// 根据大神级别, 更换图片.
        weakSelf.godTag.image = Img([KKDataDealTool returnImageStr:price.userMedalDetail.currentMedalLevelConfigCode]);
        weakSelf.priceLabel.text = [NSString stringWithFormat:@"%@K币/人", price.gameBoardPrice];
        weakSelf.price = price;
    } Fail:^{
        
    }];
}

- (void)requestUpdateGamePriceIds:(NSString *)ids priceStr:(NSString *)priceStr {
    WS(weakSelf)
    [KKAboutMySkillService shareInstance].userGameBoardPriceConfigId = ids;
    [KKAboutMySkillService shareInstance].modifiPrice = priceStr;
    [KKAboutMySkillService requestUpdatePriceSuccess:^{
        [weakSelf.settingPriceView removeFromSuperview];
        [weakSelf requestGamePriceInfo];
    } Fail:^{
        
    }];
}
@end
