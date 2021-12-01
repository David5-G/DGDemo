 //
//  KKVoiceRoomVCViewController.m
//  kk_espw
//
//  Created by david on 2019/10/14.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKVoiceRoomVC.h"
#import "KKLiveStudioVC.h"
#import "KKGameRoomOwnerController.h"

#import "KKChatRoomTableVC.h"
#import "KKChatRoomOnlineUserPopVC.h"
#import "KKChatRoomUserMgrPopVC.h"
//view
#import "KKLiveStudioOnlineUserView.h"
#import "KKVoiceRoomMicPView.h"
#import "KKVoiceRoomInputView.h"
#import "KKShareWQDView.h"
#import "KKLiveStudioActionSheetView.h"//操作表
//viewModel
#import "KKVoiceRoomViewModel.h"
//model
#import "KKVoiceRoomSimpleModel.h"
#import "KKVoiceRoomUserSimpleModel.h"
//RTC
#import "KKRtcService.h"
#import "KKVoiceRoomRtcMgr.h"
#import "KKConversationController.h"
//---------------房间变动
//房主退出
static const NSInteger voiceRoom_alert_host_leave = 1001;
//房主退出,导致的房间解散
static const NSInteger voiceRoom_alert_room_dissolution = 1002;
//踢出房间
static const NSInteger voiceRoom_alert_room_kick = 1003;
//---------------麦位变动
//麦位退出
static const NSInteger voiceRoom_alert_micP_leave = 1011;
//主动上麦
static const NSInteger voiceRoom_alert_micP_get = 1012;
//主动下麦
static const NSInteger voiceRoom_alert_micP_quit = 1013;
//抱上麦
static const NSInteger voiceRoom_alert_micP_give = 1014;
//抱下麦
static const NSInteger voiceRoom_alert_micP_takeAway = 1015;




@interface KKVoiceRoomVC ()<
UIGestureRecognizerDelegate,
RongRTCRoomDelegate,
RongRTCActivityMonitorDelegate,
KKVoiceRoomInputViewDelegate,
KKChatRoomTableVCDelegate,
CatDefaultPopDelegate,
KKPlayerGameCardToolDelagate>
{
    CGFloat _titleViewTopSpace;
    CGFloat _titleViewHeight;
    CGFloat _micPositionViewHeight;
    CGFloat _inputViewHeight;
}

@property (nonatomic, strong) UIScrollView *scrollView;
//-----------------navi
@property (nonatomic, strong) UILabel *naviTitleLabel;
@property (nonatomic, strong) KKLiveStudioOnlineUserView *onlineUserView;
@property (nonatomic, assign) NSInteger joinLeaveCount;//加入离开计数
@property (nonatomic, assign) NSInteger onlineUserTotalCount;
//-----------------宣言
@property (nonatomic, strong) DGLabel *declarationLabel;
//-----------------麦位
@property (nonatomic, strong) KKVoiceRoomMicPView *micPView;
@property (nonatomic, copy) NSArray <KKVoiceRoomMicPSimpleModel *>*currentMicPArray;
//-----------------聊天
@property (nonatomic, assign) BOOL isForbidWord;
@property (nonatomic, strong) UIView *chatContainerView;
@property (nonatomic, strong) KKChatRoomTableVC *chatRoomVC;
//-----------------输入条
@property (nonatomic, strong) KKVoiceRoomInputView *inputView;
//-----------------pop 
@property (nonatomic, strong) CatDefaultPop *pop;
@property (nonatomic, strong) KKBottomPopVC *popVC;
//-----------------工具参数
@property (nonatomic, copy) NSString *hostUserId;
@property (nonatomic, assign) BOOL isVoiceOpen;
@property (nonatomic, assign) BOOL isMicOpen;
@property (nonatomic, assign) BOOL isMicUser;//是否是micUser
@property (nonatomic, assign) NSInteger selectedMicId;//选中(被点击的)的micId
@property (nonatomic, assign) NSInteger currentMicId;//当前自己所在麦位的micId
//viewModel
@property (nonatomic, assign) BOOL needShowHUD;
@property (nonatomic, strong) KKVoiceRoomViewModel *viewModel;
@property (nonatomic, strong) KKChatRoomUserListViewModel *userListViewModel;
//model
@property (nonatomic, strong)  KKVoiceRoomSimpleModel *voiceRoomSimple;
@end

@implementation KKVoiceRoomVC
#pragma mark - getter/setter
#pragma mark getter
-(KKVoiceRoomViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[KKVoiceRoomViewModel alloc]init];
    }
    return _viewModel;
}

-(KKChatRoomUserListViewModel *)userListViewModel {
    if (!_userListViewModel) {
        _userListViewModel = [[KKChatRoomUserListViewModel alloc]init];
        _userListViewModel.canForbidConsult = YES;
    }
    return _userListViewModel;
}

#pragma mark setter
-(void)setVoiceRoomSimple:(KKVoiceRoomSimpleModel *)voiceRoomSimple {
    _voiceRoomSimple = voiceRoomSimple;
    //1.关联的懒加载属性 更新
    self.userListViewModel.channelId = voiceRoomSimple.channelId;
}

-(void)setRoomId:(NSString *)roomId {
    if (roomId.length < 1) {
        return;
    }
    
    //换房间处理
    if (![_roomId isEqualToString:roomId]) {
        self.isVoiceOpen = YES;
        self.isMicOpen = NO;
        self.currentMicPArray = nil;
    }
    
    _roomId = [roomId copy];
    //1.关联的懒加载属性 更新
    self.viewModel.roomId = roomId;
    
    //2.重新配置rtc (因为是单例, 当换房间时候viewDidLoad不会走,所以将rtcConfig放在这里)
    [self rtcConfig];
}

-(void)setIsMicOpen:(BOOL)isMicOpen {
    _isMicOpen = isMicOpen;
    
    //1.mic状态
    self.inputView.micButton.selected = isMicOpen;
    
    //2.rtc关闭mic
    [[KKRtcService shareInstance] setMicrophoneDisable:!isMicOpen];
}

-(void)setIsVoiceOpen:(BOOL)isVoiceOpen {
    _isVoiceOpen = isVoiceOpen;
    
    //1.喇叭状态
    self.inputView.speakerButton.selected = isVoiceOpen;
    
    //2.rtc声音
    [[KKRtcService shareInstance] setMuteAllVoice:!isVoiceOpen];
}


#pragma mark - singleton
static KKVoiceRoomVC *_voiceRoom = nil;
static dispatch_once_t onceToken;

+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        _voiceRoom = [[KKVoiceRoomVC alloc] init];
    });
    return _voiceRoom;
}


/** 清空 释放 */
- (void)remove{
    //1.更新KKFloatViewMgr中招募厅的相关数据
    [self setFloatViewInfo:nil];
    
    //2.如果有pop要移除
    if (self.pop) {
        [self.pop dismissCatDefaultPopView];
    }
    
    //3.释放self
    _voiceRoom = nil;
    onceToken = 0;
}

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDimension];
    [self setupUI];
    [self setupNavi];
    //通知
    [self registerChatRoomNotification];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //移除popVC
    if (self.popVC) {
        [self.popVC removeSelf];
        self.popVC = nil;
    }
    //请求
    self.needShowHUD = YES;
    [self requestVoiceRoomInfo];
    [KKFloatViewMgr shareInstance].hiddenFloatView = YES;
    [[KKFloatViewMgr shareInstance] hiddenGameRoomFloatView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[KKFloatViewMgr shareInstance] notHiddenGameRoomFloatView];
    [KKFloatViewMgr shareInstance].hiddenFloatView = NO;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    self.fd_interactivePopDisabled = YES;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.fd_interactivePopDisabled = NO;
}

-(void)dealloc {
    [self removeChatRoomNotification];
    BBLOG(@"KKVoiceRoomVC -- dealloc");
}

