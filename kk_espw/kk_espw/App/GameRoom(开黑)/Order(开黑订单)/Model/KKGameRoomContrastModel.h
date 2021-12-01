//
//  KKGameRoomContrastModel.h
//  kk_espw
//
//  Created by hsd on 2019/8/5.
//  Copyright © 2019 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 游戏位置
@interface KKGameRoomPositionModel : NSObject

@property (nonatomic, assign) NSInteger position;
@property (nonatomic, copy, nonnull) NSString *title;

+ (instancetype)createWith:(NSInteger)position title:(NSString *)title;

@end

@interface KKGameRoomContrastModel : NSObject

/// 游戏位置对照表
@property (nonatomic, strong, nonnull) NSDictionary<NSString *, KKGameRoomPositionModel *> *positionMapDic;

/// 勋章对照表
@property (nonatomic, strong, nonnull) NSDictionary<NSString *, NSString *> *medalMapDic;

/// 评价对照表
@property (nonatomic, strong, nonnull) NSDictionary<NSString *, NSString *> *evaluateMapDic;

/// 模式对应收费人数对照表
@property (nonatomic, strong, nonnull) NSDictionary<NSString *, NSNumber *> *patternMapDic;

/// 等级logo对照表
@property (nonatomic, strong, nonnull) NSDictionary<NSString *, UIImage *> *rankImageMapDic;

/// 在cell上的性别图片对照表
@property (nonatomic, strong, nonnull) NSDictionary<NSString *, UIImage *> *sexMapDic;

/// 在玩家卡片上的性别图片对照表
@property (nonatomic, strong, nonnull) NSDictionary<NSString *, UIImage *> *cardSexMapDic;

/// 单例
+ (instancetype _Nonnull)shareInstance;

@end

NS_ASSUME_NONNULL_END
