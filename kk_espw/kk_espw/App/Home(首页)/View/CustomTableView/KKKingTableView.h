//
//  KKKingTableView.h
//  kk_espw
//
//  Created by jingtian9 on 2019/10/11.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKJTHeaderView.h"
@class KKHomeRoomListInfo;
NS_ASSUME_NONNULL_BEGIN
typedef void(^didSelectRowAtIndexPathBlock)(KKHomeRoomListInfo *info);
@interface KKKingTableView : UITableView
@property (nonatomic, strong) KKJTHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataList; /// 数据
@property (nonatomic, copy) didSelectRowAtIndexPathBlock didSelectRowAtIndexPathBlock;
@end

NS_ASSUME_NONNULL_END
