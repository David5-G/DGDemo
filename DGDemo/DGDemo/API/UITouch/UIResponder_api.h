
#ifndef UIResponder_Api_h
#define UIResponder_Api_h
#endif

UIResponder.h

//官方API参考说明网址：https://developer.apple.com/reference/uikit/uiresponder?language=objc#symbols

NS_ASSUME_NONNULL_BEGIN

@class UIPress;

@class UIPressesEvent;

@protocol UIResponderStandardEditActions<NSObject>

@optional

//剪切

- (void)cut:(nullableid)senderNS_AVAILABLE_IOS(3_0);

//复制

- (void)copy:(nullableid)senderNS_AVAILABLE_IOS(3_0);

//粘贴

- (void)paste:(nullableid)senderNS_AVAILABLE_IOS(3_0);

//选择

- (void)select:(nullableid)senderNS_AVAILABLE_IOS(3_0);

//全选

- (void)selectAll:(nullableid)senderNS_AVAILABLE_IOS(3_0);

//删除

- (void)delete:(nullableid)senderNS_AVAILABLE_IOS(3_2);

//从左到右写入字符串(居左)

- (void)makeTextWritingDirectionLeftToRight:(nullableid)senderNS_AVAILABLE_IOS(5_0);

//从右到左写入字符串(居右)

- (void)makeTextWritingDirectionRightToLeft:(nullableid)senderNS_AVAILABLE_IOS(5_0);

//切换字体为黑体(粗体)

- (void)toggleBoldface:(nullableid)senderNS_AVAILABLE_IOS(6_0);

//切换字体为斜体

- (void)toggleItalics:(nullableid)senderNS_AVAILABLE_IOS(6_0);

//给文字添加下划线

- (void)toggleUnderline:(nullableid)senderNS_AVAILABLE_IOS(6_0);

//增加字体大小

- (void)increaseSize:(nullableid)senderNS_AVAILABLE_IOS(7_0);

//减小字体大小

- (void)decreaseSize:(nullableid)senderNS_AVAILABLE_IOS(7_0);

 

@end

 

@interface UIResponder : NSObject<UIResponderStandardEditActions>

#ifUIKIT_DEFINE_AS_PROPERTIES

//下一个响应者

@property(nonatomic,readonly, nullable) UIResponder*nextResponder;

#else

//返回接收下一个响应者，或者nil如果它有没有。

- (nullableUIResponder*)nextResponder;

#endif

 

#ifUIKIT_DEFINE_AS_PROPERTIES

//是否可以成为第一个响应者

@property(nonatomic,readonly) BOOLcanBecomeFirstResponder;   // default is NO

#else

//返回一个布尔值指出接收者是否可以成为第一个响应者。

- (BOOL)canBecomeFirstResponder;   // default is NO

#endif

//通知接收器，它是即将成为第一响应在其窗口。

- (BOOL)becomeFirstResponder;

 

#ifUIKIT_DEFINE_AS_PROPERTIES

//是否愿意放弃第一响应状态。

@property(nonatomic,readonly) BOOLcanResignFirstResponder;   // default is YES

#else

//返回一个布尔值，指示接收者是否愿意放弃第一响应状态。

- (BOOL)canResignFirstResponder;   // default is YES

#endif

//通知接收器，它已被要求放弃在其窗口第一个响应者的地位。

- (BOOL)resignFirstResponder;

 

#ifUIKIT_DEFINE_AS_PROPERTIES

//是否是第一响应者

@property(nonatomic,readonly) BOOL isFirstResponder;

#else

//返回一个布尔值指出接收者是否是第一个响应者。

- (BOOL)isFirstResponder;

#endif

 

//响应触摸事件 -----

//告诉当一个或多个手指触摸到了视图或者窗口响应。

- (void)touchesBegan:(NSSet<UITouch*> *)touches withEvent:(nullable UIEvent *)event;

//讲述当用图或窗口内的事件移动相关联的一个或更多个手指的响应者。

- (void)touchesMoved:(NSSet<UITouch*> *)touches withEvent:(nullable UIEvent *)event;

//讲述当一个或多个手指从视图或窗口所提出的应答。

- (void)touchesEnded:(NSSet<UITouch*> *)touches withEvent:(nullable UIEvent *)event;

//发送到应答时，系统事件（如低存储器警告）取消的触摸事件。

- (void)touchesCancelled:(NSSet<UITouch*> *)touches withEvent:(nullable UIEvent *)event;

