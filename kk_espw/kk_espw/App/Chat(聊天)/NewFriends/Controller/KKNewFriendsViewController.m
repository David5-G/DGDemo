//
//  KKNewFriendsViewController.m
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/22.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKNewFriendsViewController.h"
#import <IMUIKit/IMUIKit.h>

@interface KKNewFriendsViewController ()

@end

@implementation KKNewFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    KKNewFriendsController *newFriendsController = [[KKNewFriendsController alloc] init];
    [self addChildViewController:newFriendsController];
    [self.view addSubview:newFriendsController.view];
    
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"新朋友"];
    
}

@end
