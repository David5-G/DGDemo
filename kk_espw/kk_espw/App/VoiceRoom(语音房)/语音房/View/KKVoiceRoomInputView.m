//
//  KKVoiceRoomInputView.m
//  kk_espw
//
//  Created by david on 2019/7/18.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKVoiceRoomInputView.h"
#import "KKUIFaceView.h"


#pragma mark - extern

static const CGFloat kk_faceViewHeight = 216;

@interface KKVoiceRoomInputView ()<UITextFieldDelegate,KKUIFaceViewDelegate>{
    CGFloat _leftSpace;
    CGFloat _inputViewHeight;
    CGFloat _toolButtonWidth;
}

@property (nonatomic, assign) CGRect originalFrame;
//leftToolView
@property (nonatomic, assign) CGFloat leftToolViewOriginalWidth;
@property (nonatomic, strong) UIView *leftToolView;
//rightTool
@property (nonatomic, assign) CGFloat rightToolViewOriginalWidth;
@property (nonatomic, strong) UIView *rightToolView;
//buttons
@property (nonatomic, strong, readwrite) DGButton *micButton;
@property (nonatomic, strong, readwrite) DGButton *speakerButton;
@property (nonatomic, strong, readwrite) DGButton *shareButton;
@property (nonatomic, strong, readwrite) DGButton *broomButton;
//input
@property (nonatomic, assign) BOOL showingKeyboard;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) DGButton *emojiButton;
@property (nonatomic, strong) DGTextField *inputTextField;
//emoji
@property (nonatomic, strong) KKUIFaceView *faceView;
@property (nonatomic, assign) BOOL showingFaceView;
@end

@implementation KKVoiceRoomInputView

#pragma mark - lazy load
- (KKUIFaceView *)faceView {
    if(!_faceView){
        _faceView = [[KKUIFaceView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kk_faceViewHeight)];
        _faceView.delegate = self;
        [_faceView setData:[[IMUIKitManager sharedInstance].config.emojiFaces mutableCopy]];
    }
    return _faceView;
}

-(DGButton *)speakerButton {
    if (!_speakerButton) {
        WS(weakSelf);
        DGButton *aBtn = [[DGButton alloc]init];
        _speakerButton = aBtn;
        [aBtn setNormalImg:Img(@"input_speakerClose_gray") selectedImg:Img(@"input_speakerOpen_gray")];
        [aBtn addClickWithTimeInterval:0.3 block:^(DGButton *btn) {
            BOOL wantOpen = !btn.selected;
            SS(strongSelf);
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(inputView:openSpeaker:)]) {
                [strongSelf.delegate inputView:strongSelf openSpeaker:wantOpen];
            }
        }];
    }
    return _speakerButton;
}

-(DGButton *)micButton {
    if (!_micButton) {
        WS(weakSelf);
        DGButton *aBtn = [[DGButton alloc]init];
        _micButton = aBtn;
        [aBtn setNormalImg:Img(@"input_micClose_gray") selectedImg:Img(@"input_micOpen_gray")];
        [aBtn addClickWithTimeInterval:0.3 block:^(DGButton *btn) {
            BOOL wantOpen = !btn.selected;
            SS(strongSelf);
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(inputView:openMic:)]) {
                [strongSelf.delegate inputView:strongSelf openMic:wantOpen];
            }
        }];
    }
    return _micButton;
}

-(DGButton *)shareButton {
    if (!_shareButton) {
        WS(weakSelf);
        DGButton *aBtn = [DGButton btnWithImg:Img(@"input_share_gray")];
        _shareButton = aBtn;
        [aBtn addClickWithTimeInterval:0.3 block:^(DGButton *btn) {
            SS(strongSelf);
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(inputView:didClickShare:)]) {
                [strongSelf.delegate inputView:strongSelf didClickShare:btn];
            }
        }];
    }
    return _shareButton;
}

-(DGButton *)broomButton {
    if (!_broomButton) {
        WS(weakSelf);
        DGButton *aBtn = [DGButton btnWithImg:Img(@"input_broom_gray")];
        _broomButton = aBtn;
        [aBtn addClickWithTimeInterval:0.3 block:^(DGButton *btn) {
            SS(strongSelf);
            if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(inputView:didClickBroom:)]) {
                [strongSelf.delegate inputView:strongSelf didClickBroom:btn];
            }
        }];
    }
    return _broomButton;
}

#pragma mark - life circle
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.originalFrame = frame;
        [self setDimension];
        [self setupUI];
        [self addKeyboardNotifications];
    }
    return self;
}

-(void)dealloc {
    //这里不能用self.faceView, 会导致崩溃
    [_faceView removeFromSuperview];
    [self removeKeyBoardNotifications];
}


