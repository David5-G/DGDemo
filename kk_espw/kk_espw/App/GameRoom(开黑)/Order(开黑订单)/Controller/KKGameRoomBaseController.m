//
//  KKGameRoomBaseController.m
//  kk_espw
//
//  Created by hsd on 2019/7/18.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKGameRoomBaseController.h"
#import "KKChangeImageColorModel.h"
#import "KKGamePrepareToolView.h"
#import "KKPlayerGameCardView.h"
#import "KKLiveStudioOnlineUserView.h"
#import "KKVoiceRoomInputView.h"
@interface KKGameRoomBaseController ()

@end

@implementation KKGameRoomBaseController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = KKES_COLOR_HEX(0x100D15);
    /// 遮罩View
    UIView *shadeV = [[UIView alloc] initWithFrame:CGRectMake(0, 500, SCREEN_WIDTH, SCREEN_HEIGHT - 500)];
    shadeV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:shadeV];
    [self p_initBgLogoImageView];
    [self p_initNavView];
    [self p_initGameSuperView];
    [self p_initGameInfoViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

#pragma mark - init
- (void)p_initBgLogoImageView {
    // 背景logo
    self.gameLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 275 + STATUS_AND_NAV_BAR_HEIGHT)];
    self.gameLogoImageView.image = Img(@"game_room_background_image");
    [self.view addSubview:self.gameLogoImageView];
}

- (void)p_initNavView {
    
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, STATUS_AND_NAV_BAR_HEIGHT)];
    self.navView.layer.zPosition = 1001;
    [self.view addSubview:self.navView];
    
    self.navBackBtn = [[CC_Button alloc] init];
    self.navBackBtn.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:16];
    UIImage *sourceImg = Img(@"game_nav_back_black");
    UIImage *whiteImg = [KKChangeImageColorModel changeImageToColor:KKES_COLOR_HEX(0xFFFFFF) sourceImage:sourceImg];
    [self.navBackBtn setImage:whiteImg forState:UIControlStateNormal];
    [self.navBackBtn setTitleColor:KKES_COLOR_HEX(0xFFFFFF) forState:UIControlStateNormal];
    [self.navBackBtn setTitleColor:KKES_COLOR_HEX(0x929292) forState:UIControlStateHighlighted];
    [self.navBackBtn addTarget:self action:@selector(p_clickNavBackButton) forControlEvents:UIControlEventTouchUpInside];
    [self.navView addSubview:self.navBackBtn];
    [self.navBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.navView).mas_offset(10);
        make.top.mas_equalTo(self.navView).mas_offset(STATUS_BAR_HEIGHT);
        make.height.mas_equalTo(44);
        make.width.mas_lessThanOrEqualTo(SCREEN_WIDTH / 2 - 10);
    }];
}

