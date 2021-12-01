//
//  KKMyCardsViewController.m
//  kk_espw
//
//  Created by 景天 on 2019/7/15.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKMyCardsViewController.h"
#import "KKMyCardsListCell.h"
#import "KKAddMyCardViewController.h"
#import "KKMyCardService.h"
#import "KKCardTag.h"
#import "KKTag.h"
@interface KKMyCardsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tags;
@end

@implementation KKMyCardsViewController

#pragma mark - Init
- (NSMutableArray *)tags {
    if (!_tags) {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT + RH(15), SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_ADD_NAVIGATIONBARHEIGHT - RH(20)) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[KKMyCardsListCell class] forCellReuseIdentifier:@"KKMyCardsListCell"];
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

#pragma mark - Live Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUI];
    [self setUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestCardTagListInfo];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tags.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RH(130);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKMyCardsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKMyCardsListCell"];
    cell.model = self.tags[indexPath.row];
    WS(weakSelf)
    cell.tapEditCardBlock = ^(KKCardTag * _Nonnull cardInfo) {
        [weakSelf toPushEditCardVC:cardInfo];
    };
    return cell;
}

#pragma mark - UI
- (void)setNavUI {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"我的名片"];
    [self createAddCardButton];
}

- (void)createAddCardButton {
    WS(weakSelf)
    CC_Button *addCardButton = [CC_Button buttonWithType:UIButtonTypeCustom];
    addCardButton.frame = CGRectMake(SCREEN_WIDTH - RH(55 + 16), STATUS_BAR_HEIGHT + RH(16), RH(65), RH(13));
    addCardButton.titleLabel.font = RF(14);
    addCardButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [addCardButton setTitle:@"添加名片" forState:UIControlStateNormal];
    [addCardButton setTitleColor:KKES_COLOR_BLACK_TEXT forState:UIControlStateNormal];
    [addCardButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        [weakSelf toPushAddCardVC];
    }];
    [self.naviBar addSubview:addCardButton];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
}

#pragma mark - Jump
- (void)toPushAddCardVC {
    KKAddMyCardViewController *addCardVC = New(KKAddMyCardViewController);
    [self.navigationController pushViewController:addCardVC animated:YES];
}

- (void)toPushEditCardVC:(KKCardTag *)cardInfo {
    KKAddMyCardViewController *editCardVC = New(KKAddMyCardViewController);
    editCardVC.isEdit = @"YES";
    editCardVC.cardInfo = cardInfo;
    [self.navigationController pushViewController:editCardVC animated:YES];
}

#pragma mark - Net
/// 游戏档案查询
- (void)requestCardTagListInfo {
    [self.tags removeAllObjects];
    WS(weakSelf)
    [KKMyCardService requestCardTagListSuccess:^(NSMutableArray * _Nonnull dataList) {
        [weakSelf.tags addObjectsFromArray:dataList];
        if (weakSelf.tags.count > 0) {
            [weakSelf.tableView reloadData];
        }
    } Fail:^{
        
    }];
}
@end
