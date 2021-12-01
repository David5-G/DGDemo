//
//  KKLiveStudioOnlineUserCell.m
//  kk_espw
//
//  Created by david on 2019/7/24.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomOnlineUserCell.h"

@interface KKChatRoomOnlineUserCell ()
{
    CGFloat _portraitHeight;
    CGFloat _nameLabelHeight;
    CGFloat _nameLabelTopSpace;
}
@property (nonatomic, strong) UIView *handleView;
@property (nonatomic, strong) UILabel *onMicLabel;
/** 标签 */
@property (nonatomic, strong) UIImageView *tagImageView;
@end

@implementation KKChatRoomOnlineUserCell


#pragma mark - life circle
  
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setDimension];
        [self setupUI];
    }
    return self;
}

#pragma mark - UI
-(void)setDimension {
    _portraitHeight = [ccui getRH:50];
    _nameLabelHeight = [ccui getRH:23];
    _nameLabelTopSpace = [ccui getRH:2];
}

-(void)setupUI {
    CGFloat leftSpace = [ccui getRH:21];
    CGFloat portraitH = _portraitHeight;
    CGFloat nameLabelTopSpace = _nameLabelTopSpace;
    CGFloat nameLabelH = _nameLabelHeight;
    CGFloat handleViewW = [ccui getRH:140];
    
    //1.头像
    UIImageView *portraitImgV = [[UIImageView alloc]init];
    self.portraitImageView = portraitImgV;
    portraitImgV.backgroundColor = UIColor.lightGrayColor;
    portraitImgV.layer.cornerRadius = portraitH/2.0;
    portraitImgV.layer.masksToBounds = YES;
    [self.contentView addSubview:portraitImgV];
    [portraitImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftSpace);
        make.centerY.mas_equalTo(0);
        make.width.height.mas_equalTo(portraitH);
    }];
    
    //2.name
    DGLabel *nameL = [DGLabel labelWithText:@"XXX" fontSize:[ccui getRH:16] color:KKES_COLOR_BLACK_TEXT];
    self.nameLabel = nameL;
    [self.contentView addSubview:nameL];
    [nameL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(portraitImgV.mas_right).mas_offset([ccui getRH:10]);
        make.top.mas_equalTo(portraitImgV.mas_top).mas_equalTo(nameLabelTopSpace);
        make.height.mas_equalTo(nameLabelH);
        make.right.mas_equalTo(-handleViewW-leftSpace);
    }];
    
    //3.tag
    UIImageView *tagImgV = [[UIImageView alloc] init];
    self.tagImageView = tagImgV;
    [self.contentView addSubview:tagImgV];
    [tagImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameL.mas_left);
        make.bottom.mas_equalTo(portraitImgV.mas_bottom).mas_offset(-[ccui getRH:8]);
        make.width.mas_equalTo([ccui getRH:42]);
        make.height.mas_equalTo([ccui getRH:14]);
    }];
    
    //4.操作view
    UIView *handleV = [[UIView alloc]init];
    self.handleView = handleV;
    [self.contentView addSubview:handleV];
    [handleV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-leftSpace);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo([ccui getRH:24]);
        make.width.mas_equalTo(handleViewW);
    }];
    
}

