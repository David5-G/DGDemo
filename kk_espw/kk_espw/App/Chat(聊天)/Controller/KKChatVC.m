//
//  KKChatVC.m
//  kk_espw
//
//  Created by david on 2019/7/5.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatVC.h"

@interface KKChatVC ()

@end

@implementation KKChatVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavi];
    [self setupUI];
}

#pragma mark - UI
-(void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"聊天"];
}

-(void)setupUI {
    
}

@end
