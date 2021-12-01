//
//  KKCapitalDetailViewController.m
//  kk_espw
//
//  Created by 景天 on 2019/7/23.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKCapitalDetailViewController.h"
#import "KKCapitalDetailHeadView.h"
#import "NoContentReminderView.h"
#import <CatDateSelect.h>
#import "KKCapotalDetailCell.h"
#import "KKCapitalService.h"
@interface KKCapitalDetailViewController ()<UITableViewDelegate, UITableViewDataSource, CatDateSelectDelegate, KKCapitalDetailHeadViewDelegate>
@property (nonatomic, strong) KKCapitalDetailHeadView *capitalDetailHeadView;
@property (nonatomic, copy) NSString *selectType;
@property (nonatomic, copy) NSString *startDate;
@property (nonatomic, copy) NSString *endDate;
@property (nonatomic, strong) NoContentReminderView *notDateView;
@property (nonatomic, strong) CatDateSelect *startDateSelect;
@property (nonatomic, strong) CatDateSelect *endDateSelect;
@property (nonatomic, strong) UITableView *tableViewInCome;
@property (nonatomic, strong) UITableView *tableViewFreeze;
@property (nonatomic, strong) NSMutableArray *dataAccountArray;
@property (nonatomic, strong) NSMutableArray *dataFreezeArray;
@property (nonatomic, strong) KKPaginator *paginatorIncome;
@property (nonatomic, strong) KKPaginator *paginatorFreeze;

@end

@implementation KKCapitalDetailViewController
#pragma mark - Init
- (NoContentReminderView *)notDateView{
    if (!_notDateView) {
        _notDateView = [[NoContentReminderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 200)];
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"暂无数据!" withColor:[UIColor grayColor]];
        [NoContentReminderView showReminderViewToView:_notDateView imageTopY:(SCREEN_HEIGHT - 300) / 2 image:[UIImage imageNamed:@"data_is_null"] remindWords:attribute];
        _notDateView.hidden = YES;
    }
    return _notDateView;
}

- (KKCapitalDetailHeadView *)capitalDetailHeadView {
    if (!_capitalDetailHeadView) {
        _capitalDetailHeadView = [[KKCapitalDetailHeadView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, RH(100))];
        _capitalDetailHeadView.delegate = self;
    }
    return _capitalDetailHeadView;
}

- (UITableView *)tableViewInCome {
    if (!_tableViewInCome) {
        _tableViewInCome = [[UITableView alloc] initWithFrame:CGRectMake(0, _capitalDetailHeadView.bottom + RH(10), SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_ADD_NAVIGATIONBARHEIGHT - _capitalDetailHeadView.height - RH(10)) style:UITableViewStylePlain];
        _tableViewInCome.delegate = self;
        _tableViewInCome.dataSource = self;
        _tableViewInCome.tableFooterView = New(UIView);
        [_tableViewInCome registerClass:[KKCapotalDetailCell class] forCellReuseIdentifier:@"KKCapotalDetailCell"];
    }
    return _tableViewInCome;
}

- (UITableView *)tableViewFreeze {
    if (!_tableViewFreeze) {
        _tableViewFreeze = [[UITableView alloc] initWithFrame:CGRectMake(0, _capitalDetailHeadView.bottom + RH(10), SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_ADD_NAVIGATIONBARHEIGHT - _capitalDetailHeadView.height - RH(10)) style:UITableViewStylePlain];
        _tableViewFreeze.delegate = self;
        _tableViewFreeze.dataSource = self;
        _tableViewFreeze.tableFooterView = New(UIView);
        [_tableViewFreeze registerClass:[KKCapotalDetailCell class] forCellReuseIdentifier:@"KKCapotalDetailCell"];
    }
    return _tableViewFreeze;
}

- (NSMutableArray *)dataAccountArray {
    if (!_dataAccountArray) {
        _dataAccountArray = [NSMutableArray array];
    }
    return _dataAccountArray;
}

- (NSMutableArray *)dataFreezeArray {
    if (!_dataFreezeArray) {
        _dataFreezeArray = [NSMutableArray array];
    }
    return _dataFreezeArray;
}

#pragma mark - UI
- (void)setUI{
    [self.view addSubview:self.capitalDetailHeadView];
    _startDate = _capitalDetailHeadView.calendarLeftButton.currentTitle;
    _endDate = _capitalDetailHeadView.calendarRightButton.currentTitle;
    
    [self createDateSelectView];
    [self.view addSubview:self.tableViewInCome];
    [self.view addSubview:self.tableViewFreeze];
    
    _tableViewFreeze.hidden = YES;
}

- (void)setNavUI{
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"资金明细"];
}

/// 创建日期选择器
- (void)createDateSelectView {
    _startDateSelect = [[CatDateSelect alloc] initWithCancelTitle:@"取消" confirmTitle:@"确认" theme:CatDateSelectThemeDay minDate:nil maxDate:[CatDateSelectTool caculateCurrentDate]];
    _startDateSelect.delegate = self;
    
    _endDateSelect = [[CatDateSelect alloc] initWithCancelTitle:@"取消" confirmTitle:@"确认" theme:CatDateSelectThemeDay minDate:nil maxDate:[CatDateSelectTool caculateCurrentDate]];
    _endDateSelect.delegate = self;
}

#pragma mark - CatDateSelectDelegate
- (void)catDateSelectConfirm:(CatDateSelect *)dateSelect selectYear:(NSString *)selectYear selectMonth:(NSString *)selectMonth selectDay:(NSString *)selectDay selectWeek:(NSString *)selectWeek {
    if (dateSelect == _startDateSelect) {
        NSString *date = [NSString stringWithFormat:@"%@-%@-%@", selectYear, selectMonth, selectDay];
        [_capitalDetailHeadView.calendarLeftButton setTitle:date forState:UIControlStateNormal];
        
        _startDate = date;
        
    }else {
        NSString *date = [NSString stringWithFormat:@"%@-%@-%@", selectYear, selectMonth, selectDay];
        [_capitalDetailHeadView.calendarRightButton setTitle:date forState:UIControlStateNormal];
        
        _endDate = date;
    }
}

