//
//  KKLiveStudioForbidWordUserCell.m
//  kk_espw
//
//  Created by david on 2019/7/24.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioForbidWordUserCell.h"

@interface KKLiveStudioForbidWordUserCell ()
{
    CGFloat _portraitHeight;
    CGFloat _nameLabelHeight;
    CGFloat _nameLabelTopSpace;
}
@property (nonatomic, strong) UIView *handleView;
/** 标签 */
@property (nonatomic, strong) UIImageView *tagImageView;
/** 取消禁言 (isHostCheck=才会有)*/
@property (nonatomic, strong) UIButton *cancelForbidButton;
@end

@implementation KKLiveStudioForbidWordUserCell


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
    CGFloat leftSpace = [ccui getRH:20];
    CGFloat portraitH = _portraitHeight;
    CGFloat nameLabelTopSpace = _nameLabelTopSpace;
    CGFloat nameLabelH = _nameLabelHeight;
    CGFloat handleViewW = [ccui getRH:70];
    
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
    
    //1.上麦
    DGButton *cancelBtn = [DGButton btnWithFontSize:fontSize title:@"解除" titleColor:UIColor.whiteColor bgColor:KKES_COLOR_YELLOW];
    self.cancelForbidButton = cancelBtn;
    cancelBtn.layer.cornerRadius = cornerR;
    cancelBtn.layer.masksToBounds = YES;
    [self.handleView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo([ccui getRH:58]);
    }];
    
    WS(weakSelf);
    [cancelBtn addClickWithTimeInterval:0.5 block:^(DGButton *btn) {
        SS(strongSelf);
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(triggerView:setForbidWord:)]) {
            [strongSelf.delegate triggerView:strongSelf setForbidWord:NO];
        }
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
        if(!self.cancelForbidButton){
            [self setupHandleView];
        }
    }
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


