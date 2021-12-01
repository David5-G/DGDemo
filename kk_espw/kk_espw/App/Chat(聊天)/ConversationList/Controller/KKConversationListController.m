//
//  KKConversationListController.m
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/5.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKConversationListController.h"
#import "KKConversationController.h"
#import <LoginKit/MLLKLoginVC.h>
#import "KKContactsController.h"
#import <IMUIKit/KKConversation.h>
#import <IMUIKit/IMUIKit.h>
#import "KKConversationListNetworkAdapter.h"
#import <IMUIKit/KKApplyCardModel.h>
#import "KKTabBadgeValueManager.h"

NSString *const conversationListCellId = @"conversationListCellId";

@interface KKConversationListController ()<KKUIConversationListControllerDelegagte>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *redLabel;

@end

@implementation KKConversationListController

- (void)viewDidLoad {
    [super viewDidLoad];
    KKUIConversationListController *conversationListController = [[KKUIConversationListController alloc] init];
    conversationListController.delegate = self;
    [self.view addSubview:conversationListController.view];
    [self addChildViewController:conversationListController];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTabBarMessageCount:) name:IMKitNotification_IMMessageCount object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popViewDidSendMessageButton:) name:IMKitNotification_IMTippedPopViewWithSendMessage object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigations];
    
    [self fetchFriendApplyNetwork];
}

/// 获取好友申请数量
- (void)fetchFriendApplyNetwork {
    
    WS(weakSelf);
    [KKConversationListNetworkAdapter fetchFriendApplyNetwork:^(BOOL isHiddenRed) {
        weakSelf.redLabel.hidden = isHiddenRed;
    }];
}

- (void)updateTabBarMessageCount:(NSNotification *)notification {
    int unreadMessageCount = [notification.object intValue];
    [KKTabBadgeValueManager setBadgeValue:unreadMessageCount];
}

- (void)popViewDidSendMessageButton:(NSNotification *)notification {
    KKApplyCardModel *cardModel = (KKApplyCardModel *)notification.object;

    KKConversation *conversation = [[KKConversation alloc] init];
    conversation.targetId = cardModel.targetUserId;
    conversation.head = [NSString stringWithFormat:@"%@%@",cardModel.userLogoUrl,cardModel.targetUserId];
    conversation.conversationType = KKConversationType_PRIVATE;
    conversation.conversationTitle = cardModel.nickName;
    KKConversationController *controller = [[KKConversationController alloc] initWithConversation:conversation extra:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)setupNavigations {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    
    UIButton *contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactButton setImage:[UIImage imageNamed:@"imkit_message_contact"] forState:UIControlStateNormal];
    [contactButton addTarget:self action:@selector(contactButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [self.naviBar addSubview:contactButton];
    [contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.naviBar).mas_offset(-15);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.bottom.equalTo(self.naviBar);
    }];
    
    UILabel *redLabel = [[UILabel alloc] init];
    self.redLabel = redLabel;
    redLabel.hidden = YES;
    redLabel.backgroundColor = [UIColor redColor];
    redLabel.layer.cornerRadius = 4;
    redLabel.layer.masksToBounds = YES;
    [self.naviBar addSubview:redLabel];
    [redLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.equalTo(contactButton);
        make.size.mas_equalTo(CGSizeMake(8, 8));
    }];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = @"消息";
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.textColor = rgba(51, 51, 51, 1);
    messageLabel.font = [UIFont boldSystemFontOfSize:21];
    [self.naviBar addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.naviBar).mas_offset(20);
        make.centerY.equalTo(contactButton);
        make.size.mas_equalTo(CGSizeMake(50, 21));
    }];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.alpha = 1;
    lineView.backgroundColor = rgba(255, 223, 71, 1);
    lineView.layer.cornerRadius = 3;
    lineView.layer.masksToBounds = YES;
    [self.naviBar addSubview:lineView];
    [self.naviBar sendSubviewToBack:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(messageLabel);
        make.bottom.equalTo(messageLabel.mas_bottom).mas_offset(3);
        make.size.mas_equalTo(CGSizeMake(37, 6));
    }];
    
}

- (void)contactButtonDidTipped:(UIButton *)sender {
    KKContactsController *contactsController = [[KKContactsController alloc] init];
    __weak typeof(self) ws = self;
    contactsController.chatDidTippedBlock = ^(KKConversation * _Nullable conversation) {
        KKConversationController *controller = [[KKConversationController alloc] initWithConversation:conversation extra:nil];
        [ws.navigationController pushViewController:controller animated:YES];
    };
    [self.navigationController pushViewController:contactsController animated:YES];
}

- (void)conversationListController:(KKUIConversationListController *)conversationController didSelectConversation:(KKConversation *)conversation {
    
    KKConversationController *controller = [[KKConversationController alloc] initWithConversation:conversation extra:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
