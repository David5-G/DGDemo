//
//  DGTextField.m
//  DGTool
//
//  Created by David.G on 16/7/20.
//  Copyright © 2016年 david. All rights reserved.
//

#import "DGTextField.h"

@interface DGTextField ()

@end

@implementation DGTextField

#pragma mark - life circle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
         [self onInit];
    }
    return self;
}



- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
         [self onInit];
    }
    return self;
}

- (void)dealloc {
    [self removeKeyBoardNotifications];
}

#pragma mark - config

- (void)onInit {
    [self addKeyboardNotifications];
    self.movingView = [UIApplication sharedApplication].keyWindow;
    self.movingViewOriginalFrame = CGRectZero;
}

-(void)setFont:(CGFloat)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment {

    [self setTextColor:color];
    self.textAlignment = alignment;
    self.font = [UIFont systemFontOfSize:font];
    self.autocapitalizationType = UITextAutocapitalizationTypeNone;
    //self.autocorrectionType = UITextAutocorrectionTypeNo;
    //self.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.keyboardType = UIKeyboardTypeDefault;
    self.returnKeyType = UIReturnKeyDone;
}

/** 设置InputAccessoryView, 用于点击"完成"撤销键盘 */
-(void)setDoneInputAccessoryView {
    
    //1.btn
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:self.tintColor forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(closeKeyboard) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    
    //2.fixItem
    UIBarButtonItem *fixItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixItem.width = 1;
    
    //3.spaceItem
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //4.toolBar
    CGFloat toolBarH = 44;
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), toolBarH)];
    toolBar.items = @[flexibleItem, btnItem, fixItem];
    self.inputAccessoryView = toolBar;
}

-(void)closeKeyboard {
    [self resignFirstResponder];
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
    
    //1.过滤self非第一响应者
    if (!self.isFirstResponder) {  return ; }
    
    //2.计算
    //键盘高度
    CGFloat keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    //self的相对keyWindow的origin
    CGPoint relativePoint = [self convertPoint: CGPointZero toView: [UIApplication sharedApplication].keyWindow];
    //要移动的距离 (移动多少才能展示self)
    CGFloat overstep = CGRectGetHeight(self.frame) + relativePoint.y + keyboardHeight - CGRectGetHeight([UIScreen mainScreen].bounds);
    //加上偏移高度
    overstep += self.spaceY;
    
    //在这里要记录一下当前movingView的frame, 用于keyboardWillHide中将movingView的frame复位, (在keyboardWillHide中会置为CGRectZero)
    if (CGRectEqualToRect(self.movingViewOriginalFrame, CGRectZero)) {
        self.movingViewOriginalFrame = self.movingView.frame;
    }
    
    //3. 如果overstep<=0代表不被遮挡,不需要移动
    if (overstep < 0) {  return ; }
    
    //4.动画
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.movingView.frame;
    frame.origin.y -= overstep;
    [UIView animateWithDuration: duration delay: 0 options: UIViewAnimationOptionCurveLinear animations: ^{
        self.movingView.frame = frame;
    } completion: nil];

}

- (void)keyboardWillHide:(NSNotification *)notification {
    //1.过滤self非第一响应者
    if (!self.isFirstResponder) { return ;}
    
    //2.动画
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration: duration delay: 0 options: UIViewAnimationOptionCurveLinear animations: ^{
        self.movingView.frame = self.movingViewOriginalFrame;
        
    } completion:^(BOOL finished) {
        self.movingViewOriginalFrame = CGRectZero;
    }];
    
}


#pragma mark - range
- (NSRange) selectedRange {
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextRange* selectedRange = self.selectedTextRange;
    UITextPosition* selectionStart = selectedRange.start;
    UITextPosition* selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

// 备注：UITextField必须为第一响应者才有效
- (void) setSelectedRange:(NSRange) range {
    
    UITextPosition* beginning = self.beginningOfDocument;
    
    UITextPosition* startPosition = [self positionFromPosition:beginning offset:range.location];
    UITextPosition* endPosition = [self positionFromPosition:beginning offset:range.location + range.length];
    UITextRange* selectionRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    
    [self setSelectedTextRange:selectionRange];
}
 
@end