//发送到应答器时的触摸所估计的特性发生了改变，使它们不再估计或更新不再预期。

- (void)touchesEstimatedPropertiesUpdated:(NSSet<UITouch*> *)touches NS_AVAILABLE_IOS(9_1);

  

//响应新闻发布会  ---

//发送到时，在相关联的视图被按压物理按钮接收机。

- (void)pressesBegan:(NSSet<UIPress*> *)presses withEvent:(nullable UIPressesEvent *)eventNS_AVAILABLE_IOS(9_0);

//发送到接收器时，force压在相关的视图已经改变。

- (void)pressesChanged:(NSSet<UIPress*> *)presses withEvent:(nullable UIPressesEvent *)eventNS_AVAILABLE_IOS(9_0);

//发送到接收器时，force压在相关的视图已经改变。

- (void)pressesEnded:(NSSet<UIPress*> *)presses withEvent:(nullable UIPressesEvent *)eventNS_AVAILABLE_IOS(9_0);

//送到时，系统事件（例如低内存报警）取消了新闻事件的接收器。

- (void)pressesCancelled:(NSSet<UIPress*> *)presses withEvent:(nullable UIPressesEvent *)eventNS_AVAILABLE_IOS(9_0);

 

//响应运动事件 -----

//告诉一个移动事件已经开始接收器。

- (void)motionBegan:(UIEventSubtype)motionwithEvent:(nullable UIEvent *)event NS_AVAILABLE_IOS(3_0);

//告诉运动活动已结束的接收器。

- (void)motionEnded:(UIEventSubtype)motionwithEvent:(nullable UIEvent *)event NS_AVAILABLE_IOS(3_0);

//告诉运动活动已经取消了接收器。

- (void)motionCancelled:(UIEventSubtype)motionwithEvent:(nullable UIEvent *)event NS_AVAILABLE_IOS(3_0);

 

//响应远程控制活动----

//发送到当接收到远程控制事件的接收机。

- (void)remoteControlReceivedWithEvent:(nullable UIEvent *)eventNS_AVAILABLE_IOS(4_0);

 

//验证命令 ----

//请接收响应启用或在用户界面中关闭指定的命令。

//通过这个方法告诉UIMenuController它内部应该显示什么内容,”复制”、”粘贴”等

- (BOOL)canPerformAction:(SEL)action withSender:(nullableid)senderNS_AVAILABLE_IOS(3_0);

//返回响应的操作目标对象。

//默认的实现是调用canPerformAction:withSender:方法来确定对象是否可以调用action操作。如果我们想要重写目标的选择方式，则应该重写这个方法。

- (nullable id)targetForAction:(SEL)action withSender:(nullableid)senderNS_AVAILABLE_IOS(7_0);



//获取撤消经理 ---

//返回响应链就近共享撤消管理。

//UIResponder提供了一个只读方法来获取响应链中共享的undo管理器，公共的事件撤销管理者

@property(nullable,nonatomic,readonly) NSUndoManager*undoManager NS_AVAILABLE_IOS(3_0);

 

@end

//响应者支持的快捷键

typedef NS_OPTIONS(NSInteger,UIKeyModifierFlags) {
    
        UIKeyModifierAlphaShift     = 1 <<16,  // Alppha+Shift键
    
        UIKeyModifierShift          = 1 <<17,  //Shift键
    
        UIKeyModifierControl        = 1 <<18,  //Control键
    
        UIKeyModifierAlternate      = 1 <<19,  //Alt键
    
        UIKeyModifierCommand        = 1 <<20,  //Command键
    
        UIKeyModifierNumericPad     = 1 <<21,  //Num键
    
}NS_ENUM_AVAILABLE_IOS(7_0);

 

@interface UIKeyCommand :NSObject <NSCopying, NSSecureCoding>

 

- (instancetype)initNS_DESIGNATED_INITIALIZER;

- (nullable instancetype)initWithCoder:(NSCoder*)aDecoder NS_DESIGNATED_INITIALIZER;

//输入字符串

@property (nonatomic,readonly) NSString *input;

//按键调节器

@property (nonatomic,readonly) UIKeyModifierFlagsmodifierFlags;

//按指定调节器键输入字符串并设置事件

@property (nullable,nonatomic,copy) NSString*discoverabilityTitle NS_AVAILABLE_IOS(9_0);

 

// The action forUIKeyCommands should accept a single (id)sender, as do theUIResponderStandardEditActions above

