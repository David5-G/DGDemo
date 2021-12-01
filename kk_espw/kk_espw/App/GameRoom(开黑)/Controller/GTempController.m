//
//  GTempController.m
//  kk_espw
//
//  Created by hsd on 2019/7/18.
//  Copyright © 2019 david. All rights reserved.
//

#import "GTempController.h"
#import "KKCreateGameRoomController.h"

@interface GTempController ()

@end

@implementation GTempController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    
    CC_Button *btn = [[CC_Button alloc] init];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn setTitle:@"这是一个按钮" forState:UIControlStateNormal];
    [btn setTitleColor:KKES_COLOR_HEX(0xffffff) forState:UIControlStateNormal];
    [btn cc_setBackgroundColor:KKES_COLOR_HEX(0xD2A54D) forState:UIControlStateNormal];
    [btn cc_setBackgroundColor:KKES_COLOR_HEX(0xADADAD) forState:UIControlStateHighlighted];
    [btn addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        KKCreateGameRoomController *vc = [[KKCreateGameRoomController alloc] init];
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
}



@end
