//
//  KKConversationSettingNetworkAdapter.h
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/30.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKConversationSettingNetworkAdapter : NSObject

/**
 删除好友
 
 @param params 请求参数
 @param currentView 当前view
 @param successHandler 成功的回调
 @param faileHandler 失败的回调
 */
+ (void)fetchDeleteFriendsNetwork:(NSDictionary *_Nonnull)params
                   currentView:(UIView *)currentView
                successHandler:(void(^ __nullable)(ResModel * __nullable model))successHandler
                  faileHandler:(void (^)(NSError * __nullable))faileHandler;

@end

NS_ASSUME_NONNULL_END
