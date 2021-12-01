//
//  KKConversationSettingOtherCell.h
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/30.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IMUIKit/KKConversation.h>

@protocol KKConversationSettingOtherCellDelegate <NSObject>

- (void)conversationIsNoTrouble:(BOOL)isNoTrouble;
- (void)conversationIsTop:(BOOL)isTop;

@end

NS_ASSUME_NONNULL_BEGIN

@interface KKConversationSettingOtherCell : UITableViewCell

@property (nonatomic, weak) id<KKConversationSettingOtherCellDelegate> delegate;

- (void)setupUI:(NSString *)info withIndex:(NSIndexPath *)indexPath andConversation:(KKConversation *)conversation;

@end

NS_ASSUME_NONNULL_END
