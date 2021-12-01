//
//  KKEditUserInfoController.m
//  kk_espw
//
//  Created by 景天 on 2019/7/15.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKEditUserInfoController.h"
#import <CatCommonSelect.h>
#import <CatDateSelect.h>
#import <CatDateSelectTool.h>
#import <CatCitySelect.h>
#import <CatPickerPhotoController.h>
#import "KKEditUserInfoService.h"
#import "KKMessage.h"
#import "UIViewController+ImagePicker.h"
#import "LoginLib.h"
@interface KKEditUserInfoController ()
<
UITableViewDataSource,
UITableViewDelegate,
CatCommonSelectDelegate,
CatDateSelectDelegate,
CatCitySelectDelegate,
CatPickerPhotoControllerDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UILabel *sexLabel;
@property (nonatomic, strong) UILabel *birthLabel;
@property (nonatomic, strong) UILabel *areaLabel;
@property (nonatomic, strong) UIButton *editImageButton;
@property (nonatomic, strong) CatCommonSelect *commonSelect;
@property (nonatomic, strong) CatDateSelect *dateSelect;
@property (nonatomic, strong) CatCitySelect *citySelect;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) UIImage *headImage;
@property (nonatomic, strong) UITextField *textF;
@end
@implementation KKEditUserInfoController
#pragma mark - 初始化
- (UILabel *)birthLabel {
    if (!_birthLabel) {
        _birthLabel = [[UILabel alloc] initWithFrame:CGRectMake(RH(96), RH(17), SCREEN_WIDTH - 2 * RH(96), 14)];
        _birthLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:14];
    }
    return _birthLabel;
}

- (UILabel *)areaLabel {
    if (!_areaLabel) {
        _areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(RH(96), RH(17), SCREEN_WIDTH - 2 * RH(96), 14)];
        _areaLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:14];
    }
    return _areaLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, RH(170) + STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, RH(49) * 4) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
        _tableView.tableFooterView = New(UIView);
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (UIButton *)editImageButton {
    if (!_editImageButton) {
        WS(weakSelf)
        _editImageButton = New(UIButton);
        _editImageButton.top = RH(25) + STATUSBAR_ADD_NAVIGATIONBARHEIGHT;
        _editImageButton.left = (SCREEN_WIDTH - RH(120)) / 2;
        _editImageButton.size = CGSizeMake(RH(120), RH(120));
        _editImageButton.backgroundColor = [UIColor lightGrayColor];
        _editImageButton.layer.cornerRadius = RH(60);
        _editImageButton.clipsToBounds = YES;
        [_editImageButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            [weakSelf editImageButtonAction];
        }];
    }
    return _editImageButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray = @[@"昵   称:", @"性   别:", @"生   日:", @"地   区:"];
    [self setNavUI];
    [self setUI];
    
    [self requestMyInfo];
}

- (void)setNavUI {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"编辑资料"];
}

- (void)setUI {
    [self.view addSubview:self.editImageButton];
    [self.view addSubview:self.tableView];
    [self createCommitButton];
    [self createSexSelectView];
    [self createDateSelectView];
    [self createCitySelectView];
    /// 右下角的图标
    UIImageView *rBottomImageView = New(UIImageView);
    rBottomImageView.top = _editImageButton.bottom - RH(35);
    rBottomImageView.left = (SCREEN_WIDTH - RH(120)) / 2 + RH(95);
    rBottomImageView.image = Img(@"mine_bottom_cm");
    rBottomImageView.size = CGSizeMake(RH(25), RH(25));
    [self.view addSubview:rBottomImageView];
}

- (UILabel *)createCellLabelWithTextColor:(UIColor *)textColor {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(RH(96), RH(17), SCREEN_WIDTH - 2 * RH(96), 14)];
    label.textColor = textColor;
    label.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:14];
;
    return label;
}

/// 创建性别选择器
- (void)createSexSelectView {
    _commonSelect = [[CatCommonSelect alloc]initWithCancelTitle:@"取消" confirmTitle:@"确认" dataArr:@[@"男", @"女"]];
    _commonSelect.selectContentColor = KKES_COLOR_MAIN_YELLOW;
    _commonSelect.delegate = self;
}

/// 创建日期选择器
- (void)createDateSelectView {
    CCLOG(@"%@", [CatDateSelectTool caculateCurrentDate]);
    _dateSelect = [[CatDateSelect alloc] initWithCancelTitle:@"取消" confirmTitle:@"确认" theme:CatDateSelectThemeDay minDate:@"1900-01-01" maxDate:[CatDateSelectTool caculateCurrentDate]];
    _dateSelect.delegate = self;
}