- (void)p_initGameSuperView {
    
    // 滚动视图
    CGRect frame = CGRectMake(0, STATUS_AND_NAV_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_AND_NAV_BAR_HEIGHT);
    self.backgroundScrollView = [[KKGameScrollView alloc] initWithFrame:frame];
    self.backgroundScrollView.showsVerticalScrollIndicator = NO;
    self.backgroundScrollView.showsHorizontalScrollIndicator = NO;
    self.backgroundScrollView.delaysContentTouches = NO;
    self.backgroundScrollView.contentSize = frame.size;
    self.backgroundScrollView.touchDelegate = self;
    if (@available(iOS 11.0, *)) {
        [self.backgroundScrollView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    [self.view addSubview:self.backgroundScrollView];
    
    CGRect bounds = frame;
    bounds.origin.y = 0;
    
    // 占位View, UICollectionView 直接放在 UIScrollView 上, masonry 会失效
    self.gameSuperView = [[UIView alloc] initWithFrame:bounds];
    [self.backgroundScrollView addSubview:self.gameSuperView];
}

- (void)p_initNavRightView {
    
    self.navCloseBtn = [[CC_Button alloc] init];
    [self.navCloseBtn setImage:Img(@"icon_close_white") forState:UIControlStateNormal];
    [self.navCloseBtn setImageEdgeInsets:UIEdgeInsetsMake(3.5, 5, 3.5, 5)];
    [self.navView addSubview:self.navCloseBtn];
    [self.navCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(27);
        make.height.mas_equalTo(26);
        make.right.mas_equalTo(self.navView).mas_offset(-12);
        make.top.mas_equalTo(self.navView).mas_offset(STATUS_BAR_HEIGHT + 8.5);
    }];
    
    self.studioOnlineUserView = [[KKLiveStudioOnlineUserView alloc] init];
    [self.studioOnlineUserView setOnlineUserCountViewBackgroundColor:rgba(59, 56, 62, 0.8)];
    [self.navView addSubview:self.studioOnlineUserView];
    [self.studioOnlineUserView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.navCloseBtn.mas_left).mas_offset(-2);
        make.centerY.mas_equalTo(self.navCloseBtn);
        make.height.mas_equalTo(NAV_BAR_HEIGHT);
        make.width.mas_equalTo([ccui getRH:130]);
    }];
    
    WS(weakSelf)
    [self.navCloseBtn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        [weakSelf p_clickNavCloseButton];
    }];
    [self.studioOnlineUserView addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        // 点击了在线列表
        [weakSelf p_clickStudioOnlineView];
    }];
}

- (void)p_initGameInfoViews {
    
    self.seperateLogoImageView = [[UIImageView alloc] init];
    self.seperateLogoImageView.image = Img(@"game_seperate_logo");
    [self.gameSuperView addSubview:self.seperateLogoImageView];
    [self.seperateLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.gameSuperView).mas_offset(32);
        make.top.mas_equalTo(self.gameSuperView).mas_offset(46);
        make.width.mas_equalTo(144);
        make.height.mas_equalTo(9);
    }];
    
    self.playerLevelLabel = [[UILabel alloc] init];
    self.playerLevelLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:17];
    self.playerLevelLabel.textColor = KKES_COLOR_HEX(0xD2A54D);
    self.playerLevelLabel.textAlignment = NSTextAlignmentCenter;
    //self.playerLevelLabel.text = @"大区微信黄金段位";
    [self.gameSuperView addSubview:self.playerLevelLabel];
    [self.playerLevelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.seperateLogoImageView);
        make.bottom.mas_equalTo(self.seperateLogoImageView.mas_top).mas_offset(-3);
        make.height.mas_equalTo(20);
    }];
    
    self.playerNumberLabel = [[UILabel alloc] init];
    self.playerNumberLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:17];
    self.playerNumberLabel.textColor = KKES_COLOR_HEX(0xFFFFFF);
    self.playerNumberLabel.textAlignment = NSTextAlignmentCenter;
    //self.playerNumberLabel.text = @"五人模式";
    [self.gameSuperView addSubview:self.playerNumberLabel];
    [self.playerNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.seperateLogoImageView);
        make.top.mas_equalTo(self.seperateLogoImageView.mas_bottom).mas_offset(3);
        make.height.mas_equalTo(20);
    }];
    
    self.chargeLabel = [[UILabel alloc] init];
    self.chargeLabel.layer.cornerRadius = 1;
    self.chargeLabel.layer.masksToBounds = YES;
    self.chargeLabel.backgroundColor = RGBA(255, 255, 255, 0.5);
    self.chargeLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:11];
    self.chargeLabel.textAlignment = NSTextAlignmentCenter;
    self.chargeLabel.textColor = KKES_COLOR_HEX(0xFFFFFF);
    //self.chargeLabel.text = @"收费";
    [self.gameSuperView addSubview:self.chargeLabel];
    [self.chargeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.playerLevelLabel.mas_right).mas_offset(8);
        make.centerY.mas_equalTo(self.playerLevelLabel);
        make.height.mas_equalTo(16);
        make.width.mas_equalTo(36);
    }];
    
    self.rightGameLogoImageView = [[UIImageView alloc] init];
    [self.gameSuperView addSubview:self.rightGameLogoImageView];
    [self.rightGameLogoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gameSuperView).mas_offset(3);
        make.right.mas_equalTo(self.gameSuperView).mas_offset(-15);
        make.width.mas_equalTo(110);
        make.height.mas_equalTo(140);
    }];
    
    self.gameStateLabel = [[UILabel alloc] init];
    self.gameStateLabel.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:12];
    self.gameStateLabel.textColor = KKES_COLOR_HEX(0xECC165);
    //self.gameStateLabel.text = @"待开始";
    self.gameStateLabel.textAlignment = NSTextAlignmentRight;
    [self.gameSuperView addSubview:self.gameStateLabel];
    [self.gameStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.gameSuperView).mas_offset(-14);
        make.top.mas_equalTo(self.gameSuperView).mas_offset(9);
        make.height.mas_equalTo(14);
    }];
}