#pragma mark - UI
-(void)setDimension {
    _titleViewHeight = [ccui getRH:35];
    _titleViewTopSpace = [ccui getRH:22] + STATUSBAR_ADD_NAVIGATIONBARHEIGHT;
    _micPositionViewHeight = [ccui getRH:240];
    _inputViewHeight = [ccui getRH:50];
}


-(void)setupNavi {
    WS(weakSelf);
    //1. 隐藏默认的
    [self setNaviBarWithType:DGNavigationBarTypeClear];
    [self hideBackButton:YES];
    
    //2.left
    //2.1 backBtn
    CGFloat backBtnW = [ccui getRH:36];
    CGFloat backBtnH = [ccui getRH:30];
    DGButton *backBtn = [DGButton btnWithImg:Img(@"navi_back_white")];
    //backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.naviBar addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:2]);
        make.bottom.mas_equalTo(-(NAV_BAR_HEIGHT-backBtnH)/2.0);
        make.height.mas_equalTo(backBtnH);
        make.width.mas_equalTo(backBtnW);
    }];
    [backBtn addClickWithTimeInterval:0.1 block:^(DGButton *btn) {
        [weakSelf naviPopAction:YES];
    }];
    
    //2.2 title
    DGLabel *titleL = [DGLabel labelWithText:@"" fontSize:12 color:UIColor.whiteColor bold:YES];
    titleL.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:[ccui getRH:19]];
    self.naviTitleLabel = titleL;
    [self.naviBar addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backBtn.mas_right).mas_offset(-[ccui getRH:4]);
        make.centerY.mas_equalTo(backBtn);
    }];
    
    //3.right
    //3.1 关闭
    DGButton *closeBtn = [DGButton btnWithImg:Img(@"icon_close_white")];
    [self.naviBar addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-[ccui getRH:5]);
        make.centerY.mas_equalTo(backBtn);
        make.width.mas_equalTo([ccui getRH:34]);
        make.height.mas_equalTo([ccui getRH:38]);
    }];
    [closeBtn addClickWithTimeInterval:1.0 block:^(DGButton *btn) {
        [weakSelf clickQuikButton];
    }];
    
    //3.2 在线用户
    KKLiveStudioOnlineUserView *userV = [[KKLiveStudioOnlineUserView alloc]initWithFrame:CGRectZero];
    self.onlineUserView = userV;
    [self.naviBar addSubview:userV];
    [userV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(closeBtn.mas_left).mas_offset(-[ccui getRH:6]);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(NAV_BAR_HEIGHT);
        make.width.mas_equalTo([ccui getRH:130]);
    }];
    [userV addTapWithTimeInterval:1.0 tapBlock:^(UIView * _Nonnull view) {
        [weakSelf clickOnlineUserView];
    }];
    
}

-(void)setupUI {
    
    //1.bg
    UIImageView *bgImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"voice_bg"]];
    bgImgV.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:bgImgV];
    [bgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    //2.scrollView
    CGRect scrollFrame = self.view.bounds;
    scrollFrame.size.height -= _inputViewHeight + HOME_INDICATOR_HEIGHT;
    UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:scrollFrame];
    scrollV.bounces = NO;
    scrollV.contentSize = scrollFrame.size;
    if (@available(iOS 11.0, *)) {
        scrollV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.scrollView = scrollV;
    [self.view addSubview:scrollV];
    
    //tap
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapScrollView:)];
    tap.delegate = self;
    [self.scrollView addGestureRecognizer:tap];
    
    //subviews
    UIView *titleV = [self setupTitleView];
    UIView *micPositionV = [self setupMicPositionView:titleV];
    [self setupChatContainerView:micPositionV];
    
    //3.inputV
    KKVoiceRoomInputView *inputV = [[KKVoiceRoomInputView alloc]initWithFrame:CGRectMake(0, scrollV.bottom, self.view.width, _inputViewHeight)];
    inputV.rightToolButtons = @[KKInputViewToolButtonSpeaker,KKInputViewToolButtonShare];
    inputV.speakerButton.selected = YES;
    inputV.delegate = self;
    inputV.themeStyle = KKInputViewThemeStyleDark;
    self.inputView = inputV;
    self.isMicUser = NO;
    [self.view addSubview:inputV];
    
}


-(UIView *)setupTitleView {
    CGFloat topSpace = _titleViewTopSpace;
    CGFloat height = _titleViewHeight;
    //1.titleView
    UIView *titleV = [[UIView alloc]init];
    [self.scrollView addSubview:titleV];
    [titleV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topSpace);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(height);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    //top
    UIImageView *topImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"voice_title_top"]];
    [titleV addSubview:topImgV];
    [topImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo([ccui getRH:15]);
        make.right.mas_equalTo([ccui getRH:-20]);
        make.height.mas_equalTo(1);
    }];
    
    //bottom
    UIImageView *bottomImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"voice_title_bottom"]];
    [titleV addSubview:bottomImgV];
    [bottomImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo([ccui getRH:15]);
        make.right.mas_equalTo([ccui getRH:-20]);
        make.height.mas_equalTo(1);
    }];
    
    //center
    UIImageView *centerImgV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"voice_title_center"]];
    [titleV addSubview:centerImgV];
    [centerImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:39]);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo([ccui getRH:14]);
        make.height.mas_equalTo([ccui getRH:10]);
    }];
    
    //titleItem
    DGLabel *titleItemL = [DGLabel labelWithText:@"房间宣言:" fontSize:[ccui getRH:14] color:rgba(249, 211, 91, 1)];
    [titleV addSubview:titleItemL];
    [titleItemL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(centerImgV.mas_right).offset([ccui getRH:5]);
        make.centerY.mas_equalTo(0);
    }];
    
    //titleLabel
    DGLabel *titleL = [DGLabel labelWithText:@"随便写一个,来人聊一聊" fontSize:[ccui getRH:14] color:UIColor.whiteColor];
    self.declarationLabel = titleL;
    [titleV addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleItemL.mas_right).offset([ccui getRH:3]);
        make.centerY.mas_equalTo(0);
    }];
    
    //3.return
    return titleV;
}

-(UIView *)setupMicPositionView:(UIView *)topV {
    WS(weakSelf);
    CGFloat height = _micPositionViewHeight;
    //1.micPostionV
    UIView *micPContainerV = [[UIView alloc]init];
    [self.scrollView addSubview:micPContainerV];
    [micPContainerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topV.mas_bottom).mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
    
    //2.micPView
    KKVoiceRoomMicPView *micPV = [[KKVoiceRoomMicPView alloc]init];
    self.micPView = micPV;
    __block BOOL canClick = YES;
    micPV.tapMicPItemBlock = ^(NSInteger index, KKVoiceRoomMicPItemView * _Nonnull itemView) {
        //过滤同时点击多个
        if (!canClick) { return ; }
        canClick = NO;
        //延时改变canClick
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
            canClick = YES;
        });
        //执行方法
        [weakSelf clickMicPItemView:itemView];
    };
    [micPContainerV addSubview:micPV];
    [micPV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([ccui getRH:30]);
        make.left.bottom.right.mas_equalTo(0);
    }];
    
    //3.return
    return micPContainerV;
}

