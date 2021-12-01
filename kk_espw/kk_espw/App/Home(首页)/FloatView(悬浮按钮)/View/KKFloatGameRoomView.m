//
//  KKFloatGameRoomView.m
//  kk_espw
//
//  Created by 景天 on 2019/7/24.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKFloatGameRoomView.h"
#import "KKFloatGameRoomModel.h"
@interface KKFloatGameRoomView ()
@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UILabel *compereL;
@property (nonatomic, strong) UIImageView *headerImage;
@property (nonatomic, strong) CC_Button *closeButton;
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
    [KKFloatGameRoomView shareInstance].frame = CGRectMake(SCREEN_WIDTH - RH(170), SCREEN_HEIGHT - RH(174), RH(154), RH(37));
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
        self.backgroundColor = [UIColor blackColor];
        self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.18].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,6);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 8;
        self.alpha = 0.7;
        self.layer.cornerRadius = RH(18.5);
        
        _headerImage = New(UIImageView);
        _headerImage.left = RH(3);
        _headerImage.top = RH(3);
        _headerImage.size = CGSizeMake(RH(30), RH(30));
        _headerImage.layer.cornerRadius = RH(15);
        _headerImage.clipsToBounds = YES;
        _headerImage.layer.borderColor = KKES_COLOR_MAIN_YELLOW.CGColor;
        _headerImage.layer.borderWidth = RH(3);
        [self addSubview:_headerImage];
        
        _titleL = New(UILabel);
        _titleL.left = RH(3) + _headerImage.right;
        _titleL.top = RH(6);
        _titleL.size = CGSizeMake(RH(80), RH(11));
        _titleL.layer.cornerRadius = RH(15);
        _titleL.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(12)];
        _titleL.textColor = [UIColor whiteColor];
        [self addSubview:_titleL];
        
        _compereL = New(UILabel);
        _compereL.left = RH(3) + _headerImage.right;
        _compereL.top = _titleL.bottom + RH(3);
        _compereL.size = CGSizeMake(RH(80), RH(11));
        _compereL.layer.cornerRadius = RH(15);
        _compereL.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(9)];
        _compereL.textColor = KKES_COLOR_YELLOW;
        [self addSubview:_compereL];
        
        _closeButton = [CC_Button buttonWithType:UIButtonTypeCustom];
        _closeButton.left = RH(127);
        _closeButton.top = RH(11);
        _closeButton.size = CGSizeMake(RH(15), RH(17));
        [_closeButton setImage:Img(@"home_close_lobby") forState:UIControlStateNormal];
        WS(weakSelf)
        [_closeButton addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
            if (weakSelf.tapCloseGameRoomBlock) {
                weakSelf.tapCloseGameRoomBlock();
            }
        }];
        [self addSubview:_closeButton];
    }
    return self;
}

- (void)setGameModel:(KKFloatGameRoomModel *)gameModel {
    [_headerImage sd_setImageWithURL:Url(gameModel.ownerLogoUrl) placeholderImage:Img(@"default_hostName_bg")];
    _titleL.text = @"开黑房";
    _compereL.text = @"进行中";
    _compereL.textColor = KKES_COLOR_YELLOW;
}

- (void)setVoiceModel:(KKFloatVoiceRoomModel *)voiceModel {
    _titleL.text = @"语音房";
    _compereL.text = [NSString stringWithFormat:@"房主:%@", voiceModel.ownerName];
    _compereL.textColor = [UIColor whiteColor];
    [_headerImage sd_setImageWithURL:Url(voiceModel.ownerLogoUrl) placeholderImage:Img(@"default_hostName_bg")];
}
@end
