//
//  BaseViewModel.m
//  DGNotJustMVC
//
//  Created by David.G on 2019/7/10.
//  Copyright © 2019 David.G. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel
-(void)setBlockWithSuccess:(SuccessBlock)successBlock fail:(FailBlock)failBlock {
    _successBlock = successBlock;
    _failBlock = failBlock;
}
@end
