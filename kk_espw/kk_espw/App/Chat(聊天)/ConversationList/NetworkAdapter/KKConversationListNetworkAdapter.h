//
//  KKConversationListNetworkAdapter.h
//  IMUIKit
//
//  Created by 罗礼豪 on 2019/8/2.
//  Copyright © 2019 罗礼豪. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKConversationListNetworkAdapter : NSObject

/**
 获取好友申请的消息数

 @param successHandler 成功的回调
 */
+ (void)fetchFriendApplyNetwork:(void(^ __nullable)(BOOL isHiddenRed))successHandler;

@end

NS_ASSUME_NONNULL_END
