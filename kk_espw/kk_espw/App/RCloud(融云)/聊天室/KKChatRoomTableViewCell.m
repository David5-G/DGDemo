//
//  KKChatRoomTableViewCell.m
//  kk_espw
//
//  Created by 阿杜 on 2019/8/16.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKChatRoomTableViewCell.h"
#import "KKChatRoomMessage.h"

@interface KKChatRoomTableViewCell(){
    CGFloat _containerViewLeftSpace;
    CGFloat _contentLabelLeftSpace;
    CGFloat _topSpace;
}
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *contentLabel;
@end

@implementation KKChatRoomTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setDimension];
        [self setupUI];
    }
    return self;
}

#pragma mark - UI
-(void)setDimension {
    _containerViewLeftSpace = [ccui getRH:14];
    _contentLabelLeftSpace = [ccui getRH:14];
    _topSpace = [ccui getRH:4];
}

-(void)setupUI {
    
    CGFloat containerLeftSpace = _containerViewLeftSpace;
    CGFloat labelLeftSpace = _contentLabelLeftSpace;
    CGFloat topSpace = _topSpace;
    //1.containerV
    CGRect containerFrame = CGRectMake(containerLeftSpace, topSpace, SCREEN_WIDTH-containerLeftSpace*2, 0);
    UIView *containerV = [[UIView alloc]initWithFrame:containerFrame];
    containerV.userInteractionEnabled = NO;
    self.containerView = containerV;
    [self.contentView addSubview:containerV];
    
    //2.contentL
    CGRect labelFrame = CGRectMake(labelLeftSpace, topSpace, 50, 0);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    self.contentLabel = label;
    label.numberOfLines = 0;
    label.textColor = KKES_COLOR_BLACK_TEXT;
    [containerV addSubview:label];
}


#pragma mark - public
-(void)loadMsg:(KKChatRoomMessage *)msg {
    //1.bg
    if (msg.backGroundColor) {
        self.backgroundColor = msg.backGroundColor;
    }else {
        self.backgroundColor = UIColor.clearColor;
    }
    //2.containerViewFrame
    self.containerView.height = msg.contentSize.height + 2*_topSpace;
    self.containerView.width = msg.contentSize.width + 2*_contentLabelLeftSpace;
    
    //3.labelFrame, content
    self.contentLabel.attributedText = msg.attributeContent;
    self.contentLabel.size = msg.contentSize;
    
    //4.按样式更新UI
    if (msg.isDark) {
        self.containerView.backgroundColor = rgba(0, 0, 0, 0.15);
        self.containerView.layer.cornerRadius = [ccui getRH:13];
        self.containerView.layer.masksToBounds = YES;
    }else{
        self.containerView.backgroundColor = UIColor.clearColor;
        self.containerView.layer.cornerRadius = 0;
        self.containerView.layer.masksToBounds = NO;
        //非dark模式,调整contentLabel的Frame
        self.contentLabel.top = 0;
        self.contentLabel.left = 0;
    }
}

@end
