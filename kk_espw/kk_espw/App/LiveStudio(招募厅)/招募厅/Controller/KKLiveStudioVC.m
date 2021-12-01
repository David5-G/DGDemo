//
//  KKLiveStudioVC.m
//  kk_espw
//
//  Created by david on 2019/7/18.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioVC.h"
#import "KKVoiceRoomVC.h"
#import "KKGameRoomOwnerController.h"

#import "KKLiveStudioGameRoomPopVC.h"
#import "KKChatRoomOnlineUserPopVC.h"
#import "KKChatRoomMicRankPopVC.h"
#import "KKChatRoomUserMgrPopVC.h"
#import "KKChatRoomTableVC.h"
#import "KKLiveStudioHostEnterVC.h"
//view
#import "KKLiveStudioOnlineUserView.h"
#import "KKLiveStudioMicPositionView.h"//麦位
#import "KKLiveStudioGameRoomView.h"//开黑房
#import "KKVoiceRoomInputView.h"
#import "KKLiveStudioActionSheetView.h"//操作表
#import "KKCreateCardView.h"
#import "KKCardsSelectView.h"
#import "KKCardTag.h"
//viewModel
#import "KKLiveStudioViewModel.h"
#import "KKChatRoomUserListViewModel.h"
#import "KKLiveStudioGameRoomViewModel.h"

//tool
#import "KKPlayerGameCardTool.h"
#import "KKHomeService.h"
#import "KKMyCardService.h"
//RTC
#import "KKRtcService.h"
#import "KKLiveStudioRtcMgr.h"
//自定义消息
#import "KKChatRoomCustomMsg.h"
#import "KKChatRoomMicPositionMsg.h"
#import "KKAddMyCardViewController.h"

typedef NS_ENUM(NSUInteger, KKLiveStudioUserType) {
    KKLiveStudioUserTypeCommon = 0,
    KKLiveStudioUserTypeMic,
    KKLiveStudioUserTypeHost,
};

static const NSInteger liveStudio_timeInterval = 5;
//主播位置
static const NSInteger liveStudio_alert_host_leave = 1001;
static const NSInteger liveStudio_alert_host_identityInvalid = 1002;
//麦位
static const NSInteger liveStudio_alert_guestMicP_close = 1011;
static const NSInteger liveStudio_alert_guestMicP_quit = 1012;
static const NSInteger liveStudio_alert_guestMicP_give = 1013;
static const NSInteger liveStudio_alert_guestMicP_takeAway = 1014;
//push
static const NSInteger liveStudio_alert_pushToGameRoom = 1021;

@interface KKLiveStudioVC ()
<UIGestureRecognizerDelegate,
RongRTCRoomDelegate,
RongRTCActivityMonitorDelegate,
KKLiveStudioMicPositionViewDelegate,
KKLiveStudioGameRoomViewDelegate,
KKVoiceRoomInputViewDelegate,
KKChatRoomTableVCDelegate,
CatDefaultPopDelegate,
KKPlayerGameCardToolDelagate>
{
    CGFloat _topViewHeight;
    CGFloat _micPositionViewTopSpace;
    CGFloat _micPositionViewHeight;
    CGFloat _gameRoomDefaultHeight;
    CGFloat _gameRoomNoDataHeight;
    CGFloat _inputViewHeight;
}

@property (nonatomic, strong) UIScrollView *scrollView;
//-----------------navi
@property (nonatomic, strong) UILabel *naviTitleLabel;
@property (nonatomic, strong) UIImageView *redSexangleImageView;
@property (nonatomic, strong) KKLiveStudioOnlineUserView *onlineUserView;
@property (nonatomic, assign) NSInteger joinLeaveCount;//加入离开计数
@property (nonatomic, assign) NSInteger onlineUserTotalCount;
//-----------------麦位
@property (nonatomic, strong) KKLiveStudioMicPositionView *micPositionView;
@property (nonatomic, assign) BOOL guestMicClosed;
@property (nonatomic, assign) BOOL isHostIdentity;//自己是否有主播权限
@property (nonatomic, copy) NSString *hostUserId;//当前主播userId
@property (nonatomic, copy) NSString *guestUserId;//当前嘉宾userId
//-----------------推荐开黑房
@property (nonatomic, weak) KKLiveStudioGameRoomView *gameRoomView;
@property (nonatomic, strong) KKLiveStudioGameRoomSimpleModel *selectedGameRoomSimpleModel;
@property (nonatomic, strong) NSString *selectedCardId;
//-----------------聊天
@property (nonatomic, assign) BOOL isForbidWord;
@property (nonatomic, strong) UIView *chatContainerView;
@property (nonatomic, strong) KKChatRoomTableVC *chatRoomVC;
//-----------------输入条
@property (nonatomic, assign) BOOL isVoiceOpen;
@property (nonatomic, assign) BOOL isMicOpen;
@property (nonatomic, assign) KKLiveStudioUserType userType;
@property (nonatomic, strong) KKVoiceRoomInputView *inputView;
//-----------------pop
@property (nonatomic, strong) CatDefaultPop *pop;
@property (nonatomic, strong) KKBottomPopVC *popVC;

//-----------------tool
//timer
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger leftTime;
//viewModel
@property (nonatomic, assign) BOOL needShowHUD;
@property (nonatomic, strong) KKLiveStudioViewModel *viewModel;
@property (nonatomic, strong) KKLiveStudioGameRoomViewModel *gameRoomViewModel;
@property (nonatomic, strong) KKChatRoomUserListViewModel *userListViewModel;
 
@end

@implementation KKLiveStudioVC
#pragma mark - getter/setter
#pragma mark getter
-(KKLiveStudioViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[KKLiveStudioViewModel alloc]init];
    }
    return _viewModel;
}

-(KKLiveStudioGameRoomViewModel *)gameRoomViewModel {
    if (!_gameRoomViewModel) {
        _gameRoomViewModel = [[KKLiveStudioGameRoomViewModel alloc]init];
    }
    return _gameRoomViewModel;
}

-(KKChatRoomUserListViewModel *)userListViewModel {
    if (!_userListViewModel) {
        _userListViewModel = [[KKChatRoomUserListViewModel alloc]init];
    }
    return _userListViewModel;
}


#pragma mark setter

-(void)setStudioId:(NSString *)studioId {
    //如果是同一个房间, 直接return
    if ([_studioId isEqualToString:studioId]) {
        return;
    }
    _studioId = [studioId copy];
    //1.关联的懒加载属性 更新
    self.viewModel.studioId = studioId;
    self.gameRoomViewModel.studioId = studioId;
    self.userListViewModel.channelId = studioId;
    
    //因为是单例, 当换房间时候viewDidLoad不会走,所以讲2和3放在此方法中
    //目前招募厅只有一个(id只有一个), 2和3的作用体现不出来,但以防产品添加招募厅个数
    //2.重新配置rtc
    [self rtcConfig];
    //3.开启声音
    self.isVoiceOpen = YES;
}

-(void)setHostUserId:(NSString *)hostUserId {
    _hostUserId = [hostUserId copy];
   
    //1.麦位信息
    self.micPositionView.hostName = [self.viewModel getHostName];
    self.micPositionView.hostlogoUrl = [self.viewModel getHostLogoUrl];
    //2.麦位状态
    self.micPositionView.hostStatus = hostUserId.length>0 ? KKLiveStudioMicPStatusPresent : KKLiveStudioMicPStatusAbsent;
}


