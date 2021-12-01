

//
//  KKVoiceTableView.m
//  kk_espw
//
//  Created by jingtian9 on 2019/10/11.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKVoiceTableView.h"
#import "KKVoiceRoomListCell.h"
@interface KKVoiceTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) CGPoint lastContentOffset;
@property (nonatomic, strong) NSMutableArray *data; /// 数据

@end

@implementation KKVoiceTableView
- (NSMutableArray *)data {
    if (!_data) {
        _data = [NSMutableArray array];
    }
    return _data;
}

- (void)setHeaderView:(KKJTHeaderView *)headerView{
    _headerView = headerView;
    self.dataSource = self;
    self.delegate = self;
    self.scrollIndicatorInsets = UIEdgeInsetsMake(headerView.height, 0, 0, 0);
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.headerView.height)];
    self.tableHeaderView = tableHeaderView;
    [self registerClass:[KKVoiceRoomListCell class] forCellReuseIdentifier:@"KKVoiceRoomListCell"];
}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat placeHolderHeight = self.headerView.height - 60;
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= 0 && offsetY <= placeHolderHeight) {
        if (offsetY > self.lastContentOffset.y) {
            //往上滑动
            if (offsetY > (-self.headerView.top)) {
                self.headerView.top = -offsetY;
            }
        }else
        {
            //往下滑动
            if (offsetY<(-self.headerView.top)) {
                self.headerView.top = -offsetY;
            }
        }
    }
    else if (offsetY > placeHolderHeight) {
        if (self.headerView.top != (-placeHolderHeight)) {
            if (offsetY > self.lastContentOffset.y) {
                //往上滑动
                self.headerView.top = self.headerView.top - (scrollView.contentOffset.y - self.lastContentOffset.y);
            }
            if (self.headerView.top < (-placeHolderHeight)) {
                self.headerView.top = -placeHolderHeight;
            }
            if (self.headerView.top >= 0) {
                self.headerView.top = 0;
            }
        }
    }
    else if (offsetY < 0) {
        self.headerView.top =  - offsetY;
    }
    self.lastContentOffset = scrollView.contentOffset;
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RH(128);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKVoiceRoomListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKVoiceRoomListCell"];
    if (indexPath.row < self.data.count) {
        cell.model = self.data[indexPath.row];
    }
    cell.isSearch = NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KKHomeVoiceRoomModel *model;
    if (indexPath.row < self.data.count) {
        model = self.data[indexPath.row];
    }
    if (self.didSelectRowVoiceAtIndexPathBlock) {
        self.didSelectRowVoiceAtIndexPathBlock(model);
    }
}

- (void)setDataList:(NSMutableArray *)dataList {
    self.data = dataList;
    [self reloadData];
}

@end

