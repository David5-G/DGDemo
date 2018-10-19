

#ifndef Summary_api_h
#define Summary_api_h

#endif


关于响应者的概念，通过以下几点说明：

//响应者对象（Response object）
响应者对象就是可以响应事件并对事件作出处理。在iOS中，存在UIResponder类，它定义了响应者对象的所有方法。UIApplication、UIView等类都继承了UIResponder类，UIWindow和UIKit中的控件因为继承了UIView，所以也间接继承了UIResponder类，这些类的实例都可以当作响应者。

//第一响应者（First responder）:
当前接受触摸的响应者对象被称为第一响应者，即表示当前该对象正在与用户交互，它是响应者链的开端。

//响应者链（Responder chain）:
响应者链表示一系列的响应者对象。事件被交由第一响应者对象处理，如果第一响应者不处理，事件被沿着响应者链向上传递，交给下一个响应者（next responder）。一般来说，第一响应者是个视图对象或者其子类对象，当其被触摸后事件被交由它处理，如果它不处理，事件就会被传递给它的视图控制器对象（如果存在），然后是它的父视图（superview）对象（如果存在），以此类推，直到顶层视图。接下来会沿着顶层视图（top view）到窗口（UIWindow对象）再到程序（UIApplication对象）。如果整个过程都没有响应这个事件，该事件就被丢弃。一般情况下，在响应者链中只要由对象处理事件，事件就停止传递。但有时候可以在视图的响应方法中根据一些条件判断来决定是否需要继续传递事件。



//管理事件分发

视图对触摸事件是否需要作处回应可以通过设置视图的userInteractionEnabled属性。默认状态为YES，如果设置为NO，可以阻止视图接收和分发触摸事件。除此之外，当视图被隐藏（setHidden：YES）或者透明（alpha值为0）也不会收事件。不过这个属性只对视图有效，如果想要整个程序都步响应事件，可以调用UIApplication的beginIngnoringInteractionEvents方法来完全停止事件接收和分发。通过endIngnoringInteractionEvents方法来恢复让程序接收和分发事件。如果要让视图接收多点触摸，需要设置它的multipleTouchEnabled属性为YES，默认状态下这个属性值为NO，即视图默认不接收多点触摸。







//处理用户的触摸事件

//首先触摸的对象是视图，而视图的类UIView继承了UIRespnder类，但是要对事件作出处理，还需要重写UIResponder类中定义的事件处理函数。根据不通的触摸状态，程序会调用相应的处理函数，这些函数包括以下几个：

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event;

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event;

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event;

-(void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent *)event;

//当手指接触屏幕时，就会调用touchesBegan:withEvent方法；

//当手指在屏幕上移时，动就会调用touchesMoved:withEvent方法；

//当手指离开屏幕时，就会调用touchesEnded:withEvent方法；

//当触摸被取消（比如触摸过程中被来电打断），就会调用touchesCancelled:withEvent方法。而这几个方法被调用时，正好对应了UITouch类中phase属性的4个枚举值。

//

//上面的四个事件方法，在开发过程中并不要求全部实现，可以根据需要重写特定的方法。对于这4个方法，都有两个相同的参数：NSSet类型的touches和UIEvent类型的event。其中touches表示触摸产生的所有UITouch对象，而event表示特定的事件。因为UIEvent包含了整个触摸过程中所有的触摸对象，

//因此可以调用allTouches方法获取该事件内所有的触摸对象，

//也可以调用touchesForVIew：

//或者touchesForWindows：取出特定视图或者窗口上的触摸对象。

//在这几个事件中，都可以拿到触摸对象，然后根据其位置，状态，时间属性做逻辑处理。



//下面是移动某一个试图内的子视图的小动画的实现效果，代码不全，精髓在其中：

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event

{
    
    UITouch *touch = [touches anyObject];
    
    if([self.viewpointInside:[touch locationInView:rollView] withEvent:nil]) originLocation =[touch locationInView:self.view];
        
        }



-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event

{
    
    UITouch *touch = [touches anyObject];
    
    if([self.viewpointInside:[touch locationInView:rollView] withEvent:nil])
        
    {
        
        CGPoint currentLocation = [touchlocationInView:self.view];
        
        CGRect frame = rollLabel.frame;
        
        
        
        frame.origin.x = currentLocation.x -originLocation.x;
        
        
        
        if(frame.origin.x < -10)frame.origin.x = -10;
            
            if(frame.origin.x >rollView.frame.size.width)frame.origin.x = rollView.frame.size.width;
                
                frame.origin.y = labelLocation.y;
                
                rollLabel.frame = frame;
                
                }
    
}



