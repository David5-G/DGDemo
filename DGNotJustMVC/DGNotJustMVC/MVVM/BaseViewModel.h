//
//  BaseViewModel.h
//  DGNotJustMVC
//
//  Created by David.G on 2019/7/10.
//  Copyright © 2019 David.G. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SuccessBlock)(id data);
typedef void(^FailBlock)(id data);

@interface BaseViewModel : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) SuccessBlock successBlock;
@property (nonatomic,copy) FailBlock failBlock;

-(void)setBlockWithSuccess:(SuccessBlock)successBlock fail:(FailBlock)failBlock;

@end

NS_ASSUME_NONNULL_END
