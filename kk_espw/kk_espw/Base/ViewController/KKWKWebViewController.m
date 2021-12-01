//
//  KKWKWebViewController.m
//  kk_espw
//
//  Created by 景天 on 2019/8/5.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKWKWebViewController.h"
#import <bench_ios/CC_FormatDic.h>
#import "KKDiscoverDetailViewController.h"
#import "KKMyCardService.h"
#import "KKCreateCardView.h"
#import "KKHomeService.h"
#import "KKCheckInfo.h"
#import "KKCreateGameRoomController.h"
#import "KKGameRoomOwnerController.h"
#import "LoginLib.h"
#import "KKHomeVC.h"
#import "KKMineVC.h"
#import "KKCustomTabViewController.h"

@interface KKWKWebViewController ()
<WKUIDelegate,
WKNavigationDelegate,
WKScriptMessageHandler>
@property (nonatomic, strong) KKCreateCardView *createCardView;

@end

@implementation KKWKWebViewController
#pragma mark - Init
- (UIProgressView *)progressView
{
    if (!_progressView){
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, -STATUS_BAR_HEIGHT, SCREEN_WIDTH, 2)];
        _progressView.tintColor = [UIColor blueColor];
        _progressView.trackTintColor = [UIColor clearColor];
    }
    return _progressView;
}

#pragma mark - Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavUI];
    [self setUI];
    [self.wkwebView.configuration.userContentController addScriptMessageHandler:self name:@"popViewController"];
    [self.wkwebView.configuration.userContentController addScriptMessageHandler:self name:@"pushInformationDetail"];
    [self.wkwebView.configuration.userContentController addScriptMessageHandler:self name:@"toCreateGameBoard"];
    [self.wkwebView.configuration.userContentController addScriptMessageHandler:self name:@"toInvite"];
}

#pragma mark - UI
- (void)setNavUI {
    [self setNaviBarWithType:DGNavigationBarTypeClear];
}

- (void)setUI {
    [self.view addSubview:self.progressView];
    [self createWkWebView];
}

- (void)initCardView {
    _createCardView = [[KKCreateCardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:_createCardView];
}

- (void)createWkWebView {
    /// 创建网页配置对象
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    /// 创建设置对象
    WKPreferences *preference = [[WKPreferences alloc]init];
    /// 最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
    preference.minimumFontSize = 0.0;
    /// 设置是否支持javaScript 默认是支持的
    preference.javaScriptEnabled = YES;
    /// 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
    preference.javaScriptCanOpenWindowsAutomatically = YES;
    config.preferences = preference;
    /// 自适应屏幕的宽度js
    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    /// 添加js调用
    [config.userContentController addUserScript:wkUserScript];
    _wkwebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, -STATUS_BAR_HEIGHT + 1, SCREEN_WIDTH, SCREEN_HEIGHT + STATUS_BAR_HEIGHT) configuration:config];
    [self.view addSubview:_wkwebView];
    /// UI代理
    _wkwebView.UIDelegate = self;
    // 导航代理
    _wkwebView.navigationDelegate = self;
    /// 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
    _wkwebView.allowsBackForwardNavigationGestures = YES;
    /// 添加监测网页加载进度的观察者
    [self webViewAddObserver];
}

- (void)loadWkWebViewWithURL:(NSString *)url {
    NSArray *urls = [url componentsSeparatedByString:@"?"];
    NSString *frantStr = urls.firstObject;
    NSString *lastStr = urls.lastObject;
    
    NSString *rUrl;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:[KKNetworkConfig shareInstance].user_loginKey forKey:@"loginKey"];
    [dic setValue:[KKUserInfoMgr shareInstance].userId forKey:@"authedUserId"];
    NSString *sign = [CC_FormatDic getSignFormatStringWithDic:dic andMD5Key:[KKNetworkConfig shareInstance].user_signKey];
    rUrl = [NSString stringWithFormat:@"%@?%@&%@", frantStr, sign, lastStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:rUrl]];
    [self.wkwebView loadRequest:request];
}


#pragma mark WKNavigationDelegate
/// 页面开始加载时调用, WKNavigationDelegate主要处理一些跳转、加载处理操作，WKUIDelegate主要处理JS脚本，确认框，警告框等
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

/// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
}

/// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

/// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
#if 0
    
#endif
    /// 页面加载完成之后, 判断按钮的隐藏状态, 之后进入的多层,才会显示按钮
    if ([self.wkwebView canGoBack]) {
        
    }else {
        
    }
    
    [self forbidWebviewEnlargedAndShrink:self.wkwebView];
}

/// 提交发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self.progressView setProgress:0.0f animated:NO];
}

/// 接收到服务器跳转请求即服务重定向时之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    
}

#pragma mark - KVO
-(void)webViewAddObserver {
    [self.wkwebView addObserver:self
                     forKeyPath:@"estimatedProgress"
                        options:0
                        context:nil];
}

/// observeValueForKeyPath: 监听进度
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey,id> *)change
                       context:(void *)context{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))]
        && object == _wkwebView) {
        NSLog(@"网页加载进度 = %f",_wkwebView.estimatedProgress);
        self.progressView.progress = _wkwebView.estimatedProgress;
        if (_wkwebView.estimatedProgress >= 1.0f) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressView.progress = 0;
            });
        }
    }else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

#pragma mark WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if ([message.name isEqualToString:@"popViewController"]) {
        
        [self popVC];
    }else if ([message.name isEqualToString:@"pushInformationDetail"]){
        
        [self pushDiscoverDetail:message.body];
    }else if ([message.name isEqualToString:@"toCreateGameBoard"]) {
        
        [self toStartCreateGameBoard];
    }else if ([message.name isEqualToString:@"toInvite"]){
        
        [self toPushInviteVC];
    }
}


#pragma mark jump
- (void)toStartCreateGameBoard{
    KKCustomTabViewController *tab  = (KKCustomTabViewController *)[[UIApplication sharedApplication] delegate].window.rootViewController;
    [tab setSelectedIndex:0];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)popVC {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)toPushInviteVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)pushDiscoverDetail:(NSString *)body {
    KKDiscoverDetailViewController *vc = New(KKDiscoverDetailViewController);
    vc.bodyId = body;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)dealloc {
    /// 移除观察者
    [self.wkwebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    [self.wkwebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(title))];
    /// 移除scriptMsgHandler
    WKUserContentController *userCC = self.wkwebView.configuration.userContentController;
    [userCC removeScriptMessageHandlerForName:@"popViewController"];
    [userCC removeScriptMessageHandlerForName:@"pushInformationDetail"];
    [userCC removeScriptMessageHandlerForName:@"toCreateGameBoard"];
    [userCC removeScriptMessageHandlerForName:@"toInvite"];

}

- (UIStatusBarStyle)getStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)forbidWebviewEnlargedAndShrink:(WKWebView *)webView{
    NSString* javascript = @"var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);";
    [webView evaluateJavaScript:javascript completionHandler:nil];
}

@end