-(void)setGuestUserId:(NSString *)guestUserId {
    _guestUserId = [guestUserId copy];
    
    //1.麦位信息
    self.micPositionView.guestName = [self.viewModel getMicUserName];
    self.micPositionView.guestlogoUrl = [self.viewModel getMicUserlogoUrl];
    //2.麦位状态
    if (guestUserId.length > 0) {
           self.micPositionView.guestStatus = KKLiveStudioMicPStatusPresent;
       }else{
           self.micPositionView.guestStatus = self.guestMicClosed ? KKLiveStudioMicPStatusClose : KKLiveStudioMicPStatusAbsent;
       }
   
}

-(void)setGuestMicClosed:(BOOL)guestMicClosed {
    //1.没变动过滤
    if (_guestMicClosed == guestMicClosed) {
        return;
    }
    //2.存值
    _guestMicClosed = guestMicClosed;
    
    //3.变动
    if (guestMicClosed) {
        self.micPositionView.guestStatus = KKLiveStudioMicPStatusClose;
    }else {
        self.micPositionView.guestStatus = KKLiveStudioMicPStatusAbsent;
    }
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
static KKLiveStudioVC *_liveStudio = nil;
static dispatch_once_t onceToken;

+ (instancetype)shareInstance {
    dispatch_once(&onceToken, ^{
        _liveStudio = [[KKLiveStudioVC alloc] init];
    });
    return _liveStudio;
}


/** 清空 释放 */
- (void)remove{
    //1.更新KKFloatViewMgr中招募厅的相关数据
    [self setFloatViewInfo:NO];
    
    //2.释放self
    _liveStudio = nil;
    onceToken = 0;
}

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDimension];
    [self setupUI];
    [self setupNavi];
    //默认为闭麦
    _guestMicClosed = YES;
    self.micPositionView.guestStatus = KKLiveStudioMicPStatusClose;
    //通知
    [self registerChatRoomNotification];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [KKFloatViewMgr shareInstance].hiddenFloatView = YES;
    //移除popVC
    if (self.popVC) {
        [self.popVC removeSelf];
        self.popVC = nil;
    }
    //请求
    self.needShowHUD = YES;
    [self requestGameRoomList];
    [self requestLiveStudioInfo];
    
    [[KKFloatViewMgr shareInstance] hiddenLiveStudioFloatView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [KKFloatViewMgr shareInstance].hiddenFloatView = NO;
    [[KKFloatViewMgr shareInstance] notHiddenLiveStudioFloatView];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    self.fd_interactivePopDisabled = YES;
    [self startTimer];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.fd_interactivePopDisabled = NO;
    [self stopTimer];

}

-(void)dealloc {
    [self removeChatRoomNotification];
    BBLOG(@"KKLiveStudioVC -- dealloc");
}

#pragma mark - UI
-(void)setDimension {
    
    _topViewHeight = [ccui getRH:155];
    _micPositionViewTopSpace = STATUS_AND_NAV_BAR_HEIGHT + [ccui getRH:8];
    _micPositionViewHeight = [ccui getRH:94];
    _gameRoomDefaultHeight = [ccui getRH:138];
    _gameRoomNoDataHeight = [ccui getRH:78];
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
    titleL.font = [KKFont fontWithName:[UIFont boldSystemFontOfSize:10].fontName size:19 italicAngle:10];
    self.naviTitleLabel = titleL;
    [self.naviBar addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backBtn.mas_right).mas_offset(-[ccui getRH:4]);
        make.centerY.mas_equalTo(backBtn);
    }];
    
    //2.3 红色六边形gif
    //动图图片
    NSMutableArray *imgArr = [NSMutableArray arrayWithCapacity:4];
    for (NSInteger i=1; i<5; i++) {
        NSString *imgStr = [NSString stringWithFormat:@"live_gif_redSexangle_%02ld",(long)i];
        [imgArr addObject:Img(imgStr)];
    }
    
    UIImageView *redImgV = [[UIImageView alloc]initWithImage:imgArr.firstObject];
    self.redSexangleImageView = redImgV;
    redImgV.animationImages = imgArr;
    redImgV.animationDuration = 0.1*imgArr.count;
    redImgV.animationRepeatCount = 0;
    //[redImgV startAnimating];
    [self.naviBar addSubview:redImgV];
    [redImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleL.mas_right).mas_offset([ccui getRH:6]);
        make.centerY.mas_equalTo(titleL);
        make.width.mas_equalTo([ccui getRH:14]);
        make.height.mas_equalTo([ccui getRH:16]);
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
    //WS(weakSelf)
    
    //1.scrollView
    CGRect scrollFrame = self.view.bounds;
    scrollFrame.size.height -= _inputViewHeight + HOME_INDICATOR_HEIGHT;
    UIScrollView *scrollV = [[UIScrollView alloc]initWithFrame:scrollFrame];
    scrollV.bounces = NO;
    scrollV.backgroundColor = UIColor.whiteColor;
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
    [self setupTopBgView];
    UIView *hostV = [self setupMicPostitionView];
    UIView *gameRoomV = [self setupGameRoom:hostV];
    [self setupChatContainerView:gameRoomV];
    
    //2.inputV
    KKVoiceRoomInputView *inputV = [[KKVoiceRoomInputView alloc]initWithFrame:CGRectMake(0, scrollV.bottom, scrollV.width, _inputViewHeight)];
    inputV.rightToolButtons = @[KKInputViewToolButtonSpeaker];
    inputV.speakerButton.selected = YES;
    inputV.delegate = self;
    inputV.themeStyle = KKInputViewThemeStyleDefault;
    self.inputView = inputV;
    self.userType = KKLiveStudioUserTypeCommon;
    [self.view addSubview:inputV];
    //2.1 leftTool
    [self setupInputViewLeftToolSubview:NO];
    
    //4.为适配iPhoneX
    if(iPhoneX) {
        UIView *blankV = [[UIView alloc]initWithFrame:CGRectMake(0, inputV.bottom, self.view.width, HOME_INDICATOR_HEIGHT)];
        blankV.backgroundColor = UIColor.whiteColor;
        [self.view addSubview:blankV];
    }
}

-(void)setupInputViewLeftToolSubview:(BOOL)isHost {

    UIColor *yellowC = rgba(236, 193, 101, 1);
    NSString *btnTitle = isHost ? @"待上麦用户" : @"排麦";
    CGFloat btnW = isHost ? [ccui getRH:75] : [ccui getRH:50];
    //1.创建btn
    DGButton *micRankBtn = [DGButton btnWithFontSize:[ccui getRH:13] bold:NO title:btnTitle titleColor:yellowC];
    micRankBtn.layer.cornerRadius = [ccui getRH:5];
    micRankBtn.layer.masksToBounds = YES;
    micRankBtn.layer.borderColor = yellowC.CGColor;
    micRankBtn.layer.borderWidth = 1;
    WS(weakSelf)
    [micRankBtn addClickWithTimeInterval:0.2 block:^(DGButton *btn) {
        SS(strongSelf)
        if ([strongSelf checkIsCurrentHost]) {
            [strongSelf showUserMgrPopVC];
        }else{
            [strongSelf showMicRankPopVC];
        }
    }];
    
    //2.设置LeftToolView
    [self.inputView setLeftToolSubview:micRankBtn width:btnW];
}


