//
//  KKShareVoiceRoomViewController.m
//  kk_espw
//
//  Created by jingtian9 on 2019/10/17.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKShareVoiceRoomViewController.h"
#import "KKShareVoiceRoomView.h"
#import "KKShareVoiceRoomService.h"
#import "KKVoiceRoomModel.h"
#import "KKShareGameInfo.h"
#import "KKCalculateTextWidthOrHeight.h"
#import "KKVoiceRoomViewModel.h"
#import "KKHomeVoiceRoomModel.h"
#import "KKVoiceRoomVC.h"
#import "KKVoiceRoomRtcMgr.h"
@interface KKShareVoiceRoomViewController ()<CatDefaultPopDelegate>
@property (nonatomic, strong) UIImageView *bgView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nickL;
@property (nonatomic, strong) UIImageView *sexImageView;
@property (nonatomic, strong) KKShareVoiceRoomView *voiceRoomView;
@property (nonatomic, strong) KKHomeVoiceRoomModel *currentVoiceRoomModel;
@property (nonatomic, strong) KKShareGameInfo *shareInfo;
@property (nonatomic, strong) CatDefaultPop *alertExitGameBoardWithVoice; // 语音房
@property (nonatomic, strong) CatDefaultPop *alertExitLiveStudioWithVoice;
@property (nonatomic, strong) CatDefaultPop *alertExitVoiceRoomWithVoice;
@end

@implementation KKShareVoiceRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavUI];
    [self setUI];
    
    [self requestShareVoiceRoomData];
}

#pragma mark - UI
- (void)setNavUI {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"KK电竞"];
}

