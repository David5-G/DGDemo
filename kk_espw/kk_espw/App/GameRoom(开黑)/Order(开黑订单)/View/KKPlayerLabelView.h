//
//  KKPlayerLabelView.h
//  kk_espw
//
//  Created by hsd on 2019/7/19.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, KKPlayerLabelViewModelType) {
    KKPlayerLabelViewModelTypeBigImage = 1,     ///< 背景大图
    KKPlayerLabelViewModelTypeIconImage = 2,    ///< 左侧小图标
};

/// 玩家标签数据模型
@interface KKPlayerLabelViewModel : NSObject

@property (nonatomic, assign) KKPlayerLabelViewModelType modelType; ///< 展示样式

@property (nonatomic, strong, nullable) NSArray<UIColor *> *bgColors;           ///< 背景色组
@property (nonatomic, strong, nullable) UIImage *img;               ///< 图片
@property (nonatomic, strong, nullable) NSString *labelString;      ///< 玩家标签

@property (nonatomic, strong, nonnull) UIFont *labelFont;           ///< 字体, 不需要设置,默认根据UI图写死
@property (nonatomic, strong, nonnull) UIColor *labelColor;         ///< 颜色, 不需要设置,默认根据UI图写死

/**
 工厂方法

 @param type 显示模式
 @param bgColors 标签背景色组, 如果数组长度大于1, 则表示背景为渐变色
 @param img 图片(可为底图也可为左侧小图标, 取决于type)
 @param labelStr 标题文字, 如果 type == bigImage, 则该标题不显示
 @return 实例
 */
+ (instancetype _Nonnull)createWithType:(KKPlayerLabelViewModelType)type
                                bgColors:(NSArray<UIColor *> * _Nullable)bgColors
                                    img:(UIImage * _Nullable)img
                              labelStr:(NSString * _Nullable)labelStr;

@end

NS_ASSUME_NONNULL_BEGIN

/// 玩家标签
@interface KKPlayerLabelView : UIView

/// 数据源
@property (nonatomic, strong, nonnull) KKPlayerLabelViewModel *model;

/// 图标距离左侧x点, 默认2
@property (nonatomic, assign) CGFloat iconImageToLeft;

/// 文字距离图标x点， 默认2
@property (nonatomic, assign) CGFloat labelToIconImage;

/// 文字距离尾部x点, 默认2
@property (nonatomic, assign) CGFloat labelToTrail;

/// 左侧图标宽度, 10
@property (nonatomic, assign, readonly) CGFloat iconImageWidth;

@end

NS_ASSUME_NONNULL_END