//下面是在ios开发中常见的功能。即touch移动事件，是移动到当前视图的子视图中，还是移动到当前视图以外了。办法是，继承UIView，覆盖touchesMoved方法：

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event{
    
    UITouch *touch=[touches anyObject];
    
    if (![self pointInside:[touchlocationInView:self] withEvent:nil])
        
    {
        
        NSLog(@"移动到当前视图以外了");
        
    }
    
    else
        
    {
        
        UIView *hitView=[self hitTest:[[touchesanyObject] locationInView:self] withEvent:nil];
        
        if (hitView==self)
            
        {
            
            NSLog(@"移动到当前视图中");
            
        }
        
        else
            
        {
            
            NSLog(@"移动到当前视图的子视图中");
            
        }
        
    }
    
}



//  =======项目实践=========



//下面的代码示例了对消息处理方法的声明让进行双击操作时增加所点击视图的大小而单击操作时减少所点击视图的大小。

//当点击的次数为2时,响应者对象通过调用NSObject类的cancelPerformRequestsWithTarget:方法取消被挂起的延迟调用。

//如果点击次数不为2,则在延迟时间到达后,将会调用选择子所指定的单击事件处理方法。

- (void)touchesBegan:(NSSet*)toucheswithEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    if (2== touch.tapCount) {
        
        [NSObjectcancelPreviousPerformRequestsWithTarget:self];
        
    }
    
}

- (void)touchesMoved:(NSSet*)toucheswithEvent:(UIEvent *)event { }



//当点击的次数为1时,响应者对象向其自身发送performSelector:withObject:afterDelay:消息。选择子标识了对单击事件响应的方法;第二个参数是一个NSValue或NSDictionary对象,用来保存UITouch对象的一些状态;延迟时间是表示单击和双击之间有意义的时间间隔。

//注:因为touch对象在触摸序列的处理中是可变的,所以你不能retain一个touch对象并假设它的状态不会发生改变(你也不能拷贝一个touch对象,因为其没有申明NSCopying协议)。但如果你需要保存touch对象的某些状态,你需要将touch对象的状态用NSVaule对象,字典对象或其它类似对象进行保存。

//当点击的次数为2时,响应者对双击的操作进行处理。

- (void)touchesEnded:(NSSet*)toucheswithEvent:(UIEvent *)event {
    
    UITouch*touch = [touches anyObject];
    
    if (1== touch.tapCount)
        
    {
        
        NSDictionary *touchLoc =[NSDictionarydictionaryWithObject:[NSValuevalueWithCGPoint:[touchlocationInView:self]]
                                 
                                                           forKey:@"location"];
        
        [self performSelector:@selector(handleSingleTap:)
         
                   withObject:touchLoc
         
                   afterDelay:0.3];}
    
    else if (2== touch.tapCount)
        
    {
        
        //double-tap:increase view size by 10%
        
        CGRect viewFrame = self.frame;
        
        viewFrame.size.width+= self.frame.size.width* 0.1;
        
        viewFrame.size.height+= self.frame.size.height* 0.1;
        
        viewFrame.origin.x-= (self.frame.origin.x* 0.1)/2.0;
        
        viewFrame.origin.y-= (self.frame.origin.y* 0.1)/2.0;
        
        
        
        [UIView beginAnimations:nilcontext:NULL];[selfsetFrame:viewFrame];
        
        [UIView commitAnimations];
        
    }
    
}







- (void)touchesCancelled:(NSSet*)toucheswithEvent:(UIEvent *)event { }



- (void)handleSingleTap:(NSDictionary*)touches{//Single-tap: decrease view size by 10%
    
    
    
    CGRect viewFrame = self.frame;
    
    viewFrame.size.width-= self.frame.size.width* 0.1;
    
    viewFrame.size.height-= self.frame.size.height* 0.1;
    
    viewFrame.origin.x+= (self.frame.origin.x* 0.1)/2.0;
    
    viewFrame.origin.y+= (self.frame.origin.y* 0.1)/2.0;
    
    
    
    [UIView beginAnimations:nilcontext:NULL];[selfsetFrame:viewFrame];
    
    [UIView commitAnimations];
    
}



//----------处理滑动或拖动手势 -------

