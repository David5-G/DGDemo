//
//  KKCreateVoiceCell.m
//  kk_espw
//
//  Created by jingtian9 on 2019/10/14.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKCreateVoiceCell.h"

@interface KKCreateVoiceCell()<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *tf;
@end

@implementation KKCreateVoiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        //1.房间宣言
        UILabel *titleL = [[UILabel alloc] init];
        titleL.top = RH(5);
        titleL.left = RH(0);
        titleL.width = SCREEN_WIDTH;
        titleL.height = RH(20);
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.text = @"房间宣言";
        titleL.textColor = KKES_COLOR_BLACK_TEXT;
        titleL.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(14)];
        [self.contentView addSubview:titleL];
        //2.房间宣言Content
        UIView *contentV = [[UIView alloc] init];
        contentV.top = RH(13) + titleL.bottom;
        contentV.left = RH(20);
        contentV.size = CGSizeMake(SCREEN_WIDTH - RH(40), RH(39));
        contentV.backgroundColor = RGB(242, 242, 242);
        contentV.layer.cornerRadius = RH(5);
        [self.contentView addSubview:contentV];
        //2.1 TF
        _tf = [[UITextField alloc] init];
        _tf.left = RH(10);
        _tf.top = 0;
        _tf.size = CGSizeMake(contentV.width - RH(10) * 2, RH(39));
        _tf.placeholder = @"这是一个宣言啊";
        [contentV addSubview:_tf];
        _tf.delegate = self;
        _tf.font = [KKFont pingfangFontStyle:PFFontStyleMedium size:RH(15)];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:) name:UITextFieldTextDidChangeNotification object:nil];
        //3.随机
        WS(weakSelf)
        CC_Button *randomButton = [CC_Button buttonWithType:UIButtonTypeCustom];
        randomButton.left = RH(313);
        randomButton.top = contentV.bottom + RH(29);
        randomButton.size = CGSizeMake(RH(45), 20);
        [randomButton setTitle:@"随机" forState:UIControlStateNormal];
        [randomButton setImage:Img(@"random_count") forState:UIControlStateNormal];
        [randomButton setTitleColor:KKES_COLOR_BLACK_TEXT forState:UIControlStateNormal];
        randomButton.titleLabel.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:RH(12)];
        [randomButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            if (weakSelf.tapRandomNumButttonBlock) {
                weakSelf.tapRandomNumButttonBlock();
            }
        }];
        randomButton.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [self.contentView addSubview:randomButton];
    }
    return self;
}

- (void)setDeclarationStr:(NSString *)declarationStr {
    _tf.text = declarationStr;
}

- (void)textFiledEditChanged:(NSNotification *)obj{
    UITextField *textfield = (UITextField *)obj.object;
    //1. 获取字符
    NSString *toBeString = textfield.text;
    //2. 获取高亮部分
    UITextRange *selectedRange = [textfield markedTextRange];
    UITextPosition *position = [textfield positionFromPosition:selectedRange.start offset:0];
    
    //3. 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position || !selectedRange){
        if (toBeString.length > 12){
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:12];
            if (rangeIndex.length == 1){
                textfield.text = [toBeString substringToIndex:12];
            }else{
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 12)];
                textfield.text = [toBeString substringWithRange:rangeRange];
            }
            [CC_Notice show:@"最多12个字符"];
        }
    }
    if (self.tfInputBlock) {
        self.tfInputBlock(textfield.text);
    }
}


@end
