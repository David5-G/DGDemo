//
//  KKLiveStudioForbidWordUserCell.h
//  kk_espw
//
//  Created by david on 2019/7/25.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomUserListBaseCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface KKChatRoomForbidWordCell : KKChatRoomUserListBaseCell

/** 头像 */
@property (nonatomic, strong) UIImageView *portraitImageView;
/** 名字 */
@property (nonatomic, strong) UILabel *nameLabel;
/** 徽章标签 本地图片名字 */
@property (nonatomic, copy) NSString *localImageName;

#pragma mark 主播权限
/** 是否是 主播查看 */
@property (nonatomic, assign) BOOL isHostCheck;
/** cell的代理 */
@property (nonatomic, weak) id<KKChatRoomUserListBaseCellDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