//水平或垂直方面的滑动属于简单的手势,你可以在你的代码中进行跟踪并对其进行处理。要检测一个滑动手势,你必须跟踪与所希望的移动轴相反的用户手指的移动,但是滑动的组成最终还是由你来决定。换句话说,你需要确定用户手指是否移动的足够远,是否以直线方式向前移动,是否移动的足够快。要对上述的内容进行判断,你要存储下初始时的触摸位置,然后与touch-moved事件中位置进行比较。



//下面的代码示例了一些基本的跟踪方法用于判断视图上进行水平方向的滑动。

//在这个例子中首先将触摸的初始位置存储到startTouchPosition实例变量中。

//当用户移动手指,代码对当前的触摸位置与初始触摸位置进行比较来确定是否为滑动操作。

//如果手指在垂直方向上移动了太多的距离,则不认为是一次滑动而进行不同的处理。

//一旦滑动足够远并被认为是一个完整的手势时会调用相应的操作。

//要在垂直方向上判断滑动操作,你也可以使用类似的代码,只不过对对X和Y方向进行交换。

- (void)touchesBegan:(NSSet*)toucheswithEvent:(UIEvent *)event {UITouch*touch = [touches anyObject];
    
    startTouchPosition = [touch locationInView:self];
    
}

- (void)touchesMoved:(NSSet*)toucheswithEvent:(UIEvent *)event {UITouch*touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touchlocationInView:self];
    
    if ((fabs(startTouchPosition.x- currentTouchPosition.x)>=HORIZ_SWIPE_DRAG_MIN) &&
        
        (fabs(startTouchPosition.y-currentTouchPosition.y) <=VERT_SWIPE_DRAG_MIN))
        
    {
        
        if(startTouchPosition.x< currentTouchPosition.x)
            
        {
            
            NSLog(@"swipe toright");
            
        }
        
        else
            
        {
            
            NSLog(@"swipe toleft");
            
        }
        
    }
    
}



-  (void)touchesEnded:(NSSet*)toucheswithEvent:(UIEvent *)event {startTouchPosition= CGPointZero;
    
}

-  (void)touchesCancelled:(NSSet*)toucheswithEvent:(UIEvent *)event {startTouchPosition= CGPointZero;
    
}



// 下面的代码是一个更简单的单触摸事件的跟踪,这次则是用来对拖动进行处理。

- (void)touchesBegan:(NSSet*)toucheswithEvent:(UIEvent *)event {
    
}



//对本次位置和上次位置取差值。然后使用差值来重新设置视图的位置。

- (void)touchesMoved:(NSSet*)toucheswithEvent:(UIEvent *)event {
    
    UITouch*touch = [touches anyObject];
    
    CGPoint currentTouchPosition = [touchlocationInView:self];
    
    CGPointprevTouchPosition = [touchpreviousLocationInView:self];
    
    CGRect viewFrame = self.frame;
    
    float deltaX =currentTouchPosition.x- prevTouchPosition.x;
    
    floatdeltaY = currentTouchPosition.y -prevTouchPosition.y;
    
    viewFrame.origin.x+= deltaX;
    
    viewFrame.origin.y+= deltaY;
    
    [self setFrame:viewFrame];
    
}



- (void)touchesEnded:(NSSet*)toucheswithEvent:(UIEvent *)event {}



- (void)touchesCancelled:(NSSet*)toucheswithEvent:(UIEvent *)event {}





//----- 处理复杂的多点触摸序列-------



//点击、拖动、滑动只是简单的手势,通常只涉及一次触摸。要对两个或两个以上的触摸事件进行处理则更为复杂。你可能要跟踪在整个触摸阶段的所有触摸,记录被更改的触摸属性以及更改内部状态为合适值。

//为了能对多触摸事件进行跟踪和处理还需要做如下的事情:

//· 设置视图的multipleTouchEnabled属性为YES

//· 使用CoreFoundation的字典对象(CFDictionaryRef)在事件过程的各阶段中跟踪触摸的改变当处理一个多触摸事件时,你经常会存储每个触摸的最初状态以用于以后的比较。



//作为例子,你将对每个触摸的最后位置与初始位置进行比较。

//在touchesBegan:withEvent:方法中,你将从locationInView:方法加获得每个触摸的初始位置并将这些位置以UITouch对象的地址作为键值存储到CFDictionaryRef对象中。

