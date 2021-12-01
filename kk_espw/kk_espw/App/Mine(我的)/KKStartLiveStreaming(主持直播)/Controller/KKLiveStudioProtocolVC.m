//
//  KKAgreementBrowerViewController.m
//  kk_espw
//
//  Created by 景天 on 2019/8/1.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKLiveStudioProtocolVC.h"
#import "KKH5Service.h"
#import "KKH5Url.h"
@interface KKLiveStudioProtocolVC ()


@end

@implementation KKLiveStudioProtocolVC
#pragma mark - Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestH5URLData];
}

- (void)requestH5URLData {
    WS(weakSelf)
    [KKH5Service requestH5URLDataSuccess:^(KKH5Url * _Nonnull modelURL) {
        [weakSelf loadWkWebViewWithURL:modelURL.LIVING_PACT];
    } Fail:^{
        
    }];
}

@end