-(UIView *)setupChatContainerView:(UIView *)topV {
    
    CGFloat height = self.scrollView.height - _titleViewTopSpace - _titleViewHeight - _micPositionViewHeight;
    
    //1.containerV
    UIView *chatContainerV = [[UIView alloc]init];
    chatContainerV.backgroundColor = UIColor.clearColor;
    self.chatContainerView = chatContainerV;
    [self.scrollView addSubview:chatContainerV];
    [chatContainerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topV.mas_bottom).mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
    
    //2.chatRoomVC
    KKChatRoomTableVC *chatRoomVC = [[KKChatRoomTableVC alloc]initWithThemeStyle:KKChatRoomTableVCThemeStyleDark];
    chatRoomVC.automaticallyAdjustsScrollViewInsets = NO;
    chatRoomVC.view.backgroundColor = UIColor.clearColor;
    chatRoomVC.delegate = self;
    
    //3.添加chatRoomVC
    self.chatRoomVC = chatRoomVC;
    [self addChildViewController:chatRoomVC];
    [self.chatContainerView addSubview:chatRoomVC.view];
    [self.chatRoomVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([ccui getRH:5]);
        make.left.right.bottom.mas_equalTo(0);
    }];
    
    //4.return
    return chatContainerV;
}
    

#pragma mark tool
/** 刷新在线人数view */
-(void)refreshOnlieUserView:(NSArray <KKVoiceRoomUserSimpleModel *>*)userModelArr totalCount:(NSInteger)totalCount {
    
    //1.总人数
    [self.onlineUserView setUserCount:totalCount];
    
    //2.更新头像
    NSInteger needCount = 3;
    //2.1 获取头像array
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:needCount];
    for (NSInteger i=0; i<userModelArr.count && i<needCount; i++) {
        KKVoiceRoomUserSimpleModel *userModel = userModelArr[i];
        [mArr addObject:userModel.userLogoUrl];
    }
    //2.2 赋值
    [self.onlineUserView setUserLogoUrlArray:mArr];
}

/** 刷新麦位UI */
-(void)refreshMicPView {
    NSString *myUserId = [KKUserInfoMgr shareInstance].userId;
    NSInteger currentMicId = 0;
    //遍历更新UI
    for (NSInteger i=0; i<self.currentMicPArray.count; i++) {
        KKVoiceRoomMicPItemView *itemV = [self.micPView getItemViewAtIndex:i];
        if (!itemV) {
            continue;
        }
        KKVoiceRoomMicPSimpleModel *model = self.currentMicPArray[i];
        //用tag记录micId
        itemV.tag = model.micId;
         
        //1.闭麦
        if (!model.enabled) {
            if(itemV.status != KKVoiceRoomMicPStatusClose){
                itemV.status = KKVoiceRoomMicPStatusClose;
            }
            continue;
        }
        //2.麦位没人
        if (model.userId.length<1) {
            if(itemV.status != KKVoiceRoomMicPStatusAbsent){
                itemV.status = KKVoiceRoomMicPStatusAbsent;
            }
            continue;
        }
        //3.麦位有人
        //status属性要先设置,因为其setter方法会清空别的属性
        if (![itemV.userId isEqualToString:model.userId]) {
            itemV.status = KKVoiceRoomMicPStatusPresent;
            itemV.userId = model.userId;
            itemV.portraitUrlStr = model.userLogoUrl;
            itemV.name = model.userLoginName;
            itemV.isHost = [model.userId isEqualToString:self.hostUserId];
            itemV.sexType = [self getSexType:model.sex.name];
        }
        
        //4.是自己就要更新micId
        if ([model.userId isEqualToString:myUserId]) {
            currentMicId = model.micId;
        }
    }
    
    //更新currentMicId
    self.currentMicId = currentMicId;
}

/** 刷新麦位speaking状态 */
-(void)updateMicPositionSpeaking:(NSString *)trackId audioLevel:(NSInteger)audioLevel isSend:(BOOL)isSend {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (NSInteger i=0; i<self.currentMicPArray.count; i++) {
            KKVoiceRoomMicPItemView *itemV = [self.micPView getItemViewAtIndex:i];
            //0.过滤空
            if (!itemV || itemV.userId.length < 1) {
                continue;
            }
            
            //1.发送
            if (isSend) {
                if (self.isMicOpen) {
                    if ([trackId containsString:itemV.userId]) {
                        itemV.isSpeaking = audioLevel > 0;
                    }
                }else{
                    if (itemV.isSpeaking == YES) {
                        itemV.isSpeaking = NO;
                    }
                }
                continue ;
            }
            
            //2.接收
            if ([trackId containsString:itemV.userId]) {
                itemV.isSpeaking = audioLevel > 0;
            }
        }
    });
}

/** 刷新inputView */
-(void)refreshInputView {
    
    //现在是否是micUser
    BOOL isMicUserNow = [self checkIsMicUser:[KKUserInfoMgr shareInstance].userId];
    
    //1.过滤 状态没改变,
    if (self.isMicUser == isMicUserNow) {
        return;
    }
    //更新状态
    self.isMicUser = isMicUserNow;
    
    //2.状态改变了
    //2.1 退出键盘
    [self.inputView stopInput];
    //2.2 改变rightToolButtons
    if (isMicUserNow) {
        self.inputView.rightToolButtons = @[KKInputViewToolButtonSpeaker, KKInputViewToolButtonMic,KKInputViewToolButtonShare];
    }else{
        self.inputView.rightToolButtons = @[KKInputViewToolButtonSpeaker,KKInputViewToolButtonShare];
    }

    //3.麦克风
    self.inputView.micButton.selected = self.isMicOpen;
    
    //4.喇叭
    self.inputView.speakerButton.selected = self.isVoiceOpen;
}

#pragma mark - tool
/** 查看是不是 房主 */
-(BOOL)checkIsHost {
    if ([self.hostUserId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
        return YES;
    }
    return NO;
}

/** 查看是不是 麦位用户 */
-(BOOL)checkIsMicUser:(NSString *)userId {
    //1.过滤空
    if (userId.length < 1) {
        return NO;
    }
    
    //2.遍历查询
    for (KKVoiceRoomMicPSimpleModel *model in self.currentMicPArray) {
        if ([userId isEqualToString:model.userId]) {
            return YES;
        }
    }
    
    //3.没查到
    return NO;
}

-(void)joinLeaveCountAdd:(BOOL)isAdd {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //1.在线数
        NSInteger userCount = self.onlineUserTotalCount;
        if (userCount > 3) {
            userCount += isAdd ? 1 : -1;
            userCount = userCount>0 ? userCount : 0;
            self.onlineUserTotalCount = userCount;
            [self.onlineUserView setUserCount:userCount];
            
        }else{//小于3的情况直接刷新
            self.joinLeaveCount = 0;
            [self requestVoiceRoomInfo];
        }
        
        //2.计数
        self.joinLeaveCount += 1;
        if (self.joinLeaveCount > 20) {
            self.joinLeaveCount = 0;
            [self requestVoiceRoomInfo];
        }
    });
}

-(KKVoiceRoomMicPSexType)getSexType:(NSString *)str {
    if ([str isEqualToString:@"M"]) {
        return KKVoiceRoomMicPSexTypeMale;
    }
    
    if ([str isEqualToString:@"F"]) {
        return KKVoiceRoomMicPSexTypeFemale;
    }
    
    return KKVoiceRoomMicPSexTypeUnknown;
}

-(void)setFloatViewInfo:(KKVoiceRoomSimpleModel *)vModel {
    
    //1.清空
    if (!vModel) {
        [KKFloatViewMgr shareInstance].voiceRoomModel = nil;
        [KKFloatViewMgr shareInstance].type = KKFloatViewTypeUnknow;
        return;
    }
    
    //2.如果是同一个房间
//    if ([[KKFloatViewMgr shareInstance].voiceRoomModel.channelId isEqualToString:vModel.channelId]) {
//        return;
//    }
    
    //3.更新
    KKFloatVoiceRoomModel *model = [[KKFloatVoiceRoomModel alloc]init];
    model.roomId = [self.roomId integerValue];
    model.channelId = vModel.channelId;
    model.ownerName = vModel.ownerUserLoginName;
    model.ownerLogoUrl = vModel.ownerUserLogoUrl;
    model.ownerUserId = vModel.ownerUserId;
    [KKFloatViewMgr shareInstance].voiceRoomModel = model;
    [KKFloatViewMgr shareInstance].type = KKFloatViewTypeVoiceRoom;
}

