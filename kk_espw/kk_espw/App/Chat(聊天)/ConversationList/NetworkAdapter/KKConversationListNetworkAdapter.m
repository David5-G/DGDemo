//
//  KKConversationListNetworkAdapter.m
//  IMUIKit
//
//  Created by 罗礼豪 on 2019/8/2.
//  Copyright © 2019 罗礼豪. All rights reserved.
//

#import "KKConversationListNetworkAdapter.h"

@implementation KKConversationListNetworkAdapter


+ (void)fetchFriendApplyNetwork:(void(^ __nullable)(BOOL isHiddenRed))successHandler {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"USER_READ_RECORD_QUERY" forKey:@"service"];
    
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        if (error) {
        } else {
            NSDictionary *resultDic = resModel.resultDic;
            NSDictionary *response = [resultDic objectForKey:@"response"];
            NSString *newFriendCount = [response objectForKey:@"newFriendCount"];
            
            BOOL isHiddenRed;
            if ([newFriendCount intValue] <= 0) {
                isHiddenRed = YES;
            } else {
                isHiddenRed = NO;
            }
            successHandler(isHiddenRed);
        }
    }];
}

@end
