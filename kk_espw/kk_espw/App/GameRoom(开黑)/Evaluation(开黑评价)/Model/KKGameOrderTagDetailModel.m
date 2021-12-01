//
//  KKGameOrderTagDetailModel.m
//  kk_espw
//
//  Created by hsd on 2019/8/13.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameOrderTagDetailModel.h"

@implementation KKGameUserGameTagModel

@end








@implementation KKGameOrderDetailMemoModel

@end









@implementation KKGameOrderTagDetailModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"ownerPosition": @"KKGameStatusInfoModel",
             @"userGameTag": @"KKGameUserGameTagModel",
             @"dataList": @"KKGameBoardDetailSimpleModel",
             };
}

@end
