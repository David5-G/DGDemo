//
//  KKLiveStudioMicRankCell.h
//  kk_espw
//
//  Created by david on 2019/7/24.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomUserListBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKChatRoomMicRankCell : KKChatRoomUserListBaseCell
/** 排名 */
@property (nonatomic, strong) UILabel *rankLabel;
/** 头像 */
@property (nonatomic, strong) UIImageView *portraitImageView;
/** 名字 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 徽章标签 本地图片名字 */
@property (nonatomic, copy) NSString *localImageName;

#pragma mark 主播权限
/** 是否是 主播查看 */
@property (nonatomic, assign) BOOL isHostCheck;
/** 是否是 被禁言 (isHostCheck=YES才会有)*/
@property (nonatomic, assign) BOOL isForbid;
/** 是否是 正在麦上 (isHostCheck=YES才会有)*/
@property (nonatomic, assign) BOOL isOnMic;
/** 给麦(抱上麦) (isHostCheck=YES才会有)*/
@property (nonatomic, strong) UIButton *giveMicButton;
/** cell的代理 */
@property (nonatomic, weak) id<KKChatRoomUserListBaseCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
