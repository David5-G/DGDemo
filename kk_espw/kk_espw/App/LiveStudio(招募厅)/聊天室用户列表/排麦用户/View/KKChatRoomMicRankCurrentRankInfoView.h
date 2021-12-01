//
//  KKLiveStudioMicRankCurrentRankInfoView.h
//  kk_espw
//
//  Created by david on 2019/7/24.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKChatRoomMicRankCurrentRankInfoView : UIView

/** 排名 */
@property (nonatomic, strong) UILabel *rankLabel;
/** 头像 */
@property (nonatomic, strong) UIImageView *portraitImageView;
/** 名字 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 徽章标签 本地图片名字 */
@property (nonatomic, copy) NSString *localImageName;

/** 排名信息label */
@property (nonatomic, strong) UILabel *rankInfoLabel;

/** 是否是 正在排麦 */
@property (nonatomic, assign,getter=isRanking) BOOL ranking;

@end

NS_ASSUME_NONNULL_END
