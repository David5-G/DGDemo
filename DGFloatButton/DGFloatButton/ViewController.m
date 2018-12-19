//
//  ViewController.m
//  DGFloatButton
//
//  Created by david on 2018/12/19.
//  Copyright © 2018 david. All rights reserved.
//

#import "ViewController.h"
#import "DGFloatButton.h"

@interface ViewController ()
//floatButton
@property (nonatomic,strong) DGFloatButton *floatButton;
@end

@implementation ViewController
#pragma mark - lazy Load
-(DGFloatButton *)floatButton {
    if (_floatButton == nil) {
        _floatButton = [[DGFloatButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-60, self.view.frame.size.height-150, 50, 50)];
        [_floatButton setBackgroundImage:[UIImage imageNamed:@"dgfb_icon"] forState:UIControlStateNormal];
        typeof(self) __weak weakSelf = self;
        _floatButton.clickBlock = ^{
            [weakSelf showClickedNotice:@"大的floatButton"];
        };
    }
    return _floatButton;
}

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupGrayViewAndFloatButton];
    
    [self.view addSubview:self.floatButton];
}

-(void)setupGrayViewAndFloatButton {
    //1.grayView
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(20, 100, 200, 200)];
    view.clipsToBounds = YES;//加上这一行,floatBtn滑出superView就不显示了,不会遮挡别的视图
    view.backgroundColor = UIColor.lightGrayColor;
    [self.view addSubview:view];
    
    //2.floatBtn
    DGFloatButton *floatButton = [[DGFloatButton alloc]initWithFrame:CGRectMake(5, 5, 30, 30)];
    [view addSubview:floatButton];
    [floatButton setBackgroundImage:[UIImage imageNamed:@"dgfb_icon"] forState:UIControlStateNormal];
    typeof(self) __weak weakSelf = self;
    floatButton.clickBlock = ^{
        [weakSelf showClickedNotice:@"小的floatButton"];
    };
}

#pragma mark - Notice
/** 显示一个警告消息提示 */
-(void)showClickedNotice:(NSString *)msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"点击" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

@end
