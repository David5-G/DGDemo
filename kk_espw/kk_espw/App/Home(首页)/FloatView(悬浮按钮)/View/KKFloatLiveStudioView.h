//
//  KKFloatLiveStudioView.h
//  kk_espw
//
//  Created by 景天 on 2019/7/24.
//  Copyright © 2019年 david. All rights reserved.
//

#import "DGFloatButton.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^tapCloseLiveStudio)(void);
@interface KKFloatLiveStudioView : DGFloatButton
@property (nonatomic, copy) NSString *recruitID;
@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *compereL;
@property (nonatomic, strong) CC_Button *closeButton;
@property (nonatomic, copy) tapCloseLiveStudio tapCloseLiveStudio;

/**
 初始化
 
 @return 实例
 */
+ (instancetype)shareInstance;

/**
 展示
 */
- (void)showkSuspendedView;

/**
 移除
 */
- (void)removekSuspendedView;

/**
 销毁
 */
+ (void)destroyInstance;

- (void)setTitle:(NSString *)title Name:(NSString *)name ImgUrl:(NSString *)imgUrl;

@end

NS_ASSUME_NONNULL_END
