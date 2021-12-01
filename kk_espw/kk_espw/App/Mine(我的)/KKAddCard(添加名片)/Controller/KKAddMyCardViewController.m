//
//  KKAddMyCardViewController.m
//  kk_espw
//
//  Created by 景天 on 2019/7/16.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKAddMyCardViewController.h"
#import "KKSexSelectView.h"
#import "KKAddCardBottomView.h"
#import <CatCommonSelect.h>
#import "KKAddCardService.h"
#import "KKCardTag.h"
#import "KKMessage.h"
@interface KKAddMyCardViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
CatCommonSelectDelegate,
UITextFieldDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *detailDataArray;

@property (nonatomic, strong) UITextField *danTf;
@property (nonatomic, strong) UITextField *nameTf;

@property (nonatomic, strong) KKSexSelectView *sexSelectView;
@property (nonatomic, strong) KKAddCardBottomView *cardBottomView;
@property (nonatomic, strong) CatCommonSelect *commonSelect;
@property (nonatomic, strong) CatCommonSelect *danSelectView;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *areaStr;

@end

@implementation KKAddMyCardViewController
#pragma mark - UI
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT + RH(10), SCREEN_WIDTH, RH(49) * 3) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.bounces = NO;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavUI];
    [self setUI];
    /// 初始值
    _dataArray = @[@"*所在大区", @"*段位", @"*昵称"];
    _detailDataArray = @[@"请选择角色所在的大区", @"请选择段位", @"请填写昵称"];
    /// 默认性别
    _sex = @"M";
    
    /// 编辑名片和添加名片特殊处理下
    /// 如果是编辑名片
    if (_isEdit == YES) {
        /// 区, 段位, 昵称赋值
        _detailDataArray = @[_cardInfo.platformType.message, _cardInfo.rank.message, _cardInfo.nickName];
        /// 性别视图处理下
        if ([_cardInfo.sex.name isEqualToString:@"M"]) {
            _sexSelectView.sex = _cardInfo.sex.name;
        }else  {
            _sexSelectView.sex = _cardInfo.sex.name;
        }
        /// 默认选中的性别传值
        _sex = _cardInfo.sex.name;
        /// 服务器
        _cardBottomView.tf.text = _cardInfo.serviceArea;
        _areaStr = _cardInfo.serviceArea;
        /// 擅长位置
        _cardBottomView.preferLocations = (NSMutableArray *)_cardInfo.preferLocations;
    }
}

#pragma mark - UI
- (void)setUI {
    [self.view addSubview:self.tableView];
    [self createAreaSelectView];
    [self createSexSelectView];
    [self createCarBottomView];
    [self createDanSelectView];
}

- (void)setNavUI {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    if (_isEdit == YES) {
        [self setNaviBarTitle:@"编辑名片"];
        return;
    }
    [self setNaviBarTitle:@"添加名片"];
}

- (UITextField *)createTf:(NSIndexPath *)indexPath {
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - RH(280 + 18) - 20, RH(17), RH(280), RH(16))];
    tf.placeholder = self.detailDataArray[indexPath.row];
    tf.adjustsFontSizeToFitWidth = YES;
    tf.font = RF(14);
    tf.textAlignment = NSTextAlignmentRight;
    NSAttributedString *atStr = [[NSAttributedString alloc]initWithString:@"请输入昵称" attributes:@{NSForegroundColorAttributeName : KKES_COLOR_GRAY_TEXT}];
    tf.attributedPlaceholder = atStr;
    tf.textColor = KKES_COLOR_GRAY_TEXT;
    /// 如果是编辑名片.
    if (_isEdit == YES) {
        tf.text = self.cardInfo.nickName;
    }
    return tf;
}

