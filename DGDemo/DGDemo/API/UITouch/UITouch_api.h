
#ifndef UITouch_api_h
#define UITouch_api_h

#endif


UITouch.h【触摸】

官方API网址: https://developer.apple.com/reference/uikit/uitouch?language=objc#symbols

//当用户用一根手指触摸屏幕时，会创建一个与手指相关联的UITouch对象,一根手指对应一个UITouch对象

//UITouch的作用保存着跟手指相关的信息，比如触摸的位置、时间、阶段

//当手指移动时，系统会更新同一个UITouch对象，使之能够一直保存该手指在的触摸位置,当手指离开屏幕时，系统会销毁相应的UITouch对象

//提示：iPhone开发中，要避免使用双击事件！

//当手指接触到屏幕，不管是单点触摸还是多点触摸，事件都会开始，直到用户所有的手指都离开屏幕。期间所有的UITouch对象都被包含在UIEvent事件对象中，由程序分发给处理者。事件记录了这个周期中所有触摸对象状态的变化。

//只要屏幕被触摸，系统就会报若干个触摸的信息封装到UIEvent对象中发送给程序，由管理程序UIApplication对象将事件分发。一般来说，事件将被发给主窗口，然后传给第一响应者对象(FirstResponder)处理。

 

@class UIWindow, UIView,UIGestureRecognizer;

//触摸状态

typedef NS_ENUM(NSInteger,UITouchPhase) {
    
        UITouchPhaseBegan,             //触摸开始.
    
        UITouchPhaseMoved,             //接触点移动.
    
        UITouchPhaseStationary,        //接触点无移动.
    
        UITouchPhaseEnded,             //触摸结束.
    
        UITouchPhaseCancelled,         //触摸取消
    
};

 

//在iOS9中提供如下的接口用于检查设备是否支持3D Touch：

typedef NS_ENUM(NSInteger,UIForceTouchCapability) {
    
       UIForceTouchCapabilityUnknown = 0,     //3D Touch检测失败
    
        UIForceTouchCapabilityUnavailable = 1,  //3D Touch不可用
    
        UIForceTouchCapabilityAvailable = 2     //3D Touch可用
    
};

//触摸类型

typedef NS_ENUM(NSInteger,UITouchType) {
    
        UITouchTypeDirect,                       //直接触摸
    
        UITouchTypeIndirect,                     // 间接触摸
    
        UITouchTypeStylus NS_AVAILABLE_IOS(9_1),// 笔触摸
    
}NS_ENUM_AVAILABLE_IOS(9_0);

 

//触摸特性

typedef NS_OPTIONS(NSInteger,UITouchProperties) {
    
        UITouchPropertyForce = (1UL <<0),      //力度
    
        UITouchPropertyAzimuth = (1UL <<1),    //方位
    
        UITouchPropertyAltitude = (1UL <<2),   //高度
    
        UITouchPropertyLocation = (1UL <<3),   //位置
    
} NS_AVAILABLE_IOS(9_1);

 

@interface UITouch : NSObject

 

//时间戳记录了触摸事件产生或变化时的时间。单位是秒。

@property(nonatomic,readonly) NSTimeInterval      timestamp;

//触摸事件在屏幕上有一个周期，即触摸开始、触摸点移动、触摸结束，还有中途取消。通过phase可以查看当前触摸事件在一个周期中所处的状态。

@property(nonatomic,readonly) UITouchPhase        phase;

//轻击（Tap）操作和鼠标的单击操作类似，tapCount表示短时间内轻击屏幕的次数。因此可以根据tapCount判断单击、双击或更多的轻击。

@property(nonatomic,readonly) NSUInteger          tapCount;

//触摸的类型

@property(nonatomic,readonly) UITouchType         type NS_AVAILABLE_IOS(9_0);

//触摸的半径

@property(nonatomic,readonly) CGFloat majorRadiusNS_AVAILABLE_IOS(8_0);

//触摸半径的容差（点）。

@property(nonatomic,readonly) CGFloatmajorRadiusTolerance NS_AVAILABLE_IOS(8_0);

//触摸产生时所处的窗口。由于窗口可能发生变化，当前所在的窗口不一定是最开始的窗口。

@property(nullable,nonatomic,readonly,strong) UIWindow                        *window;

//触摸产生时所处的视图。由于视图可能发生变化，当前视图也不一定时最初的视图。

@property(nullable,nonatomic,readonly,strong) UIView                          *view;

//正在接收触摸对象的手势识别。

@property(nullable,nonatomic,readonly,copy)   NSArray <UIGestureRecognizer *>*gestureRecognizers NS_AVAILABLE_IOS(3_2);

  

//现在触摸的坐标//函数返回一个CGPoint类型的值，表示触摸在view这个视图上的位置，这里返回的位置是针对view的坐标系的。调用时传入的view参数为空的话，返回的时触摸点在整个窗口的位置。

-(CGPoint)locationInView:(nullable UIView *)view;

 

//上一次触摸的坐标//该方法记录了前一个坐标值，函数返回也是一个CGPoint类型的值，表示触摸在view这个视图上的位置，这里返回的位置是针对view的坐标系的。调用时传入的view参数为空的话，返回的时触摸点在整个窗口的位置。

-(CGPoint)previousLocationInView:(nullable UIView *)view;

//现在触摸的精确的坐标

-(CGPoint)preciseLocationInView:(nullable UIView *)viewNS_AVAILABLE_IOS(9_1);

//上一次触摸的精确的坐标

-(CGPoint)precisePreviousLocationInView:(nullable UIView *)viewNS_AVAILABLE_IOS(9_1);

 

//触摸的力度

@property(nonatomic,readonly) CGFloat forceNS_AVAILABLE_IOS(9_0);

//触摸的最大的力度

@property(nonatomic,readonly) CGFloatmaximumPossibleForce NS_AVAILABLE_IOS(9_0);

 

//沿着x轴正向的方位角,当与x轴正向方向相同时,该值为0;当view参数为nil时，默认为keyWindow返回触针的方位角（弧度）。

-(CGFloat)azimuthAngleInView:(nullable UIView *)viewNS_AVAILABLE_IOS(9_1);

//当前触摸对象的方向上的单位向量当view参数为nil时，默认为keyWindow返回在触针的方位角的方向指向的单位矢量。

-(CGVector)azimuthUnitVectorInView:(nullable UIView *)viewNS_AVAILABLE_IOS(9_1);

 

//当笔平行于平面时,该值为0

//当笔垂直于平面时,该值为Pi / 2

//触针的高度（单位为弧度）。

@property(nonatomic,readonly) CGFloat altitudeAngleNS_AVAILABLE_IOS(9_1);

 

//当每个触摸对象的触摸特性发生变化时，该值将会单独增加,返回值是NSNumber 索引号，让您关联与原来的触摸更新的联系

@property(nonatomic,readonly) NSNumber *_Nullable estimationUpdateIndexNS_AVAILABLE_IOS(9_1);

//当前触摸对象估计的触摸特性,返回值是UITouchPropertyies一组触摸属性，这些属性将得到更新。

@property(nonatomic,readonly) UITouchPropertiesestimatedProperties NS_AVAILABLE_IOS(9_1);

//一组期望在未来的更新报文的触摸性能。

@property(nonatomic,readonly) UITouchPropertiesestimatedPropertiesExpectingUpdates NS_AVAILABLE_IOS(9_1);



@end
---------------------
作者：吴福增
来源：CSDN
原文：https://blog.csdn.net/wufuzeng/article/details/53405792?utm_source=copy

