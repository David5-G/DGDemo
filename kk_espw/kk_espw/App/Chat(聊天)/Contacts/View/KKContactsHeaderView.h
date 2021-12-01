//
//  KKContactsHeaderView.h
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/15.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KKContactsHeaderViewDelegate <NSObject>

- (void)pushToNewsFriendsInterface;

@end

NS_ASSUME_NONNULL_BEGIN

@interface KKContactsHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<KKContactsHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
