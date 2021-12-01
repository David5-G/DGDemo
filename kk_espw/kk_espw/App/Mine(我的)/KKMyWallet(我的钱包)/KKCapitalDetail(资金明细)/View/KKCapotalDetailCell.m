//
//  KKCapotalDetailCell.m
//  kk_espw
//
//  Created by 景天 on 2019/7/23.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKCapotalDetailCell.h"
#import "KKCapitalAccount.h"
#import "KKMessage.h"
#import "KKCapitalFreeze.h"
@interface KKCapotalDetailCell()

@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UILabel *statusLabel;
@property (nonatomic, strong) UILabel *balancelabel;
@property (nonatomic, strong) UILabel *payWayLabel;

@end


@implementation KKCapotalDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _yearLabel = New(UILabel);
        _yearLabel.left = RH(14);
        _yearLabel.top = RH(20);
        _yearLabel.size = CGSizeMake((SCREEN_WIDTH - RH(28)) / 3, RH(18));
        _yearLabel.textColor = KKES_COLOR_GRAY_TEXT;
        _yearLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:14];
        _yearLabel.textAlignment = NSTextAlignmentLeft;
        
        [self.contentView addSubview:_yearLabel];
        
        _amountLabel = New(UILabel);
        _amountLabel.left = _yearLabel.right;
        _amountLabel.top = RH(20);
        _amountLabel.size = CGSizeMake((SCREEN_WIDTH - RH(28)) / 3, RH(18));
        _amountLabel.textColor = KKES_COLOR_MAIN_YELLOW;
        _amountLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:16];
        
        _amountLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_amountLabel];
        
        _balancelabel = New(UILabel);
        _balancelabel.left = _amountLabel.right;
        _balancelabel.top = RH(20);
        _balancelabel.size = CGSizeMake((SCREEN_WIDTH - RH(28)) / 3, RH(18));
        _balancelabel.textColor = KKES_COLOR_BLACK_TEXT;
        _balancelabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:14];
        
        _balancelabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_balancelabel];
        
        _hourLabel = New(UILabel);
        _hourLabel.left = RH(14);
        _hourLabel.top = _yearLabel.bottom;
        _hourLabel.size = CGSizeMake((SCREEN_WIDTH - RH(28)) / 3, RH(18));
        _hourLabel.textColor = KKES_COLOR_GRAY_TEXT;
        _hourLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:14];
        
        _hourLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_hourLabel];
        
        _statusLabel = New(UILabel);
        _statusLabel.left = _hourLabel.right;
        _statusLabel.top = _amountLabel.bottom;
        _statusLabel.size = CGSizeMake((SCREEN_WIDTH - RH(28)) / 3, RH(18));
        _statusLabel.textColor = KKES_COLOR_GRAY_TEXT;
        _statusLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:13];
        
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_statusLabel];
        
        _payWayLabel = New(UILabel);
        _payWayLabel.left = _statusLabel.right;
        _payWayLabel.top = _balancelabel.bottom;
        _payWayLabel.size = CGSizeMake((SCREEN_WIDTH - RH(28)) / 3, RH(18));
        _payWayLabel.textColor = KKES_COLOR_GRAY_TEXT;
        _payWayLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:14];
        
        _payWayLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_payWayLabel];
    }
    return self;
}

- (void)setCapitalAccount:(KKCapitalAccount *)capitalAccount {
    NSArray *times = [capitalAccount.gmtTrans componentsSeparatedByString:@" "];
    NSString *year = times.firstObject;
    NSString *hour = times.lastObject;
    
    _yearLabel.text = year;
    _hourLabel.text = hour;
    
    if ([capitalAccount.transDirection.name isEqualToString:@"O"]) {
        _amountLabel.text = [NSString stringWithFormat:@"-%@", capitalAccount.transAmount];
        _amountLabel.textColor = KKES_COLOR_BLACK_TEXT;
    }else {
        _amountLabel.text = [NSString stringWithFormat:@"+%@", capitalAccount.transAmount];
        _amountLabel.textColor = KKES_COLOR_MAIN_YELLOW;

    }
    _balancelabel.text = capitalAccount.balanceAfter;
    _statusLabel.text = capitalAccount.transDirection.message;
    _payWayLabel.text = capitalAccount.memo;
    
    _amountLabel.hidden = NO;
    _statusLabel.hidden = NO;
}

- (void)setCapitalFreeze:(KKCapitalFreeze *)capitalFreeze {
    NSArray *times = [capitalFreeze.gmtCreate componentsSeparatedByString:@" "];
    NSString *year = times.firstObject;
    NSString *hour = times.lastObject;
    
    _yearLabel.text = year;
    _hourLabel.text = hour;
    
    
    if (capitalFreeze.freezeAmount.floatValue > 0) {
        _balancelabel.text = capitalFreeze.beginFreezeAmount;
        _payWayLabel.text = @"冻结中";
    }else {
        _balancelabel.text = capitalFreeze.unfreezeAmount;
        _payWayLabel.text = @"已解冻";
    }
    
    _amountLabel.hidden = YES;
    _statusLabel.hidden = YES;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
