//
//  KKLiveStudioGameRoomPopVC.m
//  kk_espw
//
//  Created by david on 2019/8/7.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioGameRoomPopVC.h"
#import "KKLiveStudioGameRoomViewModel.h"

@interface KKLiveStudioGameRoomPopVC ()
@property (nonatomic, strong) UITextField *idTextField;
@property (nonatomic, strong) UITextField *timeTextField;

//时间btn
@property (nonatomic, copy) NSString *selectedTimeStr;
@property (nonatomic, strong) UIView *timeButtonView;
@property (nonatomic, strong) UIButton *curTimeButton;
//
@property (nonatomic, copy) NSArray <NSString *>*timeArray;
@property (nonatomic, copy) NSString *minTimeConfig;
@property (nonatomic, copy) NSString *maxTimeConfig;
@end

@implementation KKLiveStudioGameRoomPopVC

#pragma mark - life circle
-(instancetype)init {
    self = [super init];
    if (self) {
        [self addKeyboardNotifications];
    }
    return self;
}

-(void)dealloc {
    [self removeKeyBoardNotifications];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self requestGameRoomRecommendTimeConfig];
}

#pragma mark - UI
#pragma mark 重写父类方法
-(void)setupSubViewsForDisplayView:(UIView *)displayView {
    CGFloat leftSpace = [ccui getRH:22];
    CGFloat topSpace = [ccui getRH:10];
    CGFloat titleH = [ccui getRH:40];
    
    //tap
    [self addTap:displayView];
    
    //1.title
    DGLabel *titleL = [DGLabel labelWithText:@"推荐开黑房" fontSize:[ccui getRH:18] color:KKES_COLOR_BLACK_TEXT bold:YES];
    titleL.textAlignment = NSTextAlignmentCenter;
    [displayView addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftSpace);
        make.top.mas_equalTo(topSpace);
        make.right.mas_equalTo(-leftSpace);
        make.height.mas_equalTo(titleH);
    }];
    
    //2.开黑房id
    //2.1 idInputV
    UIView *idInputV = [[UIView alloc]init];
    idInputV.backgroundColor = rgba(238, 238, 238, 1);
    idInputV.layer.cornerRadius = [ccui getRH:4];
    idInputV.layer.masksToBounds = YES;
    [displayView addSubview:idInputV];
    [idInputV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([ccui getRH:69]);
        make.left.mas_equalTo([ccui getRH:95]);
        make.right.mas_equalTo(-leftSpace);
        make.height.mas_equalTo([ccui getRH:35]);
    }];
    
    
    self.idTextField = [self setupInputView:idInputV placeholder:@"请输入ID"];
    self.idTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.idTextField addTarget:self action:@selector(roomIdDidChanged:) forControlEvents: UIControlEventEditingChanged];
    
    //2.2 idItemL
    DGLabel *idItemL = [DGLabel labelWithText:@"开黑房ID:" fontSize:[ccui getRH:14] color:KKES_COLOR_BLACK_TEXT bold:YES];
    [displayView addSubview:idItemL];
    [idItemL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:27]);
        make.centerY.mas_equalTo(idInputV);
    }];
    
    //3.推荐时长
    //3.1 itemL
    DGLabel *timeItemL = [DGLabel labelWithText:@"推荐时长:" fontSize:[ccui getRH:14] color:KKES_COLOR_BLACK_TEXT bold:YES];
    [displayView addSubview:timeItemL];
    [timeItemL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:27]);
        make.top.mas_equalTo(idInputV.mas_bottom).mas_offset([ccui getRH:30]);
    }];
    
    //3.2 timeBtnV
    UIView *timeBtnV = [[UIView alloc] init];
    self.timeButtonView = timeBtnV;
    [displayView addSubview:timeBtnV];
    [timeBtnV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeItemL.mas_bottom).mas_equalTo([ccui getRH:13]);
        make.left.mas_equalTo(leftSpace);
        make.right.mas_equalTo(-leftSpace);
        make.height.mas_equalTo([ccui getRH:38]);
    }];
    if(self.timeArray){
        [self refreshTimeButtonView];
    }
    
    //4.time
    //4.1 timeInputV
    UIView *timeInputV = [[UIView alloc]init];
    timeInputV.backgroundColor = rgba(238, 238, 238, 1);
    timeInputV.layer.cornerRadius = [ccui getRH:4];
    timeInputV.layer.masksToBounds = YES;
    [displayView addSubview:timeInputV];
    [timeInputV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(timeBtnV.mas_bottom).mas_offset([ccui getRH:5]);
        make.left.mas_equalTo(leftSpace);
        make.height.mas_equalTo([ccui getRH:35]);
        make.width.mas_equalTo([ccui getRH:77]);
    }];
    self.timeTextField = [self setupInputView:timeInputV placeholder:@"输入数字"];
    self.timeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.timeTextField addTarget:self action:@selector(timeDidChanged:) forControlEvents: UIControlEventEditingChanged];
    
    //4.2 unitL
    DGLabel *timeUnitL = [DGLabel labelWithText:@"秒" fontSize:[ccui getRH:12] color:KKES_COLOR_BLACK_TEXT];
    [displayView addSubview:timeUnitL];
    [timeUnitL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(timeInputV.mas_right).mas_offset([ccui getRH:4]);
        make.centerY.mas_equalTo(timeInputV);
    }];
    
    //5.confirmBtn
    DGButton *confirmBtn = [DGButton btnWithFontSize:[ccui getRH:16] title:@"确定" titleColor:UIColor.whiteColor];
    [confirmBtn setNormalBgColor:KKES_COLOR_YELLOW selectedBgColor:KKES_COLOR_YELLOW];
    confirmBtn.layer.cornerRadius = [ccui getRH:4];
    confirmBtn.layer.masksToBounds = YES;
    [displayView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftSpace);
        make.right.mas_equalTo(-leftSpace);
        make.height.mas_equalTo([ccui getRH:45]);
        make.bottom.mas_equalTo(-[ccui getRH:13]-HOME_INDICATOR_HEIGHT);
    }];
    
    WS(weakSelf);
    [confirmBtn addClickWithTimeInterval:0.5 block:^(DGButton *btn) {
        [weakSelf clickConfirmButton];
    }];
    
}