/// 进入这个语音房, 将退出当前开黑房
- (void)showAlertExitGameBoardWithVoiceRoom {
    self.alertExitGameBoardWithVoice = [[CatDefaultPop alloc] initWithTitle:@"是否进入?" content:@"进入这个语音房, 将退出当前开黑房?" cancelTitle:@"取消" confirmTitle:@"确定"];
    self.alertExitGameBoardWithVoice.delegate = self;
    [self.alertExitGameBoardWithVoice popUpCatDefaultPopView];
    self.alertExitGameBoardWithVoice.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    [self.alertExitGameBoardWithVoice updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
}

/// 进入这个语音房, 将退出当前招募厅
- (void)showAlertExitLiveStudioWithVoiceRoom {
    self.alertExitLiveStudioWithVoice = [[CatDefaultPop alloc] initWithTitle:@"是否进入?" content:@"进入这个语音房, 将退出招募厅?" cancelTitle:@"取消" confirmTitle:@"确定"];
    self.alertExitLiveStudioWithVoice.delegate = self;
    [self.alertExitLiveStudioWithVoice popUpCatDefaultPopView];
    self.alertExitLiveStudioWithVoice.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    [self.alertExitLiveStudioWithVoice updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
}

/// 进入这个语音房, 将退出上一个语音房
- (void)showAlertExitVoiceWithVoiceRoom {
    self.alertExitVoiceRoomWithVoice = [[CatDefaultPop alloc] initWithTitle:@"是否进入?" content:@"进入这个语音房, 将退出上一个语音房?" cancelTitle:@"取消" confirmTitle:@"确定"];
    self.alertExitVoiceRoomWithVoice.delegate = self;
    [self.alertExitVoiceRoomWithVoice popUpCatDefaultPopView];
    self.alertExitVoiceRoomWithVoice.popView.contentLb.textAlignment = NSTextAlignmentCenter;
    [self.alertExitVoiceRoomWithVoice updateCancelColor:KKES_COLOR_GRAY_TEXT confirmColor:KKES_COLOR_MAIN_YELLOW];
}

- (void)setUI {
    _bgView = New(UIImageView);
    _bgView.left = 0;
    _bgView.top = STATUSBAR_ADD_NAVIGATIONBARHEIGHT;
    _bgView.size = CGSizeMake(SCREEN_WIDTH, RH(150));
    _bgView.image = Img(@"share_room_bg_jt");
    [self.view addSubview:_bgView];
    
    _headerImageView = New(UIImageView);
    _headerImageView.centerX = self.view.centerX - RH(38.5);
    _headerImageView.top = _bgView.top + RH(111);
    _headerImageView.size = CGSizeMake(RH(77), RH(77));
    _headerImageView.clipsToBounds = YES;
    _headerImageView.layer.cornerRadius = RH(38.5);
    _headerImageView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerImageView];
    
    _nickL = New(UILabel);
    _nickL.top = _headerImageView.bottom + RH(10);
    _nickL.height = RH(20);
    _nickL.text = @"张楚岚";
    _nickL.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:RH(17)];
    _nickL.textColor = KKES_COLOR_BLACK_TEXT;
    [self.view addSubview:_nickL];
    
    _sexImageView = New(UIImageView);
    _sexImageView.top = _nickL.top + RH(6);
    [self.view addSubview:_sexImageView];
    
    UILabel *title = New(UILabel);
    title.left = 0;
    title.top = _nickL.bottom + RH(50);
    title.size = CGSizeMake(SCREEN_WIDTH, 14);
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:RH(15)];
    title.textColor = KKES_COLOR_DARK_GRAY_TEXT;
    title.text = @"邀请你加入语音";
    [self.view addSubview:title];
    
    UIImageView *down = New(UIImageView);
    down.left = RH(182);
    down.top = RH(11) + title.bottom;
    down.size = CGSizeMake(RH(13), RH(13));
    down.image = Img(@"share_room_down_jt");
    [self.view addSubview:down];
    WS(weakSelf)
    _voiceRoomView = [[KKShareVoiceRoomView alloc] initWithFrame:CGRectMake(RH(15), down.bottom + RH(18), SCREEN_WIDTH - RH(30), RH(139))];
    [self.view addSubview:_voiceRoomView];
    
    UIButton *join = [UIButton buttonWithType:UIButtonTypeCustom];
    join.left = RH(52);
    join.top = _voiceRoomView.bottom + RH(20);
    join.size = CGSizeMake(SCREEN_WIDTH - RH(104), RH(45));
    join.backgroundColor = [UIColor whiteColor];
    join.layer.borderWidth = 1;
    join.layer.borderColor = [UIColor colorWithRed:236/255.0 green:193/255.0 blue:101/255.0 alpha:1.0].CGColor;
    join.layer.cornerRadius = 22.5;
    [join setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    join.backgroundColor = KKES_COLOR_MAIN_YELLOW;
    [join setTitle:@"立即加入" forState:UIControlStateNormal];
    [self.view addSubview:join];
    [join addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        if (![KKUserInfoMgr isLogin]) {
            [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            
            return ;
        }
        if (!weakSelf.currentVoiceRoomModel.channelId) {
            [CC_Notice show:@"语音房信息获取失败!"];
            return ;
        }
        [weakSelf pushToVoiceVC:weakSelf.roomId.integerValue channelId:weakSelf.currentVoiceRoomModel.channelId];
    }];
    
    UIButton *toHomeVC = [UIButton buttonWithType:UIButtonTypeCustom];
    toHomeVC.left = RH(52);
    toHomeVC.top = join.bottom + RH(25);
    toHomeVC.size = CGSizeMake(SCREEN_WIDTH - RH(104), RH(45));
    toHomeVC.backgroundColor = [UIColor whiteColor];
    toHomeVC.layer.borderWidth = 1;
    toHomeVC.layer.borderColor = [UIColor colorWithRed:236/255.0 green:193/255.0 blue:101/255.0 alpha:1.0].CGColor;
    toHomeVC.layer.cornerRadius = 22.5;
    [toHomeVC setTitleColor:KKES_COLOR_MAIN_YELLOW forState:UIControlStateNormal];
    [toHomeVC setTitle:@"去首页看看" forState:UIControlStateNormal];
    [self.view addSubview:toHomeVC];
    [toHomeVC addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        self.navigationController.tabBarController.selectedIndex = 0;
        [weakSelf.navigationController popToRootViewControllerAnimated:YES];
    }];
}

#pragma mark - catDefaultPopConfirm
- (void)catDefaultPopConfirm:(CatDefaultPop*)defaultPop{
    WS(weakSelf)
    [[KKVoiceRoomRtcMgr shareInstance] checkRoomStatus:self.currentVoiceRoomModel.ID success:^{
        
        if (defaultPop == self.alertExitLiveStudioWithVoice) { /// 离开招募厅, 在进入语音房
            [[KKFloatViewMgr shareInstance] tryToLeaveLiveStudio:^{
                [weakSelf jumpVoiceVCWithRoomId:weakSelf.currentVoiceRoomModel.ID.integerValue channelId:weakSelf.currentVoiceRoomModel.channelId];
            }];
        }else if (defaultPop == self.alertExitGameBoardWithVoice) { /// 离开开黑房, 在进入语音房
            [[KKFloatViewMgr shareInstance] tryToLeaveGameRoom:^{
                [weakSelf jumpVoiceVCWithRoomId:weakSelf.currentVoiceRoomModel.ID.integerValue channelId:weakSelf.currentVoiceRoomModel.channelId];
            }];
        }else if (defaultPop == self.alertExitVoiceRoomWithVoice) { /// 离开旧, 在进入新语音房
            [[KKFloatViewMgr shareInstance] tryLeaveVoiceRoom:^{
                [weakSelf jumpVoiceVCWithRoomId:weakSelf.currentVoiceRoomModel.ID.integerValue channelId:weakSelf.currentVoiceRoomModel.channelId];
            }];
        }
    }];
}