#pragma mark - UI
-(void)setDimension {
    _leftSpace = [ccui getRH:10];
    _inputViewHeight = [ccui getRH:33];
    _toolButtonWidth = [ccui getRH:33];
}
-(void)setupUI {

    CGFloat leftS  = _leftSpace;
    CGFloat inputViewH = _inputViewHeight;
    
    //1.左侧toolV
    UIView *leftToolV = [[UIView alloc]init];
    leftToolV.clipsToBounds = YES;
    self.leftToolView = leftToolV;
    [self addSubview:leftToolV];
    [leftToolV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(inputViewH);
    }];
    [self setLeftToolSubview:nil width:0];
    
    //2.右侧toolV
    UIView *rightToolV = [[UIView alloc]init];
    rightToolV.clipsToBounds = YES;
    self.rightToolView = rightToolV;
    [self addSubview:rightToolV];
    [rightToolV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(0);
        make.height.mas_equalTo(inputViewH);
    }];
    
    //3.inputView
    UIView *inputV = [[UIView alloc]init];
    inputV.backgroundColor = rgba(53, 38, 37, 0.8);
    inputV.layer.cornerRadius = [ccui getRH:5];
    inputV.layer.masksToBounds = YES;
    self.inputView = inputV;
    [self addSubview:inputV];
    [inputV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftToolV.mas_right).mas_offset(leftS);
        make.right.mas_equalTo(rightToolV.mas_left).mas_equalTo(-leftS);
        make.height.mas_equalTo(inputViewH);
        make.centerY.mas_equalTo(0);
    }];
    [self setupInputView];

}

-(void)setupInputView {
    WS(weakSelf);
    CGFloat btnW = _inputViewHeight;
    //1.emojiBtn
    DGButton *emojiBtn = [[DGButton alloc]init];
    [emojiBtn setNormalImg:Img(@"input_emoji_white") selectedImg:Img(@"input_keyboard_gray")];
    emojiBtn.backgroundColor = UIColor.clearColor;
    self.emojiButton = emojiBtn;
    [self.inputView addSubview:emojiBtn];
    [emojiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.width.mas_equalTo(btnW);
    }];
    [emojiBtn addClickWithTimeInterval:0.3 block:^(DGButton *btn) {
        btn.selected = !btn.selected;
        [weakSelf showFaceView:btn.selected byEmojiButton:YES];
    }];
    
    //2.textField
    DGTextField *tf = [[DGTextField alloc]init];
    tf.movingView = self;
    tf.spaceY = (self.height-_inputViewHeight)/2.0;
    NSAttributedString *placeholderString = [[NSAttributedString alloc] initWithString:@"说点什么吧……" attributes:@{NSForegroundColorAttributeName : rgba(102, 102, 102, 1)}];
    tf.attributedPlaceholder = placeholderString;
    [tf setFont:[ccui getRH:12] textColor:KKES_COLOR_BLACK_TEXT textAlignment:NSTextAlignmentLeft];
    tf.returnKeyType = UIReturnKeySend;
    tf.delegate = self;
    tf.backgroundColor = UIColor.clearColor;
    self.inputTextField = tf;
    [self.inputView addSubview:tf];
    [tf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ccui getRH:10]);
        make.right.mas_equalTo(emojiBtn.mas_left);
        make.top.bottom.mas_equalTo(0);
    }];
}


-(void)setLeftToolSubview:(nullable UIView *)subview width:(CGFloat)width {
    //1.清空
    for (UIView *subview in self.leftToolView.subviews) {
        [subview removeFromSuperview];
    }
    
    //2.判空
    if(!subview){
        self.leftToolViewOriginalWidth = 0;
        [self updateLeftToolViewConstraints:0];
        return;
    }
    
    //3.赋值
    CGFloat leftS  = _leftSpace;
    [self.leftToolView addSubview:subview];
    [subview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(leftS);
        make.width.mas_equalTo(width);
    }];
    self.leftToolViewOriginalWidth = width + 2*leftS;
    [self updateLeftToolViewConstraints:self.leftToolViewOriginalWidth];
}

-(void)refreshRightToolView {
    
    //1.清空
    for (UIView *subview in self.rightToolView.subviews) {
        [subview removeFromSuperview];
    }
    
    //2.获取btns
    NSMutableArray *btns = [NSMutableArray array];
    for (NSString *str in self.rightToolButtons) {
        if ([str isEqualToString:KKInputViewToolButtonSpeaker]) {
            [btns addObject:self.speakerButton];
        }else if ([str isEqualToString:KKInputViewToolButtonMic]){
            [btns addObject:self.micButton];
        }else if ([str isEqualToString:KKInputViewToolButtonShare]){
            [btns addObject:self.shareButton];
        }else if ([str isEqualToString:KKInputViewToolButtonBroom]){
            [btns addObject:self.broomButton];
        }
    }
    
    //3.设置rightV
    CGFloat btnW = _toolButtonWidth;
    self.rightToolViewOriginalWidth = btnW * btns.count + [ccui getRH:15];
    [self updateRightToolViewConstraints:self.rightToolViewOriginalWidth];
    UIButton *preBtn;
    for (UIButton *btn in btns) {
        btn.selected = NO;
        [self.rightToolView addSubview:btn];
        if (preBtn) {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(preBtn.mas_right).offset(0);
                make.centerY.mas_equalTo(0);
                make.width.height.mas_equalTo(btnW);
            }];
        }else {
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.centerY.mas_equalTo(0);
                make.width.height.mas_equalTo(btnW);
            }];
        }
        //赋值preBtn
        preBtn = btn;
    }

}