/** 设置 顶部背景view */
-(void)setupTopBgView {
    CGFloat topViewH = _topViewHeight;
    
    //1.topV
    UIView *topV = [[UIView alloc]init];
    topV.clipsToBounds = NO;
    [self.scrollView addSubview:topV];
    [topV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(topViewH);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    //2.bgImgV
    UIImageView *topBgImgV = [[UIImageView alloc]initWithImage:Img(@"live_bg_header")];
    [topV addSubview:topBgImgV];
    [topBgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
}

/** 设置 主持view */
-(UIView *)setupMicPostitionView {
    
    CGFloat micViewH = _micPositionViewHeight;
    CGFloat topSpace = _micPositionViewTopSpace;
    CGFloat leftSpace = [ccui getRH:14];
    
    //1.hostV
    CGRect micViewBounds = CGRectMake(0, 0, SCREEN_WIDTH-2*leftSpace, micViewH);
    KKLiveStudioMicPositionView *micV = [[KKLiveStudioMicPositionView alloc]initWithFrame:micViewBounds];
    micV.backgroundColor = UIColor.whiteColor;
    micV.delegate = self;
    self.micPositionView = micV;
    [self.scrollView addSubview:micV];
    [micV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topSpace);
        make.left.mas_equalTo(leftSpace);
        make.right.mas_equalTo(-leftSpace);
        make.height.mas_equalTo(micViewH);
    }];
    
    //2.圆角处理
    UIBezierPath *micMaskPath = [UIBezierPath bezierPathWithRoundedRect:micViewBounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake([ccui getRH:5], [ccui getRH:5])];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.frame = micViewBounds;
    maskLayer.path = micMaskPath.CGPath;
    micV.layer.mask = maskLayer;
 
    //3.
    return micV;
}


/** 设置 推荐开黑房 */
-(UIView *)setupGameRoom:(UIView *)topV {
    CGFloat gameRoomViewH = _gameRoomNoDataHeight;
    
    //1.gameRoomV
    KKLiveStudioGameRoomView *gameRoomV = [[KKLiveStudioGameRoomView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, gameRoomViewH)];
    gameRoomV.dataArray = nil;
    gameRoomV.delegate = self;
    gameRoomV.backgroundColor = UIColor.whiteColor;
    gameRoomV.isHostCheck = NO;
    
    self.gameRoomView = gameRoomV;
    [self.scrollView addSubview:gameRoomV];
    [gameRoomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topV.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(gameRoomViewH);
    }];
    
    WS(weakSelf);
    [gameRoomV setConfigBlock:^(KKLiveStudioGameRoomCollectionViewCell *cell, KKLiveStudioGameRoomSimpleModel *model, NSIndexPath *indexPath) {
        cell.idLabel.text = model.gameRoomId;
        cell.titleLabel.text = [NSString stringWithFormat:@"%@-%@",model.platformType.message,model.rank.message];
        cell.msgLabel.text  = model.title;
        cell.maleCountLabel.text = [NSString stringWithFormat:@"%ld",model.male];
        cell.femaleCountLabel.text = [NSString stringWithFormat:@"%ld",model.female];
        cell.statisticLabel.text = [NSString stringWithFormat:@"%ld/%ld",(model.male+model.female),model.total];
        
    } selectBlock:^(KKLiveStudioGameRoomSimpleModel *model, NSIndexPath *indexPath) {
        [weakSelf.inputView stopInput];//退出键盘
        [weakSelf didSelectedGameRoom:model];
    }];
    
    //2.return
    return gameRoomV;
}

-(void)setupChatContainerView:(UIView *)topV {
    
    CGFloat height = self.scrollView.height - _micPositionViewTopSpace - _micPositionViewHeight - _gameRoomNoDataHeight;
    
    //1.containerV
    UIView *chatContainerV = [[UIView alloc]init];
    chatContainerV.backgroundColor = KKES_COLOR_BG;
    self.chatContainerView = chatContainerV;
    [self.scrollView addSubview:chatContainerV];
    [chatContainerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topV.mas_bottom).mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(height);
    }];
    
    //2.chatRoomVC
    KKChatRoomTableVC *chatRoomVC = [[KKChatRoomTableVC alloc]init];
    chatRoomVC.automaticallyAdjustsScrollViewInsets = NO;
    chatRoomVC.targetId = self.studioId;
    chatRoomVC.view.backgroundColor = KKES_COLOR_BG;
    chatRoomVC.delegate = self;
    
    //3.添加chatRoomVC
    self.chatRoomVC = chatRoomVC;
    [self addChildViewController:chatRoomVC];
    [chatContainerV addSubview:chatRoomVC.view];
    [self.chatRoomVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([ccui getRH:5]);
        make.left.right.bottom.mas_equalTo(0);
    }];
}

#pragma mark tool

/** 刷新在线人数view */
-(void)refreshOnlieUserView:(NSArray <KKChatRoomUserSimpleModel *>*)userModelArr totalCount:(NSInteger)totalCount {
    
    //1.总人数
    [self.onlineUserView setUserCount:totalCount];
    
    //2.更新头像
    NSInteger needCount = 3;
    //2.1 获取头像array
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:needCount];
    for (NSInteger i=0; i<userModelArr.count && i<needCount; i++) {
        KKChatRoomUserSimpleModel *userModel = userModelArr[i];
        [mArr addObject:userModel.userLogoUrl];
    }
    //2.2 赋值
    [self.onlineUserView setUserLogoUrlArray:mArr];
}

/** 更新麦位说话状态 */
-(void)updateMicPositionSpeaking:(NSString *)trackId audioLevel:(NSInteger)audioLevel {
    dispatch_async(dispatch_get_main_queue(), ^{
        //1.主播
        if (self.hostUserId.length>0 && [trackId containsString:self.hostUserId]) {
            //1.1 自己是主播 且 关闭麦克风
            if([self checkIsCurrentHost] && self.isMicOpen==NO){
                self.micPositionView.hostSpeaking = NO;
                
            }else{//1.2 其余取决于音量
                self.micPositionView.hostSpeaking = audioLevel>0;
            }
        }
        //2.麦位
//        if (self.guestUserId.length>0 && [trackId containsString:self.guestUserId]) {
//            self.micPositionView.guestSpeaking = audioLevel>0;
//        }
    });
}

