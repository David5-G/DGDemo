//
//  KKFloatGameRoomView.m
//  kk_espw
//
//  Created by 景天 on 2019/7/24.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKFloatGameRoomView.h"

@interface KKFloatGameRoomView ()
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *compereL;
@end

@implementation KKFloatGameRoomView

static dispatch_once_t onceToken;
static KKFloatGameRoomView *khSuspendedView = nil;
+ (instancetype)shareInstance{
    dispatch_once(&onceToken, ^{
        khSuspendedView = [[KKFloatGameRoomView alloc] init];
    });
    return khSuspendedView;
}

- (void)showKhSuspendedView {
    [KKFloatGameRoomView shareInstance].frame = CGRectMake(SCREEN_WIDTH - RH(76), SCREEN_HEIGHT - RH(254), RH(60), RH(60));
    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:[KKFloatGameRoomView shareInstance]];
}

- (void)removeKhSuspendedView{
    [[KKFloatGameRoomView shareInstance] removeFromSuperview];
}

+ (void)destroyInstance {
    khSuspendedView = nil;
    onceToken = 0;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = RH(30);
        self.backgroundColor = [UIColor blackColor];
        
        _titleL = New(UILabel);
        _titleL.left = RH(0);
        _titleL.top = RH(15);
        _titleL.size = CGSizeMake(RH(60), RH(14));
        _titleL.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:15];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.textColor = [UIColor whiteColor];
        _titleL.text = @"开黑房";
        [self addSubview:_titleL];
        
        _compereL = New(UILabel);
        _compereL.left = RH(13);
        _compereL.top = _titleL.bottom + RH(7);
        _compereL.size = CGSizeMake(RH(33), RH(10));
        _compereL.textAlignment = NSTextAlignmentCenter;
        _compereL.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:10];
        _compereL.textColor = [UIColor whiteColor];
        _compereL.text = @"进行中";
        [self addSubview:_compereL];
    }
    return self;
}

@end