#pragma mark - KKCapitalDetailHeadViewDelegate
- (void)tapedIncomeButton {
    _selectType = @"收支";
    _tableViewInCome.hidden = NO;
    _tableViewFreeze.hidden = YES;
}

- (void)tapedFreezeButton {
    _selectType = @"冻结";
    _tableViewInCome.hidden = YES;
    _tableViewFreeze.hidden = NO;
    [_tableViewFreeze reloadData];
}

- (void)tapedStartDateButton {
    [_startDateSelect popUpCatDateSelectView];
}

- (void)tapedEndDateButton {
    [_endDateSelect popUpCatDateSelectView];
}

- (void)tapedSearchButton {
    if ([_selectType isEqualToString:@"收支"]) {
        [self loadData];
    }else {
        [self loadDataFreeze];
    }
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([_selectType isEqualToString:@"收支"]) {
        
        return self.dataAccountArray.count;
    }else {
        return self.dataFreezeArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKCapotalDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKCapotalDetailCell"];
    if ([_selectType isEqualToString:@"收支"]) {
        cell.capitalAccount = self.dataAccountArray[indexPath.row];
    }else {
        cell.capitalFreeze = self.dataFreezeArray[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RH(64);
}

#pragma mark - Cycle
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setNavUI];
    [self setUI];
    _selectType = @"收支";
    [self loadData];
    [self loadDataFreeze];
}

#pragma mark - Net

- (void)loadData {
    WS(weakSelf)
    self.tableViewInCome.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.paginatorIncome.page = 1;
        [weakSelf.dataAccountArray removeAllObjects];
        [weakSelf requestCapitalAccountData];
    }];
    [self.tableViewInCome.mj_header beginRefreshing];
    self.tableViewInCome.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        SS(strongSelf)
        if (strongSelf->_paginatorIncome.page < strongSelf->_paginatorIncome.pages) {
            strongSelf->_paginatorIncome.page++;
            [weakSelf requestCapitalAccountData];
        }else{
            [strongSelf.tableViewInCome.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)loadDataFreeze {
    WS(weakSelf)
    self.tableViewFreeze.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.paginatorFreeze.page = 1;
        [weakSelf.dataFreezeArray removeAllObjects];
        [weakSelf requestCapitalFreezeData];
    }];
    [self.tableViewFreeze.mj_header beginRefreshing];
    self.tableViewFreeze.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        SS(strongSelf)
        if (strongSelf->_paginatorFreeze.page < strongSelf->_paginatorFreeze.pages) {
            strongSelf->_paginatorFreeze.page++;
            [weakSelf requestCapitalFreezeData];
        }else{
            [strongSelf.tableViewFreeze.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

- (void)requestCapitalAccountData {
    WS(weakSelf)
    CCLOG(@"%@\n%@", _startDate, _endDate);
    NSNumber *currentPage = self.paginatorIncome?@(self.paginatorIncome.page):@(1);
    [KKCapitalService requestCapitalAccountDataWithStartDate:_startDate EndDate:_endDate CurrentPage:currentPage Success:^(NSMutableArray * _Nonnull dataList, KKPaginator * _Nonnull paginator) {
        [weakSelf.dataAccountArray addObjectsFromArray:dataList];
        [weakSelf.tableViewInCome reloadData];
        
        if (weakSelf.dataAccountArray.count == 0) {
            weakSelf.tableViewInCome.tableFooterView = weakSelf.notDateView;
            weakSelf.notDateView.hidden = NO;
        }else {
            weakSelf.tableViewInCome.tableFooterView = New(UIView);
            weakSelf.notDateView.hidden = YES;
        }
        weakSelf.paginatorIncome = paginator;
        [weakSelf.tableViewInCome.mj_footer endRefreshing];
        [weakSelf.tableViewInCome.mj_header endRefreshing];
    } Fail:^{
        [weakSelf.tableViewInCome.mj_footer endRefreshing];
        [weakSelf.tableViewInCome.mj_header endRefreshing];

    }];
}

- (void)requestCapitalFreezeData {
    WS(weakSelf)
    CCLOG(@"%@\n%@", _startDate, _endDate);
    NSNumber *currentPage = self.paginatorFreeze?@(self.paginatorFreeze.page):@(1);
    [KKCapitalService requestCapitalFreezeDataWithStartDate:_startDate EndDate:_endDate CurrentPage:currentPage Success:^(NSMutableArray * _Nonnull dataList, KKPaginator * _Nonnull paginator) {
        [weakSelf.dataFreezeArray addObjectsFromArray:dataList];
        [weakSelf.tableViewFreeze reloadData];
        
        if (weakSelf.dataFreezeArray.count == 0) {
            weakSelf.tableViewFreeze.tableFooterView = weakSelf.notDateView;
            weakSelf.notDateView.hidden = NO;
        }else {
            weakSelf.tableViewFreeze.tableFooterView = New(UIView);
            weakSelf.notDateView.hidden = YES;
        }
        weakSelf.paginatorFreeze = paginator;
        [weakSelf.tableViewFreeze.mj_footer endRefreshing];
        [weakSelf.tableViewFreeze.mj_header endRefreshing];
    } Fail:^{
        [weakSelf.tableViewFreeze.mj_footer endRefreshing];
        [weakSelf.tableViewFreeze.mj_header endRefreshing];

    }];
}
@end
