//
//  KKUserFeedbackViewController.m
//  kk_espw
//
//  Created by 景天 on 2019/7/17.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKUserFeedbackViewController.h"
#import "KKUserFeedBackService.h"

@interface KKUserFeedbackViewController ()<UITextFieldDelegate,UITextViewDelegate>
{
    CGFloat _leftSpace;
    CGFloat _commonFontSize;
    UIColor *_placeholderColor;
    NSInteger _maxWordCount;
}
@property (nonatomic, weak) DGTextView *textView;
@property (nonatomic, weak) UILabel *wordCountLabel;
@property (nonatomic, weak) UITextField *cellTextField;

@end

@implementation KKUserFeedbackViewController


#pragma mark - lazy load


#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDimension];
    [self setupNavi];
    [self setupUI];
}

#pragma mark - UI
- (void)setDimension {
    _leftSpace = [ccui getRH:15];
    _commonFontSize = [ccui getRH:15];
    _placeholderColor = rgba(199, 199, 199, 1);
    _maxWordCount  = 200;
}

- (void)setupNavi {
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"用户反馈"];
}

- (void)setupUI {
    /// 问题和意见
    DGLabel *titleL = [DGLabel labelWithText:@"问题和意见" fontSize:_commonFontSize color:KKES_COLOR_BLACK_TEXT];
    [self.view addSubview:titleL];
    titleL.top = STATUSBAR_ADD_NAVIGATIONBARHEIGHT + RH(15);
    titleL.left = RH(22);
    titleL.size = CGSizeMake(200, RH(14));
    [self.view addSubview:titleL];
    
    /// textView底部白色View
    UIView *whiteView = [[UIView alloc] init];
    [self.view addSubview:whiteView];
    whiteView.left = 0;
    whiteView.top = STATUSBAR_ADD_NAVIGATIONBARHEIGHT + RH(42);
    whiteView.size = CGSizeMake(SCREEN_WIDTH, RH(173));
    whiteView.backgroundColor = [UIColor whiteColor];
    [self setupTextView:whiteView];
    
    /// 联系方式
    DGLabel *cellTitleL = [DGLabel labelWithText:@"联系方式" fontSize:_commonFontSize color:KKES_COLOR_BLACK_TEXT];
    cellTitleL.left = RH(21);
    cellTitleL.top = STATUSBAR_ADD_NAVIGATIONBARHEIGHT + RH(232);
    cellTitleL.size = CGSizeMake(RH(100), RH(13));
    [self.view addSubview:cellTitleL];
   
    UIView *whiteViewTF = [[UIView alloc] init];
    [self.view addSubview:whiteViewTF];
    whiteViewTF.left = 0;
    whiteViewTF.top = whiteView.bottom + RH(44);
    whiteViewTF.size = CGSizeMake(SCREEN_WIDTH, RH(49));
    whiteViewTF.backgroundColor = [UIColor whiteColor];
    
    UITextField *cellTf = [self createTextFieldWithPlaceHolder:@"请输入您的联系方式"];
    self.cellTextField = cellTf;
    cellTf.left = RH(21);
    cellTf.top = RH(0);
    cellTf.size = CGSizeMake(SCREEN_WIDTH - RH(42), RH(49));
    [cellTf addTarget:self action:@selector(cellDidChanged:) forControlEvents: UIControlEventEditingChanged];
    [whiteViewTF addSubview:cellTf];
    
    CC_Button *quitButton = [CC_Button buttonWithType:UIButtonTypeCustom];
    quitButton.top = whiteViewTF.bottom + RH(30);
    quitButton.left = RH(25);
    quitButton.size = CGSizeMake(SCREEN_WIDTH - RH(50), RH(45));
    [quitButton setTitle:@"提交" forState:UIControlStateNormal];
    quitButton.backgroundColor = KKES_COLOR_MAIN_YELLOW;
    quitButton.layer.cornerRadius = RH(4);
    WS(weakSelf)
    [quitButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        
        if (weakSelf.textView.text.length == 0) {
            [CC_Notice show:@"反馈内容为空"];
            return ;
        }
        if ([weakSelf checkCellValidity:weakSelf.cellTextField.text]) {
            [weakSelf requestFeedBack];
        }
    }];
    [self.view addSubview:quitButton];
}

