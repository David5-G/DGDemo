//
//  KKGameReportController.h
//  kk_espw
//
//  Created by hsd on 2019/7/25.
//  Copyright © 2019 david. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKGameReportController : BaseViewController
@property (nonatomic,copy) NSString *userId;//被举报人id
@property (nonatomic,copy) NSString *complaintObjectId;//举报主体id,名片profile id 或人 userid
@end

NS_ASSUME_NONNULL_END
