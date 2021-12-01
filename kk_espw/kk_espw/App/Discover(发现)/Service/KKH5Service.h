//
//  KKH5Service.h
//  kk_espw
//
//  Created by 景天 on 2019/8/5.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KKH5Url;
NS_ASSUME_NONNULL_BEGIN
typedef void(^requestH5URLBlockSuccess)(KKH5Url *modelURL);
typedef void(^requestH5URLBlockFail)(void);

@interface KKH5Service : NSObject
@property (nonatomic, copy) requestH5URLBlockSuccess requestH5URLBlockSuccess;
@property (nonatomic, copy) requestH5URLBlockFail requestH5URLBlockFail;

+ (void)requestH5URLDataSuccess:(requestH5URLBlockSuccess)success Fail:(requestH5URLBlockFail)fail;
@end

NS_ASSUME_NONNULL_END