#pragma mark tool
-(void)refreshTimeButtonView {
    
    //过滤
    if (self.timeArray.count < 1) {
        return;
    }
    
    CGFloat btnW = [ccui getRH:59];
    CGFloat btnH = [ccui getRH:27];
    CGFloat spaceX = [ccui getRH:13];
    CGFloat spaceY = [ccui getRH:11];
    
    NSInteger rowCount = 4;
    NSInteger lineCount = (self.timeArray.count+rowCount-1)/rowCount;
    CGFloat timeBtnViewH = lineCount * (btnH + spaceY);
    
    //1.清空subview
    for (UIView *subview in self.timeButtonView.subviews) {
        [subview removeFromSuperview];
        self.curTimeButton = nil;
    }
    
    //2.更新约束
    [self.timeButtonView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(timeBtnViewH);
    }];
    
    //3.添加buttn
    for (NSInteger i=0; i<self.timeArray.count; i++) {
        NSString *title = [NSString stringWithFormat:@"%@秒",self.timeArray[i]];
        DGButton *btn = [DGButton btnWithFontSize:[ccui getRH:12] title:title titleColor:KKES_COLOR_GRAY_TEXT];
        [btn setNormalBgColor:rgba(238, 238, 238, 1) selectedBgColor:rgba(236, 193, 101, 1)];
        [btn setNormalTitleColor:KKES_COLOR_GRAY_TEXT selectedTitleColor:UIColor.whiteColor];
        btn.frame = CGRectMake((i%rowCount)*(btnW+spaceX), (i/4)*(btnH+spaceY), btnW, btnH);
        btn.layer.cornerRadius = btnH/2.0;
        btn.layer.masksToBounds = YES;
        [self.timeButtonView addSubview:btn];
        
        //4.处理点击
        WS(weakSelf);
        [btn addClickWithTimeInterval:0.01 block:^(DGButton *btn) {
            SS(strongSelf);
            
            //4.1 btn处理
            if (btn == strongSelf.curTimeButton) {
                btn.selected = NO;
                strongSelf.curTimeButton = nil;
            }else {
                strongSelf.curTimeButton.selected = NO;
                btn.selected = YES;
                strongSelf.curTimeButton = btn;
            }
            
            //4.2 只要点击btn,就关闭键盘
            [strongSelf.view endEditing:YES];
            
            //4.3时间
            strongSelf.timeTextField.text = nil;
            [strongSelf timeDidChanged:strongSelf.timeTextField];
        }];
        
        //5.默认选中第二个
        if(i == 1){
            btn.selected = YES;
            self.curTimeButton = btn;
        }
    }
    
}

