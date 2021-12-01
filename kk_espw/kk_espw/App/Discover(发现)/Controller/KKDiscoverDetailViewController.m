//
//  KKDiscoverDetailViewController.m
//  kk_espw
//
//  Created by 景天 on 2019/8/6.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKDiscoverDetailViewController.h"
#import "KKH5Service.h"
#import "KKH5Url.h"

@interface KKDiscoverDetailViewController ()

@end

@implementation KKDiscoverDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (self.bodyId) {
        [self requestH5URLData];
    }
    if (self.linkUrl) {
        [self loadWkWebViewWithURL:self.linkUrl];
        self.view.backgroundColor = [UIColor whiteColor];
        self.wkwebView.top = STATUS_BAR_HEIGHT;
    }
}

- (void)requestH5URLData {
    WS(weakSelf)
    [KKH5Service requestH5URLDataSuccess:^(KKH5Url * _Nonnull modelURL) {
        NSString *url = [NSString stringWithFormat:@"%@%@", modelURL.CMS_DETAIL, weakSelf.bodyId];
        [weakSelf loadWkWebViewWithURL:url];
    } Fail:^{
        
    }];
}
@end