#pragma mark - interaction
-(void)tapScrollView:(UITapGestureRecognizer *)tapGr {
    [self.inputView stopInput];//退出键盘
}

-(void)clickOnlineUserView {
    [self.inputView stopInput];//退出键盘
    
    //1.房主
    if ([self checkIsHost]) {
        [self showUserMgrPopVC];
        return;
    }
    
    //2.普通成员
    [self showOnlineUserPopVC];
}

-(void)clickQuikButton {
    [self.inputView stopInput];//退出键盘
    
    //1.房主退出
    if([self checkIsHost]){
        [self showAlertWithTitle:@"提示" content:@" 退出后，房间将解散，\n成员将会自动退出！" cancelTitle:@"取消" confirmTitle:@"确定" tag:voiceRoom_alert_host_leave];
        return;
    }
    
    //2.麦位用户
    if([self checkIsMicUser:[KKUserInfoMgr shareInstance].userId]){
        [self showAlertWithTitle:@"提示" content:@"退出后，你将不再参与该房间的语音对话！" cancelTitle:@"取消" confirmTitle:@"确定" tag:voiceRoom_alert_micP_leave];
        return;
    }
    
    //3.观众直接退出
    [self requestLeaveVoiceRoom:nil];
}

-(void)clickMicPItemView:(KKVoiceRoomMicPItemView *)itemView {
    self.selectedMicId = itemView.tag;
    NSString *userId = itemView.userId;
    
    //1.房主点击
    if ([self checkIsHost]) {
        //1.1 麦位有人
        if (userId.length > 0) {
            [self showPlayerCard:userId needReport:YES isOnMic:YES];
            return;
        }
        
        //1.2 麦位没人,等待入座
        if(itemView.status == KKVoiceRoomMicPStatusAbsent){
            [self showActionSheet:@[@"上麦",@"抱用户上麦",@"闭麦",@"取消"] userId:nil];
            return;
        }
        
        //1.3 麦位没人,闭麦
        if(itemView.status == KKVoiceRoomMicPStatusClose){
            [self showActionSheet:@[@"开启麦位",@"取消"] userId:nil];
            return;
        }
        return;
    }
    
    //2.普通用户点击
    //2.1 麦位有人
    if (userId.length > 0) {
        [self showPlayerCard:userId needReport:YES isOnMic:YES];
        return;
    }
    
    //2.2 麦位没人,等待入座
    if(itemView.status == KKVoiceRoomMicPStatusAbsent){
        [self reqeustMicGet];
        return;
    }
    
    //2.3 麦位没人,闭麦
    //不响应
}

#pragma mark - pop
/** show操作表 */
-(void)showActionSheet:(NSArray *)titleArr userId:(NSString *)userId{
    CGFloat cellH = [ccui getRH:58];
    WS(weakSelf);
    //1.创建popV
    KKLiveStudioActionSheetView *popV = [[KKLiveStudioActionSheetView alloc]initWithFrame:CGRectMake(0, 0, 0, cellH*titleArr.count+HOME_INDICATOR_HEIGHT)];
    popV.dataArray = titleArr;
    popV.cellHeight = cellH;
    [popV showPopView];
    
    //2.block
    popV.selectBlock = ^(NSString * title) {
       
        if([title isEqualToString:@"闭麦"]){
            [weakSelf requestMicClose:YES];
            
        } else if([title isEqualToString:@"开启麦位"]){
            [weakSelf requestMicClose:NO];
            
        } else if([title isEqualToString:@"抱用户上麦"]){
            [weakSelf showUserMgrPopVC];
            
        } else if([title isEqualToString:@"上麦"]){
            [weakSelf reqeustMicGet];
        }
        
        //清空选中麦位
        weakSelf.selectedMicId = 0;
    };
}

/** show在线用户列表popVC */
-(void)showOnlineUserPopVC {
    //1.创建
    KKChatRoomOnlineUserPopVC *popVC = [[KKChatRoomOnlineUserPopVC alloc]init];
    popVC.view.frame = self.view.bounds;
    [popVC setDisplayViewHeight:[ccui getRH:508]+HOME_INDICATOR_HEIGHT];
    popVC.roomId = self.voiceRoomSimple.channelId;
    popVC.hostUserId = self.hostUserId;
    popVC.canForbidConsult = YES;
    popVC.playerGameCardDelegate = self;
    popVC.playerGameCardNeedKick = YES;
    self.popVC = popVC;
    
    //2.添加
    [self.view addSubview:popVC.view];
    [self addChildViewController:popVC];
    
    //3.show
    [popVC showSelf];
}

/** show用户状态管理popVC */
-(void)showUserMgrPopVC {
    
    //1.创建
    KKChatRoomUserMgrPopVC *popVC = [[KKChatRoomUserMgrPopVC alloc]initWithTitleArray:@[KKLiveStudioUserMgrTitleOnline,KKLiveStudioUserMgrTitleForbidWord]];
    popVC.view.frame = self.view.bounds;
    [popVC setDisplayViewHeight:[ccui getRH:508]+HOME_INDICATOR_HEIGHT];
    popVC.roomId = self.voiceRoomSimple.channelId;
    popVC.hostUserId = self.hostUserId;
    popVC.canForbidConsult = YES;
    popVC.playerGameCardDelegate = self;
    popVC.playerGameCardNeedKick = YES;
    self.popVC = popVC;
    
    WS(weakSelf)
    popVC.willRomoveSelfBlock = ^{
        weakSelf.selectedMicId = 0;
    };
    popVC.voiceRoomGiveMicBlock = ^(BOOL isGive, NSString * _Nonnull userId, void (^ _Nullable block)(BOOL)) {
        SS(strongSelf)
        if (isGive) {
            [strongSelf requestMicGive:userId block:block];
        }else{
            [strongSelf requestMicTakeAway:userId block:block];
        }
    };
    
    //2.添加
    [self.view addSubview:popVC.view];
    [self addChildViewController:popVC];
    
    //3.show
    [popVC showSelf];
}


#pragma mark card
-(void)showPlayerCard:(NSString *)userId needReport:(BOOL)needReport isOnMic:(BOOL)isOnMic {
    
    BOOL isHost = [self checkIsHost];
    [[KKPlayerGameCardTool shareInstance] showUserInfo:userId roomId:self.voiceRoomSimple.channelId needKick:YES isHostCheck:isHost isOnMic:isOnMic delegate:self];
}

#pragma mark - alert
-(void)showAlertWithTitle:(NSString *)title content:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle tag:(NSInteger)tag {
    
    //语音房被销毁了 => 直接rerun
    if(!_voiceRoom){
        return;
    }
    
    //1.取消上一个pop
    if (self.pop) {
        [self.pop dismissCatDefaultPopView];
        self.pop = nil;
    }
    
    //pop 
    CatDefaultPop *pop;
    if (cancelTitle.length > 0) {
        pop = [[CatDefaultPop alloc] initWithTitle:title content:message cancelTitle:cancelTitle confirmTitle:confirmTitle];
    }else{
        pop = [[CatDefaultPop alloc] initWithTitle:title content:message confirmTitle:confirmTitle];
    }
    
    [pop popUpCatDefaultPopView];
    pop.delegate = self;
    self.pop = pop;
    pop.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    pop.popView.tag = tag;
    [pop updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:rgba(250, 206, 112, 1)];
}


