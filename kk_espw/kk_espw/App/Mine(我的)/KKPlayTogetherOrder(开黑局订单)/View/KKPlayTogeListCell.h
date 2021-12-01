//
//  KKPlayTogeListCell.h
//  kk_espw
//
//  Created by 景天 on 2019/7/18.
//  Copyright © 2019年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKOrderListInfo;
NS_ASSUME_NONNULL_BEGIN
typedef void(^tapOperationButtonBlock)(UIButton *btn, KKOrderListInfo *model, NSString *can);
typedef void(^tapJoinGroupButtonBlock)(KKOrderListInfo *model);
typedef void(^tapShareButtonBlock)(KKOrderListInfo *model);
typedef void(^didSelectCollectionCellBlock)(KKOrderListInfo *model);
@interface KKPlayTogeListCell : UITableViewCell
@property (nonatomic, strong) KKOrderListInfo *model;
@property (nonatomic, copy) tapOperationButtonBlock tapOperationButtonBlock;
@property (nonatomic, copy) tapShareButtonBlock tapShareButtonBlock;
@property (nonatomic, copy) tapJoinGroupButtonBlock tapJoinGroupButtonBlock;
@property (nonatomic, copy) didSelectCollectionCellBlock didSelectCollectionCellBlock;

@property (nonatomic, assign) BOOL m_isDisplayed;

- (void)setConfig:(NSString *)config systemDate:(NSString *)systemDate;
/**
 *  == [子类可以重写] ==
 *
 *  加载数据
 *
 *  @param data      数据
 *  @param indexPath 数据编号
 */
- (void)loadData:(id)data indexPath:(NSIndexPath*)indexPath;
@end

NS_ASSUME_NONNULL_END
