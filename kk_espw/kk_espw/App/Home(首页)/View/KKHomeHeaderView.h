//
//  KKHomeHeaderView.h
//  kk_espw
//
//  Created by 景天 on 2019/7/10.
//  Copyright © 2019年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKHomeRoomStatus;
@protocol KKHomeHeaderViewDelegate <NSObject>

@optional
- (void)didSelectedSDCycleScrollViewIndex:(NSInteger)index;
- (void)didSelectedLeftView;
- (void)didSelectedRightView;
- (void)didSelectedSearchButton;
- (void)didSelectedScanButton;

@end


NS_ASSUME_NONNULL_BEGIN

@interface KKHomeHeaderView : UIView
@property (nonatomic, weak) id<KKHomeHeaderViewDelegate> delegate;
@property (nonatomic, strong) KKHomeRoomStatus *status;
@property (nonatomic, strong) NSMutableArray *imagesURLStrings;
@end

NS_ASSUME_NONNULL_END