/// 创建城市选择器
- (void)createCitySelectView {
    _citySelect = [[CatCitySelect alloc] init];
    _citySelect.delegate = self;
}

/// 创建图片选择器
- (void)createCatPickerPhotoController {
    CatPickerPhotoController *vc = [CatPickerPhotoController controllerWithMode:CatPickerPhotoModeSingle delegate:self];
    [vc.backButton setImage:Img(@"navi_back_gray") forState:UIControlStateNormal];
    CatTakePhoneImages(vc, @"photo_select", @"photo_unselect", @"editinfo_take_photo");
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navC animated:YES completion:nil];
}

/// 确定按钮
- (void)createCommitButton {
    CC_Button *commitButton = [CC_Button buttonWithType:UIButtonTypeCustom];
    commitButton.top = _tableView.bottom + RH(25);
    commitButton.left = RH(20);
    commitButton.size = CGSizeMake(SCREEN_WIDTH - RH(40), RH(45));
    [commitButton setTitle:@"确定" forState:UIControlStateNormal];
    commitButton.backgroundColor = KKES_COLOR_MAIN_YELLOW;
    commitButton.layer.cornerRadius = RH(6);
    WS(weakSelf)
    [commitButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        [weakSelf toCommit];
    }];
    [self.view addSubview:commitButton];
}

#pragma mark - CatPickerPhotoControllerDelegate
- (void)catPickerPhotoController:(CatPickerPhotoController *)controller
       didFinishPickingWithItems:(NSArray <UIImage *> *)images {
    if (images.count == 0) {
        return;
    }
    _headImage = images.firstObject;
    [_editImageButton setImage:_headImage forState:UIControlStateNormal];
}

#pragma mark - CatCitySelectDelegate
- (void)catCitySelectCancel:(CatCitySelect *)citySelect {
    
}

- (void)catCitySelectConfirm:(CatCitySelect *)citySelect selectProvince:(NSString *)selectProvince selectCity:(NSString *)selectCity selectDistrict:(NSString *)selectDistrict {
    _areaLabel.text = [NSString stringWithFormat:@"%@,%@,%@", selectProvince, selectCity, selectDistrict];
    _area = [NSString stringWithFormat:@"%@,%@,%@", selectProvince, selectCity, selectDistrict];
}

#pragma mark - CatDateSelectDelegate
- (void)catDateSelectCancel:(CatDateSelect *)dateSelect {
    
}

- (void)catDateSelectConfirm:(CatDateSelect *)dateSelect selectYear:(NSString *)selectYear selectMonth:(NSString *)selectMonth selectDay:(NSString *)selectDay selectWeek:(NSString *)selectWeek {
    _birthLabel.text = [NSString stringWithFormat:@"%@-%@-%@", selectYear, selectMonth, selectDay];
    _birthday = [NSString stringWithFormat:@"%@-%@-%@", selectYear, selectMonth, selectDay];
}

#pragma mark - CatCommonSelectDelegate
- (void)catCommonSelectCancel:(CatCommonSelect *)commonSelect{
    
}