//在touchesEnded:withEvent:方法中,你将从字典对象中取出初始位置值并与当前位置值进行比较(你应该使用CFDictionaryRef对象而非NSDictionary对象,后一个对象对键值进行拷贝操作,但UITouch对象并没有申明用于对象拷贝的NSCopying协议)。



//下面的代码示例了使用Core Foundation字典对象对初始位置进行存储。

- (void)cacheBeginPointForTouches:(NSSet*)touches {if ([touches count] > 0) {
    
    for (UITouch*touch in touches)
        
    {
        
        CGPoint *point = (CGPoint*)CFDictionaryGetValue(touchBeginPoints,touch);
        
        if (NULL== point)
            
        {
            
            point = (CGPoint *)malloc(sizeof(CGPoint));
            
            CFDictionarySetValue(touchBeginPoints, touch, point);
            
        }
        
        *point = [touch locationInView:self.superview];
        
    }
    
}
    
}

- (void)comparePointForTouches:(NSSet*)touches {
    
    NSArray *sortedTouch = [[touchesallObjects]sortedArrayUsingSelector:@selector(compareAddress:)];
    
    UITouch*touch1 = [sortedTouchobjectAtIndex:0];
    
    //下面的代码示例了如何从字典对象中取得初始位置数据并获得对应触摸的当前位置。
    
    UITouch *touch2 = [sortedTouchobjectAtIndex:1];
    
    CGPoint beginPoint1 =*((CGPoint*)CFDictionaryGetValue(touchBeginPoints,touch1));
    
    CGPoint currentPoint1 = [touch1locationInView:self.superview];
    
    CGPoint beginPoint2 =*((CGPoint*)CFDictionaryGetValue(touchBeginPoints,touch2));
    
    CGPoint currentPoint2 = [touch2locationInView:self.superview];//Compare current andbegin point
    
}





//----更具体的操作可参考apple提供的MoveMe示例。----

//Hit-Testing

//你自己定义的响应者可以使用hit-testing来找到要对与触摸对应的该响应者中的子视图或子层(subLayer)并对其进行合适的处理。

//要完成该操作可以调用视图的hitTest:withEvent:方法或子层的hitTest:方法或者直接重载其中任一方法。响应者有时会在事件转发之前对hitTest进行处理。



//如果传入hitTest:withEvent:或hitTest:方法的触摸点位置在包括此方法的视图范围之内,则会被忽略。也就是说子视图在其父视图的范围之外则不会收到触摸事件。

//如果你自定的视图有子视图,你必须决定是否在子视图层或父视图层对触摸进行处理。

//如果子视图没有声明touchesBegan:withEvent:,touchesMoved:withEvent:或touchesEnded:withEvent:方法对触摸进行处理,则相关的事件会传递给它的父视图。对于多次点击或多点触摸都是与首个触摸子视图相联系,所以父视图是不会收到触摸消息的。要确认能收到所有的触摸消息,父视图要重载hitTest:withEvent:方法并返回其自身对象而不是其子视图。



//下面的代码示例用于检测位于自定义视图层上的“info”图片何时被点击

- (void)touchesBegan:(NSSet*)toucheswithEvent:(UIEvent *)event {
    
    CGPoint location = [[touches anyObject]locationInView:self];
    
    CALayer *hitLayer = [[selflayer] hitTest:[selfconvertPoint:locationfromView:nil]];
    
    if (hitLayer)
        
    {
        
        [self displayInfo];
        
    }
    
}



//下面的代码,一个响应者类(在本例中为UIWindow的子类)重载了hitTest:withEvent:方法。

//首先返回父类的hit-test视图,如果该视图是其本身,则返回其最后一个子视图。

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    
    UIView *hitView = [superhitTest:pointwithEvent:event];
    
    if (hitView == self)
        
    {
        
        return [[selfsubviews]lastObject];
        
    }
    
    else
        
    {
        
        return hitView;
        
    }
    
}



//------转发触摸事件------

//事件转发是用于一些应用程序的一种技术。

//你通过调用另一个响应者对象的事件处理方法将触摸事件进行转发。尽管这是个很有效率的方法,但在使用过程中还有很多需要注意的地方。

//UIKitFramework中的类并不是设计用于接收不在其范围内的触摸事件,从编程的角度来看,也就是UITouch对象的view属性必须持有一个对framework对象的引用以用来对触摸事件进行处理。如果你想在你的应用程序中有选择的将触摸事件传递给其它响应者,用于接收的响应者必须是你自己定义的UIView的子类。



