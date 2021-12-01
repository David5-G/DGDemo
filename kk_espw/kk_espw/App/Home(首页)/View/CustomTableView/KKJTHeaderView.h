//
//  KKJTHeaderView.h
//  kk_espw
//
//  Created by jingtian9 on 2019/10/11.
//  Copyright © 2019 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKJTHeaderView;
@class KKHomeRoomStatus;

typedef void(^didTapSelectViewBlock)(void);

@protocol headerViewDelegate<NSObject>

@required
- (void)headerView:(KKJTHeaderView *)headerView SelectionIndex:(NSInteger)index;
- (void)headerViewIndex:(NSInteger)index;
@optional
- (void)didSelectedLeftView;
- (void)didSelectedRightView;
- (void)didSelectedSDCycleScrollViewIndex:(NSInteger)index;

@end

@interface KKJTHeaderView : UIView
@property (nonatomic,weak) id<headerViewDelegate> delegate;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) NSMutableArray *banners;
@property (nonatomic, strong) KKHomeRoomStatus *status;
@property (nonatomic, copy) didTapSelectViewBlock didTapSelectViewBlock;
@property (nonatomic, copy) NSString *selectViewTitle;
@end
