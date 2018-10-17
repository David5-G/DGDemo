

#ifndef Macro_h
#define Macro_h


//---------------------------------------------------
#ifdef TARGET_IPHONE_SIMULATOR
//XXXXX  模拟器时会编译的代码
#else
//XXXXX  不是模拟器才会编译的代码
#endif


//---------------------------------------------------
#pragma mark - color
/** 二进制颜色*/
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0x00FF0000) >> 16)) / 255.0     \
green:((float)((rgbValue & 0x0000FF00) >>  8)) / 255.0     \
blue:((float)((rgbValue & 0x000000FF) >>  0)) / 255.0     \
alpha:1.0]

#define UIColorFromHexStr(hexStr) ({NSString *colorHexStr = [hexStr stringByReplacingOccurrencesOfString:@"#" withString:@"0x"]; \
unsigned colorHex = 0; \
[[NSScanner scannerWithString:colorHexStr] scanHexInt:&colorHex];\
UIColorFromRGB(colorHex);})

#pragma mark rgb
/** rgb颜色*/
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b)    RGBA(r,g,b,1.0f)

/** 常用颜色 */
#define BLACK_TEXT_COLOR        RGBA(51,51,51,1.0)
#define DARK_GRAY_TEXT_COLOR    RGBA(102,102,102,1.0)
#define GRAY_TEXT_COLOR         RGBA(153,153,153,1.0)



//---------------------------------------------------
#pragma mark - 设备/版本
/** 获取系统版本*/
#define IOS_VERSION            [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion   [[UIDevice currentDevice] systemVersion]
#define CurrentAppVersion      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// 判断iPhone
#define iPhone4 (MAX(SCREEN_WIDTH, SCREEN_HEIGHT) == 480)
#define iPhone5 (MAX(SCREEN_WIDTH, SCREEN_HEIGHT) == 568)
#define iPhoneX (MAX(SCREEN_WIDTH, SCREEN_HEIGHT) >= 812)

//---------------------------------------------------
#pragma mark - scale
#define fiveScreen_ScreenWidthScale (MINValue(SCREEN_WIDTH,SCREEN_HEIGHT)/320.0*0.8+0.2)
#define sixScreen_ScreenWidthScale  (MINValue(SCREEN_WIDTH,SCREEN_HEIGHT)/375.0)

#define ScreenWidthScale      (MINValue(SCREEN_WIDTH,SCREEN_HEIGHT)/414.0*0.8+0.2)
#define ScreenHeightScale     (MAXValue(SCREEN_WIDTH,SCREEN_HEIGHT)/736.0*0.8+0.2)
#define ScreenWidthFullScale  MINValue(SCREEN_WIDTH,SCREEN_HEIGHT)/414
#define ScreenWidthScaleWithSCREENWIDTH(a) (a/414.0*0.8+0.2)


//---------------------------------------------------
#pragma mark - 尺寸(宽高)
/** 获取屏幕 宽度、高度*/
#define SCREEN_BOUNDS ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//#define BBKEY_WINDOW [UIApplication sharedApplication].keyWindow
#define BBKEY_WINDOW [[[UIApplication sharedApplication] delegate] window]
//#define BBKEY_WINDOW [AppDelegate sharedApplication].window

// tabBar高度
#define TAB_BAR_HEIGHT (iPhoneX ? (49.f+34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (iPhoneX ? 34.f : 0.f)
// 导航栏高度
#define NAV_BAR_HEIGHT (44.f)
#define STATUS_AND_NAV_BAR_HEIGHT (STATUS_BAR_HEIGHT + NAV_BAR_HEIGHT)
#define STATUS_BAR_HEIGHT (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))

// 设备相关
#define GREATER_iPhone5_WIDTH           (MIN(SCREEN_WIDTH, SCREEN_HEIGHT) > 320)
#define GREATER_iPhone6_WIDTH           (MIN(SCREEN_WIDTH, SCREEN_HEIGHT) > 375)

//HERMIT
#pragma mark HERMIT
#define HERMIT_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define HERMIT_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define HERMIT_RGBCOLOR [UIColor colorWithRed:244/255.0f green:244/255.0f blue:244/255.0f alpha:1]
#define UNIT_WIDTH ([UIScreen mainScreen].bounds.size.width) / 320


//---------------------------------------------------
#pragma mark - strong/weak
#define WS(weakSelf)    __weak __typeof(&*self)weakSelf = self;
#define SS(strongSelf)  __strong __typeof(&*weakSelf)strongSelf = weakSelf;

#define weak(v)         __weak typeof(v) weak_##v = v;
#define strong(v)       __strong typeof(v) strong_##v = weak_##v;



//---------------------------------------------------
#pragma mark - log
#ifdef DEBUG
#   define DGLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DGLog(...)
#endif



//---------------------------------------------------
#pragma mark - other
#define IGNORE_ERROR @"a"    // 回调的时候,忽略掉的错误提示

/** 简写*/
#define UIFont(f)      [UIFont systemFontOfSize:f]
#define UIImage(a)  [UIImage imageNamed:a]
#define New(T)      [[T alloc] init]


/** 最大最小值 */
#define MAXValue(A,B) ({__typeof(A) __a = (A);__typeof(B) __b = (B);__a > __b ? __a : __b;})
#define MINValue(A,B) ({__typeof(A) __a = (A);__typeof(B) __b = (B);__a > __b ? __b : __a;})


#endif /* Macro_h */
