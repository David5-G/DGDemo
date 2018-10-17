

#ifndef UIGestureRecognizer_api_h
#define UIGestureRecognizer_api_h
#endif

在iOS中添加手势可以归纳为以下几个步骤：

 

1、创建对应的手势对象；

2、设置手势识别属性【可选】；

3、附加手势到指定的对象；

4、编写手势操作方法；

 

一、UIGestureRecognizer有六个子类，分别为：

 

1、UITapGestureRecognizer（点击）

2、UIPanGestureRecognizer（拖移）

3、UIPinchGestureRecognizer（捏合）

4、UIRotationGestureRecognizer（旋转）

5、UISwipeGestureRecognizer（滑动）

6、UILongPressGestureRecognizer（长按）

 

//在这六种手势识别中，只有一种手势是离散手势，它就是UITapGestureRecgnier。

//离散手势的特点就是一旦识别就无法取消，而且只会调用一次手势操作事件（初始化手势时指定的触发方法）。

//换句话说其他五种手势是连续手势，连续手势的特点就是会多次调用手势操作事件，而且在连续手势识别后可以取消手势。

 

【UIGestureRecognizer.h】================

 

@protocolUIGestureRecognizerDelegate;

@class UIView, UIEvent,UITouch, UIPress;

 

typedef NS_ENUM(NSInteger,UIGestureRecognizerState) {
    
        UIGestureRecognizerStatePossible,   // 尚未识别是何种手势操作（但可能已经触发了触摸事件），默认状态
    
        UIGestureRecognizerStateBegan,      // 手势已经开始，此时已经被识别，但是这个过程中可能发生变化，手势操作尚未完成
    
        UIGestureRecognizerStateChanged,    // 手势状态发生转变
    
        UIGestureRecognizerStateEnded,      // 手势识别操作完成（此时已经松开手指）
    
        UIGestureRecognizerStateCancelled,  // 手势被取消，恢复到默认状态
    
        UIGestureRecognizerStateFailed,     // 手势识别失败，恢复到默认状态
    
     
    
        UIGestureRecognizerStateRecognized =UIGestureRecognizerStateEnded // 识手势识别完成，同UIGestureRecognizerStateEnded
    
};

 

NS_CLASS_AVAILABLE_IOS(3_2) @interface UIGestureRecognizer :NSObject

 

//UIGestureRecognizer类为其子类准备好了一个统一的初始化方法，无论什么样的手势动作，其执行的结果都是一样的：

//创建的时候就添加触摸事件

- (instancetype)initWithTarget:(nullable id)target action:(nullable SEL)actionNS_DESIGNATED_INITIALIZER;

//添加触摸执行事件

- (void)addTarget:(id)target action:(SEL)action;

//移除触摸执行事件

- (void)removeTarget:(nullable id)target action:(nullable SEL)action;

 

//设置手势的状态

@property(nonatomic,readonly)UIGestureRecognizerState state;

// 代理

@property(nullable,nonatomic,weak) id<UIGestureRecognizerDelegate> delegate;

//手势是否可用

@property(nonatomic, getter=isEnabled) BOOL enabled;

//触发手势的视图（一般在触摸执行操作中我们可以通过此属性获得触摸视图进行操作）

@property(nullable, nonatomic,readonly) UIView *view;

//默认为YES，当这个属性设置为YES时，如果识别到了手势，系统将会发送touchesCancelled:withEvent:消息在其时间传递链上，终止触摸事件的传递，设置为NO，则不会终止事件的传递，（即手势方法和 touchesBegain： touchesMove：都执行）

@property(nonatomic) BOOL cancelsTouchesInView;

 

//一个手势触发之前，是会一并发消息给事件传递链的，delaysTouchesBgan属性用于控制这个消息的传递时机，默认这个属性为NO，此时在触摸开始的时候，就会发消息给事件传递链，如果我们设置为YES，在触摸没有被识别失败前，都不会给事件传递链发送消息。

//手势识别失败前不执行触摸开始事件，默认为NO；如果为YES，那么成功识别则不执行触摸开始事件，失败则执行触摸开始事件；如果为NO，则不管成功与否都执行触摸开始事件；

@property(nonatomic) BOOL delaysTouchesBegan;

//手势识别结束后，是立刻发送touchesEnded消息到事件传递链或者等待一个很短的时间后，如果没有接收到新的手势识别任务，再发送。

@property(nonatomic) BOOL delaysTouchesEnded;

 

@property(nonatomic, copy) NSArray<NSNumber*> *allowedTouchTypes NS_AVAILABLE_IOS(9_0); // Array ofUITouchTypes as NSNumbers.

@property(nonatomic, copy) NSArray<NSNumber*> *allowedPressTypes NS_AVAILABLE_IOS(9_0); // Array ofUIPressTypes as NSNumbers.

 

// Indicates whetherthe gesture recognizer will consider touches of different touch typessimultaneously.

// If NO, it receivesall touches that match its allowedTouchTypes.

// If YES, once itreceives a touch of a certain type, it will ignore new touches of other types,until it is reset to UIGestureRecognizerStatePossible.

@property (nonatomic) BOOLrequiresExclusiveTouchType NS_AVAILABLE_IOS(9_2); // defaults to YES

 

//当手势冲突，触发是很随机的，如果我们想设置一下当手势互斥时要优先触发的手势，可以使用如下的方法：

//这个方法中第一个参数是需要时效的手势，第二个是生效的手势。

- (void)requireGestureRecognizerToFail:(UIGestureRecognizer*)otherGestureRecognizer;

 

// 获取手指相对于某一个视图位置；

-(CGPoint)locationInView:(nullable UIView*)view;

 

