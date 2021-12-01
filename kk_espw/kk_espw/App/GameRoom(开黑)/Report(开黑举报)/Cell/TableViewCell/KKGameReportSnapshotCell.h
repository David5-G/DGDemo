//
//  KKGameReportScreenshotCell.h
//  kk_espw
//
//  Created by hsd on 2019/7/25.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ReportImageSelected)(NSArray *imgArr);

/// 截图cell
@interface KKGameReportSnapshotCell : UITableViewCell

@property (nonatomic,copy) ReportImageSelected imageSelect;

@end

NS_ASSUME_NONNULL_END