/** 刷新inputView */
-(void)refreshInputView {
    
    //现在是否是micUser
    KKLiveStudioUserType userTypeNow = [self checkUserType];
    
    //1.过滤 状态没改变,
    if (self.userType == userTypeNow) {
        return;
    }
    //更新状态
    self.userType = userTypeNow;
    
    //2.状态改变了
    //2.1 退出键盘
    [self.inputView stopInput];
    //2.2 改变rightToolButtons
    if (userTypeNow == KKLiveStudioUserTypeHost) {
        self.inputView.rightToolButtons = @[KKInputViewToolButtonSpeaker, KKInputViewToolButtonMic,KKInputViewToolButtonBroom];
    }else if (userTypeNow == KKLiveStudioUserTypeMic) {
        self.inputView.rightToolButtons = @[KKInputViewToolButtonSpeaker,KKInputViewToolButtonMic];
    }else {
        self.inputView.rightToolButtons = @[KKInputViewToolButtonSpeaker];
    }
    
    //2.3 leftToolV
    [self setupInputViewLeftToolSubview: [self checkIsCurrentHost]];
    
    //3.麦克风
    self.inputView.micButton.selected = self.isMicOpen;
    
    //4.喇叭
    self.inputView.speakerButton.selected = self.isVoiceOpen;
}


/** 更新gameRoom和chatView的约束 */
-(void)updateConstraintsForGameRoomViewAndChatView {
    
    //1.gameRoomV
    CGFloat gameRoomH = self.gameRoomViewModel.gameRooms.count>0 ? _gameRoomDefaultHeight : _gameRoomNoDataHeight;
    [self.gameRoomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(gameRoomH);
    }];

    //2.chatV
    CGFloat chatH = self.scrollView.height - _micPositionViewTopSpace - _micPositionViewHeight - gameRoomH;
    [self.chatContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(chatH);
    }];
    
}

/** 创建名片列表 */
- (KKCardsSelectView *)createProfileCardList {
    
    KKLiveStudioGameRoomSimpleModel *model = self.selectedGameRoomSimpleModel;
    NSString *gameRoomId = model.gameRoomId;
    NSString *gameBoardId = model.gameBoardId;
    
    WS(weakSelf)
    KKCardsSelectView *listV = [[KKCardsSelectView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:listV];
    
    __weak __typeof(&*listV)weakListV = listV;
    listV.didSelectTableViewCellBlock = ^(KKCardTag * _Nonnull card) {
        if ([card.nickName isEqualToString:@"添加名片"]) {
            //1.点击了添加名片.
            [weakSelf pushAddCardVC];
            
        }else {
            //2.能不能进去
            NSString *cardId = card.ID;
            weakSelf.selectedCardId = cardId;
            [weakSelf.gameRoomViewModel checkCanGoGameRoom:gameRoomId boardId:gameBoardId cardId:cardId success:^{
                [weakSelf showAlertWithTitle:@"是否进入?" content:@"进入开黑房后, 将退出招募厅?" cancelTitle:@"取消" confirmTitle:@"确定" tag:liveStudio_alert_pushToGameRoom];
                
            } fail:^{
                //名片不符合
            }];
        }
        
        //3.移除
        [weakListV removeFromSuperview];
    };
    
    //4.return
    return listV;
}



#pragma mark - tool
-(BOOL)checkIsCurrentHost {
    if ([self.hostUserId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
        return YES;
    }
    return NO;
}

-(BOOL)checkIsCurrentGuest {
    if ([self.guestUserId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
        return YES;
    }
    return NO;
}

-(KKLiveStudioUserType)checkUserType {
    if ([self checkIsCurrentHost]) {
        return KKLiveStudioUserTypeHost;
    }
    
    if ([self checkIsCurrentGuest]) {
        return KKLiveStudioUserTypeMic;
    }
    
    return KKLiveStudioUserTypeCommon;
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
            [self requestLiveStudioInfo];
        }
        
        
        //2.计数
        self.joinLeaveCount += 1;
        if (self.joinLeaveCount > 20) {
            self.joinLeaveCount = 0;
            [self requestLiveStudioInfo];
        }
    });
}


-(void)setFloatViewInfo:(BOOL)isSet {
    
    //1.清空
    if (!isSet) {
        [KKFloatViewMgr shareInstance].liveStudioModel = nil;
        [KKFloatViewMgr shareInstance].type = KKFloatViewTypeUnknow;
        return;
    }
    
    //2.如果是同一个房间
//    if ([[KKFloatViewMgr shareInstance].liveStudioModel.studioId isEqualToString:self.studioId]) {
//        return;
//    }
    
    //3.更新
    KKFloatLiveStudioModel *model = [[KKFloatLiveStudioModel alloc]init];
    model.studioId = self.studioId;
    model.hostLogoUrl = [self.viewModel getHostLogoUrl];
    model.title = [self.viewModel studioName];
    model.hostName = [self.viewModel getHostName];
    [KKFloatViewMgr shareInstance].liveStudioModel = model;
    [KKFloatViewMgr shareInstance].type = KKFloatViewTypeLiveStudio;
}


#pragma mark - interaction
-(void)tapScrollView:(UITapGestureRecognizer *)tapGr {
    [self.inputView stopInput];//退出键盘
}

-(void)clickOnlineUserView {
    [self.inputView stopInput];//退出键盘
    
    //1是主播
    if([self checkIsCurrentHost]){
        [self showUserMgrPopVC];
        
    }else{
        [self showOnlineUserPopVC];
    }
}

-(void)clickQuikButton {
    [self.inputView stopInput];//退出键盘
    
    //1.是主播
    if([self checkIsCurrentHost]){
        [self showAlertWithTitle:@"提示" content:@"退出后，将结束主持！\n是否确认退出" cancelTitle:@"取消" confirmTitle:@"确定" tag:liveStudio_alert_host_leave];
        return ;
    }
    
    //2.是麦位user, 普通user直接退出直播间
    [self requestLeaveLiveStudio:nil];
}

-(void)didSelectedGameRoom:(KKLiveStudioGameRoomSimpleModel *)model {
    //1.主播不能点击
    if ([self checkIsCurrentHost]) {
        return;
    }
    //2.是麦位用户
    if([self checkIsCurrentGuest]){
        [self showAlertWithTitle:@"提示" content:@"请先下麦,然后才能加入开黑房" cancelTitle:@"取消" confirmTitle:@"确定" tag:liveStudio_alert_guestMicP_quit];
        return;
    }
    //3.处理
    self.selectedGameRoomSimpleModel = model;
    [self requestCardList];
}


#pragma mark - timer
-(void)startTimer {
    WS(weakSelf);
    self.leftTime = liveStudio_timeInterval;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:weakSelf selector:@selector(timerMethod:) userInfo:nil repeats:YES];
}

-(void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerMethod:(NSTimer*)timer{
    
    self.leftTime--;
    if (self.leftTime <= 0) {
        [self requestGameRoomList];
        self.leftTime = liveStudio_timeInterval + 1;
    }
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
        //1.抱用户上麦
        if([title isEqualToString:@"抱用户上麦"]){
            [weakSelf showUserMgrPopVC];
            return ;
        }
        //2.设为闭麦位
        if([title isEqualToString:@"设为闭麦位"]){
            [weakSelf showAlertWithTitle:@"提示" content:@"设为闭麦，则用户排麦列表清空\n无法排麦" cancelTitle:@"取消" confirmTitle:@"确定" tag:liveStudio_alert_guestMicP_close];
            return ;
        }
        //3.设为闭麦位
        if([title isEqualToString:@"开启麦位"]){
            [weakSelf requestGuestMicPositionClose:NO];
            return ;
        }
    };
}

