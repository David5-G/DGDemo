//
//  KKVoiceTableView.h
//  kk_espw
//
//  Created by jingtian9 on 2019/10/11.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKJTHeaderView.h"
@class KKHomeVoiceRoomModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^didSelectRowVoiceAtIndexPathBlock)(KKHomeVoiceRoomModel *model);
@interface KKVoiceTableView : UITableView
@property (nonatomic, strong) KKJTHeaderView *headerView;
@property (nonatomic, strong) NSMutableArray *dataList; /// 数据
@property (nonatomic, copy) didSelectRowVoiceAtIndexPathBlock didSelectRowVoiceAtIndexPathBlock;
@end

NS_ASSUME_NONNULL_END
