//
//  KKHomeRecommendCell.h
//  kk_espw
//
//  Created by 景天 on 2019/7/11.
//  Copyright © 2019年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKHomeRoomListInfo;
@class KKMessage;

NS_ASSUME_NONNULL_BEGIN

@interface KKHomeRecommendCell : UITableViewCell
@property (nonatomic, strong) KKHomeRoomListInfo *info;
@property (nonatomic, assign) BOOL isSearch;
@end

NS_ASSUME_NONNULL_END
