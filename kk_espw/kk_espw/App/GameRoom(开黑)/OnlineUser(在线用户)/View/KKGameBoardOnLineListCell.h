//
//  KKGameBoardOnLineListCell.h
//  kk_espw
//
//  Created by jingtian9 on 2019/10/22.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKChatRoomUserSimpleModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^forbiddenBlock)(KKChatRoomUserSimpleModel *model, UIButton *currnetButton);
@interface KKGameBoardOnLineListCell : UITableViewCell
@property (nonatomic, strong) KKChatRoomUserSimpleModel *model;
@property (nonatomic, copy) forbiddenBlock forbiddenBlock;
@property (nonatomic, assign) BOOL isForbiddenList;
@end

NS_ASSUME_NONNULL_END
