//
//  KKGameReportTypeCell.h
//  kk_espw
//
//  Created by hsd on 2019/7/25.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKGameReportTypeCell : UITableViewCell

@property (nonatomic, strong, nullable) NSString *titleString;      ///< 标题
@property (nonatomic, assign) BOOL reportSelect;                ///< 是否选中

@end

NS_ASSUME_NONNULL_END
