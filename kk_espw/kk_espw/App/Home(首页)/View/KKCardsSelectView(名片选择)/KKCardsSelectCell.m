//
//  KKCardsSelectCell.m
//  kk_espw
//
//  Created by 景天 on 2019/7/11.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKCardsSelectCell.h"
#import "KKCardTag.h"
#import "KKMessage.h"
@implementation KKCardsSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.left, [ccui getRH:2], SCREEN_WIDTH - [ccui getRH:50], [ccui getRH:56])];
        bgView.backgroundColor = RGB(237, 237, 237);
        bgView.layer.cornerRadius = 4;
        [self.contentView addSubview:bgView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:21], [ccui getRH:12], [ccui getRH:180], [ccui getRH:14])];
        [self.contentView addSubview:_nameLabel];
        _nameLabel.font = [ccui getRFS:14];
        _nameLabel.textColor = KKES_COLOR_BLACK_TEXT;
        
        _areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.left, _nameLabel.bottom + [ccui getRH:10], [ccui getRH:180], [ccui getRH:14])];
        [bgView addSubview:_areaLabel];
        _areaLabel.font = [ccui getRFS:12];
        _areaLabel.textColor = KKES_COLOR_GRAY_TEXT;
        
        _selectImageView = [[UIImageView alloc] initWithFrame:CGRectMake([ccui getRH:293], [ccui getRH:20], [ccui getRH:19], [ccui getRH:15])];
        [bgView addSubview:_selectImageView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        _selectImageView.image = Img(@"card_selected");
    }else {
        _selectImageView.image = nil;
    }
    
}

- (void)setModel:(KKCardTag *)model {
    _nameLabel.text = model.nickName;
    if ([model.nickName isEqualToString:@"全部"] || [model.nickName isEqualToString:@"添加名片"]) {
        _nameLabel.top = RH(22);
        _areaLabel.hidden = YES;
    }else {
        _areaLabel.hidden = NO;
        _nameLabel.top = RH(12);
        if (model.platformType) {
            _areaLabel.text = [NSString stringWithFormat:@"%@-%@", model.platformType.message, model.rank.message];
        }else {
            _areaLabel.text = model.rank.message;
        }
    }
}
@end