/// 创建区选择器
- (void)createAreaSelectView {
    _commonSelect = [[CatCommonSelect alloc]initWithCancelTitle:@"取消" confirmTitle:@"确认" dataArr:@[@"微信", @"QQ"]];
    _commonSelect.selectContentColor = KKES_COLOR_MAIN_YELLOW;
    _commonSelect.delegate = self;
    
    if (self.isEdit == YES) {
        if ([_cardInfo.platformType.message isEqualToString:@"微信"]) {
            _commonSelect.selectIndex = 0;
        }else {
            _commonSelect.selectIndex = 1;
        }
    }else {
        _commonSelect.selectIndex = 0;
    }
}

/// 创建段位选择器
- (void)createDanSelectView {
    _danSelectView = [[CatCommonSelect alloc]initWithCancelTitle:@"取消" confirmTitle:@"确认" dataArr:@[@"青铜", @"白银", @"黄金", @"铂金", @"钻石", @"星耀", @"王者", @"荣耀"]];
    _danSelectView.selectContentColor = KKES_COLOR_MAIN_YELLOW;
    _danSelectView.delegate = self;
    
    if (self.isEdit == YES) {
        if ([_cardInfo.rank.message isEqualToString:@"青铜"]) {
            _danSelectView.selectIndex = 0;
        }else if ([_cardInfo.rank.message isEqualToString:@"白银"]) {
            _danSelectView.selectIndex = 1;
        }else if ([_cardInfo.rank.message isEqualToString:@"黄金"]) {
            _danSelectView.selectIndex = 2;
        }else if ([_cardInfo.rank.message isEqualToString:@"铂金"]) {
            _danSelectView.selectIndex = 3;
        }else if ([_cardInfo.rank.message isEqualToString:@"钻石"]) {
            _danSelectView.selectIndex = 4;
        }else if ([_cardInfo.rank.message isEqualToString:@"星耀"]) {
            _danSelectView.selectIndex = 5;
        }else if ([_cardInfo.rank.message isEqualToString:@"王者"]) {
            _danSelectView.selectIndex = 6;
        }else if ([_cardInfo.rank.message isEqualToString:@"荣耀"]) {
            _danSelectView.selectIndex = 7;
        }
    }else {
        _danSelectView.selectIndex = 4;
    }
}

/// 创建性别选择器
- (void)createSexSelectView {
    WS(weakSelf)
    _sexSelectView = [[KKSexSelectView alloc] initWithFrame:CGRectMake(0, self.tableView.bottom + RH(10), SCREEN_WIDTH, RH(97))];
    [self.view addSubview:_sexSelectView];
    _sexSelectView.didSelectViewWithMaleBlock = ^{
        weakSelf.sex = @"M";
    };
    _sexSelectView.didSelectViewWithFeMaleBlock = ^{
        weakSelf.sex = @"F";
    };
}

/// 服务区, 提交按钮
- (void)createCarBottomView {
    WS(weakSelf)
    _cardBottomView = [[KKAddCardBottomView alloc] initWithFrame:CGRectMake(0, self.sexSelectView.bottom + RH(10), SCREEN_WIDTH, RH(230))];
    _cardBottomView.locSelectBlock = ^(NSMutableArray * _Nonnull arr) {
        [weakSelf toCommit:arr];
    };
    _cardBottomView.inputAreaStrBlock = ^(NSString * _Nonnull str) {
        weakSelf.areaStr = str;
    };
    [self.view addSubview:_cardBottomView];
}

#pragma mark - CatCommonSelectDelegate
- (void)catCommonSelectCancel:(CatCommonSelect *)commonSelect{
    
}

- (void)catCommonSelectConfirm:(CatCommonSelect *)commonSelect selectData:(NSString *)selectData{
    if (commonSelect == _commonSelect) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.detailTextLabel.text = selectData;
    }else {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        cell.detailTextLabel.text = selectData;
    }
}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RH(49);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idr = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idr];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:idr];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.textLabel.font = RF(15);
    cell.textLabel.textColor = KKES_COLOR_BLACK_TEXT;
    
    if (indexPath.row == 2) {
        _nameTf = [self createTf:indexPath];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
        [cell.contentView addSubview:_nameTf];
    }else {
        cell.detailTextLabel.text = self.detailDataArray[indexPath.row];
        cell.detailTextLabel.font = RF(14);
        cell.detailTextLabel.textColor = KKES_COLOR_GRAY_TEXT;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [_commonSelect popUpCatCommonSelectView];
    }else if (indexPath.row == 1) {
        [_danSelectView popUpCatCommonSelectView];
    }
}

