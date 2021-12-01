//
//  UITableView+KKDropDownAmplification.h
//  kk_espw
//
//  Created by hsd on 2019/7/12.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKHeaderAmplificationView.h"

NS_ASSUME_NONNULL_BEGIN

/// 头部视图自动下拉放大
@interface UITableView (KKDropDownAmplification)

@property (nonatomic, assign) UIEdgeInsets originContentInset;  ///< 安装自动下拉放大头视图后,原始inset

/**
 添加头部自动放大视图

 @param headerView 头部视图
 */
- (void)kkAddHeaderDropDownAmplificationView:(KKHeaderAmplificationView *)headerView;




@end

NS_ASSUME_NONNULL_END