#ifUIKIT_DEFINE_AS_PROPERTIES

//触摸点的个数（就是同时触摸的手指个数）

@property(nonatomic, readonly) NSUInteger numberOfTouches;                                          // number of touchesinvolved for which locations can be queried

#else

-(NSUInteger)numberOfTouches;                                          // number of touchesinvolved for which locations can be queried

#endif

 

//获取手指相对于某一个视图位置

//方法中touchIndex是手指的序号（比如手势是两个手指触发，手指接触屏幕肯定有先后，第一个接触的系统内部自动给其标为第0个，第二个手指给其标记为第1个）

-(CGPoint)locationOfTouch:(NSUInteger)touchIndex inView:(nullable UIView*)view;

 

@end

 

 

@protocolUIGestureRecognizerDelegate <NSObject>

@optional

 

//开始进行手势识别时调用的方法，返回NO则结束，不再触发手势

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer;

 

//是否支持多时候触发，返回YES，则可以多个手势一起触发方法，返回NO则为互斥

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizershouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer;

 

//每次尝试识别手势都会调用，一般只会在手势冲突时候，比如同时添加轻击手势和长按手势，轻击手势设置代理，在区分是轻击手势或者长按手势还没有确定结果的时候调用，而不设置轻击手势代理而设置长按代理的时候就不会调用

//下面这个两个方法也是用来控制手势的互斥执行的

//这个方法返回YES，第一个手势和第二个互斥时，第一个会失效

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizershouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer NS_AVAILABLE_IOS(7_0);

//调用时机同上

//这个方法返回YES，第一个和第二个互斥时，第二个会失效

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizershouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer*)otherGestureRecognizer NS_AVAILABLE_IOS(7_0);

 

//在上面两个方法之前调用

//手指触摸屏幕后回调的方法，返回NO则不再进行手势识别，方法触发等

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch *)touch;

//同上

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceivePress:(UIPress *)press;

 

@end

 

 

【UITapGestureRecognizer.h】 【点击手势】==================

@interface UITapGestureRecognizer: UIGestureRecognizer

//设置点击次数，默认为单击

@property (nonatomic)NSUInteger  numberOfTapsRequired;

//设置同时点击的手指数

@property (nonatomic) NSUInteger  numberOfTouchesRequired __TVOS_PROHIBITED;

 

@end

 

【UIPinchGestureRecognizer.h】【捏合手势】==================

 

@interfaceUIPinchGestureRecognizer : UIGestureRecognizer

//设置缩放比例

@property (nonatomic)          CGFloat scale;

//设置捏合速度

@property (nonatomic,readonly) CGFloat velocity;

 

@end

 

【UIPanGestureRecognzer.h】【拖拽手势】==================

@interface UIPanGestureRecognizer: UIGestureRecognizer

//设置触发拖拽的最少触摸点，默认为1

@property (nonatomic)          NSUInteger minimumNumberOfTouches__TVOS_PROHIBITED;

//设置触发拖拽的最多触摸点

@property (nonatomic)          NSUInteger maximumNumberOfTouches__TVOS_PROHIBITED;

 

/**
 
  * locationInView和translationInView的区别
 
  *
 
  * translationInView 是UIPanGestureRecognizer 的属性
 
  * locationInView    是UIGestureRecognizer    的属性
 
  *
 
  * translationInView 获取到的是手指移动后，在相对坐标中的偏移量
 
  * locationInView    获取到的是手指点击屏幕实时的坐标点；
 
  */

//获取当前位置

-(CGPoint)translationInView:(nullable UIView *)view;

 

//设置当前位置

- (void)setTranslation:(CGPoint)translationinView:(nullable UIView *)view;

//设置拖拽速度

-(CGPoint)velocityInView:(nullable UIView *)view;

 

@end

 

【UISwipeGestureRecognizer.h】【滑动手势】==================

 

typedef NS_OPTIONS(NSUInteger,UISwipeGestureRecognizerDirection) {
    
        UISwipeGestureRecognizerDirectionRight = 1 << 0,
    
        UISwipeGestureRecognizerDirectionLeft  = 1 << 1,
    
        UISwipeGestureRecognizerDirectionUp    = 1 << 2,
    
        UISwipeGestureRecognizerDirectionDown  = 1 << 3
    
};

 

@interfaceUISwipeGestureRecognizer : UIGestureRecognizer

//设置触发滑动手势的触摸点数

@property(nonatomic) NSUInteger                        numberOfTouchesRequired__TVOS_PROHIBITED;

//设置滑动方向

@property(nonatomic)UISwipeGestureRecognizerDirection direction;

 

@end

 

【UIRotationGestureRecognizer.h】【旋转手势】=====================

 

@interface UIRotationGestureRecognizer: UIGestureRecognizer

//设置旋转角度

@property (nonatomic)          CGFloat rotation;

//设置旋转速度

@property (nonatomic,readonly) CGFloat velocity;

 

@end

 

【UILongPressGestureRecognizer.h】【长按手势】==================

 

@interfaceUILongPressGestureRecognizer : UIGestureRecognizer

//设置触发前的点击次数

@property (nonatomic) NSUIntegernumberOfTapsRequired;

//设置触发的触摸点数

@property (nonatomic) NSUIntegernumberOfTouchesRequired __TVOS_PROHIBITED;

//设置最短的长按时间

@property (nonatomic) CFTimeIntervalminimumPressDuration;

//设置在按触时时允许移动的最大距离默认为10像素

@property (nonatomic) CGFloatallowableMovement;

 

@end
---------------------
作者：吴福增
来源：CSDN
原文：https://blog.csdn.net/wufuzeng/article/details/53404082?utm_source=copy