#pragma mark delegate
-(void)catDefaultPopConfirm:(CatDefaultPop *)defaultPop {
    NSInteger tag = defaultPop.popView.tag;
    //1.房间
    //1.1 房主退出
    if (voiceRoom_alert_host_leave == tag) {
        [self postHostLeaveNotification];
        [self requestLeaveVoiceRoom:nil];
        return;
    }
    //1.2 房间解散
    if (voiceRoom_alert_room_dissolution == tag) {
        [self postHostLeaveNotification];
        [self requestLeaveVoiceRoom:nil];
        return;
    }
    //1.3 被踢出房间
    if (voiceRoom_alert_room_kick == tag) {
        [self requestLeaveVoiceRoom:nil];
        return;
    }
    
    //2.麦位
    //2.1 麦位用户退出
    if (voiceRoom_alert_micP_leave == tag) {
        [self requestLeaveVoiceRoom:nil];
        return;
    }
    //2.2 被抱上麦
    if (voiceRoom_alert_micP_give == tag) {
        self.isMicOpen = YES;
        return;
    }
    //2.3 被抱下麦
    if (voiceRoom_alert_micP_takeAway == tag) {
        return;
    }
}

-(void)catDefaultPopCancel:(CatDefaultPop*)defaultPop {
    NSInteger tag = defaultPop.popView.tag;
    
    //1.被抱上麦, 却选择下麦
    if (voiceRoom_alert_micP_give == tag) {
        [self requestMicQuit];
        return;
    }
}



#pragma mark - delegate
#pragma mark UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //UIView *gView = gestureRecognizer.view;
    UIView *tView = touch.view;
    if ([tView isKindOfClass:[KKVoiceRoomMicPView class]] ||
        [tView isKindOfClass:[UITableView class]] ||
        [tView isKindOfClass:[UICollectionView class]]) {
        return YES;
    }
    return NO;
}

#pragma mark KKChatRoomTableVCDelegate
-(void)chatRoomWillBeginDragging:(KKChatRoomTableVC *)chatRoomTableVC {
    [self.inputView stopInput];//退出键盘
}

-(void)chatRoom:(KKChatRoomTableVC *)chatRoomTableVC didSelectMsg:(KKChatRoomMessage *)msg {
    [self.inputView stopInput];//退出键盘
    //清空选中micId
    self.selectedMicId = 0;
    
    //1.普通消息 -> 展示名片
    NSString *userId = msg.rcMsg.senderUserId;
    BOOL isOnMic = [self checkIsMicUser:userId];
    [self showPlayerCard:userId needReport:YES isOnMic:isOnMic];
}

#pragma mark KKVoiceRoomInputViewDelegate
-(void)inputView:(KKVoiceRoomInputView *)inputView tryToSendText:(NSString *)text {
    
    //1.过滤
    //输入超量
    if (text.length > 50) {
        [CC_Notice show:@"最多可输入50个字" atView:self.view];
        return;
    }
    
    //退出键盘
    [self.inputView stopInput];
    
    //没输入
    if (text.length < 1) {
        return;
    }
    
    //被禁言
    if (self.isForbidWord) {
        [CC_Notice show:@"你已被禁言" atView:self.view];
        return;
    }
    
    //2.发送文字
    WS(weakSelf);
    __weak __typeof(&*inputView)weakInputView = inputView;
    [self.chatRoomVC sendTextMsg:text success:^(long messageId) {
        [weakInputView clearInputText];
        
    } error:^(RCErrorCode nErrorCode, long messageId) {
        dispatch_main_async_safe(^{
            [CC_Notice show:@"消息发送失败" atView:weakSelf.view];
        });
    }];
}

-(void)inputView:(KKVoiceRoomInputView *)inputView didClickShare:(UIButton *)button {
    KKShareWQDView *shareV = [[KKShareWQDView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, RH(183))];
    [shareV showPopView];
    KKVoiceRoomSimpleModel *voiceRoomSimple = [self.viewModel voiceRoomSimple];
    WS(weakSelf)
    shareV.tapShareKKBlock = ^{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:@"连麦语音房邀请" forKey:@"title"];
        [dic setValue:@"拒绝孤单！来kk电竞连麦语音房，我们一起玩吧。" forKey:@"subheading"];
        [dic setValue:voiceRoomSimple.idStr forKey:@"gameBoradId"];
        [dic setValue:voiceRoomSimple.ownerUserLogoUrl forKey:@"ownerUserHeaderImgUrl"];
        [dic setValue:[KKUserInfoMgr shareInstance].userId forKey:@"shareUserId"];
        [dic setValue:@"voiceRoomType" forKey:@"gameType"];
        KKContactsController *vc = [[KKContactsController alloc] initWithType:KKContactsControllerTypeGameRoom extra:dic];
        vc.gameLinkedDidTippedBlock = ^(KKConversation * _Nullable conversation, NSString * _Nullable extra) {
            KKConversationController *controller = [[KKConversationController alloc] initWithConversation:conversation extra:extra];
            controller.view.backgroundColor = [UIColor whiteColor];
            [weakSelf.navigationController popViewControllerAnimated:YES];
            [CC_Notice showNoticeStr:@"分享成功" atView:self.view delay:2];
        };
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
    shareV.tapShareQQBlock = ^{
        [KKShareTool configJShareWithPlatform:JSHAREPlatformQQ title:@"连麦语音房邀请" text:@"拒绝孤单！来kk电竞连麦语音房，我们一起玩吧。" url:weakSelf.viewModel.shareUrl type:RoomType];
    };
    shareV.tapShareWXBlock = ^{
        [KKShareTool configJShareWithPlatform:JSHAREPlatformWechatSession title:@"连麦语音房邀请" text:@"拒绝孤单！来kk电竞连麦语音房，我们一起玩吧。" url:weakSelf.viewModel.shareUrl type:RoomType];
    };
}

-(void)inputView:(KKVoiceRoomInputView *)inputView openSpeaker:(BOOL)isOpen {
    self.isVoiceOpen = isOpen;
    
    //1.提示
    NSString *noticeStr = isOpen ? @"已取消静音" : @"静音中";
    [CC_Notice showNoticeStr:noticeStr atView:self.view delay:1.0];
}

- (void)inputView:(KKVoiceRoomInputView *)inputView openMic:(BOOL)isOpen {
    self.isMicOpen = isOpen;
    
    NSString *noticeStr = isOpen ? @"麦克风开启" : @"麦克风关闭";
    [CC_Notice showNoticeStr:noticeStr atView:self.view delay:1.0];
}

#pragma mark KKPlayerGameCardToolDelagate
-(void)playerGameCardTool:(KKPlayerGameCardTool *)tool handleMsg:(NSString *)msg targetUserId:(nonnull NSString *)targetUserId{

    NSString *userId = targetUserId;
    
    if([msg isEqualToString:@"禁言"]){
        [self requestForbidWord:userId isForbid:YES];
        
    }else if([msg isEqualToString:@"解禁"]){
        [self requestForbidWord:userId isForbid:NO];
        
    }else if([msg isEqualToString:@"移出房间"]){
        [self requestKickUser:userId];
        
    }else if([msg isEqualToString:@"抱上麦"]){
        [self requestMicGive:userId block:nil];
        
    }else if([msg isEqualToString:@"抱下麦"]){
        [self requestMicTakeAway:userId block:nil];
        
    }else if([msg isEqualToString:@"下麦"]){
        [self requestMicQuit];
    }
    
    //清空选中micId
    self.selectedMicId = 0;
}

#pragma mark - notification
#pragma mark 发送
-(void)postHostLeaveNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_VOICE_ROOM_HOST_LEAVE object:self userInfo:nil];
}

#pragma mark 接收
-(void)registerChatRoomNotification {
    //1.麦位变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationTransferToMainThread:) name:LIVE_STUDIO_MIC_POSITION_CHANGE_NOTIFICATION object:nil];
    
    //2.聊天室成员变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationTransferToMainThread:) name:CHAT_ROOM_MEMBER_CHANGE_NOTIFICATION object:nil];
}

