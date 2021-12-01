//
//  KKLiveStudioMetalSimpleModel.h
//  kk_espw
//
//  Created by david on 2019/7/31.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@class
KKLiveStudioMetalConfigSimpleModel,
KKLiveStudioMetalLabelConfigSimpleModel;


NS_ASSUME_NONNULL_BEGIN
///勋章类
@interface KKLiveStudioMetalSimpleModel : NSObject

@property (nonatomic, copy) NSString *idStr;

///当前勋章等级配置id
@property (nonatomic, assign) NSInteger currentMedalLevelConfigId;

///当前值
@property (nonatomic, assign) NSInteger currentValue;

///是否有效
@property (nonatomic, assign) BOOL enabled;

/**
 状态
 枚举字段如下：
 NORMAL => 普通
 INVALID => 无效
 PRE_DELETE => 预删除
 */
@property (nonatomic, copy) NSString *status;

///用户id
@property (nonatomic, copy) NSString *userId;

///空间id   (后台给的是long)
@property (nonatomic, copy) NSString *areaId;

///当前勋章等级配制code
@property (nonatomic, copy) NSString *currentMedalLevelConfigCode;

///是否佩戴
@property (nonatomic, assign) BOOL adorned;

///勋章标签
@property (nonatomic, strong) NSArray <KKLiveStudioMetalLabelConfigSimpleModel *>*medalLabelConfigList;

@end



#pragma mark -
///勋章标签类
@interface KKLiveStudioMetalLabelConfigSimpleModel : NSObject
///勋章配置
@property (nonatomic, copy) KKLiveStudioMetalConfigSimpleModel *medalConfig;

///内容
@property (nonatomic, copy) NSString *content;

///是否有效
@property (nonatomic, assign) BOOL enabled;
@end



#pragma mark -
///勋章配置类
@interface KKLiveStudioMetalConfigSimpleModel : NSObject
///代码
@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *idStr;

@property (nonatomic, copy) NSString *name;

///是否有效
@property (nonatomic, assign) BOOL enabled;
@end

NS_ASSUME_NONNULL_END
