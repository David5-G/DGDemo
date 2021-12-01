//
//  KKLiveStudioMicRankCell.m
//  kk_espw
//
//  Created by david on 2019/7/24.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomMicRankCell.h"

@interface KKChatRoomMicRankCell ()
{
    CGFloat _portraitHeight;
    CGFloat _nameLabelHeight;
    CGFloat _nameLabelTopSpace;
}
@property (nonatomic, strong) UIView *handleView;
@property (nonatomic, strong) UILabel *onMicLabel;
@property (nonatomic, strong) UIImageView *tagImageView;
@end

@implementation KKChatRoomMicRankCell
 

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
    CGFloat handleViewW = [ccui getRH:80];
    
    //0.rank
    DGLabel *rankL = [DGLabel labelWithText:@"1" fontSize:[ccui getRH:15] color:KKES_COLOR_BLACK_TEXT];
    self.rankLabel = rankL;
    [self.contentView addSubview:rankL];
    [rankL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftSpace);
        make.centerY.mas_equalTo(0);
    }];
    
    //1.头像
    UIImageView *portraitImgV = [[UIImageView alloc]init];
    self.portraitImageView = portraitImgV;
    portraitImgV.backgroundColor = UIColor.lightGrayColor;
    portraitImgV.layer.cornerRadius = portraitH/2.0;
    portraitImgV.layer.masksToBounds = YES;
    [self.contentView addSubview:portraitImgV];
    [portraitImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:16]+leftSpace);
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
    
    //1.上麦
    DGButton *giveMicBtn = [DGButton btnWithFontSize:fontSize title:@"抱TA上麦" titleColor:UIColor.whiteColor bgColor:KKES_COLOR_YELLOW];
    [giveMicBtn setNormalBgColor:KKES_COLOR_YELLOW selectedBgColor:UIColor.grayColor];
    self.giveMicButton = giveMicBtn;
    giveMicBtn.layer.cornerRadius = cornerR;
    giveMicBtn.layer.masksToBounds = YES;
    [self.handleView addSubview:giveMicBtn];
    [giveMicBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo([ccui getRH:70]);
    }];
    
    WS(weakSelf);
    [giveMicBtn addClickWithTimeInterval:0.5 block:^(DGButton *btn) {
        SS(strongSelf);
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(triggerView:setMicGive:)]) {
            [strongSelf.delegate triggerView:strongSelf setMicGive:YES];
        }
    }];
    
    //2.在麦上
    DGLabel *onMicL = [DGLabel labelWithText:@"正在麦上" fontSize:fontSize color:KKES_COLOR_YELLOW];
    self.onMicLabel = onMicL;
    onMicL.hidden = YES;
    onMicL.textAlignment = NSTextAlignmentRight;
    [self.handleView addSubview:onMicL];
    [onMicL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo([ccui getRH:70]);
    }];
}

#pragma mark - setter
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)setIsHostCheck:(BOOL)isHostCheck {
    _isHostCheck = isHostCheck;
    
    //1.不是主播, 隐藏后return
    if (!isHostCheck) {
        self.handleView.hidden = YES;
        return ;
    }
    
    //2.是主播,显示
    if(isHostCheck){
        self.handleView.hidden = NO;
        //3.没有创建控件, 就去创建
        if(!self.giveMicButton){
            [self setupHandleView];
        }
    }
}

- (void)setIsForbid:(BOOL)isForbid {
    _isForbid = isForbid;
    
    //1.抱上麦按钮
    self.giveMicButton.selected = isForbid;
    self.giveMicButton.userInteractionEnabled = !isForbid;
}


-(void)setIsOnMic:(BOOL)isOnMic {
    _isOnMic = isOnMic;
    
    self.onMicLabel.hidden  = !isOnMic;
    self.giveMicButton.hidden = isOnMic;
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

