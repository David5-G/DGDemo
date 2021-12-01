//
//  KKPaginator.h
//  kk_espw
//
//  Created by 景天 on 2019/7/19.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KKPaginator : NSObject
@property(nonatomic,assign) NSInteger items;// = 1;
@property(nonatomic,assign) NSInteger itemsPerPage;// = 20;
@property(nonatomic,assign) NSInteger page;// = 1+1>pages;
@property(nonatomic,assign) NSInteger pages;// = 1;
@end

NS_ASSUME_NONNULL_END
