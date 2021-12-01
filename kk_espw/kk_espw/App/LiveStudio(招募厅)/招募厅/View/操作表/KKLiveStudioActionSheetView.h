//
//  KKLiveStudioActionSheetView.h
//  kk_espw
//
//  Created by david on 2019/7/24.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKBottomPopView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKLiveStudioActionSheetView : KKBottomPopView

@property (nonatomic, copy) NSArray <NSString *>*dataArray;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, copy) void(^selectBlock)(NSString *);

@end

NS_ASSUME_NONNULL_END