-(void)setupHandleView {
    CGFloat cornerR = [ccui getRH:5];
    CGFloat fontSize = [ccui getRH:12];
    WS(weakSelf);
    
    //1.禁言
    DGButton *forbidBtn = [DGButton btnWithFontSize:fontSize title:@"禁言" titleColor:KKES_COLOR_YELLOW];
    self.forbidWordButton = forbidBtn;
    forbidBtn.layer.cornerRadius = cornerR;
    forbidBtn.layer.masksToBounds = YES;
    forbidBtn.layer.borderColor = (KKES_COLOR_YELLOW).CGColor;
    forbidBtn.layer.borderWidth = 1.0;
    [self.handleView addSubview:forbidBtn];
    [forbidBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo([ccui getRH:57]);
    }];
    
    [forbidBtn addClickWithTimeInterval:0.5 block:^(DGButton *btn) {
        //禁言中不可点
        NSString *cTitle = [btn titleForState:UIControlStateNormal];
        if ([cTitle isEqualToString:@"禁言中"]) {  return ; }
        //非禁言,调代理去禁言
        SS(strongSelf);
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(triggerView:setForbidWord:)]) {
            [strongSelf.delegate triggerView:strongSelf setForbidWord:YES];
        }
    }];
    
    //2.上麦
    DGButton *giveMicBtn = [DGButton btnWithFontSize:fontSize title:@"抱TA上麦" titleColor:UIColor.whiteColor];
    [giveMicBtn setNormalBgColor:KKES_COLOR_YELLOW selectedBgColor:KKES_COLOR_YELLOW];
    self.giveMicButton = giveMicBtn;
    giveMicBtn.layer.cornerRadius = cornerR;
    giveMicBtn.layer.masksToBounds = YES;
    [self.handleView addSubview:giveMicBtn];
    [giveMicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo([ccui getRH:70]);
    }];
    
    [giveMicBtn addClickWithTimeInterval:0.2 block:^(DGButton *btn) {
        if (btn.selected) { return ; }
        
        SS(strongSelf);
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(triggerView:setMicGive:)]) {
            [strongSelf.delegate triggerView:strongSelf setMicGive:YES];
        }
    }];
    
    //3.在麦上
    DGLabel *onMicL = [DGLabel labelWithText:@"正在麦上" fontSize:fontSize color:KKES_COLOR_YELLOW];
    self.onMicLabel = onMicL;
    onMicL.hidden = YES;
    onMicL.textAlignment = NSTextAlignmentRight;
    [self.handleView addSubview:onMicL];
    [onMicL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
}

#pragma mark - setter
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)setHandleViewHidden:(BOOL)handleViewHidden {
    _handleViewHidden = handleViewHidden;
    
    self.handleView.hidden = handleViewHidden;
}

-(void)setIsHostCheck:(BOOL)isHostCheck {
    _isHostCheck = isHostCheck;
    
    //1.不是主播, 隐藏后return
    if (!isHostCheck) {
        self.handleViewHidden = YES;
        return ;
    }
    
    //2.是主播,显示
    if(isHostCheck && self.handleViewHidden==NO){
        self.handleView.hidden = NO;
        //3.没有创建控件, 就去创建
        if(!self.forbidWordButton){
            [self setupHandleView];
        }
    }
}

-(void)setIsOnMic:(BOOL)isOnMic {
    _isOnMic = isOnMic;
    
    self.onMicLabel.hidden  = !isOnMic;
    self.forbidWordButton.hidden = isOnMic;
    self.giveMicButton.hidden = isOnMic;
}

- (void)setIsForbid:(BOOL)isForbid {
    _isForbid = isForbid;
    
    //1.禁言按钮
    NSString *title = isForbid ? @"禁言中" : @"禁言";
    [self.forbidWordButton setTitle:title forState:UIControlStateNormal];

    //2.抱上麦按钮
    UIColor *bgColor = isForbid ? UIColor.grayColor : KKES_COLOR_YELLOW;
    [self.giveMicButton setNormalBgColor:bgColor selectedBgColor:bgColor];
    self.giveMicButton.selected = isForbid;
}

-(void)setLocalImageName:(NSString *)localImageName {
    _localImageName = [localImageName copy];
    
    //1.imageView
    self.tagImageView.hidden = localImageName.length<1;
    self.tagImageView.image = Img(localImageName);
    
    //2.nameLabel
    WS(weakSelf);
    CGFloat nameTopSpace = localImageName.length<1 ? (_portraitHeight - _nameLabelHeight)/2.0 : _nameLabelTopSpace;
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.portraitImageView.mas_top).mas_offset(nameTopSpace);
    }];
}

@end