#pragma mark tool

/** 根据isEditing设置UI风格 */
-(void)setStyleForEditing:(BOOL)isEditing {
    //1.ToolV
    [self HideLeftRightToolView:isEditing];
    
    
    //2.inputV
    if (isEditing) {
        self.inputTextField.attributedPlaceholder = [self attributedPlaceholderWithColor:rgba(102, 102, 102, 1)];
        self.inputTextField.textColor = KKES_COLOR_BLACK_TEXT;
        self.backgroundColor = UIColor.whiteColor;
        self.inputView.backgroundColor = rgba(242, 242, 242, 1);
        [self.emojiButton setNormalImg:Img(@"input_emoji_gray") selectedImg:Img(@"input_keyboard_gray")];
        return;
    }
    
    switch (self.themeStyle) {
        case KKInputViewThemeStyleDefault:{
            self.inputTextField.attributedPlaceholder = [self attributedPlaceholderWithColor:rgba(102, 102, 102, 1)];
            self.inputTextField.textColor = KKES_COLOR_BLACK_TEXT;
            self.backgroundColor = UIColor.whiteColor;
            self.inputView.backgroundColor = rgba(242, 242, 242, 1);
            [self.emojiButton setNormalImg:Img(@"input_emoji_gray") selectedImg:Img(@"input_keyboard_gray")];
        }break;
        case KKInputViewThemeStyleDark:{
            self.inputTextField.attributedPlaceholder = [self attributedPlaceholderWithColor:rgba(204, 204, 204, 1)];
            self.inputTextField.textColor = UIColor.whiteColor;
            self.backgroundColor = UIColor.clearColor;
            self.inputView.backgroundColor = rgba(255, 255, 255, 0.2);
            [self.emojiButton setNormalImg:Img(@"input_emoji_white") selectedImg:Img(@"input_keyboard_gray")];
        }break;
        default:
            break;
    }
}


-(NSAttributedString *)attributedPlaceholderWithColor:(UIColor *)color {
    return [[NSAttributedString alloc] initWithString:@"说点什么吧……" attributes:@{NSForegroundColorAttributeName : color}];
}

#pragma mark updateConstraints
-(void)HideLeftRightToolView:(BOOL)isHide{
    if (isHide) {
        [self updateLeftToolViewConstraints:0];
        [self updateRightToolViewConstraints:0];
        return;
    }
    
    [self updateLeftToolViewConstraints:self.leftToolViewOriginalWidth];
    [self updateRightToolViewConstraints:self.rightToolViewOriginalWidth];
    
}
-(void)updateLeftToolViewConstraints:(CGFloat)w {
    [self.leftToolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(w);
    }];
}

-(void)updateRightToolViewConstraints:(CGFloat)w {
    [self.rightToolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(w);
    }];
}

#pragma mark - action
-(void)clearInputText {
    self.inputTextField.text = nil;
}

-(void)stopInput {
    //1.键盘
    if (self.showingKeyboard) {
        [self endEditing:YES];
    }
    
    //2.表情
    if (self.showingFaceView) {
        self.emojiButton.selected = NO;
        [self showFaceView:NO byEmojiButton:NO];
    }
}

#pragma mark - delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *text = textField.text;
    if (text.length < 1) {
        [textField resignFirstResponder];
        return YES;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:tryToSendText:)]) {
        [self.delegate inputView:self tryToSendText:text];
    }
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.emojiButton.selected = NO;
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    //键盘隐藏式, 会根据movingViewOriginalFrame回复movingView的frame
    //如果在显示表情状态下 打开的键盘,movingViewOriginalFrame记录的就是表情显示状态下的frame,撤销键盘后movingView(即self)恢复的frame就出错了, 所以这行代码不能少
    self.inputTextField.movingViewOriginalFrame = self.originalFrame;
    return YES;
}

