//
//  KKManageSuspenView.m
//  kk_espw
//
//  Created by 景天 on 2019/8/14.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKManageSuspenView.h"

@implementation KKManageSuspenView
static KKManageSuspenView *manager = nil;
+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[KKManageSuspenView alloc] init];
    });
    return manager;
}


@end
