//
//  KKSystemSettingViewController.m
//  kk_espw
//
//  Created by 景天 on 2019/7/17.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKSystemSettingViewController.h"
#import "MLLKPwdMgrVC.h"
#import "MLLKRealNameVC.h"
#import <SDImageCache.h>
#import "KKSystemSetService.h"
#import <LoginLib.h>
@interface KKSystemSettingViewController ()<UITableViewDelegate, UITableViewDataSource, CatDefaultPopDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) CatDefaultPop *pop;
@property (nonatomic, strong) CatDefaultPop *popClean;
@property (nonatomic, copy) NSString *realNameAuthentication;
@property (nonatomic, copy) NSString *certNo;

@end

@implementation KKSystemSettingViewController
#pragma mark - Init
- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, RH(10) + STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, RH(49) * 4) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
    }
    return _tableView;
}

#pragma mark - Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = @[@"密码管理", @"实名认证", @"清理缓存", @"关于KK电竞"];
    [self setUI];
    [self setNavUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestAuthRealNameData];
}


#pragma mark - UI
- (void)setNavUI {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"系统设置"];
}

- (void)setUI {
    [self.view addSubview:self.tableView];
    [self createQuitButton];
}

- (void)showLogoutPopView {
    CatDefaultPop *pop = [[CatDefaultPop alloc] initWithTitle:@"退出登录?" content:@"您确定要退出登录吗?" cancelTitle:@"取消" confirmTitle:@"确定"];
    pop.delegate = self;
    self.pop = pop;
    [pop popUpCatDefaultPopView];
    pop.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    [pop updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
}

- (void)showCleanPopView{
    /// 获取缓存图片的大小(字节)
    NSUInteger bytesCache = [[SDImageCache sharedImageCache] getSize];
    /// 换算成 MB (注意iOS中的字节之间的换算是1000不是1024)
    float chachMb = bytesCache/1000/1000;
    
    //1.不需要清理
    if (chachMb < 0.01) {
        [CC_Notice show:@"暂无缓存"];
        return;
    }
    
    //2.pop
    CatDefaultPop *pop = [[CatDefaultPop alloc] initWithTitle:@"清理缓存?" content:[NSString stringWithFormat:@"您确定要清理%.1fM缓存吗?", chachMb] cancelTitle:@"取消" confirmTitle:@"确定"];
    pop.delegate = self;
    self.popClean = pop;
    [pop popUpCatDefaultPopView];
    pop.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    [pop updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
}

/// 按钮
- (void)createQuitButton {
    WS(weakSelf)
    CC_Button *quitButton = [CC_Button buttonWithType:UIButtonTypeCustom];
    quitButton.top = _tableView.bottom + RH(44);
    quitButton.left = RH(25);
    quitButton.size = CGSizeMake(SCREEN_WIDTH - RH(50), RH(45));
    [quitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    quitButton.backgroundColor = RGB(255, 90, 90);
    quitButton.layer.cornerRadius = RH(4);
    quitButton.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:16];
    [quitButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        [weakSelf showLogoutPopView];
    }];
    [self.view addSubview:quitButton];
}

#pragma mark - <UITableViewDelegate, UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RH(49);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idr = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idr];
    }
    cell.textLabel.font = RF(15);
    cell.textLabel.textColor = KKES_COLOR_BLACK_TEXT;
    cell.textLabel.text = _dataArray[indexPath.row];
    if (indexPath.row != 3) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
        NSString *appVersion = [dic objectForKey:@"CFBundleShortVersionString"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"版本%@", appVersion];
    }
    cell.detailTextLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.certNo.length > 0) {
        cell.detailTextLabel.text = @"已认证";
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        MLLKPwdMgrVC *vc = [[MLLKPwdMgrVC alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1) {
        if (self.certNo.length <= 0) {
            MLLKRealNameVC *vc = [[MLLKRealNameVC alloc]init];
            WS(weakSelf)
            vc.successBlock = ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if (indexPath.row == 2) {
        [self showCleanPopView];
    }else {
        
    }
}

#pragma mark - CatDefaultPopDelegate
- (void)catDefaultPopConfirm:(CatDefaultPop *)defualtPop {
    if (defualtPop == self.pop) {
        /// 退出开黑房, 退出招募厅
        [[KKUserInfoMgr shareInstance] logoutAndSetNil:nil];
    }
    if (defualtPop == self.popClean) {
        [[CC_Mask getInstance] start];
        [CC_Mask getInstance].textL.text = @"清理中";
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[CC_Mask getInstance] stop];
                [CC_Notice show:@"清理完成"];
            });
        }];
        return;
    }
}

#pragma mark - Net
- (void)requestAuthRealNameData {
    WS(weakSelf)
    [[LoginLib getInstance] oneAuthInfoQueryWithExtraParamDic:nil AtView:self.view mask:YES block:^(NSDictionary * _Nullable modifiedDic, ResModel * _Nonnull resModel) {
        NSDictionary *dic = resModel.resultDic[@"response"][@"oneAuthInfo"];
        weakSelf.certNo = dic[@"certNo"];
        [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

@end
