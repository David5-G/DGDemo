//
//  UICollectionView+KKDropDownAmplification.h
//  kk_espw
//
//  Created by hsd on 2019/7/15.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKHeaderAmplificationView.h"


/// 头部视图自动下拉放大
@interface UICollectionView (KKDropDownAmplification)

/**
 添加头部自动放大视图
 
 @param headerView 头部视图
 */
- (void)kkAddHeaderDropDownAmplificationView:(KKHeaderAmplificationView *)headerView;

@end

