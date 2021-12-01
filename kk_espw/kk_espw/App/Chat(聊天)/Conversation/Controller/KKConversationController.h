//
//  KKConversationController.h
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/5.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IMUIKit/KKConversation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKConversationController : UIViewController

- (instancetype)initWithConversation:(KKConversation *)conversation extra:(nullable id)extra;

@end

NS_ASSUME_NONNULL_END
