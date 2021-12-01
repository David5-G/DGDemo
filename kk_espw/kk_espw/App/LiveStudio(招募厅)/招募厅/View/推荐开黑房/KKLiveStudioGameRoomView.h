//
//  KKLiveStudioGameRoomView.h
//  kk_espw
//
//  Created by david on 2019/8/11.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKLiveStudioGameRoomCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^KKLiveStudioGameRoomConfigBlock)(id cell, id model, NSIndexPath * indexPath);
typedef void (^KKLiveStudioGameRoomSelectBlock) (id model, NSIndexPath *indexPath);

#pragma mark -
@class KKLiveStudioGameRoomView;
@protocol KKLiveStudioGameRoomViewDelegate <NSObject>
@optional
-(void)gameRoomViewDidClickRecommendButton:(KKLiveStudioGameRoomView *)gameRoomView;
-(void)gameRoomViewWillBeginDragging:(KKLiveStudioGameRoomView *)conversationVC;
@end


#pragma mark -
@interface KKLiveStudioGameRoomView : UIView
@property (nonatomic, weak) id<KKLiveStudioGameRoomViewDelegate> delegate;

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property (nonatomic, copy, nullable) NSArray <id>*dataArray;
-(void)setConfigBlock:(KKLiveStudioGameRoomConfigBlock)configBlock selectBlock:(KKLiveStudioGameRoomSelectBlock)selectBlock;

/** 是否是 主播查看 */
@property (nonatomic, assign) BOOL isHostCheck;

@end

NS_ASSUME_NONNULL_END
