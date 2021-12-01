//
//  KKPlayTTService.h
//  kk_espw
//
//  Created by 景天 on 2019/7/22.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^requestOrderListBlockSuccess)(NSMutableArray *dataList, KKPaginator *paginator);
typedef void(^requestOrderListBlockFail)(void);


@interface KKPlayTTService : NSObject
@property (nonatomic, copy) requestOrderListBlockSuccess requestOrderListBlockSuccess;
@property (nonatomic, copy) requestOrderListBlockFail requestOrderListBlockFail;
@property (nonatomic, strong) NSNumber *currentPage;
@property (nonatomic, copy) NSString *pageSize;
@property (nonatomic, copy) NSString *gameBoardId;
+ (instancetype)shareInstance;

/**
 请求开黑房订单
 
 @param success success
 @param fail fail
 */
+ (void)requestOrderListSuccess:(requestOrderListBlockSuccess)success Fail:(requestOrderListBlockFail)fail;

/**
 解散对局

 @param success success
 @param fail fail
 */
+ (void)requestDissolveGameBoardId:(NSString *)gameBoardId Success:(void (^)(void))success Fail:(void (^)(void))fail;

/**
 结束对局
 */
+ (void)requestEndGameBoardId:(NSString *)gameBoard
                       userId:(NSString *)userId
                      Success:(void (^)(void))success
                         Fail:(void (^)(void))fail;

/// 请求可以评价的时间.
+ (void)requestCanEvaluateTimeSuccess:(void (^)(NSString *config, NSString *systmeDate))success Fail:(void (^)(void))fail;

@end

NS_ASSUME_NONNULL_END
