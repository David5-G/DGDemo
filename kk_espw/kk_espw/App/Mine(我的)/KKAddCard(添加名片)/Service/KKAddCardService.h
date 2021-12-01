//
//  KKAddCardService.h
//  kk_espw
//
//  Created by 景天 on 2019/7/25.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^requestAddCardBlockSuccess)(void);
typedef void(^requestAddCardBlockFail)(void);


@interface KKAddCardService : NSObject
@property (nonatomic, copy) requestAddCardBlockSuccess requestAddCardBlockSuccess;
@property (nonatomic, copy) requestAddCardBlockFail requestAddCardBlockFail;
@property (nonatomic, copy) NSString *platformType; /// QQ
@property (nonatomic, copy) NSString *modifyUserId; /// 修改人
/*
 TOP("上路"),
 
 JUG("打野"),
 
 MID("中路"),
 
 ADC("下路"),
 
 SUP("辅助"),
 */
@property (nonatomic, copy) NSString *preferLocations; /// 擅长位置
@property (nonatomic, copy) NSString *createUserId; /// 修改人
@property (nonatomic, copy) NSString *serviceArea; /// 无情冲锋39区
@property (nonatomic, copy) NSString *nickName; /// 昵称
@property (nonatomic, copy) NSString *sex; /// 性别
@property (nonatomic, copy) NSString *rank; /// 段位
@property (nonatomic, copy) NSString *service; /// 服务名
@property (nonatomic, copy) NSString *ID; /// 名片ID

+ (instancetype)shareInstance;
+ (void)destroyInstance;

/**
 请求添加名片
 
 @param success success
 @param fail fail
 */
+ (void)requestaddCardSuccess:(requestAddCardBlockSuccess)success Fail:(requestAddCardBlockFail)fail;

@end

NS_ASSUME_NONNULL_END
