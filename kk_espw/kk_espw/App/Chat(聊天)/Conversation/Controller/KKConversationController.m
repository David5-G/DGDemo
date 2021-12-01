//
//  KKConversationController.m
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/5.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKConversationController.h"
#import <IMUIKit/UIImage+TUKIT.h>
#import "KKConversationSettingController.h"
#import "KKShareGameBoardViewController.h"
#import "KKGameReportController.h"
#import "KKShareVoiceRoomViewController.h"
@interface KKConversationController ()

@property (nonatomic, strong) id extra;
@property (nonatomic, strong) KKConversation *conversation;

@end

@implementation KKConversationController

- (instancetype)initWithConversation:(KKConversation *)conversation extra:(nullable id)extra {
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _conversation = conversation;
        _extra = extra;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameCardReprotDid:) name:IMKitNotification_IMTippedGameCardReport object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[KKFloatViewMgr shareInstance] hiddenLiveStudioFloatView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gameLinkedDidTipped:) name:IMKitNotification_IMTippedGameLinkedWithSkipGameBoard object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[KKFloatViewMgr shareInstance] notHiddenLiveStudioFloatView];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)setupViews {
    KKUIChatController *uiController = [[KKUIChatController alloc] initWithConversation:_conversation extra:_extra];
    [self.view addSubview:uiController.view];
    [self addChildViewController:uiController];
    
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:_conversation.conversationTitle];
    
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setImage:[UIImage tk_imageNamed:@"im_message_nav_setting"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(settingButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:settingButton];
    [settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.naviBar).mas_offset(-20);
        make.size.mas_equalTo(CGSizeMake(22, 20));
        make.centerY.equalTo(self.naviBar.titleLabel);
    }];
}

- (void)gameLinkedDidTipped:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    NSString *gameId = [userInfo objectForKey:@"gameId"];
    NSString *shareUserId = [userInfo objectForKey:@"shareUserId"];
    NSString *gameType = [userInfo objectForKey:@"gameType"];

    if ([gameType isEqualToString:@"voiceRoomType"]) {
        KKShareVoiceRoomViewController *vc = [[KKShareVoiceRoomViewController alloc] init];
        vc.roomId = gameId;
        vc.shareUserId = shareUserId;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        KKShareGameBoardViewController *gameBoardViewController = [[KKShareGameBoardViewController alloc] init];
        gameBoardViewController.gameBoradId = gameId;
        gameBoardViewController.shareUserId = shareUserId;
        [self.navigationController pushViewController:gameBoardViewController animated:YES];
    }
}

- (void)gameCardReprotDid:(NSNotification *)notification {
    KKGameReportController *gameCardReprotController = [[KKGameReportController alloc] init];
    NSString *targetId = notification.object;
    gameCardReprotController.complaintObjectId = targetId;
    gameCardReprotController.userId = targetId;
    [self.navigationController pushViewController:gameCardReprotController animated:YES];
}

- (void)settingButtonDidTipped:(UIButton *)sender {
    KKConversationSettingController *settingController = [[KKConversationSettingController alloc] init];
    settingController.conversation = self.conversation;
    [self.navigationController pushViewController:settingController animated:YES];
}

- (void)dealloc {
}
@end
