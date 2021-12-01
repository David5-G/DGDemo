//
//  KKCollectionViewCustomLayout.h
//  kk_espw
//
//  Created by hsd on 2019/7/15.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KKCollectionViewCustomLayout;

@protocol KKCollectionViewCustomLayoutDelegate <NSObject>

@required
/// 返回 indexPath 位置的 cell Size
- (CGSize)layout:(KKCollectionViewCustomLayout *_Nonnull)layout itemSizeForIndexPath:(NSIndexPath *_Nonnull)indexPath;

@optional
/**
 一行显示几个item

 @param layout 布局
 @param section 分区
 @return 一行最多完整显示的个数,如果返回0,则忽略
 */
- (NSInteger)layout:(KKCollectionViewCustomLayout *_Nonnull)layout oneLineMaxItemsShowInSection:(NSUInteger)section;

@end


/// 自定义布局(目前只支持只有一个section的)
@interface KKCollectionViewCustomLayout : UICollectionViewLayout

/// 布局代理
@property (nonatomic, weak, nullable) id<KKCollectionViewCustomLayoutDelegate> layoutDelegate;

/// 分区内cell向内偏移量
@property (nonatomic, assign) UIEdgeInsets sectionInsets;

/// cell行间隔
@property (nonatomic, assign) CGFloat lineSpace;

/// cell之间的间隔
@property (nonatomic, assign) CGFloat itemSpace;

@end

