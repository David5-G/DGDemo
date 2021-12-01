//
//  KKCardTag.h
//  kk_espw
//
//  Created by 景天 on 2019/7/24.
//  Copyright © 2019年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KKMessage.h"

NS_ASSUME_NONNULL_BEGIN
@interface KKCardTag : NSObject
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, strong) KKMessage *platformType;
@property (nonatomic, strong) KKMessage *rank;
@property (nonatomic, strong) KKMessage *proceedStatus;
@property (nonatomic, strong) KKMessage *sex;
@property (nonatomic, strong) NSArray *preferLocations;
@property (nonatomic, copy) NSString *reliableScore;
@property (nonatomic, copy) NSString *serviceArea;
@property (nonatomic, strong) NSArray *evaluationProfileIds;
@end
NS_ASSUME_NONNULL_END
