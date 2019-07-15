//
//  MvvmViewModel.h
//  DGNotJustMVC
//
//  Created by David.G on 2019/7/10.
//  Copyright © 2019 David.G. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface MvvmViewModel : BaseViewModel

@property (nonatomic,copy) NSString *grade;//级别

#pragma mark - data
-(void)loadData;

-(void)numChanged:(NSString *)numStr atIndexPath:(NSIndexPath *)indexPath;

#pragma mark - 业务处理
-(NSString *)nameStrForIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