// Creates an keycommand that will _not_ be discoverable in the UI.

+ (UIKeyCommand*)keyCommandWithInput:(NSString *)inputmodifierFlags:(UIKeyModifierFlags)modifierFlags action:(SEL)action;

 

// Key Commands witha discoverabilityTitle _will_ be discoverable in the UI.

+ (UIKeyCommand*)keyCommandWithInput:(NSString *)inputmodifierFlags:(UIKeyModifierFlags)modifierFlags action:(SEL)actiondiscoverabilityTitle:(NSString *)discoverabilityTitle NS_AVAILABLE_IOS(9_0);

 

@end

 

//访问可用键盘命令---

@interface UIResponder(UIResponderKeyCommands)

 

//触发这一行动响应的关键命令。

//组合快捷键命令(装有多个按键的数组)

@property (nullable,nonatomic,readonly)NSArray<UIKeyCommand *> *keyCommands NS_AVAILABLE_IOS(7_0);// returns an arrayof UIKeyCommand objects<

@end

 

@class UIInputViewController;

@class UITextInputMode;

@classUITextInputAssistantItem;

 

//管理文本输入模式----

@interface UIResponder(UIResponderInputViewAdditions)

 

//显示自定义输入视图当接收机成为第一个响应者。//键盘输入视图(系统默认的,可以自定义)

@property (nullable,nonatomic, readonly,strong) __kindof UIView *inputViewNS_AVAILABLE_IOS(3_2);

//要显示的自定义输入附件视图时，接收器成为第一个响应者。//弹出键盘时附带的视图

@property (nullable,nonatomic, readonly,strong) __kindof UIView*inputAccessoryView NS_AVAILABLE_IOS(3_2);

 

//输入助手配置键盘的快捷方式栏时使用。

@property (nonnull,nonatomic, readonly,strong)UITextInputAssistantItem *inputAssistantItem NS_AVAILABLE_IOS(9_0) __TVOS_PROHIBITED__WATCHOS_PROHIBITED;

 

//当接收机成为第一个响应者使用自定义输入视图控制器。

@property (nullable,nonatomic, readonly,strong) UIInputViewController*inputViewController NS_AVAILABLE_IOS(8_0);

//显示自定义输入附件视图控制器当接收机成为第一个响应者。

@property (nullable,nonatomic, readonly,strong) UIInputViewController*inputAccessoryViewController NS_AVAILABLE_IOS(8_0);

 

//文本输入此响应的对象。

@property (nullable,nonatomic, readonly,strong) UITextInputMode*textInputMode NS_AVAILABLE_IOS(7_0);

//标识符表示该响应应保留其文本输入方式的信息。

@property (nullable,nonatomic, readonly,strong) NSString*textInputContextIdentifier NS_AVAILABLE_IOS(7_0);

//清除从应用程序的用户默认文本输入模式的信息。

+ (void)clearTextInputContextIdentifier:(NSString*)identifier NS_AVAILABLE_IOS(7_0);

 

//更新自定义输入及配件的意见时，对象是第一个响应。

- (void)reloadInputViewsNS_AVAILABLE_IOS(3_2);

 

@end

 

// 按键输入箭头指向

UIKIT_EXTERN NSString *const UIKeyInputUpArrow         NS_AVAILABLE_IOS(7_0);

UIKIT_EXTERN NSString *constUIKeyInputDownArrow      NS_AVAILABLE_IOS(7_0);

UIKIT_EXTERN NSString *constUIKeyInputLeftArrow       NS_AVAILABLE_IOS(7_0);

UIKIT_EXTERN NSString *constUIKeyInputRightArrow     NS_AVAILABLE_IOS(7_0);

UIKIT_EXTERN NSString *const UIKeyInputEscape          NS_AVAILABLE_IOS(7_0);

 

//支持用户活动 ---- //响应者类的类目:

@interface UIResponder(ActivityContinuation)

//用户活动

@property (nullable,nonatomic, strong) NSUserActivity*userActivity NS_AVAILABLE_IOS(8_0);

//更新用户活动

- (void)updateUserActivityState:(NSUserActivity*)activity NS_AVAILABLE_IOS(8_0);

//恢复用户活动

- (void)restoreUserActivityState:(NSUserActivity*)activity NS_AVAILABLE_IOS(8_0);

@end
---------------------
作者：吴福增
来源：CSDN
原文：https://blog.csdn.net/wufuzeng/article/details/53405624?utm_source=copy

