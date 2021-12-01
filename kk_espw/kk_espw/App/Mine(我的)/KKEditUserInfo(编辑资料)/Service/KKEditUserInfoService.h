//
//  KKEditUserInfoService.h
//  kk_espw
//
//  Created by 景天 on 2019/7/22.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^requestEditUserInfoBlockSuccess)(void);
typedef void(^requestEditUserInfoBlockFail)(void);
typedef void(^requestUploadImageGetFileNameBlockSuccess)(void);
typedef void(^requestUploadImageGetFileNameBlockFail)(void);
typedef void(^requestUpdateImageBlockSuccess)(void);
typedef void(^requestUpdateImageBlockFail)(void);

@interface KKEditUserInfoService : NSObject

@property (nonatomic, copy) requestEditUserInfoBlockSuccess requestEditUserInfoBlockSuccess;
@property (nonatomic, copy) requestEditUserInfoBlockFail requestEditUserInfoBlockFail;

@property (nonatomic, copy) requestUploadImageGetFileNameBlockSuccess requestUploadImageGetFileNameBlockSuccess;
@property (nonatomic, copy) requestUploadImageGetFileNameBlockFail requestUploadImageGetFileNameBlockFail;

@property (nonatomic, copy) requestUpdateImageBlockSuccess requestUpdateImageBlockSuccess;
@property (nonatomic, copy) requestUpdateImageBlockFail requestUpdateImageBlockFail;

@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *userLocation;
@property (nonatomic, strong) UIImage *image;

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
+ (void)requestEditUserInfoSuccess:(requestEditUserInfoBlockSuccess)success Fail:(requestEditUserInfoBlockFail)fail;

/**
 上传

 @param success 成功
 @param fail 失败
 */
+ (void)requestUploadImageSuccess:(requestUploadImageGetFileNameBlockSuccess)success Fail:(requestUploadImageGetFileNameBlockFail)fail;

/**
 修改

 @param success 成功
 @param fail 失败
 */
+ (void)requestUpdateImageSuccess:(requestUpdateImageBlockSuccess)success Fail:(requestUpdateImageBlockFail)fail;

@end

NS_ASSUME_NONNULL_END