-(void)removeChatRoomNotification {
    //1.麦位变化
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LIVE_STUDIO_MIC_POSITION_CHANGE_NOTIFICATION object:nil];
    
    //2.聊天室成员变化
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CHAT_ROOM_MEMBER_CHANGE_NOTIFICATION object:nil];
}

-(void)notificationTransferToMainThread:(NSNotification *)notification {
    NSString *name = notification.name;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([name isEqualToString:LIVE_STUDIO_MIC_POSITION_CHANGE_NOTIFICATION]) {
            [self notificationMicPositionChange:notification];
            
        }else if ([name isEqualToString:CHAT_ROOM_MEMBER_CHANGE_NOTIFICATION]) {
            [self notificationChatRoomMemberChange:notification];
        }
    });
    
}

/**
 @{
    @"changeType"  : xxx,
    @"changeUserId" : xxx,
 
 changeType
 * FORBID_CHAT => 禁言
 * CANCEL_FORBID => 解禁
 * KICK => 踢出房间
 * LEAVE => 房主离开
 */

-(void)notificationChatRoomMemberChange:(NSNotification *)notification {
    
    NSDictionary *dic = notification.userInfo;
    //NSObject *obj = notification.object;
    
    NSString *targetId = dic[@"targetId"];
    NSString *changeType = dic[@"changeType"];
    NSString *changeUserId = dic[@"changeUserId"];
    NSString *myUserId = [KKUserInfoMgr shareInstance].userId;
    
    //0.过滤非本房间的消息
    if (![targetId isEqualToString:self.chatRoomVC.targetId]) {
        return;
    }
    
    //1.禁言
    if([changeType isEqualToString:@"FORBID_CHAT"]){
        //是自己
        if ([changeUserId isEqualToString:myUserId]) {
            self.isForbidWord = YES;
        }
    }
    
    //2.解禁
    else if([changeType isEqualToString:@"CANCEL_FORBID"] ){
        //是自己
        if ([changeUserId isEqualToString:myUserId]) {
            self.isForbidWord = NO;
        }
    }
    
    //3.被踢出
    else if([changeType isEqualToString:@"KICK"] ){
        //是自己
        if ([changeUserId isEqualToString:myUserId]) {
            [self removeRtcConfig];
            [self showAlertWithTitle:@"提示" content:@"你已被踢出房间" cancelTitle:@"" confirmTitle:@"确定" tag:voiceRoom_alert_room_kick];
        }
    }
    
    //4.房间解散
    if([changeType isEqualToString:@"LEAVE"]){
        //房主是离开的人 & 自己不是房主
        if([changeUserId isEqualToString:self.hostUserId] &&
           ![self checkIsHost]){
            [self removeRtcConfig];
            [self showAlertWithTitle:@"提示" content:@"房主跑了，房间解散！" cancelTitle:@"" confirmTitle:@"确定" tag:voiceRoom_alert_room_dissolution];
        }
    }
}

/**  该通知, 通知不到自己
 @{
    @"micChangeType"  : content.micChangeType,
    @"fromChangeUserId" : content.fromChangeUserId,
    @"toChangeUserId"   : content.toChangeUserId,
    @"extra"            : content.extra
 }
 
 micChangeType
 * LOCK => 锁麦 (闭麦)
 * UNLOCK => 解锁麦
 * FORBIDDEN => 禁麦
 * UNFORBIDDEN => 解禁
 * CARRY => 抱麦 (抱上麦)
 * KICK => 踢麦 (抱下麦)
 * UP => 上麦
 * DOWN => 下麦
 * CHANGE => 跳麦
 */
-(void)notificationMicPositionChange:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    //NSObject *obj = notification.object;
    
    NSString *targetId = dic[@"targetId"];
    NSString *micType = dic[@"micChangeType"];
    NSString *fromUserId = dic[@"fromChangeUserId"];
    NSString *toUserId = dic[@"toChangeUserId"];
    NSString *myUserId = [KKUserInfoMgr shareInstance].userId;

     BBLOG(@"\n\n KKVoiceRoom ************************************notificationMicPositionChange targetId:%@ micType:%@ fromUserId:%@ toUserId:%@ \n",targetId, micType, fromUserId, toUserId);
    
    //0.过滤非本房间的消息
    if (![targetId isEqualToString:self.chatRoomVC.targetId]) {
        return;
    }
    
    //1.抱上麦
    if([micType isEqualToString:@"CARRY"]){
        //是自己 & 自己不在麦位
        if ([toUserId isEqualToString:myUserId] && ![self checkIsMicUser:myUserId]) {
            [self showAlertWithTitle:@"提示" content:@"你已被抱上麦\n快打开麦克风聊天吧" cancelTitle:@"下麦" confirmTitle:@"开始聊天" tag:voiceRoom_alert_micP_give];
        }
    }
    
    //2. 抱下麦
    else if ([micType isEqualToString:@"KICK"]){
            //是自己 & 自己在麦位
        if ([toUserId isEqualToString:myUserId] && [self checkIsMicUser:myUserId]) {
            self.isMicOpen = NO;
            [self showAlertWithTitle:@"提示" content:@"你已被抱下麦" cancelTitle:@"" confirmTitle:@"确定" tag:voiceRoom_alert_micP_takeAway];
        }
    }
    
    //刷新房间信息
    [self requestVoiceRoomInfo];
}

#pragma mark - request

/** 请求 退出房间 */
-(void)requestLeaveVoiceRoom:(void (^)(void))success {
    WS(weakSelf)
    [[KKVoiceRoomRtcMgr shareInstance] requestLeaveRoom:self.roomId channel:self.voiceRoomSimple.channelId success:^{
        [weakSelf naviPopAction:NO];
        if (success) {
            success();
        }
    }];
}

/** 请求 房间详情 */
-(void)requestVoiceRoomInfo {
    
    //语音房被销毁了 => 直接rerun
    if(!_voiceRoom){
        return;
    }
    
    MaskProgressHUD *HUD;
    if (self.needShowHUD) {
        HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:self.view];
    }
    
    WS(weakSelf);
    [self.viewModel requestVoiceRoomInfo:^(NSInteger code) {
        SS(strongSelf);
        
        //HUD只有在viewWillAppear中调该此方法才展示一次
        if (HUD) {
            strongSelf.needShowHUD = NO;
            [HUD stop];
        }
        
        //0.请求被拦截,或失败
        if (code < 0) {  return ; }
        
        //1. 在线用户
        NSInteger userCount = [strongSelf.viewModel onlineUserCount];
        strongSelf.onlineUserTotalCount = userCount;
        [strongSelf refreshOnlieUserView:[strongSelf.viewModel firstJoinUsers] totalCount:userCount];
        
        //2.voiceRoom信息
        KKVoiceRoomSimpleModel *voiceRoomSimple = [strongSelf.viewModel voiceRoomSimple];
        strongSelf.voiceRoomSimple = voiceRoomSimple;
        //房主id
        strongSelf.hostUserId = voiceRoomSimple.ownerUserId;
        //宣言
        strongSelf.declarationLabel.text = voiceRoomSimple.chatRoomTitle;
        //语音房的id
        strongSelf.naviTitleLabel.text = [@"ID:" stringByAppendingString:voiceRoomSimple.idStr];
        //聊天室id
        strongSelf.chatRoomVC.targetId = voiceRoomSimple.channelId;
        
        //3.更新麦位
        [strongSelf updateMicP:voiceRoomSimple.micPSimples];
        
        //4.inputView
        strongSelf.isForbidWord = [self.viewModel isForbidWord];
        [strongSelf refreshInputView];
        
        //5.floatView
        [strongSelf setFloatViewInfo:voiceRoomSimple];
    }];
}

#pragma mark 麦位
-(void)requestMicClose:(BOOL)isClose {
    NSInteger selectedMicId = self.selectedMicId;
    [self.viewModel requestMicClose:isClose micId:selectedMicId success:^(NSInteger code) {
    }];
}

