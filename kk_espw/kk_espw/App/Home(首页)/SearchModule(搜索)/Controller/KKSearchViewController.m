//
//  KKSearchViewController.m
//  kk_espw
//
//  Created by 景天 on 2019/7/23.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKSearchViewController.h"
#import "MiSearchBar.h"
#import "KKHomeRecommendCell.h"
#import "KKHomeService.h"
@interface KKSearchViewController ()
<
UISearchBarDelegate,
UITableViewDelegate,
UITableViewDataSource
>

@property (nonatomic, strong) MiSearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation KKSearchViewController
#pragma mark - Init
- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MiSearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[MiSearchBar alloc] initWithFrame:CGRectMake(RH(15), STATUS_BAR_HEIGHT + RH(9), SCREEN_WIDTH - RH(70), RH(35)) placeholder:@"请输入房间ID"];
        _searchBar.placeholder = @"  搜索";
        [_searchBar becomeFirstResponder];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, self.searchBar.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - self.searchBar.bottom) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = New(UIView);
        [_tableView registerClass:[KKHomeRecommendCell class] forCellReuseIdentifier:@"KKHomeRecommendCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RH(142);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKHomeRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKHomeRecommendCell"];
    cell.info = self.dataList[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return RH(58);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [self getHeaderView];
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self requestSearchDataKey:searchBar.text];
}

#pragma mark - UI
- (void)setUI {
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    
}

- (void)setNavUI {
    WS(weakSelf)
    [self setNaviBarWithType:DGNavigationBarTypeClear];
    [self hideBackButton:YES];
    CC_Button *cancel = [CC_Button buttonWithType:UIButtonTypeCustom];
    cancel.left = RH(14) + self.searchBar.right;
    cancel.top = self.searchBar.top + RH(10);
    cancel.size = CGSizeMake(RH(29), RH(14));
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel setTitleColor:RGB(102, 102, 102) forState:UIControlStateNormal];
    cancel.titleLabel.font = RF(15);
    [self.view addSubview:cancel];
    [cancel addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        [weakSelf popToHomeVC];
    }];
}

- (UIView *)getHeaderView {
    UIView *v = New(UIView);
    v.left = 0;
    v.top = 0;
    v.size = CGSizeMake(SCREEN_WIDTH, 58);
    v.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(RH(16), RH(25), [ccui getRH:100], [ccui getRH:13])];
    label.numberOfLines = 0;
    label.text = @"ID匹配结果";
    label.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:14];
    label.textColor = KKES_COLOR_BLACK_TEXT;
    [v addSubview:label];
    return v;
}

#pragma mark - Jump
- (void)popToHomeVC {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Net
- (void)requestSearchDataKey:(NSString *)key {
    WS(weakSelf)
    [KKHomeService shareInstance].gameRoomId = key;
    [KKHomeService requestHomeListSuccess:^(NSMutableArray * _Nonnull dataList, KKPaginator * _Nonnull paginator) {
        
        weakSelf.dataList = dataList;
        if (weakSelf.dataList.count != 0) {
            [weakSelf.tableView reloadData];
        }
    } Fail:^{
    }];
}

#pragma mark - Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
    [self setNavUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
}
@end
