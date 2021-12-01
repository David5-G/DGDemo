//
//  KKShareRoomView.h
//  kk_espw
//
//  Created by 景天 on 2019/8/2.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKHomeRecommendCell.h"
@class KKHomeRoomListInfo;
@class KKMessage;
@class KKShareGameInfo;
NS_ASSUME_NONNULL_BEGIN

@interface KKShareRoomView : UIView
@property (nonatomic, strong) KKHomeRoomListInfo *info;
@property (nonatomic, strong) KKShareGameInfo *shareInfo;
@property (nonatomic, strong) CC_Button *join;
@end

NS_ASSUME_NONNULL_END