//例如:一个应用程序有三个自定义的子视图:A,B和C。

//当用户点击了视图A,应用程序的窗口对象确定所点击的视图是个hit-test视图并向其发送初始触摸事件。

//根据一定的条件,视图A将事件转发给视图B或C。在这种情况下,视图A,B和C必须注意要使事件能进行转发,视图B和C要能对不在其范围内的触摸进行处理。



//事件转发经常需要分析触摸对象用来确定向何处转发事件。有些方法可以用来进行这样的分析:

//对于一个视图,使用hit-testing对事件进行分析在将其转发到子视图之前

//在UIWindow的自定义子类中重载sendEvent:方法,对触摸进行分析并将其转发给合适的响应者。如果重载了该方法,你就必须调用父类的sendEvent:方法



//设计你的应用其中并不需要对触摸进行分析



//下面的代码示例了第二种方法,自定义一个UIWindow的子类并对sendEvent:方法进行重载。

//本例中,子类对象将触摸事件转发给一个自定义的”helper”响应者,在该响应者中对相应的视图进行affine变换。

- (void)sendEvent:(UIEvent*)event{
    
    for (TransformGesture*gesture in transformGestures)
        
    {
        
        // collect all thetouches we care about from the eventNSSet*touches = [gestureobservedTouchesForEvent:event];NSMutableSet*began = nil;
        
        NSMutableSet *moved = nil;
        
        NSMutableSet *ended = nil;
        
        NSMutableSet *cancelled = nil;
        
        // sort the touchesby phase so we can handle them similarly to normal eventdispatch
        
        for(UITouch*touch in touches) {
            
            switch([touch phase])
            
            {
                    
                case UITouchPhaseBegan:
                    
                    if(!began)
                        
                        began = [NSMutableSetset];
                        
                        [beganaddObject:touch];
                    
                    break;
                    
                case UITouchPhaseMoved:
                    
                    if(!moved)
                        
                        moved = [NSMutableSetset];
                        
                        [movedaddObject:touch];
                    
                    break;
                    
                case UITouchPhaseEnded:
                    
                    if(!ended)
                        
                        ended = [NSMutableSetset];
                        
                        [endedaddObject:touch];
                    
                    break;
                    
                case UITouchPhaseCancelled:
                    
                    if(!cancelled)
                        
                        cancelled =[NSMutableSet set];
                        
                        [cancelledaddObject:touch];
                    
                    break;
                    
                default:break;
                    
            }
            
        }
        
        // call our methodsto handle the touches
        
        if (began)
            
            [gesture touchesBegan:beganwithEvent:event];
        
        if (moved)
            
            [gesture touchesMoved:movedwithEvent:event];
        
        if (ended)
            
            [gesture touchesEnded:endedwithEvent:event];
        
        if (cancelled)
            
            [gesture touchesCancelled:cancelledwithEvent:event];
        
    }
    
    [super sendEvent:event];
    
}





【UIevent.h】【事件】



//每产生一个事件，就会产生一个UIEvent对象

//UIevent：称为事件对象，记录事件产生的时刻和类型

//UIEvent对象代表一个事件。



在iOS中，主要有三种事件：

1.触摸事件

2.运动事件

3.远程控制事件。远程控制事件主要是外部辅助设备或者耳机的远程命令，例如控制音乐声音的大小，或者下一首歌。运动事件主要是晃动设备等。



知识点1：-------------------------------------

在iOS中并不是所有的类都能处理接收并事件，

只有继承自UIResponder类的对象才能处理事件，

（如我们常用的UIView、UIViewController、UIApplication都继承自UIResponder，它们都能接收并处理事件）。



UIView不接收触摸事件的三种情况

1.不接收用户交互 userInteractionEnabled = NO

2.隐藏 hidden = YES

3.透明 alpha = 0.0 ~ 0.01



在UIResponder中定义了上面三类事件相关的处理方法：



触摸事件：一次完整的触摸过程，会经历3个状态：

//触摸开始：

- (void)touchesBegan:(NSSet*)toucheswithEvent:(UIEvent*)event

//触摸移动：

- (void)touchesMoved:(NSSet*)toucheswithEvent:(UIEvent*)event

//触摸结束：

- (void)touchesEnded:(NSSet*)toucheswithEvent:(UIEvent*)event

//触摸取消（可能会经历）：（例如正在触摸时打入电话）

- (void)touchesCancelled:(NSSet*)toucheswithEvent:(UIEvent*)event



