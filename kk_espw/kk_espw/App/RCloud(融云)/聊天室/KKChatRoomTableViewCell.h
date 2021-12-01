//
//  KKChatRoomTableViewCell.h
//  kk_espw
//
//  Created by 阿杜 on 2019/8/16.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class KKChatRoomMessage;
@interface KKChatRoomTableViewCell : UITableViewCell

-(void)loadMsg:(KKChatRoomMessage *)msg;
@end

NS_ASSUME_NONNULL_END
