//
//  KKPlayerLabelView.m
//  kk_espw
//
//  Created by hsd on 2019/7/19.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKPlayerLabelView.h"


@implementation KKPlayerLabelViewModel

- (UIFont *)labelFont {
    if (!_labelFont) {
        _labelFont = [KKFont kkFontStyle:KKFontStyleREEJIHonghuangLiMedium size:9];
    }
    return _labelFont;
}

- (UIColor *)labelColor {
    if (!_labelColor) {
        _labelColor = KKES_COLOR_HEX(0xFFFFFF);
    }
    return _labelColor;
}

+ (instancetype)createWithType:(KKPlayerLabelViewModelType)type bgColors:(NSArray<UIColor *> *)bgColors img:(UIImage *)img labelStr:(NSString *)labelStr {
    KKPlayerLabelViewModel *model = [[KKPlayerLabelViewModel alloc] init];
    model.modelType = type;
    model.bgColors = bgColors;
    model.img = img;
    model.labelString = labelStr;
    return model;
}

@end





@interface KKPlayerLabelView ()

@property (strong, nonatomic) IBOutlet UIView *bgView;              ///< 背景视图,无颜色

@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;    ///< 充满整个背景的图片, 不和其他子控件同时显示

@property (weak, nonatomic) IBOutlet UIView *contentView;           ///< 内容视图,有颜色
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;    ///< 图标
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;         ///< 显示玩家优势
@property (weak, nonatomic) IBOutlet UIView *springView;            ///< 占位视图,无颜色

@property (nonatomic, strong, nullable) CAGradientLayer *gradientLayer;     ///< 渐变视图

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconToLead;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelToIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelToTrail;

@end

@implementation KKPlayerLabelView

#pragma mark - set
- (void)setModel:(KKPlayerLabelViewModel *)model {
    _model = model;
    
    self.contentLabel.font = model.labelFont;
    self.contentLabel.textColor = model.labelColor;
    self.contentLabel.text = model.labelString;
    
    if (model.modelType == KKPlayerLabelViewModelTypeIconImage) {
        self.iconImageView.image = model.img;
    } else {
        self.mainImageView.image = model.img;
    }
    
    if (model.modelType == KKPlayerLabelViewModelTypeIconImage) {
        // 调整约束
        if (model.img) {
            self.iconWidth.constant = 10;
            self.iconHeight.constant = 10;
            self.iconToLead.constant = self.iconImageToLeft;
            self.contentLabelToIcon.constant = self.labelToIconImage;
            
        } else {
            self.iconWidth.constant = 0;
            self.iconHeight.constant = 0;
            self.iconToLead.constant = 0;
            self.contentLabelToIcon.constant = 2;
        }
    }
    
    // 设置内容背景色
    [self setContentViewBgColors:model.bgColors];
    
    // 调整显示模式
    [self setShowModelType:model.modelType];
}

- (void)setIconImageToLeft:(CGFloat)iconImageToLeft {
    _iconImageToLeft = iconImageToLeft;
    self.iconToLead.constant = iconImageToLeft;
}

- (void)setLabelToIconImage:(CGFloat)labelToIconImage {
    _labelToIconImage = labelToIconImage;
    self.contentLabelToIcon.constant = labelToIconImage;
}

- (void)setLabelToTrail:(CGFloat)labelToTrail {
    _labelToTrail = labelToTrail;
    self.contentLabelToTrail.constant = labelToTrail;
}

#pragma mark - get
- (CGFloat)iconImageWidth {
    return self.iconWidth.constant;
}

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initDefaultData];
        [self loadXib];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self initDefaultData];
        [self loadXib];
    }
    return self;
}

#pragma mark - layout
- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.gradientLayer) {
        self.gradientLayer.frame = self.contentView.bounds;
    }
    
}

#pragma mark - load
- (void)loadXib {
    
    UIView *bgView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil] lastObject];
    [self addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self);
    }];
    
    self.contentView.layer.cornerRadius = 2;
    self.contentView.layer.masksToBounds = YES;
    
    self.contentLabel.adjustsFontSizeToFitWidth = YES;
    self.contentLabel.font = [KKFont kkFontStyle:KKFontStyleREEJIHonghuangLiMedium size:10];
}

- (void)initDefaultData {
    _iconImageToLeft = 2;
    _labelToIconImage = 2;
    _labelToTrail = 2;
}

#pragma mark - Action
- (void)setShowModelType:(KKPlayerLabelViewModelType)type {
    
    BOOL isIconModel = (type == KKPlayerLabelViewModelTypeIconImage);

    self.contentView.hidden = !isIconModel;
    self.iconImageView.hidden = !isIconModel;
    self.contentLabel.hidden = !isIconModel;
    self.springView.hidden = !isIconModel;
    self.mainImageView.hidden = isIconModel;
}

- (void)setContentViewBgColors:(NSArray<UIColor *> *)bgColors {
    
    NSString *layerName = @"gradientLayer";
    
    if (bgColors.count > 1) { //渐变色
        
        // 转换为ref
        NSMutableArray *colorRefs = [NSMutableArray array];
        for (UIColor *theColor in bgColors) {
            [colorRefs addObject:(__bridge id)theColor.CGColor];
        }
        
        if (self.gradientLayer) {
            [self.gradientLayer removeFromSuperlayer];
        }
        
        CAGradientLayer *gLayer = [CAGradientLayer layer];
        gLayer.frame = self.contentView.bounds;
        gLayer.startPoint = CGPointMake(0, 0.5);
        gLayer.endPoint = CGPointMake(1, 0.5);
        gLayer.colors = [colorRefs copy];
        gLayer.locations = @[@(0.0), @(1.0)];
        gLayer.name = layerName;
        self.gradientLayer = gLayer;
        
        [self.contentView.layer addSublayer:gLayer];
        
    } else {
        self.contentView.backgroundColor = bgColors.firstObject;
    }
}

@end
