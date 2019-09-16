//
//  Presenter.h
//  DGNotJustMVC
//
//  Created by David.G on 2019/7/10.
//  Copyright © 2019 David.G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MvpDelegate.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * MVP: 适合多人开发, 可读性强, 嵌套较少
 * (嵌套多,推荐用block,MVVM)
 *
 * 需求 ---> 写接口 ---> 代理三部曲(订协议,设代理,实现协议方法) ---> 代码
 * 需求 --驱动--> 代码
 */

/**
 * Presenter是  cell的代理, Presenter实现  UI改变 ---> model
 * MvpVC是 Presenter的代理, Mvp实现        model改变 ---> UI
 */

@interface Presenter : NSObject <MvpDelegate>

@property (nonatomic, weak) id<MvpDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *modelArray;

- (void)loadData;

@end

NS_ASSUME_NONNULL_END
