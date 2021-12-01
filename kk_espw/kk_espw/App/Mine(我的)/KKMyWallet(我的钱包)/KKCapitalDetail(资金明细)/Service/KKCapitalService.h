//
//  KKCapitalService.h
//  kk_espw
//
//  Created by 景天 on 2019/8/7.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKCapitalService : NSObject
+ (void)requestCapitalAccountDataWithStartDate:(NSString *)startDate
                                       EndDate:(NSString *)endDate
                                      CurrentPage:(NSNumber *)currentPage
                                       Success:(void(^)(NSMutableArray *dataList, KKPaginator *paginator))success
                                    Fail:(void(^)(void))fail;

+ (void)requestCapitalFreezeDataWithStartDate:(NSString *)startDate
                                       EndDate:(NSString *)endDate
                                   CurrentPage:(NSNumber *)currentPage
                                       Success:(void(^)(NSMutableArray *dataList, KKPaginator *paginator))success
                                          Fail:(void(^)(void))fail;
@end

NS_ASSUME_NONNULL_END