/** show开黑房推荐popView */
-(void)showGameRoomPopVC {
    WS(weakSelf);
    //1.创建
    KKLiveStudioGameRoomPopVC *popVC = [[KKLiveStudioGameRoomPopVC alloc]init];
    popVC.view.frame = self.view.bounds;
    [popVC setDisplayViewHeight:[ccui getRH:373]+HOME_INDICATOR_HEIGHT];
    popVC.roomId = self.studioId;
    popVC.recommendSuccessBlock = ^{
        weakSelf.leftTime = liveStudio_timeInterval;
        [weakSelf requestGameRoomList];
    };
    
    //2.添加
    [self.view addSubview:popVC.view];
    [self addChildViewController:popVC];
    
    //3.show
    [popVC showSelf];
}

/** show在线用户列表popVC */
-(void)showOnlineUserPopVC {
    //1.创建
    KKChatRoomOnlineUserPopVC *popVC = [[KKChatRoomOnlineUserPopVC alloc]init];
    popVC.view.frame = self.view.bounds;
    [popVC setDisplayViewHeight:[ccui getRH:508]+HOME_INDICATOR_HEIGHT];
    popVC.roomId = self.studioId;
    popVC.isHostCheck = [self checkIsCurrentHost];
    popVC.hostUserId = self.hostUserId;
    popVC.playerGameCardDelegate = self;
    popVC.playerGameCardNeedKick = NO;
    self.popVC = popVC;
    
    //2.添加
    [self.view addSubview:popVC.view];
    [self addChildViewController:popVC];
    
    //3.show
    [popVC showSelf];
}

/** show排麦用户列表popVC */
-(void)showMicRankPopVC {
    //1.创建
    KKChatRoomMicRankPopVC *popVC = [[KKChatRoomMicRankPopVC alloc]init];
    popVC.view.frame = self.view.bounds;
    [popVC setDisplayViewHeight:[ccui getRH:508]+HOME_INDICATOR_HEIGHT];
    popVC.ranking = NO;
    popVC.roomId = self.studioId;
    popVC.isHostCheck = [self checkIsCurrentHost];
    popVC.hostUserId = self.hostUserId;
    popVC.isOnMic = [self checkIsCurrentGuest];
    popVC.playerGameCardDelegate = self;
    popVC.playerGameCardNeedKick = NO;
    self.popVC = popVC;
    
    //2.添加
    [self.view addSubview:popVC.view];
    [self addChildViewController:popVC];
    
    //3.show
    [popVC showSelf];
}

/** show用户状态管理popVC */
-(void)showUserMgrPopVC {
    WS(weakSelf)
    
    //1.创建
    KKChatRoomUserMgrPopVC *popVC = [[KKChatRoomUserMgrPopVC alloc]init];
    popVC.view.frame = self.view.bounds;
    [popVC setDisplayViewHeight:[ccui getRH:508]+HOME_INDICATOR_HEIGHT];
    popVC.roomId = self.studioId;
    popVC.isHostCheck = [self checkIsCurrentHost];
    popVC.hostUserId = self.hostUserId;
    popVC.playerGameCardDelegate = self;
    popVC.playerGameCardNeedKick = NO;
    self.popVC = popVC;
    
    popVC.liveStudioGiveMicBlock = ^(BOOL isGive, NSString * _Nonnull userId, BOOL isRanking, void (^ _Nonnull block)(BOOL)) {
        
        SS(strongSelf)
        if (isGive) {
            return [strongSelf requestGuestMicPostitionGive:userId userIsRanking:isRanking block:block];
        }else{
            return [strongSelf requestGuestMicPositionQuit:userId block:block];
        }
    };
 
    //2.添加
    [self.view addSubview:popVC.view];
    [self addChildViewController:popVC];
    
    //3.show
    [popVC showSelf];
}

#pragma mark card
-(void)showPlayerCard:(NSString *)userId {
    BOOL isHost = [self checkIsCurrentHost];
    BOOL isOnMic = [userId isEqualToString:self.guestUserId] || [userId isEqualToString:self.hostUserId];
    
    [KKPlayerGameCardTool shareInstance].hostMicQuitTitle = @"结束直播";
    [[KKPlayerGameCardTool shareInstance] showUserInfo:userId roomId:self.studioId needKick:NO isHostCheck:isHost isOnMic:isOnMic delegate:self];
}
 

#pragma mark - alert
-(void)showAlertWithTitle:(NSString *)title content:(NSString *)message cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle tag:(NSInteger)tag {
    
    //语音房被销毁了 => 直接rerun
    if(!_liveStudio){
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
    //1.下主播位
    if (liveStudio_alert_host_leave == tag) {
        [self requestLeaveLiveStudio:nil];
        return;
    }
    //2.设为闭麦
    if (liveStudio_alert_guestMicP_close == tag) {
        [self requestGuestMicPositionClose:YES];
        return;
    }
    //3.被抱上麦
    if (liveStudio_alert_guestMicP_give == tag) {
        //3.1 打开麦克风
        self.isMicOpen = YES;
        return;
    }
    //4.下麦
    if (liveStudio_alert_guestMicP_quit == tag) {
        [self requestGuestMicPositionQuit:[KKUserInfoMgr shareInstance].userId block:nil];
        return;
    }
    //5.想进入开黑房
    if (liveStudio_alert_pushToGameRoom == tag) {
        [self tryPushToGameRoomVC];
        return;
    }
}

-(void)catDefaultPopCancel:(CatDefaultPop*)defaultPop {
    NSInteger tag = defaultPop.popView.tag;
    
    //3.被抱上麦, 却选择下麦
    if (liveStudio_alert_guestMicP_give == tag) {
        [self requestGuestMicPositionQuit:[KKUserInfoMgr shareInstance].userId block:nil];
        return;
    }
}

#pragma mark - delegate

#pragma mark UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //UIView *gView = gestureRecognizer.view;
    UIView *tView = touch.view;
    if ([tView isKindOfClass:[KKLiveStudioMicPositionView class]] ||
        [tView isKindOfClass:[KKLiveStudioGameRoomView class]] ||
        [tView isKindOfClass:[UITableView class]] ||
        [tView isKindOfClass:[UICollectionView class]]) {
        return YES;
    }
    return NO;
}

#pragma mark KKLiveStudioMicPositionViewDelegate
-(void)didClickHostButton:(KKLiveStudioMicPositionView *)micPositionView {
    [self.inputView stopInput];//退出键盘
    
    //1.主播位有人
    if(self.hostUserId){
        [self showPlayerCard:self.hostUserId];
        return;
    }
    
    //2.有主播权限
    if ([self.viewModel canBeHost]) {
        [self requestAsHost:YES];
    }else{
        [CC_Notice show:@"你没有当前直播间主持权限"];
    }
}

-(void)didClickGuestButton:(KKLiveStudioMicPositionView *)micPositionView {
    [self.inputView stopInput];//退出键盘
    
    //1.麦位有人
    if(self.guestUserId){
        [self showPlayerCard:self.guestUserId];
        return;
    }
    
    //2.不是主播
    if (![self checkIsCurrentHost]) {
        if (KKLiveStudioMicPStatusAbsent == micPositionView.guestStatus) {
            [self showMicRankPopVC];
        }
        return;
    }
    
    //3.是主播
    //3.1 处于闭麦状态
    if (KKLiveStudioMicPStatusClose == micPositionView.guestStatus) {
        [self showActionSheet:@[@"抱用户上麦",@"开启麦位",@"取消"] userId:nil];
        return;
    }
    //3.2 麦位是虚以待位状态
    [self showActionSheet:@[@"抱用户上麦",@"设为闭麦位",@"取消"] userId:nil];
}

