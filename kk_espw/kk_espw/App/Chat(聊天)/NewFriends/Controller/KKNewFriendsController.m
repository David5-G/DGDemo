//
//  KKNewFriendsController.m
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/11.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKNewFriendsController.h"
#import "KKNewFriendsCell.h"
#import "KKNewFriendsHeaderView.h"

static NSString *newFriendsCellId = @"newFriendsCellId";
static NSString *newFriendsHeaderCellId = @"newFriendsHeaderCellId";

@interface KKNewFriendsController ()<UITableViewDelegate, UITableViewDataSource, KKNewFriendsCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation KKNewFriendsController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupViews];
    
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"新朋友"];
}

- (void)setupViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_ADD_NAVIGATIONBARHEIGHT) style:UITableViewStylePlain];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [UIColor whiteColor];
    [_tableView registerClass:[KKNewFriendsCell class] forCellReuseIdentifier:newFriendsCellId];
    [_tableView registerClass:[KKNewFriendsHeaderView class] forHeaderFooterViewReuseIdentifier:newFriendsHeaderCellId];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

// MARK: - KKNewFriendsCellDelegate

- (void)acceptNewFriendsDidTipped:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        sender.backgroundColor = [UIColor whiteColor];
    } else {
        sender.backgroundColor = rgba(236, 193, 101, 1);
    }
}

// MARK: - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKNewFriendsCell *newFriendsCell = [tableView dequeueReusableCellWithIdentifier:newFriendsCellId forIndexPath:indexPath];
    newFriendsCell.selectionStyle = UITableViewCellSelectionStyleNone;
    newFriendsCell.delegate = self;
    return newFriendsCell;
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 0.01)];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    KKNewFriendsHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:newFriendsHeaderCellId];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32;
}

@end

