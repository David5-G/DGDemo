//
//  UIScrollView+Refresh.m
// 
//
//  Created by david on 15/4/11.
//  Copyright © 2015年 GW. All rights reserved.
//

#import "UIScrollView+Refresh.h"

@implementation UIScrollView (Refresh)

#pragma mark - add
/** 添加S简单的头部刷新 没有上次刷新时间,没有状态 */
- (void)addSimpleHeaderRefresh:(MJRefreshComponentRefreshingBlock)block {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    self.mj_header = header;
}

/** 添加头部刷新 */
- (void)addHeaderRefresh:(MJRefreshComponentRefreshingBlock)block{
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
}
/** 添加脚部自动刷新 */
- (void)addAutoFooterRefresh:(MJRefreshComponentRefreshingBlock)block{
    self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:block];
}
/** 添加脚部自动刷新 */
-(void)addAutoFooterRefreshWithPercent:(CGFloat)percent block:(MJRefreshComponentRefreshingBlock)block {
    
    if (percent<0 || percent>1.0) {
        percent = 1.0;
    }
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:block];
    footer.triggerAutomaticallyRefreshPercent = percent;
    self.mj_footer = footer;
}
/** 添加脚步返回刷新 */
- (void)addBackFooterRefresh:(MJRefreshComponentRefreshingBlock)block{
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:block];
}

#pragma mark - begin/end
/** 开始头部刷新 */
- (void)beginHeaderRefresh{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.mj_header beginRefreshing];
    }];
}
/** 开始脚部刷新 */
- (void)beginFooterRefresh{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.mj_footer beginRefreshing];
    }];
}
/** 结束头部刷新 */
- (void)endHeaderRefresh{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.mj_header endRefreshing];
    }];
}
/** 结束脚部刷新 */
- (void)endFooterRefresh{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.mj_footer endRefreshing];
    }];
}

/** 结束脚步刷新并设置没有更多数据 */
- (void)endFooterRefreshWithNoMoreData{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.mj_footer endRefreshingWithNoMoreData];
    }];
}
@end