- (void)catCommonSelectConfirm:(CatCommonSelect *)commonSelect selectData:(NSString *)selectData{
    _sexLabel.text = selectData;
    _sex = selectData;
}

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return RH(49);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WS(weakSelf)
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = _dataArray[indexPath.row];
    cell.textLabel.font = RF(15);
    cell.textLabel.textColor = KKES_COLOR_BLACK_TEXT;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSInteger subTag = 1001;
    for (UIView *subview in cell.contentView.subviews) {
        if (subview.tag == subTag) {
            [subview removeFromSuperview];
        }
    }
    
    switch (indexPath.row) {
        case 0:
        {
            _textF = [[UITextField alloc] initWithFrame:CGRectMake(RH(96), RH(0), SCREEN_WIDTH - 2 * RH(96), RH(49))];
            _textF.tag = subTag;
            _textF.textColor = KKES_COLOR_GRAY_TEXT;
            _textF.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:14];
            _textF.text = [KKUserInfoMgr shareInstance].userInfoModel.nickName;
            [cell.contentView addSubview:_textF];
            return cell;
        }break;
        case 1:
        {
            _sexLabel = [self createCellLabelWithTextColor:KKES_COLOR_GRAY_TEXT];
            _sexLabel.tag = subTag;
            _sexLabel.text = [KKUserInfoMgr shareInstance].userInfoModel.sex.message;
            [cell.contentView addSubview:_sexLabel];
            [_sexLabel addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
                [weakSelf.commonSelect popUpCatCommonSelectView];
            }];
            return cell;
        }
            break;
        case 2:
        {
            [cell.contentView addSubview:self.birthLabel];
            NSString *userBirthday = [KKUserInfoMgr shareInstance].userInfoModel.birthday;
            if (userBirthday) {
                NSDateFormatter *formater = [[NSDateFormatter alloc] init];
                [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *birthday = [formater dateFromString:userBirthday];
                
                NSDateFormatter *formater1 = [[NSDateFormatter alloc] init];
                [formater1 setDateFormat:@"yyyy-MM-dd"];
                NSString *birthDayStr = [formater1 stringFromDate:birthday];
                _birthLabel.text = birthDayStr;
            }else {
                _birthLabel.text = @"请选择你的生日";
            }
            _birthLabel.textColor = KKES_COLOR_GRAY_TEXT;
            [_birthLabel addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
                [weakSelf.dateSelect popUpCatDateSelectView];
            }];
            return cell;
        }
            break;
        case 3:
        {
            
            [cell.contentView addSubview:self.areaLabel];
            NSString *userLocation = [KKUserInfoMgr shareInstance].userInfoModel.userLocation;
            if (userLocation.length != 0) {
                _areaLabel.text = userLocation;
            }else {
                _areaLabel.text = @"请选择你的地区";
            }
            _areaLabel.textColor = KKES_COLOR_GRAY_TEXT;
            [_areaLabel addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
                [weakSelf.citySelect popUpCatCitySelectView];
            }];
            return cell;
        }
            break;
        default:
            break;
    }
    return nil;
}

#pragma mark - Action
- (void)editImageButtonAction {
    WS(weakSelf)
    [self pickImageWithpickImageCutImageWithImageSize:CGSizeMake(400, 400) CompletionHandler:^(NSData * _Nonnull imageData, UIImage * _Nonnull image) {
        if (image != nil) {
            weakSelf.headImage = image;
            [weakSelf.editImageButton setImage:image forState:UIControlStateNormal];
        }else{
            [CC_Notice show:@"图片获取失败"];
        }
    }];
}

- (void)toCommit {
    [self requestEditUserInfo];
}

#pragma mark - Net
- (void)requestEditUserInfo {
    WS(weakSelf)
    if (_textF.text.length == 0) {
        [CC_Notice show:@"请设置角色名"];
        return;
    }
    
    NSString *sex;
    if ([_sexLabel.text isEqualToString:@"男"]) {
        sex = @"M";
    }else if ([_sexLabel.text isEqualToString:@"女"]) {
        sex = @"F";
    }else {
        sex = @"U";
    }
    /// 不修改地区和生日也可以提交
    NSString *area;
    if (![_areaLabel.text isEqualToString:@"请选择你的地区"]) {
        area = _areaLabel.text;
    }
    
    NSString *birth;
    if (![_birthLabel.text isEqualToString:@"请选择你的生日"]) {
        birth = _birthLabel.text;
    }
    
    NSLog(@"%@%@%@%@%@", _textF.text, _headImage, sex, birth, area);
    [[LoginLib getInstance] roleBasicInfoModify:_textF.text portrait:_headImage sex:sex birthday:birth location:area extraParamDic:nil atView:self.view mask:YES block:^(NSDictionary * _Nullable modifiedDic, ResModel * _Nonnull resModel) {
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    

}

- (void)requestUploadImageSuccess:(void(^)(void))success {
    [KKEditUserInfoService shareInstance].image = _headImage;
    [KKEditUserInfoService requestUploadImageSuccess:^{
        success();
    } Fail:^{
    }];
}

- (void)requestMyInfo {
    WS(weakSelf)
    [[KKUserInfoMgr shareInstance] requestUserInfoSuccess:^{
        [weakSelf.tableView reloadData];
        NSString *url = [NSString stringWithFormat:@"%@", [KKUserInfoMgr shareInstance].userInfoModel.userLogoUrl];
        [weakSelf.editImageButton sd_setBackgroundImageWithURL:Url(url) forState:UIControlStateNormal];
    } fail:nil];
}
@end