#pragma mark - Net
- (void)requestShareVoiceRoomData {
    WS(weakSelf)
    [KKShareVoiceRoomService requestShareRoomDataWithShareId:self.shareUserId roomId:self.roomId Success:^(KKShareGameInfo * _Nonnull shareInfo, KKHomeVoiceRoomModel * _Nonnull roomModel) {
        weakSelf.voiceRoomView.model = roomModel;
        weakSelf.currentVoiceRoomModel = roomModel;
        weakSelf.shareInfo = shareInfo;
        [weakSelf.headerImageView sd_setImageWithURL:Url(shareInfo.shareUserLogoUrl)];
        weakSelf.nickL.width = [KKCalculateTextWidthOrHeight getWidthWithAttributedText:shareInfo.shareUserLoginName font:[KKFont pingfangFontStyle:PFFontStyleSemibold size:RH(17)] height:RH(15)];
        weakSelf.nickL.left = SCREEN_WIDTH / 2 - weakSelf.nickL.width / 2;
        weakSelf.nickL.text = shareInfo.shareUserLoginName;
        weakSelf.sexImageView.left = weakSelf.nickL.right + RH(5);
        if ([shareInfo.shareUserSex.name isEqualToString:@"F"]) {
            weakSelf.sexImageView.image = Img(@"home_female_pink");
            weakSelf.sexImageView.size = CGSizeMake(RH(10), RH(10));
        }else {
            weakSelf.sexImageView.image = Img(@"home_male_blue");
            weakSelf.sexImageView.size = CGSizeMake(RH(10), RH(10));
        }
    } Fail:^{
        
    }];
}

/// 进入语音房
- (void)pushToVoiceVC:(NSInteger)roomId channelId:(NSString *)channelId{
    NSString *roomIdStr = [NSString stringWithFormat:@"%ld", roomId];

    [[KKVoiceRoomRtcMgr shareInstance] checkRoomStatus:roomIdStr success:^{
        
        if ([self.currentVoiceRoomModel.roomStatus.name isEqualToString:@"close"]) {
            [CC_Notice show:@"房间已关闭"];
            return;
        }
        
        if ([KKFloatViewMgr shareInstance].gameRoomModel.gameRoomId > 0) {
            //1. 进入语音房, 将退出开黑房
            [self showAlertExitGameBoardWithVoiceRoom];
            return;
        }
        
        if ([KKFloatViewMgr shareInstance].liveStudioModel.studioId.length != 0) {
            //2. 进入语音房, 将退出招募厅
            [self showAlertExitLiveStudioWithVoiceRoom];
            return;
        }
        
        if ([KKFloatViewMgr shareInstance].voiceRoomModel.roomId > 0) {
            //3. 同样的语音房直接进入
            if ([KKFloatViewMgr shareInstance].voiceRoomModel.roomId == roomId) {
                [self jumpVoiceVCWithRoomId:roomId channelId:channelId];
                
                return;
            }else {
                //4. 不同的语音房, 退出上一个语音房.
                [self showAlertExitVoiceWithVoiceRoom];
                return;
            }
        }
        //5. 检测是否被踢出
        [self jumpVoiceVCWithRoomId:roomId channelId:channelId];
    }];
    
}

/// 尝试加入语音室
- (void)jumpVoiceVCWithRoomId:(NSInteger )roomId channelId:(NSString *)channelId{
    NSString *roomIdStr = [NSString stringWithFormat:@"%ld", roomId];
    //1. 检测是否被踢出
    [[KKVoiceRoomRtcMgr shareInstance] requestJoinRoom:roomIdStr channel:channelId success:^{
        KKVoiceRoomVC *vc = [KKVoiceRoomVC shareInstance];
        vc.roomId = [NSString stringWithFormat:@"%ld", roomId];
        [vc pushSelfByNavi:self.navigationController];
    }];
}
@end
