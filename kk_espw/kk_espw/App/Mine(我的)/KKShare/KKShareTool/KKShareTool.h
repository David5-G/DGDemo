//
//  KKShareTool.h
//  kk_espw
//
//  Created by 景天 on 2019/7/30.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ShareType) {
    ActivityType, /// 点击了开黑房列表
    RoomType, /// 点击了筛选
};

NS_ASSUME_NONNULL_BEGIN
@interface KKShareTool : NSObject
/**
 初始化

 @return 实例
 */
+ (instancetype)shareInstance;


/**
 极光分享配置
 */
+ (void)configJShare;

/**
 分享

 @param platform 平台
 @param title 标题
 @param text 文本
 @param url 链接
 */
+ (void)configJShareWithPlatform:(JSHAREPlatform)platform title:(NSString *)title text:(NSString *)text url:(NSString *)url type:(ShareType)type;

/**
 分享任务统计
 */
+ (void)requestShareWorkCreate;
@end

NS_ASSUME_NONNULL_END
