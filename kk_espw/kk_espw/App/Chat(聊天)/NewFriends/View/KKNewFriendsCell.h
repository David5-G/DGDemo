//
//  KKNewFriendsCell.h
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/11.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKNewFriendsCellDelegate <NSObject>

- (void)acceptNewFriendsDidTipped:(UIButton *_Nullable)sender;

@end

NS_ASSUME_NONNULL_BEGIN

@interface KKNewFriendsCell : UITableViewCell

@property (nonatomic, weak) id<KKNewFriendsCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