/** 请求 上麦 */
-(void)reqeustMicGet {
    NSInteger selectedMicId = self.selectedMicId;
    WS(weakSelf)
    [self.viewModel requestMicGet:selectedMicId oldMicId:self.currentMicId success:^(NSInteger code) {
        SS(strongSelf)
        
        if (code >=0) {
            strongSelf.isMicOpen = YES;
        }
    }];
}

/** 请求 下麦 */
-(void)requestMicQuit {
    WS(weakSelf)
    [self.viewModel requestMicQuit:^(NSInteger code) {
        SS(strongSelf)
        
        if (code >=0) {
            strongSelf.isMicOpen = NO;
        }
    }];
}

-(void)requestMicGive:(NSString *)userId block:(void(^ _Nullable)(BOOL))block {
     
    NSInteger selectedMicId = self.selectedMicId;
    [self.viewModel requestMicGive:userId micId:selectedMicId success:^(NSInteger code) {
        if (block) {
            block(code >= 0);
        }
    }];
    
}

-(void)requestMicTakeAway:(NSString *)userId block:(void(^ _Nullable)(BOOL))block {
     
    [self.viewModel requestMicTakeAway:userId success:^(NSInteger code) {
        if (block) {
            block(code >= 0);
        }
    }];
}

#pragma mark 禁言/解禁

-(void)requestForbidWord:(NSString *)userId isForbid:(BOOL)isForbid{
    //1.禁言
    if (isForbid) {
        [self.userListViewModel requestForbidWord:userId success:^(NSInteger code) {
            if (code >= 0) {
                [CC_Notice show:@"禁言成功"];
            }
        }];
        return;
    }
    
    //2.解禁
    [self.userListViewModel requestForbidWordCancel:userId success:^(NSInteger code) {
        if (code >= 0) {
            [CC_Notice show:@"解禁成功"];
        }
    }];
}

#pragma mark 踢人
-(void)requestKickUser:(NSString *)userId {
    [self.viewModel requestKickUser:userId success:^(NSInteger code) {
        
    }];
}



#pragma mark - jump
-(void)naviPopAction:(BOOL)isPop {
    
    //1.floatView
    if (isPop) {
        [KKFloatViewMgr shareInstance].hiddenFloatView = [KKFloatViewMgr shareInstance].voiceRoomModel.roomId > 0 ? NO : YES;
        [self setFloatViewInfo:self.voiceRoomSimple];
    }else{
        //不是pop需要销毁self
        [self remove];
    }
    
    //2.push
    if (self.navigationController) {
        if(isPop){
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            //1.获取navi的vc数组
            NSArray *vcArr = self.navigationController.viewControllers;
            
            //2.获取需要的vc数组
            NSMutableArray *mArr = [NSMutableArray array];
            for (NSInteger i=0; i<vcArr.count; i++) {
                UIViewController *tempVC = [vcArr objectAtIndex:i];
                //添加VC 除了self
                if ([tempVC isEqual:self]) {
                    continue;
                }else{
                    [mArr addObject:tempVC];
                }
            }
            //3.跳转
            [self.navigationController setViewControllers:mArr animated:YES];
        }
    }
}

-(void)pushSelfByNavi:(UINavigationController *)navi {
    
    //1.移除别的房间
    NSMutableArray *newArr = [NSMutableArray arrayWithArray:navi.viewControllers];
    NSMutableArray *deleteArr = [NSMutableArray arrayWithCapacity:newArr.count];
    for (UIViewController *vc in newArr) {
        if ([vc isMemberOfClass:[KKLiveStudioVC class]]) {
            [deleteArr addObject:vc];
        }else if ([vc isMemberOfClass:[KKGameRoomOwnerController class]]) {
            [deleteArr addObject:vc];
        }
    }
    //移除
    [newArr removeObjectsInArray:deleteArr];
    
    //2.self在navi的栈中,就改变vcArr
    if ([newArr containsObject:self]) {
        [newArr removeObject:self];
        [newArr addObject:self];
        [navi setViewControllers:newArr animated:YES];
    }else{
        //3.不在, 直接push
        [navi pushViewController:self animated:YES];
    }
    
}

#pragma mark - RTC
/** 配置rtc */
-(void)rtcConfig {
    BBLOG(@"\n\n KKVoiceRoom ************************************rtcConfig");
    [[KKRtcService shareInstance] setMuteAllVoice:!self.isVoiceOpen];
    [[KKRtcService shareInstance] setMicrophoneDisable:!self.isMicOpen];
    [[KKRtcService shareInstance] setRTCRoomDelegate:self];
    [[KKRtcService shareInstance] setRTCEngineDelegate:self];
}

/** 移除rtc配置 */
-(void)removeRtcConfig {
    BBLOG(@"\n\n KKVoiceRoom ************************************removeRtcConfig");
    //1.关闭麦克风,喇叭
    [[KKRtcService shareInstance] setMuteAllVoice:YES];
    [[KKRtcService shareInstance] setMicrophoneDisable:YES];
    //2.取消发布
    [[KKRtcService shareInstance] unpublishCurrentUserAudioStream];
    //3.取消订阅
    [self unsubscribeRemoteAudioStream:self.currentMicPArray];
    self.currentMicPArray = nil;
    //4.断开IM
    [self.chatRoomVC quitChatRoomSuccess:nil error:nil];
}

#pragma mark 麦位更新
-(void)updateMicP:(NSArray <KKVoiceRoomMicPSimpleModel *>*)newMicPArray {
    //1.第一次加载
    if (!self.currentMicPArray) {
        //1.1 赋值
        self.currentMicPArray = newMicPArray;
        //1.2 刷新UI
        [self refreshMicPView];
        //1.3 更新rtc
        //打开声音
        self.isVoiceOpen = YES;
        //是麦位用户 & 是房主 => 打开麦克风
        self.isMicOpen = NO;
        NSString *myUserId = [KKUserInfoMgr shareInstance].userId;
        if ([self checkIsMicUser:myUserId] && [self.voiceRoomSimple.ownerUserId isEqualToString:myUserId]) {
            self.isMicOpen = YES;;
        }
        
        //新上麦, 发布音频流
        [self publishAudioStream:newMicPArray];
        //新上麦, 订阅
        [self subscribeRemoteAudioStream:newMicPArray];
        return;
    }
    
    //2.更新
    //新上麦model的数组
    NSMutableArray *addMicPArr = [NSMutableArray arrayWithCapacity:6];
    //要下麦model的数组
    NSMutableArray *removeMicPArr = [NSMutableArray arrayWithCapacity:6];
    //匹配的当前麦位userId的数组
    NSMutableArray *matchCurrentMicPUserIdArr = [NSMutableArray arrayWithCapacity:6];
    //是否是相同的麦位信息(newMicPArr和self.currentMicPArray)(麦位信息没变化)
    BOOL isSameMicPArr = self.currentMicPArray.count == newMicPArray.count;
    
    //2.1 获取数据
    //遍历newMicPArray
    for (NSInteger n=0; n<newMicPArray.count; n++) {
        KKVoiceRoomMicPSimpleModel *nModel = newMicPArray[n];
        
        //是否是新增上麦
        BOOL isAdd = YES;
        //是否是同一个user在同一个麦位
        BOOL isSameUserAtSameMicP = NO;
        
        //遍历currentMicPArray
        for (NSInteger c=0; c<self.currentMicPArray.count; c++) {
            KKVoiceRoomMicPSimpleModel *cModel = self.currentMicPArray[c];
            
            //2.1.1 目前麦位没检测到变化 & 同麦位
            if ( isSameMicPArr &&
                nModel.micId == cModel.micId) {
                //不是同一个人, 则代表麦位发生了变化
                isSameMicPArr = [nModel.userId isEqualToString:cModel.userId];
            }
            
            //2.1.2 n的此麦位没人
            if(nModel.userId.length < 1){
                if (isAdd) {
                    isAdd = NO;
                    isSameUserAtSameMicP = NO;
                }
                
            } else{//2.1.3 n的此麦位有人
                //n的此麦位的userId,在c的麦位数组中, 则不是添加
                if ([nModel.userId isEqualToString:cModel.userId]) {
                    isAdd = NO;
                    isSameUserAtSameMicP = nModel.micId == cModel.micId;
                    //保存匹配到的userId
                    [matchCurrentMicPUserIdArr addObject:cModel.userId];
                }
            }
        }
        
        //2.1.4 是新增上麦
        if (isAdd) {
            isSameMicPArr = NO;
            [addMicPArr addObject:nModel];
            
        }else {//2.1.5 不是新增上麦
            //不是同一个user在同一个麦位, 则麦位信息变化了
            if (!isSameUserAtSameMicP){
                isSameMicPArr = NO;
            }
        }
    }
    
    //2.2 如果是同一个micP数组(麦位无变化),则直接return
    if(isSameMicPArr){
        return;
    }
    
    //2.3 找出要离开麦位的model
    for(NSInteger c=0; c<self.currentMicPArray.count; c++){
        KKVoiceRoomMicPSimpleModel *cModel = self.currentMicPArray[c];
        //麦位有人 & 此userId没被匹配过 => 是要下麦的model
        if (cModel.userId.length > 0 &&
            ![matchCurrentMicPUserIdArr containsObject:cModel.userId]) {
            [removeMicPArr addObject:cModel];
        }
    }
    
    //2.4 开始刷新
    //2.4.1 赋值
    self.currentMicPArray = newMicPArray;
    //2.4.2 刷新UI
    [self refreshMicPView];
    //2.4.3 更新rtc
    //要下麦, 取消发布音频流
    [self unpublishAudioStream:removeMicPArr];
    //要下麦, 取消订阅
    [self unsubscribeRemoteAudioStream:removeMicPArr];
    //新上麦, 发布音频流
    [self publishAudioStream:addMicPArr];
    //新上麦, 订阅
    [self subscribeRemoteAudioStream:addMicPArr];
}


