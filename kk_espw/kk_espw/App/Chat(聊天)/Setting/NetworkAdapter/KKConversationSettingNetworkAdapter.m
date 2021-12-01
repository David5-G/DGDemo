//
//  KKConversationSettingNetworkAdapter.m
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/30.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKConversationSettingNetworkAdapter.h"
#import "UIView+ProgressHUD.h"

@implementation KKConversationSettingNetworkAdapter

+ (void)fetchDeleteFriendsNetwork:(NSDictionary *_Nonnull)params
                      currentView:(UIView *)currentView
                   successHandler:(void(^ __nullable)(ResModel * __nullable model))successHandler
                     faileHandler:(void (^)(NSError * __nullable ))faileHandler {
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
            [CC_Notice showNoticeStr:error atView:currentView delay:2];
        } else {
            successHandler(resModel);
        }
    }];
    
}

@end
