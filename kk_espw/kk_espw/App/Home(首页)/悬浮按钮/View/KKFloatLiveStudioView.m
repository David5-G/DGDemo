//
//  KKFloatLiveStudioView.m
//  kk_espw
//
//  Created by 景天 on 2019/7/24.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKFloatLiveStudioView.h"

@interface KKFloatLiveStudioView ()

@end

@implementation KKFloatLiveStudioView
static KKFloatLiveStudioView *kSuspendedView = nil;
static dispatch_once_t onceToken;
+ (instancetype)shareInstance{
    dispatch_once(&onceToken, ^{
        kSuspendedView = [[KKFloatLiveStudioView alloc] init];
    });
    return kSuspendedView;
}

- (void)showkSuspendedView {
    [KKFloatLiveStudioView shareInstance].frame = CGRectMake(SCREEN_WIDTH - RH(170), SCREEN_HEIGHT - RH(174), RH(154), RH(37));
    [[UIApplication sharedApplication].keyWindow addSubview:[KKFloatLiveStudioView shareInstance]];
}

- (void)removekSuspendedView {
    [[KKFloatLiveStudioView shareInstance] removeFromSuperview];
}

+ (void)destroyInstance {
 
    kSuspendedView = nil;
    onceToken = 0;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.18].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,6);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 8;
        self.layer.cornerRadius = RH(18.5);
        
        _headerImage = New(UIImageView);
        _headerImage.left = RH(3);
        _headerImage.top = RH(3);
        _headerImage.size = CGSizeMake(RH(30), RH(30));
        _headerImage.layer.cornerRadius = RH(15);
        _headerImage.clipsToBounds = YES;
        [self addSubview:_headerImage];
        
        _titleL = New(UILabel);
        _titleL.left = RH(3) + _headerImage.right;
        _titleL.top = RH(6);
        _titleL.size = CGSizeMake(RH(80), RH(11));
        _titleL.layer.cornerRadius = RH(15);
        _titleL.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:11];
        _titleL.textColor = [UIColor whiteColor];
        [self addSubview:_titleL];
        
        _compereL = New(UILabel);
        _compereL.left = RH(3) + _headerImage.right;
        _compereL.top = _titleL.bottom + RH(3);
        _compereL.size = CGSizeMake(RH(80), RH(11));
        _compereL.layer.cornerRadius = RH(15);
        _compereL.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:11];
        _compereL.textColor = [UIColor whiteColor];
        [self addSubview:_compereL];
        
        _closeButton = [CC_Button buttonWithType:UIButtonTypeCustom];
        _closeButton.left = RH(127);
        _closeButton.top = RH(11);
        _closeButton.size = CGSizeMake(RH(15), RH(17));
        [_closeButton setImage:Img(@"home_close_lobby") forState:UIControlStateNormal];
        WS(weakSelf)
        [_closeButton addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
            if (weakSelf.tapCloseLiveStudio) {
                weakSelf.tapCloseLiveStudio();
            }
        }];
        [self addSubview:_closeButton];
    }
    return self;
}

- (void)setTitle:(NSString *)title Name:(NSString *)name ImgUrl:(NSString *)imgUrl {
    [_headerImage sd_setImageWithURL:Url(imgUrl)];
    _titleL.text = title;
    if (name.length == 0) {
        _compereL.text = [NSString stringWithFormat:@"主持人:%@", @"暂无"];
    }else {
        _compereL.text = [NSString stringWithFormat:@"主持人:%@", name];
    }
}

@end