#pragma mark KKUIFaceViewDelegate
- (void)faceView:(KKUIFaceView *_Nullable)faceView didSelectItemToFace:(NSString *_Nullable)face {
    NSString *content = self.inputTextField.text;
    
    //1.获取光标位置
    NSUInteger location = self.inputTextField.selectedRange.location;
    if (location > content.length) {
        location = content.length;
    }
    //2.将表情插在光标后边
    NSString *result = [NSString stringWithFormat:@"%@%@%@",[content substringToIndex:location],face,[content substringFromIndex:location]];
    
    //3.将调整后的字符串添加到UITextView上面
    self.inputTextField.text = result;
    
    //4.更新range
    NSRange cRange = NSMakeRange(location+face.length, 0);
    self.inputTextField.selectedRange = cRange;
}

- (void)faceViewDidBackDelete:(KKUIFaceView *_Nullable)faceView {
     [self.inputTextField deleteBackward];
}

- (void)faceViewSendMessage:(KKUIFaceView *_Nullable)faceView {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputView:tryToSendText:)]) {
        [self.delegate inputView:self tryToSendText:self.inputTextField.text];
    }
}

#pragma mark - keyboard notification
- (void)addKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeKeyBoardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow: (NSNotification *)notification {
    self.showingKeyboard = YES;
    
    //2.改变self的style
    [self setStyleForEditing:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.showingKeyboard = NO;
    
    //1.如果表情正在显示, 就不用设置type
    if (self.showingFaceView) {
        return;
    }
    
    //2.改变self的style
    [self setStyleForEditing:NO];
}


#pragma mark - emoji
-(void)showFaceView:(BOOL)show byEmojiButton:(BOOL)byEmojiButton{
    CGFloat duration = 0.25;
    self.showingFaceView = show;
    
    //① 隐藏
    if (!show) {
        //1.移除faceView
        [self.faceView removeFromSuperview];
       
        //2.点击按钮,即切换
        if (byEmojiButton) {
            [self.inputTextField becomeFirstResponder];
            
        }else{//3.不是切换,就是想隐藏
            [UIView animateWithDuration:duration animations:^{
                 self.frame = self.originalFrame;
            } completion:^(BOOL finished) {
                //改变self的style
                [self setStyleForEditing:NO];
            }];
        }
        return;
    }
    
    //② 显示
    //0.先隐藏键盘
    [self endEditing:YES];
    
    //1.faceView初始状态
    self.faceView.alpha = 0.2;
    CGFloat faceViewInWindowY = [self convertPoint:self.frame.origin toView:[UIApplication sharedApplication].keyWindow].y + self.frame.size.height;
    self.faceView.frame = CGRectMake(0, faceViewInWindowY, SCREEN_WIDTH, kk_faceViewHeight);
    [[KKRootContollerMgr getRootNav].topViewController.view addSubview:self.faceView];//放在keyWindow上不太妥
    
    //2.self的目标frame
    CGFloat faceViewTargetOrightY = SCREEN_HEIGHT - self.faceView.height - HOME_INDICATOR_HEIGHT;
    CGRect targetFrame = self.frame;
    CGFloat deltH = SCREEN_HEIGHT-self.superview.bounds.size.height;
    targetFrame.origin.y = faceViewTargetOrightY - targetFrame.size.height - deltH;
    
    //3.启动动画
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //3.1 faceView
        self.faceView.alpha = 1.0;
        self.faceView.frame = CGRectMake(0, faceViewTargetOrightY, SCREEN_WIDTH, kk_faceViewHeight);
        //3.2 self
        self.frame = targetFrame;
        
    } completion:^(BOOL finished) {
        //改变self的style
        [self setStyleForEditing:YES];
    }];
}

#pragma mark - setter

-(void)setRightToolButtons:(NSArray<NSString *> *)rightToolButtons {
    _rightToolButtons = [rightToolButtons copy];
    [self refreshRightToolView];
}

-(void)setThemeStyle:(KKInputViewThemeStyle)themeStyle {
    _themeStyle = themeStyle;
    
    //1.整体的UI风格
    [self setStyleForEditing:NO];
    
    //2.rightToolView
    switch (themeStyle) {
        case KKInputViewThemeStyleDefault:
            [self.speakerButton setNormalImg:Img(@"input_speakerClose_gray") selectedImg:Img(@"input_speakerOpen_gray")];
            [self.micButton setNormalImg:Img(@"input_micClose_gray") selectedImg:Img(@"input_micOpen_gray")];
            [self.shareButton setImage:Img(@"input_share_gray") forState:UIControlStateNormal];
            break;
        case KKInputViewThemeStyleDark:
            [self.speakerButton setNormalImg:Img(@"input_speakerClose_white") selectedImg:Img(@"input_speakerOpen_white")];
            [self.micButton setNormalImg:Img(@"input_micClose_white") selectedImg:Img(@"input_micOpen_white")];
            [self.shareButton setImage:Img(@"input_share_white") forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}


@end
