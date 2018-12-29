

#ifndef NSScanner_api_h
#define NSScanner_api_h

//https://blog.csdn.net/hdfqq188816190/article/details/53170711
//https://developer.apple.com/documentation/foundation/scanner#//apple_ref/occ/instm/NSScanner/scanInteger:
@interface NSScanner : NSObject <NSCopying>

@property (readonly, copy) NSString *string;

//下次扫描开始的位置，如果该值超出了string的区域，将会引起NSRangeException,该属性在发生错误后重新扫描时非常有用。（这个方法不是只读的，可自定义扫描位置）
@property NSUInteger scanLocation;

//在扫描时被跳过的字符集，默认是空白格和回车键。
//被跳过的字符集优先于扫描的字符集：例如一个scanner被跳过的字符集为空格，通过scanInt:去查找字符串中的整型数时，首先做的不是扫描，而是跳过空格，直到找到十进制数据或者其他的字符。
//在字符被扫描的时候，跳过功能就失效了。如果你扫描的字符和跳过的字符是一样的，结果将是未知的。被跳过的字符是一个唯一值，scanner不会将忽略大小写的功能应用于它，也不会用这些字符做一些组合，如果在扫描字符换的时候你想忽略全部的元音字符，就要这么做（比如：将字符集设置成“AEIOUaeiou”};
@property (nullable, copy) NSCharacterSet *charactersToBeSkipped;

//是否区分大小。默认为NO，注意：该设置不会应用到被跳过的字符集。
@property BOOL caseSensitive;

//scanner的locale对它从字符串中区分数值产生影响，它通过locale的十进制分隔符来区分浮点型数据的整数和小数部分。一个没有locale的scanner用non-localized值。新的scanner默认没有设置locale。
@property (nullable, retain) id locale;

- (instancetype)initWithString:(NSString *)string;
+ (instancetype)scannerWithString:(NSString *)string;
+ (id)localizedScannerWithString:(NSString *)string;

@end


@interface NSScanner (NSExtendedScanner)

// 溢出时, 以下方法会返回YES

/**
 扫描整型，溢出也被认为是有效的整型，int 指针指向的地址的值为扫描到的值，
 包含溢出时的INT_MAX或INT_MIN。
 */
- (BOOL)scanInt:(nullable int *)result;
- (BOOL)scanInteger:(nullable NSInteger *)result;
/**
 扫描LongLong 型，溢出也被认为是有效的整型，LongLong指针指向的地址的值为扫描到的值，包含溢出时的LLONG_MAX 或 LLONG_MIN。
 */
- (BOOL)scanLongLong:(nullable long long *)result;
- (BOOL)scanUnsignedLongLong:(nullable unsigned long long *)result;//iOS7.0


/**
 扫描双精度浮点型字符，溢出和非溢出都被认为合法的浮点型数据。
 在溢出的情况下scanner将会跳过所有的数字，所以新的扫描位置将会在整个浮点型数据的后面。double指针指向的地址存储的数据为扫描出的值，包括溢出时的HUGE_VAL或者 –HUGE_VAL，及未溢出时的0.0。
 */
- (BOOL)scanDouble:(nullable double *)result;
- (BOOL)scanFloat:(nullable float *)result;

/** 扫描十六进制无符整型，unsigned int指针指向的地址值为 扫描到的值，包含溢出时的UINT_MAX。 */
- (BOOL)scanHexInt:(nullable unsigned *)result; //可选择以"0x"或"0X"做前缀
- (BOOL)scanHexLongLong:(nullable unsigned long long *)result; //可选择以"0x"或"0X"做前缀


/**
 扫描双精度的十六进制类型，溢出和非溢出都被认为合法的浮点型数据。
 在溢出的情况下scanner将会跳过所有的数字，所以新的扫描位置将会在整个浮点型数据的后面。double指针指向的地址存储的数据为扫描出的值，包括溢出时的HUGE_VAL或者 –HUGE_VAL，及未溢出时的0.0。
 数据接收时对应的格式为 %a 或%A ，双精度十六进制字符前面一定要加 0x或者 0X。 */
- (BOOL)scanHexDouble:(nullable double *)result;
- (BOOL)scanHexFloat:(nullable float *)result; // Corresponding to %a or %A formatting. Requires "0x" or "0X" prefix.

@property (getter=isAtEnd, readonly) BOOL atEnd;

/**
 从当前的扫描位置开始扫描，判断扫描字符串是否从当前位置能扫描到和传入字符串相同的一串字符，如果能扫描到就返回YES,指针指向的地址存储的就是这段字符串的内容。
 例如scanner的string内容为123abc678,传入的字符串内容为abc，如果当前的扫描位置为0，那么扫描不到，但是如果将扫描位置设置成3，就可以扫描到了。
 */
- (BOOL)scanString:(NSString *)string intoString:(NSString * _Nullable * _Nullable)result;

/**
 扫描字符串中和NSCharacterSet字符集中匹配的字符，是按字符单个匹配的，
 例如，NSCharacterSet字符集为@”test123Dmo”，scanner字符串为 @” 123test12Demotest”，那么字符串中所有的字符都在字符集中，所以指针指向的地址存储的内容为”123test12Demotest”
 */
- (BOOL)scanCharactersFromSet:(NSCharacterSet *)set intoString:(NSString * _Nullable * _Nullable)result;

/**
 从当前的扫描位置开始扫描，扫描到和传入的字符串相同字符串时，停止，指针指向的地址存储的是遇到传入字符串之前的内容。
 例如scanner的string内容为123abc678,传入的字符串内容为abc，存储的内容为123
 */
- (BOOL)scanUpToString:(NSString *)string intoString:(NSString * _Nullable * _Nullable)result;

/**
 扫描字符串直到遇到NSCharacterSet字符集的字符时停止，
 指针指向的地址存储的内容为遇到跳过字符集字符之前的内容
 */
- (BOOL)scanUpToCharactersFromSet:(NSCharacterSet *)set intoString:(NSString * _Nullable * _Nullable)result;

@end


#endif