//4个触摸事件处理方法中，都有(NSSet*)touches和(UIEvent*)event两个参数

//一次完整的触摸过程中，只会产生一个事件对象，4个触摸方法都是同一个event参数



//如果两根手指同时触摸一个view，那么view只会调用一次touchesBegan:withEvent:方法，touches参数中装着2个UITouch对象

//如果这两根手指一前一后分开触摸同一个view，那么view会分别调用2次touchesBegan:withEvent:方法，并且每次调用时的touches参数中只包含一个UITouch对象



//根据touches中UITouch的个数可以判断出是单点触摸还是多点触摸



运动事件：

//运动开始时执行；

- (void)motionBegan:(UIEventSubtype)motionwithEvent:(UIEvent *)event NS_AVAILABLE_IOS(3_0);

//运动结束后执行；

- (void)motionEnded:(UIEventSubtype)motionwithEvent:(UIEvent *)event NS_AVAILABLE_IOS(3_0);

//运动被意外取消时执行；

- (void)motionCancelled:(UIEventSubtype)motionwithEvent:(UIEvent *)event NS_AVAILABLE_IOS(3_0);



远程控制事件：

- (void)remoteControlReceivedWithEvent:(UIEvent*)event NS_AVAILABLE_IOS(4_0);

接收到远程控制消息时执行；



知识点2：-----------------



iOS「摇一摇」功能的实现（运动事件的运用）

监听运动事件前提，监听对象必须成为第一响应者；在模拟器中运行时，可以通过「Hardware」-「Shake Gesture」来测试「摇一摇」功能



- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // 设置允许摇一摇功能
    
    [UIApplication sharedApplication].applicationSupportsShakeToEdit= YES;
    
    // 并让自己成为第一响应者
    
    [self becomeFirstResponder];
    
    return;
    
}



//摇一摇相关方法

- (void)motionBegan:(UIEventSubtype)motionwithEvent:(UIEvent *)event {
    
    NSLog(@"开始摇动");
    
    return;
    
}



- (void)motionCancelled:(UIEventSubtype)motionwithEvent:(UIEvent *)event {
    
    NSLog(@"取消摇动");
    
    return;
    
}



- (void)motionEnded:(UIEventSubtype)motionwithEvent:(UIEvent *)event {
    
    if (event.subtype == UIEventSubtypeMotionShake){ // 判断是否是摇动结束
        
        NSLog(@"摇动结束");
        
    }
    
    return;
    
}





知识点3：一个摇动随机图片显示的实例（运动事件的运用）--------------------------------------



KCImageView.m



#import "KCImageView.h"



#define kImageCount 3



@implementation KCImageView



- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.image = [self getImage];
        
    }
    
    return self;
    
}



#pragma mark 设置控件可以成为第一响应者

- (BOOL)canBecomeFirstResponder{
    
    return YES;
    
}



#pragma mark 运动开始



- (void)motionBegan:(UIEventSubtype)motionwithEvent:(UIEvent *)event{
    
    //这里只处理摇晃事件
    
    if (motion == UIEventSubtypeMotionShake) {
        
        self.image = [self getImage];
        
    }
    
}



#pragma mark 运动结束



- (void)motionEnded:(UIEventSubtype)motionwithEvent:(UIEvent *)event{
    
    
    
}



#pragma mark 随机取得图片



- (UIImage *)getImage{
    
    
    
    int index = arc4random() %kImageCount;
    
    NSString *imageName = [NSStringstringWithFormat:@"avatar%i.png",index];
    
    UIImage *image = [UIImageimageNamed:imageName];
    
    
    
    return image;
    
}



@end



KCShakeViewController.m



#import "KCShakeViewController.h"

#import "KCImageView.h"



@interface KCShakeViewController()

{
    
    KCImageView *_imageView;
    
}



@end



@implementation KCShakeViewController



- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];
    
    
    
}



#pragma mark 视图显示时让控件变成第一响应者



- (void)viewDidAppear:(BOOL)animated{
    
    
    
    _imageView = [[KCImageView alloc]initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    _imageView.userInteractionEnabled = true;
    
    [self.viewaddSubview:_imageView];
    
    [_imageView becomeFirstResponder];
    
}



#pragma mark 视图不显示时注销控件第一响应者的身份
- (void)viewDidDisappear:(BOOL)animated{
    
    [_imageView resignFirstResponder];
    
}

@end
