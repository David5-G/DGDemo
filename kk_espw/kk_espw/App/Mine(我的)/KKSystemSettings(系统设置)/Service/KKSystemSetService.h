//
//  KKSystemSetService.h
//  kk_espw
//
//  Created by 景天 on 2019/8/16.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKSystemSetService : NSObject

- (void)request_RealName_Auth_Data_Success:(void(^)(NSString *isAuth))success Fail:(void(^)(void))fail;
@end

NS_ASSUME_NONNULL_END
