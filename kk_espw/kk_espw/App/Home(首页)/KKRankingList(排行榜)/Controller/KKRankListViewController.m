//
//  KKRankListViewController.m
//  kk_espw
//
//  Created by 景天 on 2019/7/31.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKRankListViewController.h"
#import "KKH5Service.h"
#import "KKH5Url.h"
@interface KKRankListViewController ()
<WKUIDelegate,
WKNavigationDelegate,
WKScriptMessageHandler>
@end

@implementation KKRankListViewController

#pragma mark - Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavUI];
    [self requestH5URLData];
}

#pragma mark - UI
- (void)setNavUI {
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.naviBar.backButton.hidden = YES;
}

#pragma mark - Net
- (void)requestH5URLData {
    WS(weakSelf)
    [KKH5Service requestH5URLDataSuccess:^(KKH5Url * _Nonnull modelURL) {
        [weakSelf loadWkWebViewWithURL:modelURL.RANK_LIST];
    } Fail:^{
        
    }];
}

#pragma mark Jump
- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
