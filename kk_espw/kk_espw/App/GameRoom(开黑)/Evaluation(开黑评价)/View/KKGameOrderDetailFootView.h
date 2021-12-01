//
//  KKGameOverFootView.h
//  kk_espw
//
//  Created by hsd on 2019/8/12.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKGameOrderTagDetailModel.h"

typedef NS_ENUM(NSInteger, KKGameOrderDetailButtonType) {
    KKGameOrderDetailButtonTypeBorder = 0,  ///< 左侧按钮
    KKGameOrderDetailButtonTypeNoBorder = 1,    ///< 右侧按钮
};

@protocol KKGameOrderDetailFootViewDelegate <NSObject>

@optional
- (void)footViewDidClickBorderButton;
- (void)footViewDidClickNoBorderButton;

@end

NS_ASSUME_NONNULL_BEGIN

/// 游戏结束页面页脚视图
@interface KKGameOrderDetailFootView : UIView

/// 根据底部安全距离初始化
- (instancetype)initWithFrame:(CGRect)frame bottomDistance:(CGFloat)distance;

@property (nonatomic, weak, nullable) id<KKGameOrderDetailFootViewDelegate> delegate;

@property (nonatomic, strong, nullable) NSArray<KKGameUserGameTagModel *> *userGameTagArr; ///< 评价标签list
@property (nonatomic, copy, nullable) NSString *evaluateTitleString;
@property (nonatomic, copy, nullable) NSString *chargeTitleString;
@property (nonatomic, copy, nullable) NSString *orderNoString;
@property (nonatomic, copy, nullable) NSString *gameEndString;

@property (nonatomic, copy, nullable) NSString *titleString;        ///< 主标题
@property (nonatomic, copy, nullable) NSString *subTitleString;        ///< 副标题

@property (nonatomic, assign) BOOL hiddenTopView;       ///< 隐藏上半部视图
@property (nonatomic, assign) BOOL hiddenBottomView;    ///< 隐藏下半部视图

/// 设置按钮标题
- (void)setTitle:(NSString * _Nullable)title
        forState:(UIControlState)state
   forButtonType:(KKGameOrderDetailButtonType)btnType;

/// 设置按钮可否交互
- (void)setButtonEnable:(BOOL)enable forButtonType:(KKGameOrderDetailButtonType)btnType;

@end

NS_ASSUME_NONNULL_END
