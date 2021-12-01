//
//  KKLiveStudioForbidWordUserListView.h
//  kk_espw
//
//  Created by david on 2019/7/25.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKLiveStudioBlockDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKLiveStudioForbidWordUserListView : UIView

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, copy) NSArray <id>*dataArray;
-(void)setConfigBlock:(KKLiveStudioConfigBlock)configBlock selectBlock:(KKLiveStudioSelectBlock)selectBlock;

/** 是否是 主播查看 */
@property (nonatomic, assign) BOOL isHostCheck;

@end

NS_ASSUME_NONNULL_END
