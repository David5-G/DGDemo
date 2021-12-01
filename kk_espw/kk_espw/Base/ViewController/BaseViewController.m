//
//  BaseViewController.m
//  DGTool
//
//  Created by david on 2018/12/26.
//  Copyright © 2018 david. All rights reserved.
//

#import "BaseViewController.h"
#import "KKGameRoomOwnerController.h"
#import "KKHomeVC.h"
@interface BaseViewController ()

@end

@implementation BaseViewController

#pragma mark - lazy load


#pragma mark - init
-(instancetype)init {
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
         self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    return self;
}


#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = KKES_COLOR_BG;
    
    if (@available(iOS 11.0, *)) {
        
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - statusBar
-(BOOL)prefersStatusBarHidden {
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return [self getStatusBarStyle];
}

//#pragma mark - UIInterfaceOrientationMask
//-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

/**
 获取当前显示的视图
 
 @return VC
 */
+ (UIViewController *)topController {
    
    UIViewController *topC = [self topViewController:[[UIApplication sharedApplication].keyWindow rootViewController]];
    while (topC.presentedViewController) {
        topC = [self topViewController:topC.presentedViewController];
    }
    return topC;
}

+ (UIViewController *)topViewController:(UIViewController *)controller {
    if ([controller isKindOfClass:[UINavigationController class]]) {
        return [self topViewController:[(UINavigationController *)controller topViewController]];
    } else if ([controller isKindOfClass:[UITabBarController class]]) {
        return [self topViewController:[(UITabBarController *)controller selectedViewController]];
    } else {
        return controller;
    }
}

@end
