

//比较方式
typedef NS_OPTIONS(NSUInteger, NSComparisonPredicateOptions) {
    NSCasebuminPredicateOption = 0x01, //[c] 大小写不敏感
    NSDiacriticInsensitivePredicateOption = 0x02,//[d] 发音不敏感
    NSNormalizedPredicateOption 0x04,//[n] 标准(性能优化选择项)
};

//修饰器
typedef NS_ENUM(NSUInteger, NSComparisonPredicateModifier) {
    NSDirectPredicateModifier = 0, //直接比较
    NSAllPredicateModifier, // ALL toMany.x = y  left全等于right为true
    NSAnyPredicateModifier // ANY toMany.x = y   left有一个等于right为true
};

//操作方式
typedef NS_ENUM(NSUInteger, NSPredicateOperatorType) {
    NSLessThanPredicateOperatorType = 0,         //<
    NSLessThanOrEqualToPredicateOperatorType,    //<=
    NSGreaterThanPredicateOperatorType,          //>
    NSGreaterThanOrEqualToPredicateOperatorType, //>=
    NSEqualToPredicateOperatorType,              //==
    NSNotEqualToPredicateOperatorType,           //!=
    NSMatchesPredicateOperatorType,              //MATCHES
    NSLikePredicateOperatorType,                 //LIKE
    NSBeginsWithPredicateOperatorType,           //BEGINWITH
    NSEndsWithPredicateOperatorType,             //ENDWITH
    NSInPredicateOperatorType,                   //IN
    NSCustomSelectorPredicateOperatorType,       //CustomSelector
    NSContainsPredicateOperatorType  = 99,       //CONTAINS
    NSBetweenPredicateOperatorType               //BETWEEN
};

@class NSPredicateOperator;
@class NSExpression;

@interface NSComparisonPredicate : NSPredicate {
@private
    void *_reserved2;
    NSPredicateOperator *_predicateOperator;
    NSExpression *_lhs;
    NSExpression *_rhs;
}


+ (NSComparisonPredicate *)predicateWithLeftExpression:(NSExpression *)lhs rightExpression:(NSExpression *)rhs modifier:(NSComparisonPredicateModifier)modifier type:(NSPredicateOperatorType)type options:(NSComparisonPredicateOptions)options;

+ (NSComparisonPredicate *)predicateWithLeftExpression:(NSExpression *)lhs rightExpression:(NSExpression *)rhs customSelector:(SEL)selector;


- (instancetype)initWithLeftExpression:(NSExpression *)lhs rightExpression:(NSExpression *)rhs modifier:(NSComparisonPredicateModifier)modifier type:(NSPredicateOperatorType)type options:(NSComparisonPredicateOptions)options;

- (instancetype)initWithLeftExpression:(NSExpression *)lhs rightExpression:(NSExpression *)rhs customSelector:(SEL)selector;

- (nullable instancetype)initWithCoder:(NSCoder *)coder;



@property (readonly) NSPredicateOperatorType predicateOperatorType;
@property (readonly) NSComparisonPredicateModifier comparisonPredicateModifier;
@property (readonly, retain) NSExpression *leftExpression;
@property (readonly, retain) NSExpression *rightExpression;
@property (nullable, readonly) SEL customSelector;
@property (readonly) NSComparisonPredicateOptions options;

@end
