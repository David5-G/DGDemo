//
//  KKNewSearchViewController.h
//  kk_espw
//
//  Created by jingtian9 on 2019/10/16.
//  Copyright © 2019 david. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, KKSearchRoomType) {
    KKGameRoomType, //开黑房
    KKVoiceRoomType, //语音房
};
@interface KKNewSearchViewController : BaseViewController
@property (nonatomic, assign) KKSearchRoomType type;
@end

NS_ASSUME_NONNULL_END
