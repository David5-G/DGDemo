//
//  KKContactsViewController.m
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/22.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKContactsViewController.h"
#import <IMUIKit/IMUIKit.h>

@interface KKContactsViewController ()

@end

@implementation KKContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    KKContactsController *contactsController = [[KKContactsController alloc] init];
    contactsController.friendsListDidTippedBlock = ^{
        
    };
    [self addChildViewController:contactsController];
    [self.view addSubview:contactsController.view];
    
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"通讯录"];
}


@end
