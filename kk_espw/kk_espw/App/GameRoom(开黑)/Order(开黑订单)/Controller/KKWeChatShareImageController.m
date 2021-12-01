//
//  KKWeChatShareImageController.m
//  kk_espw
//
//  Created by hsd on 2019/8/13.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKWeChatShareImageController.h"
#import "KKCustomPhotoAlbum.h"
#import "KKShareTool.h"
#import <WXApi.h>

@interface KKWeChatShareImageController ()

@property (nonatomic, strong, nonnull) UILabel *saveImageLabel;
@property (nonatomic, strong, nonnull) UILabel *shareToWeChatLabel;
@property (nonatomic, strong, nonnull) CC_Button *saveImageBtn;
@property (nonatomic, strong, nonnull) CC_Button *shareBtn;
@property (nonatomic, strong, nonnull) UIImageView *mainImagView; ///< 主图片

@property (nonatomic, strong, nullable) UIImage *saveImage;

@end

@implementation KKWeChatShareImageController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"扫码进群"];
    [self initTitleLabels];
    [self initBottomButtons];
    [self initMainImageView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.imgUrl) {
        WS(weakSelf)
        [self.mainImagView sd_setImageWithURL:[NSURL URLWithString:self.imgUrl] placeholderImage:self.mainImagView.image completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            weakSelf.saveImage = image;
        }];
    }
}

- (void)initTitleLabels {
    self.saveImageLabel = [[UILabel alloc] init];
    self.saveImageLabel.textColor = KKES_COLOR_HEX(0x333333);
    self.saveImageLabel.textAlignment = NSTextAlignmentCenter;
    self.saveImageLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:13];
    self.saveImageLabel.text = @"1，保存图片，使用微信扫一扫进群";
    [self.view addSubview:self.saveImageLabel];
    [self.saveImageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(21 + STATUS_AND_NAV_BAR_HEIGHT);
        make.height.mas_equalTo(14);
    }];
    
    self.shareToWeChatLabel = [[UILabel alloc] init];
    self.shareToWeChatLabel.textColor = KKES_COLOR_HEX(0x333333);
    self.shareToWeChatLabel.textAlignment = NSTextAlignmentCenter;
    self.shareToWeChatLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:13];
    self.shareToWeChatLabel.text = @"2，分享到微信，使用微信扫码进群";
    [self.view addSubview:self.shareToWeChatLabel];
    [self.shareToWeChatLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.mas_equalTo(self.saveImageLabel);
        make.top.mas_equalTo(self.saveImageLabel.mas_bottom).mas_offset(10);
    }];
}

- (void)initBottomButtons {
    
    CGFloat lrSpace = 22;
    CGFloat insetSpace = 22;
    CGFloat width = (SCREEN_WIDTH - lrSpace * 2 - insetSpace) / 2;
    
    CGFloat safeBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeBottom = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    }
    
    self.saveImageBtn = [[CC_Button alloc] init];
    self.saveImageBtn.layer.cornerRadius = 5;
    self.saveImageBtn.layer.masksToBounds = YES;
    [self.saveImageBtn setImage:Img(@"game_wechat_saveImage") forState:UIControlStateNormal];
    [self.view addSubview:self.saveImageBtn];
    [self.saveImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(lrSpace);
        make.bottom.mas_equalTo(self.view).mas_offset(-27 - safeBottom);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(36);
    }];
    
    self.shareBtn = [[CC_Button alloc] init];
    self.shareBtn.layer.cornerRadius = 5;
    self.shareBtn.layer.masksToBounds = YES;
    [self.shareBtn setImage:Img(@"game_wechat_share") forState:UIControlStateNormal];
    [self.view addSubview:self.shareBtn];
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.view).mas_offset(-lrSpace);
        make.bottom.width.height.mas_equalTo(self.saveImageBtn);
    }];
    
    WS(weakSelf)
    [self.saveImageBtn addTappedOnceDelay:0.5 withBlock:^(UIButton *button) {
        [weakSelf saveToPhotoAlbum];
    }];
    [self.shareBtn addTappedOnceDelay:0.5 withBlock:^(UIButton *button) {
        [weakSelf shareToWeChat];
    }];
}

- (void)initMainImageView {
    self.mainImagView = [[UIImageView alloc] init];
    self.mainImagView.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:self.mainImagView];
    [self.mainImagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.shareToWeChatLabel.mas_bottom).mas_offset(19);
        make.bottom.mas_equalTo(self.saveImageBtn.mas_top).mas_offset(-35);
        make.left.mas_equalTo(self.view).mas_offset(17);
        make.right.mas_equalTo(self.view).mas_offset(-17);
    }];
}

#pragma mark - Action
- (void)saveToPhotoAlbum {
    if (!self.saveImage) {
        [CC_Notice show:@"请耐心等待图片加载完再保存" atView:self.view];
        return;
    }
    [[KKCustomPhotoAlbum shareInstance] saveImageIntoAlbum:self.saveImage withNeedReminder:YES];
}

- (void)shareToWeChat {
    if (!self.saveImage) {
        [CC_Notice show:@"请耐心等待图片加载完再操作" atView:self.view];
        return;
    }
    
    // 1. 创建多媒体消息结构体
    WXMediaMessage *mediaMsg = [WXMediaMessage message];
    
    // 2. 创建多媒体消息中包含的图片数据对象
    WXImageObject *imgObj = [WXImageObject object];
    
    // 图片数据
    imgObj.imageData = UIImageJPEGRepresentation(self.saveImage, 0.1);
    
    // 多媒体数据对象
    mediaMsg.mediaObject = imgObj;
    
    // 3. 创建d发送消息至微信的消息结构体
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    
    // 多媒体消息内容
    req.message = mediaMsg;
    
    // 指定为发送多媒体消息(不能同时发送文本和多媒体消息, 两者只能选择选其一)
    req.bText = NO;
    
    // 指定发送到聊天界面
    req.scene = WXSceneSession;
    
    // 发送请求到微信, 等待微信返回 onResp
    [WXApi sendReq:req];
}

@end