- (void)textFiledEditChanged:(NSNotification *)obj{
    
    UITextField *textfield = (UITextField *)obj.object;
    
    NSString *toBeString = textfield.text;
    //获取高亮部分
    UITextRange *selectedRange = [textfield markedTextRange];
    UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position || !selectedRange){
        if (toBeString.length > 12){
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:12];
            if (rangeIndex.length == 1){
                textfield.text = [toBeString substringToIndex:12];
            }else{
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 12)];
                textfield.text = [toBeString substringWithRange:rangeRange];
            }
            [CC_Notice show:@"最多12个字符"];
        }
    }
}

#pragma mark - Action
- (void)toCommit:(NSMutableArray *)arr {
    UITableViewCell *cellRow0 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UITableViewCell *cellRow1 = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if ([cellRow0.detailTextLabel.text isEqualToString:@"请选择角色所在的大区"]) {
        [CC_Notice show:@"请选择角色所在的大区"];
        return;
    }
    if ([cellRow1.detailTextLabel.text isEqualToString:@"请选择段位"]) {
        [CC_Notice show:@"请选择段位"];
        return;
    }
    if (_nameTf.text.length == 0) {
        [CC_Notice show:@"请填写昵称"];
        return;
    }
    
    if ([_areaStr isEqualToString:@"请填写所在区"]) {
        _areaStr = nil;
    }
    
    if (arr.count == 0) {
        arr = nil;
    }

    /// 段位
    NSString *rank = [KKDataDealTool returnDangradingEngWithChineseStr:cellRow1.detailTextLabel.text];
    /// 区
    NSString *platformType = [KKDataDealTool returnPlatformTypeEngWithChineseStr:cellRow0.detailTextLabel.text];
    /// 昵称
    NSString *nickName = _nameTf.text;
    /// 性别
    NSString *sex = _sex;
    /// 服务器
    NSString *area = _areaStr;
    /// 擅长段位
    NSString *preferLocations;
    if (arr.count == 1) {
        preferLocations = arr.firstObject;
    }else {
        preferLocations = [arr componentsJoinedByString:@","];
    }
    
    NSLog(@"platformType = %@\n,rank = %@\n, nickName = %@\n, sex = %@\n, area = %@\n, preferLocations = %@", platformType, rank, nickName, sex, area, preferLocations);
    
    [self requestAddCardPlatformType:platformType dan:rank nickName:nickName sex:sex area:area preferLocations:preferLocations];
    
}

#pragma mark - Net
- (void)requestAddCardPlatformType:(NSString *)platformType
                               dan:(NSString *)dan
                          nickName:(NSString *)nickName
                               sex:(NSString *)sex
                              area:(NSString *)area
                   preferLocations:(NSString *)preferLocations{
    WS(weakSelf)
    if (_isEdit == YES) {
        [KKAddCardService shareInstance].service = @"USER_GAME_PROFILES_MODIFY";
        [KKAddCardService shareInstance].ID = _cardInfo.ID;
    }else {
        [KKAddCardService shareInstance].service = @"USER_GAME_PROFILES_CREATE";
    }
    [KKAddCardService shareInstance].platformType = platformType;
    [KKAddCardService shareInstance].rank = dan;
    [KKAddCardService shareInstance].nickName = nickName;
    [KKAddCardService shareInstance].sex = sex;
    [KKAddCardService shareInstance].serviceArea = area;
    [KKAddCardService shareInstance].preferLocations = preferLocations;
    [KKAddCardService requestaddCardSuccess:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } Fail:^{
        
    }];
}

@end
