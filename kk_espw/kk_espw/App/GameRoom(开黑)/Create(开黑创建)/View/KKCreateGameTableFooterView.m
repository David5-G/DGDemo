//
//  KKCreateGameTableFooterView.m
//  kk_espw
//
//  Created by hsd on 2019/7/17.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKCreateGameTableFooterView.h"
#import "UIView+KKRectCorner.h"

@interface KKCreateGameTableFooterView ()

@property (strong, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *topLineView;
@property (weak, nonatomic) IBOutlet UILabel *gameOutLineLabel;
@property (weak, nonatomic) IBOutlet UIView *inputBgView;
@property (weak, nonatomic) IBOutlet UILabel *gameNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet CC_Button *arrowButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputBgViewToGameOutLine; //18
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputBgViewToArrow;       //3

@property (nonatomic, assign) BOOL hasRectCorner;   ///< 是否已经圆角处理过

@end

@implementation KKCreateGameTableFooterView

#pragma mark - static
static NSInteger kk_game_create_room_title_max_input = 20;

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = KKES_COLOR_HEX(0xFFFFFF);
        [self loadXib];
    }
    return self;
}

- (void)dealloc {
    [self.textField removeTarget:self action:@selector(textFieldValueDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)loadXib {
    
    UIView *bgView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    self.inputBgView.layer.cornerRadius = 5;
    self.inputBgView.layer.masksToBounds = YES;
    
    self.textField.textColor = KKES_COLOR_HEX(0x929292);
    self.textField.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:12];
    
    NSAttributedString *atStr = [[NSAttributedString alloc]initWithString:@"最多20个字符，默认自动生成" attributes:@{NSForegroundColorAttributeName : KKES_COLOR_HEX(0x929292), NSFontAttributeName : [KKFont pingfangFontStyle:PFFontStyleRegular size:12]}];
    self.textField.attributedPlaceholder = atStr;
    [self.textField addTarget:self action:@selector(textFieldValueDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.arrowButton setTitle:nil forState:UIControlStateNormal];
    [self.arrowButton setImageEdgeInsets:UIEdgeInsetsMake(12, 32, 16, 32)];
    [self.arrowButton setImage:[UIImage imageNamed:@"game_arrow_down"] forState:UIControlStateNormal];
    [self.arrowButton setImage:[UIImage imageNamed:@"game_arrow_up"] forState:UIControlStateSelected];

    WS(weakSelf)
    [self.arrowButton addTappedOnceDelay:0.2 withBlock:^(UIButton *button) {
        [weakSelf clickArrowButton];
    }];
}

- (void)textFieldValueDidChange:(UITextField *)tf {
    [self textFieldInputHasChange:tf];
    if (self.textDidChangeBlock) {
        self.textDidChangeBlock(tf.text);
    }
}

- (void)clickArrowButton {
    [self setDefaultState:!self.arrowButton.isSelected animated:YES];
}

- (void)setDefaultTitle:(NSString *)title {
    self.textField.text = title;
}

- (void)setDefaultState:(BOOL)isSelect animated:(BOOL)animated {
    
    self.arrowButton.selected = isSelect;
    
    if (isSelect) {
        
        CGRect frame = self.frame;
        frame.size.height += 64;
        
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                self.inputBgViewToGameOutLine.constant = 18;
                self.inputBgViewToArrow.constant = 7;
                self.frame = frame;
                [self layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                self.inputBgView.hidden = NO;
                if (self.frameDidChangeBlock) {
                    self.frameDidChangeBlock(self, animated);
                }
            }];
            
        } else {
            self.inputBgViewToGameOutLine.constant = 18;
            self.inputBgViewToArrow.constant = 7;
            self.frame = frame;
            self.inputBgView.hidden = NO;
            if (self.frameDidChangeBlock) {
                self.frameDidChangeBlock(self, animated);
            }
        }
    } else { // 折叠
        
        CGRect frame = self.frame;
        frame.size.height -= 64;
        
        if (animated) {
            [UIView animateWithDuration:0.3 animations:^{
                self.inputBgViewToGameOutLine.constant = 0;
                self.inputBgViewToArrow.constant = 0;
                self.frame = frame;
                [self layoutIfNeeded];
                
            } completion:^(BOOL finished) {
                self.inputBgView.hidden = YES;
                if (self.frameDidChangeBlock) {
                    self.frameDidChangeBlock(self, animated);
                }
            }];
        } else {
            self.inputBgViewToGameOutLine.constant = 0;
            self.inputBgViewToArrow.constant = 0;
            self.frame = frame;
            self.inputBgView.hidden = YES;
            if (self.frameDidChangeBlock) {
                self.frameDidChangeBlock(self, animated);
            }
        }
    }
}

#pragma mark - 限制最大输入字符数
//textView内容变化后调用
- (void)textFieldInputHasChange:(UITextField *)tf {
    
    //获取文本
    NSString *toBeString = tf.text;
    
    //--------------------------------------- 处理文本长度变化
    //获取输入语言
    NSString *language = tf.textInputMode.primaryLanguage;
    if ([language isEqualToString:@"zh-Hans"]) { //简体中文,五笔,手写
        UITextRange *selectRange = [tf markedTextRange]; //高亮部分
        UITextPosition *position = [tf positionFromPosition:selectRange.start offset:0];
        
        //无待选择的高亮字符串
        if (!position) {
            if ((toBeString.length > kk_game_create_room_title_max_input)) {//并且输入长度超过限制
                [self subInputTextStringToMaxNum:tf str:toBeString];
            }
        }
        
    } else {
        //非中文输入法, 输入长度超过限制
        if (toBeString.length > kk_game_create_room_title_max_input) {
            [self subInputTextStringToMaxNum:tf str:toBeString];
        }
    }
}

//截取字符串到最大角标
- (void)subInputTextStringToMaxNum:(UITextField *)tf str:(NSString *)toBeString {
    tf.text = [toBeString substringToIndex:kk_game_create_room_title_max_input];
}

@end
