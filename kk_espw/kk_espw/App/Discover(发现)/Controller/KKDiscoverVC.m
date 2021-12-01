//
//  KKDiscoverVC.m
//  kk_espw
//
//  Created by david on 2019/7/5.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKDiscoverVC.h"
#import "KKH5Service.h"
#import "KKH5Url.h"
#import "KKDiscoverDetailViewController.h"

@interface KKDiscoverVC ()

@end

@implementation KKDiscoverVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavi];
    [self setupUI];
    
}

#pragma mark - UI
- (void)setupNavi {
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = @"发现";
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = rgba(51, 51, 51, 1);
    messageLabel.font = [UIFont boldSystemFontOfSize:21];
    [self.naviBar addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.naviBar).mas_offset(20);
        make.bottom.equalTo(self.naviBar).mas_offset(-2);
        make.size.mas_equalTo(CGSizeMake(50, 21));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = rgba(255, 223, 71, 1);
    lineView.layer.cornerRadius = 3;
    lineView.layer.masksToBounds = YES;
    [self.naviBar addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(messageLabel);
        make.bottom.equalTo(messageLabel.mas_bottom).mas_offset(3);
        make.size.mas_equalTo(CGSizeMake(37, 6));
    }];
    
    self.progressView.hidden = YES;
    [self.naviBar bringSubviewToFront:messageLabel];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake([ccui getRH:161], -30, [ccui getRH:214], [ccui getRH:232])];
    bg.image = Img(@"mine_bg");
    [self.view addSubview:bg];
    
    self.wkwebView.top = self.naviBar.bottom + RH(15);
    self.wkwebView.height = SCREEN_HEIGHT - STATUSBAR_ADD_NAVIGATIONBARHEIGHT - HOME_INDICATOR_HEIGHT - RH(15);
    [self.view bringSubviewToFront:self.wkwebView];
}

#pragma mark - Net
- (void)requestH5URLData {
    WS(weakSelf)
    [KKH5Service requestH5URLDataSuccess:^(KKH5Url * _Nonnull modelURL) {
        [weakSelf loadWkWebViewWithURL:modelURL.DISCOVER];
    } Fail:^{
        
    }];
}

- (UIStatusBarStyle)getStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)viewWillAppear:(BOOL)animated {
    [self requestH5URLData];
}

- (void)viewDidDisappear:(BOOL)animated {
    
}
@end
