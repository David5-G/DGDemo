//
//  DGDataMgr.m
//  DGNotJustMVC
//
//  Created by David.G on 2019/7/10.
//  Copyright © 2019 David.G. All rights reserved.
//

#import "DGDataMgr.h"

@implementation DGDataMgr


+(NSArray *)loadDataA {
    return @[@{@"name":@"A攻击", @"imageUrl":@"http://gj", @"num":@"9"},
             @{@"name":@"A防御", @"imageUrl":@"http://fy", @"num":@"9"}];
}


+(NSArray *)loadDataB {
    return @[@{@"name":@"B攻击", @"imageUrl":@"http://gj", @"num":@"21"},
             @{@"name":@"B护甲", @"imageUrl":@"http://hj", @"num":@"21"},
             @{@"name":@"B法强", @"imageUrl":@"http://fq", @"num":@"21"},
             @{@"name":@"B魔抗", @"imageUrl":@"http://mk", @"num":@"21"}];
}

@end
