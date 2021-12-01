//
//  KKAddCardBottomView.h
//  kk_espw
//
//  Created by 景天 on 2019/7/16.
//  Copyright © 2019年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^inputAreaStrBlock)(NSString *str);
typedef void(^locSelectBlock)(NSMutableArray *arr);
@interface KKAddCardBottomView : UIView
@property (nonatomic, copy) inputAreaStrBlock inputAreaStrBlock; /// 输入的服务器回调
@property (nonatomic, copy) locSelectBlock locSelectBlock; /// 擅长位置回调
@property (nonatomic, strong) UITextField *tf;
@property (nonatomic, strong) NSMutableArray *preferLocations;
@end

NS_ASSUME_NONNULL_END
