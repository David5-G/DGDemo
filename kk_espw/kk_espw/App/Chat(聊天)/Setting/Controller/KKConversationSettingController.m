//
//  KKConversationSettingController.m
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/29.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKConversationSettingController.h"
#import "KKConversationSettingChatRecordCell.h"
#import "KKConversationSettingInfoCell.h"
#import "KKConversationSettingOtherCell.h"
#import "KKConversationSettingNetworkAdapter.h"
#import "KKChatSearchHistoryMsgVC.h"

NSString *const conversationSettingChatRecordCellId = @"conversationSettingChatRecordCellId";
NSString *const conversationSettingInfoCellId = @"conversationSettingInfoCellId";
NSString *const conversationSettingOtherCellId = @"conversationSettingOtherCellId";

@interface KKConversationSettingController ()<UITableViewDelegate, UITableViewDataSource,KKConversationSettingOtherCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, copy) NSArray<NSArray<NSString *> *> *infoArray;

@end

@implementation KKConversationSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    
    _infoArray = @[@[@""],@[@"查看聊天记录"],@[@"消息免打扰",@"会话置顶",@"清除聊天记录"]];
    
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"聊天详情"];
}

- (void)setupViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CC_STATUS_AND_NAV_BAR_HEIGHT, CC_SCREEN_WIDTH, CC_SCREEN_HEIGHT - CC_STATUS_AND_NAV_BAR_HEIGHT)];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = rgba(246, 247, 249, 1);
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[KKConversationSettingChatRecordCell class] forCellReuseIdentifier:conversationSettingChatRecordCellId];
    [_tableView registerClass:[KKConversationSettingInfoCell class] forCellReuseIdentifier:conversationSettingInfoCellId];
    [_tableView registerClass:[KKConversationSettingOtherCell class] forCellReuseIdentifier:conversationSettingOtherCellId];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    // 注释
}

// MARK: - KKConversationSettingOtherCellDelegate

/// 消息免打扰
- (void)conversationIsNoTrouble:(BOOL)isNoTrouble {
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_PRIVATE targetId:_conversation.targetId isBlocked:isNoTrouble success:^(RCConversationNotificationStatus nStatus) {
        self.conversation.isNoTrouble = isNoTrouble;
    } error:^(RCErrorCode status) {
        
    }];
}

/// 会话置顶
- (void)conversationIsTop:(BOOL)isTop {
    [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_PRIVATE targetId:_conversation.targetId isTop:isTop];
}

// MARK: - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _infoArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _infoArray[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        KKConversationSettingInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:conversationSettingInfoCellId];
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        infoCell.conversation = self.conversation;
        return infoCell;
    } else if (indexPath.section == 1) {
        KKConversationSettingChatRecordCell *chatRecordCell = [tableView dequeueReusableCellWithIdentifier:conversationSettingChatRecordCellId];
        chatRecordCell.info = self.infoArray[indexPath.section][indexPath.row];
        chatRecordCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return chatRecordCell;
    } else {
        KKConversationSettingOtherCell *otherCell = [tableView dequeueReusableCellWithIdentifier:conversationSettingOtherCellId];
        otherCell.delegate = self;
        otherCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [otherCell setupUI:self.infoArray[indexPath.section][indexPath.row] withIndex:indexPath andConversation:self.conversation];
        return otherCell;
    }
}

// MARK: - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 2) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否清除聊天记录" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
           [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_PRIVATE targetId:self.conversation.targetId];
            [[NSNotificationCenter defaultCenter] postNotificationName:IMKitNotification_IMClearConversationMessages object:nil];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        [alertC addAction:action];
        
        [alertC addAction:action2];
        [self presentViewController:alertC animated:YES completion:nil];
    }
    
    if (indexPath.section == 1) {
        KKChatSearchHistoryMsgVC *vc = [[KKChatSearchHistoryMsgVC alloc] init];
        vc.conversationType = ConversationType_PRIVATE;
        vc.targetId = _conversation.targetId;
        vc.conversation = _conversation;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 84;
    }
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 8)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 85;
    }
    return 0.01;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
        UIButton *deleteFriendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteFriendButton addTarget:self action:@selector(deleteFriendButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
        deleteFriendButton.layer.cornerRadius = 5;
        deleteFriendButton.layer.masksToBounds = YES;
        deleteFriendButton.frame = CGRectMake(62, 42, SCREEN_WIDTH - 62*2, 43);
        [deleteFriendButton setTitle:@"删除好友" forState:UIControlStateNormal];
        deleteFriendButton.backgroundColor =rgba(236, 193, 101, 1);
        [deleteFriendButton setTitleColor:rgba(255, 255, 255, 1) forState:UIControlStateNormal];
        deleteFriendButton.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:16];
        [footerView addSubview:deleteFriendButton];
        return footerView;
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.01)];
}

- (void)deleteFriendButtonDidTipped:(UIButton *)sender {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要删除该好友吗？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self deleteFriend];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertC addAction:action];
    
    [alertC addAction:action2];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)deleteFriend {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"DELETE_FRIEND" forKey:@"service"];
    [params setValue:_conversation.targetId forKey:@"friendId"];
    [params setValue:[KKUserInfoMgr shareInstance].userId forKey:@"authedUserId"];
    
    MaskProgressHUD *HUD = [MaskProgressHUD hudStartAnimatingAndAddToView:[CC_Code getAView]];
    WS(weakSelf);
    [KKConversationSettingNetworkAdapter fetchDeleteFriendsNetwork:params currentView:self.view successHandler:^(ResModel * _Nullable model) {
        [HUD stop];
        BOOL isDeleteConversation = [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:weakSelf.conversation.targetId];
        [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_PRIVATE targetId:weakSelf.conversation.targetId];
        if (isDeleteConversation) {
            CCLOG(@"成功的删除会话");
        } else {
            CCLOG(@"失败的删除会话");
        }
        [self.navigationController popToRootViewControllerAnimated:YES];;
    } faileHandler:^(NSError * _Nullable error) {

    }];
}

@end
