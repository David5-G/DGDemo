

typedef NS_OPTIONS(NSUInteger, NSRegularExpressionOptions) {
    NSRegularExpressionCaseInsensitive             = 1 << 0, // 不区分大小写的
    NSRegularExpressionAllowCommentsAndWhitespace  = 1 << 1, // 忽略空格和# -
    NSRegularExpressionIgnoreMetacharacters        = 1 << 2, //忽略通配符  整体化
    NSRegularExpressionDotMatchesLineSeparators    = 1 << 3, // 匹配任何字符，包括行分隔符
    NSRegularExpressionAnchorsMatchLines           = 1 << 4, // 允许^和$在匹配的开始和结束行
    NSRegularExpressionUseUnixLineSeparators       = 1 << 5, //设置\n为唯一的行分隔符，否则所有的都有效
    NSRegularExpressionUseUnicodeWordBoundaries    = 1 << 6  // 查找范围为整个的话无效
};


@interface NSRegularExpression : NSObject <NSCopying, NSSecureCoding> {
@protected
    NSString *_pattern;
    NSUInteger _options;
    void *_internal;
    id _reserved1;
    int32_t _checkout;
    int32_t _reserved2;
}

+ (nullable NSRegularExpression *)regularExpressionWithPattern:(NSString *)pattern options:(NSRegularExpressionOptions)options error:(NSError **)error;

- (nullable instancetype)initWithPattern:(NSString *)pattern options:(NSRegularExpressionOptions)options error:(NSError **)error ;

@property (readonly, copy) NSString *pattern;
@property (readonly) NSRegularExpressionOptions options;
@property (readonly) NSUInteger numberOfCaptureGroups;

+ (NSString *)escapedPatternForString:(NSString *)string;

@end


typedef NS_OPTIONS(NSUInteger, NSMatchingOptions) {
    NSMatchingReportProgress         = 1 << 0,
    NSMatchingReportCompletion       = 1 << 1,
    NSMatchingAnchored               = 1 << 2,
    NSMatchingWithTransparentBounds  = 1 << 3,
    NSMatchingWithoutAnchoringBounds = 1 << 4
};

typedef NS_OPTIONS(NSUInteger, NSMatchingFlags) {
    NSMatchingProgress               = 1 << 0,
    NSMatchingCompleted              = 1 << 1,
    NSMatchingHitEnd                 = 1 << 2,
    NSMatchingRequiredEnd            = 1 << 3,
    NSMatchingInternalError          = 1 << 4
};


@interface NSRegularExpression (NSMatching)

- (void)enumerateMatchesInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range usingBlock:(void (NS_NOESCAPE ^)(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL *stop))block;

- (NSArray<NSTextCheckingResult *> *)matchesInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range;

- (NSUInteger)numberOfMatchesInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range;

- (nullable NSTextCheckingResult *)firstMatchInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range;

- (NSRange)rangeOfFirstMatchInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range;

@end



@interface NSRegularExpression (NSReplacement)

- (NSString *)stringByReplacingMatchesInString:(NSString *)string options:(NSMatchingOptions)options range:(NSRange)range withTemplate:(NSString *)templ;
- (NSUInteger)replaceMatchesInString:(NSMutableString *)string options:(NSMatchingOptions)options range:(NSRange)range withTemplate:(NSString *)templ;

- (NSString *)replacementStringForResult:(NSTextCheckingResult *)result inString:(NSString *)string offset:(NSInteger)offset template:(NSString *)templ;

+ (NSString *)escapedTemplateForString:(NSString *)string;

@end



@interface NSDataDetector : NSRegularExpression {
@protected   // all instance variables are private
    NSTextCheckingTypes _types;
}

+ (nullable NSDataDetector *)dataDetectorWithTypes:(NSTextCheckingTypes)checkingTypes error:(NSError **)error;
- (nullable instancetype)initWithTypes:(NSTextCheckingTypes)checkingTypes error:(NSError **)error NS_DESIGNATED_INITIALIZER;

@property (readonly) NSTextCheckingTypes checkingTypes;

@end