#pragma mark publisth/subscribe

- (void)publishAudioStream:(NSArray <KKVoiceRoomMicPSimpleModel *>*)micPArray {
    
    NSString *myUserId = [KKUserInfoMgr shareInstance].userId;
    for (KKVoiceRoomMicPSimpleModel *model in micPArray) {
        //1.新上麦的人中的有自己,就发布音频流
        if ([myUserId isEqualToString:model.userId]) {
            [[KKRtcService shareInstance] pulishCurrentUserAudioStream];
            break;
        }
    }
}

-(void)unpublishAudioStream:(NSArray <KKVoiceRoomMicPSimpleModel *>*)micPArray {
    NSString *myUserId = [KKUserInfoMgr shareInstance].userId;
    for (KKVoiceRoomMicPSimpleModel *model in micPArray) {
        //1.下麦的人中的有自己,就取消发布音频流
        if ([myUserId isEqualToString:model.userId]) {
            self.isMicOpen = NO;
            [[KKRtcService shareInstance] unpublishCurrentUserAudioStream];
            break;
        }
    }
}


-(void)subscribeRemoteAudioStream:(NSArray <KKVoiceRoomMicPSimpleModel *>*)micPArray {
    
    NSString *myUserId = [KKUserInfoMgr shareInstance].userId;
    for (KKVoiceRoomMicPSimpleModel *model in micPArray) {
        //1.不是自己,就订阅
        if (model.userId.length > 0 && ![myUserId isEqualToString:model.userId]) {
            [[KKRtcService shareInstance] subscribeRemoteUserAudioStream:model.userId];
            continue;
        }
    }
}

-(void)unsubscribeRemoteAudioStream:(NSArray <KKVoiceRoomMicPSimpleModel *>*)micPArray {
    
    for (KKVoiceRoomMicPSimpleModel *model in micPArray) {
        //1.userId有值, 就取消订阅
        if (model.userId.length > 0) {
            [[KKRtcService shareInstance] unsubscribeRemoteUserAudioStream:model.userId];
            continue;
        }
    }
}

-(void)trySubscribeRemoteUserStream:(NSString *)userId {
    if (![userId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
        [[KKRtcService shareInstance] subscribeRemoteUserAudioStream:userId];
    }
}

-(void)tryUnsubscribeRemoteUserStream:(NSString *)userId {
    [[KKRtcService shareInstance] unsubscribeRemoteUserAudioStream:userId];
}
 

#pragma mark - RongRTCRoomDelegate

-(void)didJoinUser:(RongRTCRemoteUser *)user {
    //BBLOG(@"KKVoiceRoom ************************************didJoinUser userId:%@",user.userId);
    [self joinLeaveCountAdd:YES];
   
}

-(void)didLeaveUser:(RongRTCRemoteUser *)user {
    //BBLOG(@"KKVoiceRoom ************************************didLeaveUser userId:%@",user.userId);
    [self joinLeaveCountAdd:NO];
}

- (void)didReportFirstKeyframe:(RongRTCAVInputStream *)stream {
    BBLOG(@"\n\n KKVoiceRoom ************************************didReportFirstKeyframe userId:%@ streamID:%@ \n",stream.userId,stream.userId);
}


- (void)didUnpublishStreams:(NSArray<RongRTCAVInputStream *>*)streams {
    BBLOG(@"\n\n KKVoiceRoom ************************************didUnpublishStreams userId:%@  \n",streams.firstObject.userId);
    NSString *pUserId = streams.firstObject.userId;
    [self tryUnsubscribeRemoteUserStream:pUserId];
}

- (void)didPublishStreams:(NSArray <RongRTCAVInputStream *>*)streams {
    BBLOG(@"\n\n KKVoiceRoom ************************************didPublishStreams userId:%@ \n ",streams.firstObject.userId);
    
    NSString *pUserId = streams.firstObject.userId;
    [self trySubscribeRemoteUserStream:pUserId];
}


- (void)didConnectToStream:(RongRTCAVInputStream *)stream {
    BBLOG(@"\n\n KKVoiceRoom ************************************didConnectToStream userId:%@ streamID:%@  \n",stream.userId,stream.userId);
    //NSString *pUserId = stream.userId;
}

/** 接收到其他人发送到 room 里的消息 */
- (void)didReceiveMessage:(RCMessage *)message {
    //BBLOG(@"\n\n KKVoiceRoom ************************************didReceiveMessage:%@ \n",message.content);
}

/** 音频状态改变
 @param stream 流信息
 @param mute 当前流是否可用
 */
-(void)stream:(RongRTCAVInputStream *)stream didAudioMute:(BOOL)mute {
    
    BBLOG(@"\n\n KKVoiceRoom ************************************didAudioMute stream:%@ didAudioMute:%d \n",stream.userId, mute);
}

#pragma mark RongRTCActivityMonitorDelegate
-(void)didReportStatForm:(RongRTCStatisticalForm *)form {
    
    //1.发送
    for(RongRTCStreamStat *streamStat in form.sendStats){
        //只处理音频
        if ([streamStat.mediaType isEqualToString:RongRTCMediaTypeAudio]) {
            [self updateMicPositionSpeaking:streamStat.trackId audioLevel:streamStat.audioLevel isSend:YES];
        }
    }
    
    //2.接收
    for(RongRTCStreamStat *streamStat in form.recvStats){
        //只处理音频
        if ([streamStat.mediaType isEqualToString:RongRTCMediaTypeAudio]) {
            [self updateMicPositionSpeaking:streamStat.trackId audioLevel:streamStat.audioLevel isSend:NO];
        }
    }
}

@end
