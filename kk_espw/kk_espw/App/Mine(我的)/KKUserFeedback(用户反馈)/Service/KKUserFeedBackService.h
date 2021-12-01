//
//  KKUserFeedBackService.h
//  kk_espw
//
//  Created by 景天 on 2019/7/22.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^requestFeedbackBlockSuccess)(void);
typedef void(^requestFeedbackBlockFail)(void);

@interface KKUserFeedBackService : NSObject
@property (nonatomic, copy) requestFeedbackBlockSuccess requestFeedbackBlockSuccess;
@property (nonatomic, copy) requestFeedbackBlockFail requestFeedbackBlockFail;

@property (nonatomic, copy) NSString *adviceConent;


/**
 初始化

 @return 实例
 */
+ (instancetype)shareInstance;

/**
 请求反馈

 @param success 成功
 @param fail 失败
 */
+ (void)requestUserFeedBackSuccess:(requestFeedbackBlockSuccess)success Fail:(requestFeedbackBlockFail)fail;

@end

NS_ASSUME_NONNULL_END
