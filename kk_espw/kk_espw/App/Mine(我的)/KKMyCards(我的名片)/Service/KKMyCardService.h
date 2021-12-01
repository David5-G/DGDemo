//
//  KKMyCardService.h
//  kk_espw
//
//  Created by 景天 on 2019/7/24.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^requestCardTagListBlockSuccess)(NSMutableArray *dataList);
typedef void(^requestCardTagListBlockFail)(void);


@interface KKMyCardService : NSObject
@property (nonatomic, copy) requestCardTagListBlockSuccess requestCardTagListBlockSuccess;
@property (nonatomic, copy) requestCardTagListBlockFail requestCardTagListBlockFail;

+ (instancetype)shareInstance;

/**
 请求开黑房订单
 
 @param success success
 @param fail fail
 */
+ (void)requestCardTagListSuccess:(requestCardTagListBlockSuccess)success Fail:(requestCardTagListBlockFail)fail;

+ (void)destroyInstance;
@end

NS_ASSUME_NONNULL_END
