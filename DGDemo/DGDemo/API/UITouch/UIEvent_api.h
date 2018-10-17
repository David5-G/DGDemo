

#ifndef UIEvent_api_h
#define UIEvent_api_h

#endif


UIEvent【事件】属性和方法

官方文档：https://developer.apple.com/reference/uikit/uievent?language=objc#symbols

//触摸事件包括一个或者多个触摸(touches),每个触摸有一个UITouch对象表示。

//当触摸事件发生时，系统会通过触摸处理的逻辑找到合适的responder并把UIEvent对象传递过去。

//responder通过touchesBegan:withEvent:等方法去接收UIEvent对象。

 

@class UIWindow, UIView,UIGestureRecognizer, UITouch;

//三种事件类型

typedef NS_ENUM(NSInteger,UIEventType) {
    
        UIEventTypeTouches,         //触摸事件
    
        UIEventTypeMotion,           //运动事件
    
        UIEventTypeRemoteControl,   //远程控制事件
    
        UIEventTypePresses NS_ENUM_AVAILABLE_IOS(9_0), //物理按钮事件类型
    
};

 

//事件亚类型

typedef NS_ENUM(NSInteger,UIEventSubtype) {
    
       
    
        UIEventSubtypeNone                              = 0,//触摸事件的亚类型
    
        UIEventSubtypeMotionShake                       = 1,//摇晃
    
       
    
        UIEventSubtypeRemoteControlPlay                  = 100,//播放
    
        UIEventSubtypeRemoteControlPause                 = 101,//暂停
    
        UIEventSubtypeRemoteControlStop                 = 102,//停止
    
       UIEventSubtypeRemoteControlTogglePlayPause      = 103,//播放和暂停切换
    
        UIEventSubtypeRemoteControlNextTrack            = 104,//下一首
    
       UIEventSubtypeRemoteControlPreviousTrack        = 105,//上一首
    
       UIEventSubtypeRemoteControlBeginSeekingBackward = 106,//开始后退
    
       UIEventSubtypeRemoteControlEndSeekingBackward   = 107,//结束后退
    
       UIEventSubtypeRemoteControlBeginSeekingForward  = 108,//开始快进
    
       UIEventSubtypeRemoteControlEndSeekingForward    = 109,//结束快进
    
};

 

@interface UIEvent : NSObject

 

//事件类型

@property(nonatomic,readonly) UIEventType     type NS_AVAILABLE_IOS(3_0);

//事件亚类型

@property(nonatomic,readonly) UIEventSubtype  subtype NS_AVAILABLE_IOS(3_0);

//事件产生的时间

@property(nonatomic,readonly) NSTimeInterval  timestamp;

#ifUIKIT_DEFINE_AS_PROPERTIES

//所有的触摸

@property(nonatomic,readonly, nullable) NSSet <UITouch*> *allTouches;

#else

//所有的触摸

- (nullable NSSet <UITouch*> *)allTouches;

#endif

//获得UIWindow的触摸

- (nullable NSSet <UITouch*> *)touchesForWindow:(UIWindow *)window;

//获得UIView的触摸

- (nullable NSSet <UITouch*> *)touchesForView:(UIView *)view;

//获取事件中特定手势的触摸

- (nullable NSSet <UITouch*> *)touchesForGestureRecognizer:(UIGestureRecognizer *)gestureNS_AVAILABLE_IOS(3_2);

//会将丢失的触摸放到一个新的 UIEvent数组中，你可以用coalescedTouchesForTouch(_:)方法来访问

- (nullable NSArray <UITouch*> *)coalescedTouchesForTouch:(UITouch *)touch NS_AVAILABLE_IOS(9_0);

//辅助UITouch的触摸，预测发生了一系列主要的触摸事件。这些预测可能不完全匹配的触摸的真正的行为，因为它的移动，所以他们应该被解释为一个估计。

- (nullable NSArray <UITouch*> *)predictedTouchesForTouch:(UITouch *)touch NS_AVAILABLE_IOS(9_0);

 

@end
---------------------
作者：吴福增
来源：CSDN
原文：https://blog.csdn.net/wufuzeng/article/details/53406467?utm_source=copy

