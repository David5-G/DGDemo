

typedef NS_ENUM(NSUInteger, NSExpressionType) {
    NSConstantValueExpressionType = 0,
    NSEvaluatedObjectExpressionType,
    NSVariableExpressionType,
    NSKeyPathExpressionType,
    NSFunctionExpressionType,
    NSUnionSetExpressionType,
    NSIntersectSetExpressionType,
    NSMinusSetExpressionType,
    NSSubqueryExpressionType = 13,
    NSAggregateExpressionType = 14,
    NSAnyKeyExpressionType = 15,
    NSBlockExpressionType = 19,
    NSConditionalExpressionType = 20
};


@interface NSExpression : NSObject <NSSecureCoding, NSCopying> {
    @package
    struct _expressionFlags {
        unsigned int _evaluationBlocked:1;
        unsigned int _reservedExpressionFlags:31;
    } _expressionFlags;
#ifdef __LP64__
    uint32_t reserved;
#endif
    NSExpressionType _expressionType;
}


+ (NSExpression *)expressionWithFormat:(NSString *)expressionFormat argumentArray:(NSArray *)arguments ;
+ (NSExpression *)expressionWithFormat:(NSString *)expressionFormat, ...   ;
+ (NSExpression *)expressionWithFormat:(NSString *)expressionFormat arguments:(va_list)argList  ;

+ (NSExpression *)expressionForConstantValue:(nullable id)obj;
+ (NSExpression *)expressionForEvaluatedObject;
+ (NSExpression *)expressionForVariable:(NSString *)string;
+ (NSExpression *)expressionForKeyPath:(NSString *)keyPath;
+ (NSExpression *)expressionForFunction:(NSString *)name arguments:(NSArray *)parameters;


+ (NSExpression *)expressionForAggregate:(NSArray<NSExpression *> *)subexpressions ;
+ (NSExpression *)expressionForUnionSet:(NSExpression *)left with:(NSExpression *)right ;
+ (NSExpression *)expressionForIntersectSet:(NSExpression *)left with:(NSExpression *)right ;
+ (NSExpression *)expressionForMinusSet:(NSExpression *)left with:(NSExpression *)right ;
+ (NSExpression *)expressionForSubquery:(NSExpression *)expression usingIteratorVariable:(NSString *)variable predicate:(NSPredicate *)predicate ;
+ (NSExpression *)expressionForFunction:(NSExpression *)target selectorName:(NSString *)name arguments:(nullable NSArray *)parameters ;
+ (NSExpression *)expressionForAnyKey ;
+ (NSExpression *)expressionForBlock:(id (^)(id _Nullable evaluatedObject, NSArray<NSExpression *> *expressions, NSMutableDictionary * _Nullable context))block arguments:(nullable NSArray<NSExpression *> *)arguments ;
+ (NSExpression *)expressionForConditional:(NSPredicate *)predicate trueExpression:(NSExpression *)trueExpression falseExpression:(NSExpression *)falseExpression  ;



- (instancetype)initWithExpressionType:(NSExpressionType)type ;
- (nullable instancetype)initWithCoder:(NSCoder *)coder ;


@property (readonly) NSExpressionType expressionType;
@property (nullable, readonly, retain) id constantValue;
@property (readonly, copy) NSString *keyPath;
@property (readonly, copy) NSString *function;
@property (readonly, copy) NSString *variable;
@property (readonly, copy) NSExpression *operand;
@property (nullable, readonly, copy) NSArray<NSExpression *> *arguments;
@property (readonly, retain) id collection;
@property (readonly, copy) NSPredicate *predicate;
@property (readonly, copy) NSExpression *leftExpression;
@property (readonly, copy) NSExpression *rightExpression;


@property (readonly, copy) NSExpression *trueExpression;
@property (readonly, copy) NSExpression *falseExpression;

@property (readonly, copy) id (^expressionBlock)(id _Nullable, NSArray<NSExpression *> *, NSMutableDictionary * _Nullable);

- (nullable id)expressionValueWithObject:(nullable id)object context:(nullable NSMutableDictionary *)context;

- (void)allowEvaluation;
