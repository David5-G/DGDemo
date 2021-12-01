//
//  KKGameReportTableHeaderView.h
//  kk_espw
//
//  Created by hsd on 2019/7/25.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKGameReportTableHeaderView : UIView

@property (nonatomic, strong, nullable) NSString *titleString;  ///< 标题
@property (nonatomic, strong, nullable) UIFont *titleFont;      ///< 字体

@property (nonatomic, assign) CGFloat topInset;             ///< 顶部距离

@end

NS_ASSUME_NONNULL_END