#pragma mark KKLiveStudioGameRoomViewDelegate
-(void)gameRoomViewDidClickRecommendButton:(KKLiveStudioGameRoomView *)gameRoomView {
    [self.inputView stopInput];//退出键盘
    [self showGameRoomPopVC];
}

-(void)gameRoomViewWillBeginDragging:(KKLiveStudioGameRoomView *)conversationVC {
    [self.inputView stopInput];//退出键盘
}

#pragma mark KKChatRoomTableVCDelegate
-(void)chatRoomWillBeginDragging:(KKChatRoomTableVC *)chatRoomTableVC {
    [self.inputView stopInput];//退出键盘
}

-(void)chatRoom:(KKChatRoomTableVC *)chatRoomTableVC didSelectMsg:(KKChatRoomMessage *)msg {
    [self.inputView stopInput];//退出键盘
    
    //1.自定义消息
    if ([msg.rcMsg.content isMemberOfClass:[KKChatRoomCustomMsg class]]) {
        KKChatRoomCustomMsg *msgContent = (KKChatRoomCustomMsg *)msg.rcMsg.content;
        //1.1 广播找人()
        if ([msgContent.msgType isEqualToString:@"ESPW_SPECIAL_MSG_TYPE"]) {
            //获取数据
            NSArray *arr = [msgContent.extra componentsSeparatedByString:@","];
            NSString *gameBoardId = arr.firstObject;
            NSString *roomId = arr.lastObject;
            //创建model
            KKLiveStudioGameRoomSimpleModel *model = [[KKLiveStudioGameRoomSimpleModel alloc]init];
            model.gameBoardId = gameBoardId;
            model.gameRoomId = roomId;
            //选中model
            [self didSelectedGameRoom:model];
        }
        
        return;
    }
    
    //2.普通消息 -> 展示名片
    NSString *senderId = msg.rcMsg.senderUserId;
    [self showPlayerCard:senderId];
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

-(void)inputView:(KKVoiceRoomInputView *)inputView openSpeaker:(BOOL)isOpen {
    self.isVoiceOpen = isOpen;
    
    //1.提示
    NSString *noticeStr = isOpen ?  @"已取消静音" : @"静音中";
    [CC_Notice showNoticeStr:noticeStr atView:self.view delay:1.0];
}

-(void)inputView:(KKVoiceRoomInputView *)inputView openMic:(BOOL)isOpen {
    self.isMicOpen = isOpen;
    
    //1.提示
    NSString *noticeStr = isOpen ? @"麦克风开启" : @"麦克风关闭";
    [CC_Notice showNoticeStr:noticeStr atView:self.view delay:1.0];
}

-(void)inputView:(KKVoiceRoomInputView *)inputView didClickBroom:(UIButton *)button {
    [self.chatRoomVC cleanHistoryMessages];
}


#pragma mark KKPlayerGameCardToolDelagate
-(void)playerGameCardTool:(KKPlayerGameCardTool *)tool handleMsg:(NSString *)msg targetUserId:(nonnull NSString *)targetUserId {
    NSString *userId = targetUserId;
    
    if([msg isEqualToString:@"禁言"]){
        [self requestForbidWord:userId isForbid:YES];
        
    }else if([msg isEqualToString:@"解禁"]){
        [self requestForbidWord:userId isForbid:NO];
        
    } else if([msg isEqualToString:@"抱上麦"]){
        [self requestGuestMicPostitionGive:userId userIsRanking:NO block:nil];
        
    }else if([msg isEqualToString:@"抱下麦"]){
        [self requestGuestMicPositionQuit:userId block:nil];
        
    }else if ([msg isEqualToString:@"下麦"]) {
         [self requestGuestMicPositionQuit:userId block:nil];
    }else if ([msg isEqualToString:@"结束直播"]) {
        if([self checkIsCurrentHost]){
             [self requestAsHost:NO];
         }
    }
}

#pragma mark - notification
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
}

/**  该通知, 通知不到自己
 @{
    @"micChangeType"  : content.micChangeType,
    @"fromChangeUserId" : content.fromChangeUserId,
    @"toChangeUserId"   : content.toChangeUserId,
    @"extra"            : content.extra
 }
 
 micChangeType
 * CARRY => 抱麦 (需要弹窗提示)
 * LOCK => 锁麦
 * UNLOCK => 解锁麦
 * FORBIDDEN => 禁麦 
 * UNFORBIDDEN => 解禁
 * KICK => 踢麦
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
    
    BBLOG(@"\n\n KKLiveStudio ************************************notificationMicPositionChange targetId:%@ micType:%@ fromUserId:%@ toUserId:%@ \n",targetId, micType, fromUserId, toUserId);
    
    //0.过滤非本房间的消息
    if (![targetId isEqualToString:self.chatRoomVC.targetId]) {
        return;
    }
    
    //1.抱上麦
    if ([micType isEqualToString:@"CARRY"]) {
        //是自己 & 自己不是嘉宾
        if ([toUserId isEqualToString:myUserId] && ![self checkIsCurrentGuest]) {
            [self showAlertWithTitle:@"提示" content:@"你已被抱上麦\n快打开麦克风聊天吧" cancelTitle:@"下麦" confirmTitle:@"开始聊天" tag:liveStudio_alert_guestMicP_give];
        }
    }
    
    //2. 踢下麦
    else if ([micType isEqualToString:@"KICK"]){
        //2.1 嘉宾被抱下麦
        //是自己 & 自己是嘉宾
        if ([toUserId isEqualToString:myUserId] && [self checkIsCurrentGuest]) {
            self.isMicOpen = NO;
            [self showAlertWithTitle:@"提示" content:@"你已被抱下麦" cancelTitle:nil confirmTitle:@"确定" tag:liveStudio_alert_guestMicP_takeAway];
        }
        
        //2.2 踢主播下麦
        //是自己 & 自己是主播
        if ([toUserId isEqualToString:myUserId] && [self checkIsCurrentHost]) {
            BBLOG(@"\n\n KKLiveStudio ************************************notificationMicPositionChange 主播身份失效");
            [self showAlertWithTitle:@"提示" content:@"主播权限已失效，请刷新" cancelTitle:nil confirmTitle:@"确定" tag:liveStudio_alert_host_identityInvalid];
        }
    }
    
    //刷新招募厅信息
    [self requestLiveStudioInfo];
}



#pragma mark - request
/** 请求 退出招募厅 */
-(void)requestLeaveLiveStudio:(void (^ __nullable)(void))success {
    WS(weakSelf);
    [[KKLiveStudioRtcMgr shareInstance] requestLeaveStudio:self.studioId success:^{
        [weakSelf naviPopAction:NO];
        if (success) {
            success();
        }
    }];
}

