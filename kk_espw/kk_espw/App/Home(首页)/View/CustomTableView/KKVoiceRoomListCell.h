//
//  KKVoiceRoomListCell.h
//  kk_espw
//
//  Created by jingtian9 on 2019/10/15.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKHomeVoiceRoomModel;
NS_ASSUME_NONNULL_BEGIN

@interface KKVoiceRoomListCell : UITableViewCell
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, strong) KKHomeVoiceRoomModel *model;
@end

NS_ASSUME_NONNULL_END
