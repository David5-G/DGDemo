//
//  KKCreateGameRoomController.h
//  kk_espw
//
//  Created by hsd on 2019/7/12.
//  Copyright © 2019 david. All rights reserved.
//

#import "BaseViewController.h"
typedef NS_ENUM(NSUInteger, KKRoomType) {
    KKGameType, /// 开黑房
    KKVoiceType, /// 语音房
};
@class KKCardTag;

/// 创建开黑房
@interface KKCreateGameRoomController : BaseViewController

@property (nonatomic, copy, nonnull) NSArray<KKCardTag *> *cardList;    ///< 名片数据源
@property (nonatomic, copy, nullable) NSString *depositPrice;       ///< 收费价格

@end
