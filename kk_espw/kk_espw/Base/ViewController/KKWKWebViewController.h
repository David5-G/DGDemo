//
//  KKWKWebViewController.h
//  kk_espw
//
//  Created by 景天 on 2019/8/5.
//  Copyright © 2019年 david. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKWKWebViewController : BaseViewController
@property (nonatomic, strong) WKWebView *wkwebView;
@property (nonatomic, strong) UIProgressView *progressView;

- (void)loadWkWebViewWithURL:(NSString *)url;
@end

NS_ASSUME_NONNULL_END