- (void)setupTextView:(UIView *)sView {
    /// 1.textView
    DGTextView *textV = [[DGTextView alloc]init];
    self.textView = textV;
    textV.delegate = self;
    textV.placeholder = @"请描述您的问题与意见";
    textV.placeholderColor = _placeholderColor;
    textV.textColor = KKES_COLOR_BLACK_TEXT;
    textV.font = Font(_commonFontSize);
    [textV setDoneInputAccessoryView];
    
    [sView addSubview:textV];
    [textV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo([ccui getRH:18]);
        make.right.mas_equalTo(-[ccui getRH:18]);
        make.bottom.mas_equalTo(-[ccui getRH:25]);
    }];
    
    /// 2.wordCount
    NSString *wordContStr = [NSString stringWithFormat:@"0/%ld",_maxWordCount];
    DGLabel *wordCountL = [DGLabel labelWithText:wordContStr fontSize:[ccui getRH:12] color:_placeholderColor];
    self.wordCountLabel = wordCountL;
    [sView addSubview:wordCountL];
    [wordCountL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-[ccui getRH:15]);
        make.bottom.mas_equalTo(-[ccui getRH:10]);
    }];
}

/** 创建制定font,color的textField */
- (UITextField *)createTextFieldWithPlaceHolder:(NSString *)placeHolder{
    /// 1.创建
    UITextField *tf = [[UITextField alloc]init];
    
    /// 2.设置attributedPlaceholder
    UIFont *font = [UIFont systemFontOfSize:_commonFontSize];
    NSAttributedString *aStr = [[NSAttributedString alloc]initWithString:placeHolder attributes:@{NSForegroundColorAttributeName : _placeholderColor, NSFontAttributeName : font}];
    tf.attributedPlaceholder = aStr;
    
    /// 3.设置
    tf.font = font;
    tf.textColor = KKES_COLOR_BLACK_TEXT;
    tf.textAlignment = NSTextAlignmentLeft;
    tf.returnKeyType = UIReturnKeyDone;
    tf.delegate = self;
    
    /// 4.return
    return tf;
}

#pragma mark tool
/** 检查手机号有效性 */
- (BOOL)checkCellValidity:(NSString *)cellStr {
    
    /// 1.为空
    if(cellStr.length == 0) {
        [CC_Notice show:@"请输入手机号"];
        return NO;
    }
    
    /// 2. 位数不符
    if(cellStr.length != 11) {
        [CC_Notice show:@"请输入正确的手机号"];
        return NO;
    }
    
    /// 3.手机号验证
    NSString *regex = @"^[1][0-9]\\d{9}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![pred evaluateWithObject:cellStr]) {
        [CC_Notice show:@"请输入正确的手机号"];
        return NO;
    }
    
    /// 4.有效
    return YES;
}

#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    
    NSInteger maxWordCount = _maxWordCount;
    /// 1.输入处理
    UITextRange *selectedRange = [textView markedTextRange];
    NSString *newText = [textView textInRange:selectedRange];
    if (!newText.length) {
        if (textView.text.length > maxWordCount) {
            textView.text = [textView.text substringToIndex:maxWordCount];
        }
        
    }
    
    /// 2.字数统计
    self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",textView.text.length,(long)maxWordCount];
    
    /// 3.更改确认按钮状态
//    [self updateComfirmButtonStatus];
}


#pragma mark textField变化
- (void)cellDidChanged:(UITextField *)textField {
    if (textField.text.length > 11) {
        textField.text = [textField.text substringToIndex:11];
    }
}

#pragma mark - request
- (void)requestFeedBack {
    WS(weakSelf)
    [KKUserFeedBackService shareInstance].adviceConent = self.textView.text;
    [KKUserFeedBackService requestUserFeedBackSuccess:^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } Fail:^{
        
    }];
}

@end