-(UITextField *)setupInputView:(UIView *)inputV placeholder:(NSString *)placeholder {
    
    //1.
    DGTextField *tf = [[DGTextField alloc]init];
    NSAttributedString *placeholderString = [[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName : KKES_COLOR_GRAY_LINE}];
    tf.attributedPlaceholder = placeholderString;
    [tf setFont:[ccui getRH:14] textColor:KKES_COLOR_BLACK_TEXT textAlignment:NSTextAlignmentLeft];
    tf.placeholder = placeholder;
    tf.movingView = self.view;
    tf.spaceY = 10;
    //2.
    [inputV addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:11]);
        make.top.bottom.right.mas_equalTo(0);
    }];
    
    //3.
    return tf;
}

#pragma mark - interaction
-(void)clickConfirmButton {
    if (self.timeTextField.text.length > 0) {
        self.selectedTimeStr = self.timeTextField.text;
    }else{
        self.selectedTimeStr = [self.curTimeButton titleForState:UIControlStateNormal];
    }
    
    if (self.idTextField.text.length < 1) {
        [CC_Notice show:@"请输入房间ID"];
        return;
    }
    
    if ([self.selectedTimeStr integerValue] < [self.minTimeConfig integerValue] ||
        [self.selectedTimeStr integerValue] > [self.maxTimeConfig integerValue]) {
        NSString *noticeStr = [NSString stringWithFormat:@"推荐时长不符合规范, 请输入%@-%@的数字",self.minTimeConfig,self.maxTimeConfig];
        [CC_Notice show:noticeStr];
        return;
    }
    
    
    [self requestGameRoomRecommend];
        
}

#pragma mark tap
-(void)addTap:(UIView *)view {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)] ;
    [view addGestureRecognizer:tap];
}

-(void)closeKeyboard:(UIGestureRecognizer *)gr {
    [self.view endEditing:YES];
}


#pragma mark - UITextField输入改变
-(void)roomIdDidChanged:(UITextField *)textField {
    
    
}

-(void)timeDidChanged:(UITextField *)textField {
     //1.timeBtn
    if (textField.text.length > 0 && self.curTimeButton.selected) {
        self.curTimeButton.selected = NO;
        self.curTimeButton = nil;
    }
}

#pragma mark - keyboard notification
- (void)addKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyBoardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    self.forbidTapHidden = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.forbidTapHidden = NO;
}

#pragma mark - request
/** 请求 推荐开黑房 */
-(void)requestGameRoomRecommend {
    
    if(self.roomId.length < 1){
        [CC_Notice show:@"未设置招募厅id"];
        return;
    }
    
    NSInteger time = [self.selectedTimeStr integerValue];
    NSString *roomId = self.idTextField.text;
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"GAME_BOARD_RECOMMEND" forKey:@"service"];
    [params safeSetObject:self.roomId forKey:@"recommendObjectId"];
    [params safeSetObject:@(time) forKey:@"recommendTime"];
    [params safeSetObject:roomId forKey:@"gameRoomId"];
    [params safeSetObject:@"LIVE_HALL_RECOMMEND" forKey:@"recommendType"];
    [params safeSetObject:[KKUserInfoMgr shareInstance].userId forKey:@"recommendUserId"];
    
    //2.请求
    WS(weakSelf);
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        
        if (error) {
            [CC_Notice show:error];
            
        }else{
            //NSDictionary *responseDic = resModel.resultDic[@"response"];
            [CC_Notice show:@"推荐成功"];
            if (weakSelf.recommendSuccessBlock) {
                weakSelf.recommendSuccessBlock();
            }
            [weakSelf removeSelf];
        }
    }];
}


/** 请求 推荐开黑 时间配置 */
-(void)requestGameRoomRecommendTimeConfig {
    
    //1.参数
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:@"GAME_BOARD_RECOMMEND_TIME_QUERY" forKey:@"service"];
    
    //2.请求
    WS(weakSelf);
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    [[CC_HttpTask getInstance] post:[KKNetworkConfig currentUrl] params:params model:nil finishCallbackBlock:^(NSString *error, ResModel *resModel) {
        [HUD stop];
        SS(strongSelf)
        
        if (error) {
            [CC_Notice show:error];
            
        }else{
            NSDictionary *responseDic = resModel.resultDic[@"response"];
            NSArray *timeArr = [NSArray arrayWithArray:responseDic[@"times"]];
            strongSelf.timeArray = timeArr;
            strongSelf.minTimeConfig = responseDic[@"minTimeConfig"];
            strongSelf.maxTimeConfig = responseDic[@"maxTimeConfig"];
        }
    }];
}



#pragma mark - setter
-(void)setTimeArray:(NSArray<NSString *> *)timeArray {
    _timeArray = [timeArray copy];
    
    if (self.idTextField) {
        [self refreshTimeButtonView];
    }
}

@end
