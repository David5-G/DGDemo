//
//  KKTag.h
//  kk_espw
//
//  Created by 景天 on 2019/7/24.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/*
 "gameTagCount" : 29,
 "orderNumber" : 1,
 "gameTagId" : 1,
 "userId" : "10034004022699008900290980087710",
 "tagCode" : "KAN_YA_WANG"
 */
@interface KKTag : NSObject
@property (nonatomic, copy) NSString *gameTagCount;
@property (nonatomic, copy) NSString *orderNumber;
@property (nonatomic, copy) NSString *gameTagId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *tagCode;
@property (nonatomic, copy) NSString *evaluationNum;
@end

NS_ASSUME_NONNULL_END
