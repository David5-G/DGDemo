//
//  KKGameReportController.m
//  kk_espw
//
//  Created by hsd on 2019/7/25.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameReportController.h"
#import "KKGameReportTypeCell.h"
#import "KKGameReportSnapshotCell.h"
#import "KKGameReportTableHeaderView.h"
#import "KKReportType.h"


@interface KKGameReportController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSArray <KKReportType *>*_reportTypeArr;
    
    NSString *_selectedTypeStr;
    NSArray *_selectedImages;
    
}
@property (nonatomic, strong, nonnull) UITableView *tableView;
@property (nonatomic, strong, nonnull) CC_Button *reportBtn;
@property (nonatomic, strong, nonnull) NSIndexPath *selectIndexPath;

@end

@implementation KKGameReportController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KKES_COLOR_HEX(0xF5F5F5);
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"举报"];
    [self requetReportType];
    [self initTableView];
    [self initReportBtn];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[KKFloatViewMgr shareInstance] hiddenLiveStudioFloatView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[KKFloatViewMgr shareInstance] notHiddenLiveStudioFloatView];
}

#pragma mark - init
- (void)initdefaultData {
    self.selectIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}
- (void)initTableView {
    
    CGFloat navHeight = STATUS_AND_NAV_BAR_HEIGHT;
    
    CGRect frame = [UIScreen mainScreen].bounds;
    frame.size.height -= (124 + navHeight);
    frame.origin.y = navHeight;
    
    self.tableView = [[UITableView alloc] initWithFrame:frame style: UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = KKES_COLOR_HEX(0xF5F5F5);
    self.tableView.backgroundColor = self.view.backgroundColor;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //防止刷新单个cell时, tableView跳动到其他的cell的位置
    self.tableView.estimatedRowHeight = 0.0;
    self.tableView.estimatedSectionHeaderHeight = 0.0;
    self.tableView.estimatedSectionFooterHeight = 0.0;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KKGameReportTypeCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([KKGameReportTypeCell class])];
    
    [self.view addSubview:self.tableView];
}

- (void)initReportBtn {
    self.reportBtn = [[CC_Button alloc] init];
    self.reportBtn.layer.cornerRadius = 4;
    self.reportBtn.layer.masksToBounds = YES;
    [self.reportBtn setBackgroundColor:KKES_COLOR_HEX(0xECC165)];
    [self.reportBtn setTitleColor:KKES_COLOR_HEX(0xFFFFFF) forState:UIControlStateNormal];
    [self.reportBtn setTitleColor:KKES_COLOR_HEX(0x929292) forState:UIControlStateHighlighted];
    self.reportBtn.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:16];
    [self.reportBtn setTitle:@"提交举报" forState:UIControlStateNormal];
    
    WS(weakSelf)
    [self.reportBtn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        
        SS(strongSelf)
        strongSelf->_selectedTypeStr = strongSelf->_reportTypeArr[strongSelf.selectIndexPath.row].code;
        [weakSelf requestUploadImage];
    }];
    
    [self.view addSubview:self.reportBtn];
    [self.reportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(25);
        make.right.mas_equalTo(self.view).mas_offset(-25);
        make.bottom.mas_equalTo(self.view).mas_offset(-66);
        make.height.mas_equalTo(45);
    }];
}

#pragma mark - request

-(void)requetReportType{
    
    NSArray *reportTypes = @[
//                       @{@"message":@"开黑名片举报",@"code":@"GAME_BOARD_PROFILE"},
                       @{@"message":@"水平过低",@"code":@"LEVEL_TOO_LOW"},
                       @{@"message":@"神坑队友",@"code":@"RUBBISH_TEAM_PEOPLE"},
                       @{@"message":@"辱骂攻击",@"code":@"ABUSIVE_ATTACK"},
                       @{@"message":@"淫秽色情",@"code":@"OBSCENE_PORN"},
                       ];
    _reportTypeArr = [KKReportType mj_objectArrayWithKeyValuesArray:reportTypes];
    
}

-(void)requestUploadImage{
    [[CC_Mask getInstance] start];
    [[CC_HttpTask getInstance] uploadImages:_selectedImages url:[KKNetworkConfig currentUrl] params:nil imageSize:1 reConnectTimes:0 finishBlock:^(NSArray<ResModel *> *errorModelArr, NSArray<ResModel *> *successModelArr) {
        [[CC_Mask getInstance] stop];

        ResModel *res = errorModelArr.firstObject;
        if (res) {
            [CC_Notice show:res.errorMsgStr];
    
        }else {
            NSMutableString *mutStr = [NSMutableString new];
            for (ResModel *model in successModelArr) {
                [mutStr appendFormat:@"%@,",model.resultDic[@"response"][@"fileName"]];
            }
            [self requestReport:mutStr];
        }
    }];
}

-(void)requestReport:(NSString *)fileName
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params safeSetObject:@"GAME_BOARD_COMPLAINT" forKey:@"service"];
    [params safeSetObject:_complaintObjectId forKey:@"complaintObjectId"];
    [params safeSetObject:_userId forKey:@"userId"];
    [params safeSetObject:_selectedTypeStr forKey:@"complaintType"];
    [params safeSetObject:fileName forKey:@"complaintImage"];
    [params setObject:[KKUserInfoMgr shareInstance].userId forKey:@"complaintUserId"];
    
    [[CC_Mask getInstance] start];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resmodel) {

        if (error) {
            [CC_Notice show:error];
        }else{
            [CC_Notice show:@"举报成功！本平台将在24小时内处理"];
            [self.navigationController popViewControllerAnimated:YES];
        }
        [[CC_Mask getInstance] stop];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0) ? _reportTypeArr.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        KKGameReportTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([KKGameReportTypeCell class]) forIndexPath:indexPath];
        cell.titleString = _reportTypeArr[indexPath.row].message;
        cell.reportSelect = (indexPath.row == self.selectIndexPath.row);
        return cell;
        
    } else {
        KKGameReportSnapshotCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([KKGameReportSnapshotCell class])];
        if (!cell) {
            cell = [[KKGameReportSnapshotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([KKGameReportSnapshotCell class])];
        }
        WS(weakSelf)
        cell.imageSelect = ^(NSArray * _Nonnull imgArr) {
            SS(strongSelf)
            strongSelf->_selectedImages = imgArr;
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 49 : 141;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return section == 0 ? 40 : 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 1 ? 65 : 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    KKGameReportTableHeaderView *headerView = [[KKGameReportTableHeaderView alloc] init];
    headerView.backgroundColor = KKES_COLOR_HEX(0xF5F5F5);
    headerView.topInset = (section == 1 ? 19 : 15);
    if (section == 0) {
        headerView.titleString = @"请选择举报类型";
    }else if (section == 1) {
        headerView.titleString = @"上传举报凭证（开黑房截图+游戏截图）";
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        KKGameReportTableHeaderView *footView = [[KKGameReportTableHeaderView alloc] init];
        footView.backgroundColor = KKES_COLOR_HEX(0xF5F5F5);
        footView.titleFont = [KKFont pingfangFontStyle:PFFontStyleMedium size:12];
        footView.titleString = @"3个工作日内客服进行审核，如属实将扣用户的靠谱分。情节严重将直接封号！";
        return footView;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        self.selectIndexPath = indexPath;
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 25.0, 0, 0);
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        tableView.layoutMargins = inset;
        cell.layoutMargins = inset;
    }
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = inset;
    }
}

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