-(void)requestLiveStudioInfo {
    
    //招募厅被销毁了 => 直接rerun
    if(!_liveStudio){
        return;
    }
    
    MaskProgressHUD *HUD;
    if (self.needShowHUD) {
        HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:self.view];
    }
    
    WS(weakSelf);
    [self.viewModel requestLiveStudioInfo:^(NSInteger code) {
        SS(strongSelf);
        
        //HUD只有在viewWillAppear中调该此方法才展示一次
        if (HUD) {
            strongSelf.needShowHUD = NO;
            [HUD stop];
        }
        
        //可能想要成为主持人
        [strongSelf handleMaybeWantAsHost];
        
        //0.请求被拦截,或失败
        if (code < 0) {  return ; }
        
        //1.navi
        //1.1 title
        strongSelf.naviTitleLabel.text = [strongSelf.viewModel studioName];
        //1.2 红色六边形
        if ([strongSelf.viewModel isLiving]) {
            [strongSelf.redSexangleImageView startAnimating];
        }else{
            [strongSelf.redSexangleImageView stopAnimating];
        }
        //1.3 在线用户
        NSInteger userCount = [strongSelf.viewModel onlineUserCount];
        strongSelf.onlineUserTotalCount = userCount;
        [strongSelf refreshOnlieUserView:[strongSelf.viewModel firstJoinUsers] totalCount:userCount];
        
        //2.麦位
        [strongSelf updateMicP];
        
        //3.推荐开黑房
        strongSelf.gameRoomView.isHostCheck = [strongSelf checkIsCurrentHost];
        
        //4.inputView
        strongSelf.isForbidWord = [strongSelf.viewModel cannotSendTextMsg];
        [strongSelf refreshInputView];
        
        //5.floatView
        [self setFloatViewInfo:YES];
    }];
}

#pragma mark online Users
//暂时没用到
-(void)requestOnlieUsers {
    WS(weakSelf);
    [self.userListViewModel requestOnlineUsers:^(NSInteger code) {
        SS(strongSelf);
        //1. 请求失败, 或被拦截
        if (code < 0) {
            return;
        }
        
        //2.有数据, 刷新onlineUserView
        [self refreshOnlieUserView:strongSelf.userListViewModel.onlineUsers totalCount:strongSelf.userListViewModel.onlineTotalUserCount];
    }];
}


#pragma mark micP管理
/** 请求 成为/退出主播 */
-(void)requestAsHost:(BOOL)asHost {
    WS(weakSelf);
    //1.成为主播
    if (asHost) {
        [self.viewModel requestHostMicGet:^(NSInteger code) {
            if (code >= 0) {
                weakSelf.isMicOpen = YES;
            }
        }];
        return;
    }
    
    //2.下主播
    [self.viewModel  requestHostMicQuit:^(NSInteger code) {
        if (code >= 0) {
            weakSelf.isMicOpen = NO;
        }
    }];
}
 
/** 请求 下麦 */
-(void)requestGuestMicPositionQuit:(NSString *)userId block:(void(^ _Nullable)(BOOL))block {
     
    [self.viewModel requestMicQuit:userId success:^(NSInteger code) {
        if (block) {
            block(code >= 0);
        }
    }];
}

-(void)requestGuestMicPostitionGive:(NSString *)userId userIsRanking:(BOOL)isRanking block:(void(^ _Nullable)(BOOL))block {
     
    [self.viewModel requestMicGive:userId success:^(NSInteger code) {
        if (block) {
            block(code >= 0);
        }
    }];
 
}

/** 请求 设置嘉宾位闭麦 */
-(void)requestGuestMicPositionClose:(BOOL)isClose {
    WS(weakSelf);
    [self.viewModel requestMicSet:isClose success:^(NSInteger code) {
        if (code >= 0) {
            weakSelf.micPositionView.guestStatus = isClose ? KKLiveStudioMicPStatusClose : KKLiveStudioMicPStatusAbsent;
        }
    }];
}

#pragma mark game room
/** 请求 推荐开黑房列表 */
-(void)requestGameRoomList {

    WS(weakSelf);
    [self.gameRoomViewModel requestGameRoomList:^(NSArray<KKLiveStudioGameRoomSimpleModel *> * _Nonnull gameRooms) {
        SS(strongSelf);
        strongSelf.gameRoomView.dataArray = gameRooms;
        [strongSelf.gameRoomView.collectionView reloadData];
        [strongSelf updateConstraintsForGameRoomViewAndChatView];
    }];
}


#pragma mark card list
/** 用户游戏档案查询 */
-(void)requestCardList {
    [KKMyCardService requestCardTagListSuccess:^(NSMutableArray * _Nonnull dataList) {
        //名片列表
        KKCardsSelectView *listV = [self createProfileCardList];
        KKCardTag *addCard = New(KKCardTag);
        addCard.nickName = @"添加名片";
        [dataList addObject:addCard];
        listV.dataList = dataList;
        
    } Fail:^{
        
    }];
}

#pragma mark user管理
-(void)requestForbidWordCheckForMgr:(NSString *)userId  {
    [self.userListViewModel requestForbidWordCheck:userId success:^(NSInteger code) {
        if (code < 0) {
            return ;
        }
        NSArray *actionArr = code==1 ? @[@"举报", @"解禁", @"取消"] : @[@"举报", @"禁言", @"取消"];
        [self showActionSheet:actionArr userId:userId];
    }];
}

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

#pragma mark tool
-(void)handleMaybeWantAsHost {
    //1.过滤 不想成为主持人
    if (!self.wantAsHost) {
        return;
    }
    
    //2.自己不是主持人, 请求一次
    if(![self checkIsCurrentHost]){
        [self requestAsHost:YES];
    }
    
    //3.改变状态
    self.wantAsHost = NO;
}

#pragma mark - jump
-(void)tryPushToGameRoomVC {
    WS(weakSelf)
    [[KKLiveStudioRtcMgr shareInstance] requestLeaveStudio:self.studioId success:^{
        [weakSelf pushToGameRoomVC];
    }];
}

- (void)pushToGameRoomVC {

    KKLiveStudioGameRoomSimpleModel *model = self.selectedGameRoomSimpleModel;
    NSString *gameRoomId = model.gameRoomId;
    NSString *gameBoardId = model.gameBoardId;
    NSString *cardId = self.selectedCardId;
    
    //1.push推出gameRoomVC
    [KKGameRoomOwnerController sharedInstance].gameProfilesIdStr = cardId;
    [KKGameRoomOwnerController sharedInstance].gameRoomId = [gameRoomId integerValue];
    [KKGameRoomOwnerController sharedInstance].gameBoardIdStr = gameBoardId;
    [KKGameRoomOwnerController sharedInstance].groupIdStr = self.studioId;
    [self.navigationController pushViewController:[KKGameRoomOwnerController sharedInstance] animated:YES];
    
    //2.改变navi的vcs
    NSMutableArray *mArr = [NSMutableArray array];
    NSArray *vcArr = self.navigationController.viewControllers;
    for (NSInteger i=0; i<vcArr.count; i++) {
        UIViewController *tempVC = [vcArr objectAtIndex:i];
        //不添加self
        if (![tempVC isKindOfClass:[KKLiveStudioVC class]]) {
           [mArr addObject:tempVC];
        }
    }
    //替换
    [self.navigationController setViewControllers:mArr animated:NO];
    
    //3.销毁self
    [self remove];
}

