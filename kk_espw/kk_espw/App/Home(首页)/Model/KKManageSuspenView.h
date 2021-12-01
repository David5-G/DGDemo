//
//  KKManageSuspenView.h
//  kk_espw
//
//  Created by 景天 on 2019/8/14.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKManageSuspenView : NSObject

+ (instancetype)shareInstance;

- (void)showLiveStuioView;

@property (nonatomic, copy) NSString *isShow;

- (void)showGameBoard;


@end

NS_ASSUME_NONNULL_END