- (void)p_initPlayerListView {
    
    CGFloat itemSpace = 5;
    CGFloat horizontalInset = 19;
    CGFloat width = (SCREEN_WIDTH - horizontalInset * 2 - itemSpace * 4) / 5;
    CGFloat height = 175;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = itemSpace;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, horizontalInset, 0, horizontalInset);
    layout.itemSize = CGSizeMake(width, height);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.playerListView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.playerListView.delegate = self;
    self.playerListView.dataSource = self;
    self.playerListView.showsVerticalScrollIndicator = NO;
    self.playerListView.showsHorizontalScrollIndicator = NO;
    self.playerListView.delaysContentTouches = NO;
    self.playerListView.backgroundColor = [UIColor clearColor];
    
    // 注册cell
    [self.playerListView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
    
    [self.gameSuperView addSubview:self.playerListView];
    [self.playerListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.gameSuperView);
        make.top.mas_equalTo(self.playerNumberLabel.mas_bottom).mas_offset(22);
        make.height.mas_equalTo(height);
    }];
}

- (void)p_initPrepareView {
    self.prepareToolView = [[KKGamePrepareToolView alloc] init];
    self.prepareToolView.layer.shadowColor = RGBA(21, 17, 22, 0.09).CGColor;
    self.prepareToolView.layer.shadowOffset = CGSizeMake(0, 4);
    self.prepareToolView.layer.shadowOpacity = 1;
    self.prepareToolView.layer.cornerRadius = 6;
    [self.gameSuperView addSubview:self.prepareToolView];
    [self.prepareToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.gameSuperView);
        make.top.mas_equalTo(self.playerListView.mas_bottom).mas_offset(0);
        make.height.mas_equalTo(58);
    }];
}

- (void)p_initChatToolView {
    CGFloat safeHeight = 0;
    if (@available(iOS 11.0, *)) {
        safeHeight = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    }

    CGFloat height = 48 + safeHeight;
    self.chatToolView = [[KKVoiceRoomInputView alloc]initWithFrame:CGRectMake(0, self.view.height - height - STATUS_AND_NAV_BAR_HEIGHT, self.view.width, height - safeHeight)];
    self.chatToolView.rightToolButtons = @[KKInputViewToolButtonSpeaker,KKInputViewToolButtonMic,KKInputViewToolButtonShare];
    self.chatToolView.themeStyle = KKInputViewThemeStyleDefault;
    [self.gameSuperView addSubview:self.chatToolView];
}

#pragma mark - Action
- (void)p_clickNavBackButton {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)p_clickNavCloseButton {
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)p_clickStudioOnlineView {
    
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    cell.backgroundColor = KKES_COLOR_HEX(0xFFFFFF);
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - didReceiveMemoryWarning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