/// 进入添加名片
- (void)pushAddCardVC {
    KKAddMyCardViewController *vc = [[KKAddMyCardViewController alloc] init];
    vc.isEdit = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)naviPopAction:(BOOL)isPop {
    
    //1.
    if (isPop) {
        [KKFloatViewMgr shareInstance].hiddenFloatView = NO;
        [self setFloatViewInfo:YES];
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
                //添加VC 除了self和KKLiveStudioHostEnterVC
                if ([tempVC isKindOfClass:[KKLiveStudioHostEnterVC class]] ||
                    [tempVC isEqual:self]) {
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
        if ([vc isMemberOfClass:[KKVoiceRoomVC class]]) {
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
    [[KKRtcService shareInstance] setMuteAllVoice:NO];
    [[KKRtcService shareInstance] setMicrophoneDisable:YES];
    [[KKRtcService shareInstance] setRTCRoomDelegate:self];
    [[KKRtcService shareInstance] setRTCEngineDelegate:self];
}

/** 移除rtc配置 */
-(void)removeRtcConfig {
    //1.关闭麦克风,喇叭
    [[KKRtcService shareInstance] setMuteAllVoice:YES];
    [[KKRtcService shareInstance] setMicrophoneDisable:YES];
    //2.取消发布
    [[KKRtcService shareInstance] unpublishCurrentUserAudioStream];
    //3.取消订阅
    [self unsubscribeRemoteUserStream:self.hostUserId];
    [self unsubscribeRemoteUserStream:self.guestUserId];
    //4.断开IM
    [self.chatRoomVC quitChatRoomSuccess:nil error:nil];
}
    

#pragma mark 麦位更新
-(void)updateMicP {
    
    //1.guest麦位状态
    self.guestMicClosed = [self.viewModel isMicPostionClosed];
    
    //2.rtc
    NSString *newHostUserId = [self.viewModel getHostUserId];
    NSString *newGuestUserId = [self.viewModel getMicUserId];
    //1.主播 (有变动才调整)
    if(![self.hostUserId isEqualToString:newHostUserId]) {
        [self unpublishAudioStream:self.hostUserId];
        [self unsubscribeRemoteUserStream:self.hostUserId];
        [self publishAudioStream:newHostUserId];
        [self subscribeRemoteUserStream:newHostUserId];
        self.hostUserId = newHostUserId;
    }
    
    //2.嘉宾
    if(![self.guestUserId isEqualToString:newGuestUserId]) {
        [self unpublishAudioStream:self.guestUserId];
        [self unsubscribeRemoteUserStream:self.guestUserId];
        [self publishAudioStream:newGuestUserId];
        [self subscribeRemoteUserStream:newGuestUserId];
        self.guestUserId = newGuestUserId;
    }
}

#pragma mark publisth/subscribe
-(void)publishAudioStream:(NSString *)userId {
    //是自己, 就布音频流
    if (userId.length > 0 && [userId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
        [[KKRtcService shareInstance] setMicrophoneDisable:!self.isMicOpen];
        [[KKRtcService shareInstance] pulishCurrentUserAudioStream];
    }
}

-(void)unpublishAudioStream:(NSString *)userId {
    //是自己, 就消发布音频流
    if (userId.length > 0 && [userId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
        self.isMicOpen = NO;
        [[KKRtcService shareInstance] unpublishCurrentUserAudioStream];
    }
}

-(void)subscribeRemoteUserStream:(NSString *)userId {
    //不是自己, 就订阅
    if (userId.length > 0 && ![userId isEqualToString:[KKUserInfoMgr shareInstance].userId]) {
        [[KKRtcService shareInstance] subscribeRemoteUserAudioStream:userId];
    }
}

-(void)unsubscribeRemoteUserStream:(NSString *)userId {
    //有人, 就取消订阅
    if (userId.length>0) {
        [[KKRtcService shareInstance] unsubscribeRemoteUserAudioStream:userId];
    }
}

#pragma mark - RongRTCRoomDelegate

-(void)didJoinUser:(RongRTCRemoteUser *)user {
    //BBLOG(@"KKLiveStudio ************************************didJoinUser userId:%@",user.userId);
    [self joinLeaveCountAdd:YES];
   
}

-(void)didLeaveUser:(RongRTCRemoteUser *)user {
    //BBLOG(@"KKLiveStudio ************************************didLeaveUser userId:%@",user.userId);
    [self joinLeaveCountAdd:NO];
}

- (void)didReportFirstKeyframe:(RongRTCAVInputStream *)stream {
    //BBLOG(@"\n\n KKLiveStudio ************************************didReportFirstKeyframe userId:%@ streamID:%@ \n",stream.userId,stream.userId);
}


- (void)didUnpublishStreams:(NSArray<RongRTCAVInputStream *>*)streams {
    //BBLOG(@"\n\n KKLiveStudio ************************************didUnpublishStreams userId:%@  \n",streams.firstObject.userId);
    NSString *pUserId = streams.firstObject.userId;
    [self unsubscribeRemoteUserStream:pUserId];
}

- (void)didPublishStreams:(NSArray <RongRTCAVInputStream *>*)streams {
    //BBLOG(@"\n\n KKLiveStudio ************************************didPublishStreams userId:%@ \n ",streams.firstObject.userId);
    
    NSString *pUserId = streams.firstObject.userId;
    [self subscribeRemoteUserStream:pUserId];
}


- (void)didConnectToStream:(RongRTCAVInputStream *)stream {
    //BBLOG(@"\n\n KKLiveStudio ************************************didConnectToStream userId:%@ streamID:%@  \n",stream.userId,stream.userId);
    NSString *pUserId = stream.userId;
    [self subscribeRemoteUserStream:pUserId];
}

/** 接收到其他人发送到 room 里的消息 */
- (void)didReceiveMessage:(RCMessage *)message {
    //BBLOG(@"\n\n KKLiveStudio ************************************didReceiveMessage:%@ \n",message.content);
}

/** 音频状态改变
 @param stream 流信息
 @param mute 当前流是否可用
 */
-(void)stream:(RongRTCAVInputStream *)stream didAudioMute:(BOOL)mute {
    
    //BBLOG(@"\n\n KKLiveStudio ************************************didAudioMute stream:%@ didAudioMute:%d \n",stream.userId, mute);
}

#pragma mark RongRTCActivityMonitorDelegate
-(void)didReportStatForm:(RongRTCStatisticalForm *)form {
    //1.发送
    //是主播才用处理发送(目前只有主播麦位有动态效果)
    if([self checkIsCurrentHost]){
        for(RongRTCStreamStat *streamStat in form.sendStats){
            //只处理音频
            if ([streamStat.mediaType isEqualToString:RongRTCMediaTypeAudio]) {
                [self updateMicPositionSpeaking:streamStat.trackId audioLevel:streamStat.audioLevel];
            }
        }
    }
    
    //2.接收
    for(RongRTCStreamStat *streamStat in form.recvStats){
        //只处理音频
        if ([streamStat.mediaType isEqualToString:RongRTCMediaTypeAudio]) {
             [self updateMicPositionSpeaking:streamStat.trackId audioLevel:streamStat.audioLevel];
        }
    }
}

@end
