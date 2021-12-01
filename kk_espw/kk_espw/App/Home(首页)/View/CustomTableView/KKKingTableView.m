//
//  KKKingTableView.m
//  kk_espw
//
//  Created by jingtian9 on 2019/10/11.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKKingTableView.h"
#import "KKHomeRecommendCell.h"
#import "KKHomeRoomListInfo.h"
@interface KKKingTableView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) CGPoint lastContentOffset;
@property (nonatomic, strong) NSMutableArray *data; /// 数据

@end

@implementation KKKingTableView
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
    [self registerClass:[KKHomeRecommendCell class] forCellReuseIdentifier:@"KKHomeRecommendCell"];
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
    return [ccui getRH:153];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKHomeRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKHomeRecommendCell"];
    if (indexPath.row < self.data.count) {
        cell.info = self.data[indexPath.row];
    }
    cell.isSearch = NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KKHomeRoomListInfo *info;
    if (indexPath.row < self.data.count) {
        info = self.data[indexPath.row];
    }
    if (self.didSelectRowAtIndexPathBlock) {
        self.didSelectRowAtIndexPathBlock(info);
    }
}

- (void)setDataList:(NSMutableArray *)dataList {
    self.data = dataList;
    [self reloadData];
}
@end
