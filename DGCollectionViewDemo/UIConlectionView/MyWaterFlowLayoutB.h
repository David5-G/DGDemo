//
//  MyWaterFallLayoutB.h
//  UIConlectionView
//
//  Created by David.G on 2020/3/6.
//  Copyright © 2020 jaki. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class MyWaterFlowLayoutB;
@protocol MyWaterFlowLayoutBDelegate <NSObject>

//使用delegate取得每一个Cell的高度
- (CGFloat)waterFlow:(MyWaterFlowLayoutB *)layout heightForCellAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MyWaterFlowLayoutB : UICollectionViewLayout

//声明协议
@property (nonatomic, weak) id <MyWaterFlowLayoutBDelegate> delegate;
//确定列数
@property (nonatomic, assign) NSInteger colum;
//确定内边距
@property (nonatomic, assign) UIEdgeInsets insetSpace;
//确定每个cell之间的距离
@property (nonatomic, assign) NSInteger distance;

@end


NS_ASSUME_NONNULL_END
