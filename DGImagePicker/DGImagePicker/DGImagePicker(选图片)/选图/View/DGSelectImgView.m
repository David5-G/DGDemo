//
//  DGSelectImgView.m
//  DGImagePicker
//
//  Created by david on 2018/12/18.
//  Copyright © 2018 david. All rights reserved.
//

#import "DGSelectImgView.h"

//图片选择中的对号
@implementation DGMarkView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.isSelected = NO ;
    }
    return self;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(24.0, 24.0);
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if(self.isSelected){
        //1.填充背景
        CGContextSetRGBFillColor(context, 0.17, 0.42, 1.0, 1.0);
        CGContextFillEllipseInRect(context, self.bounds);
        
        //2.中间对号
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
        CGContextSetLineWidth(context, 1.5);
        CGContextMoveToPoint(context, 6.0, 12.0);
        CGContextAddLineToPoint(context, 10.0, 16.0);
        CGContextAddLineToPoint(context, 18.0, 8.0);
        CGContextStrokePath(context);
        
    }
    
    //3.外围圆圈
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextStrokeEllipseInRect(context, CGRectInset(self.bounds, 1.0, 1.0));
}


@end


#pragma mark -
//图片选择的覆盖视图
@implementation DGCoverView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES ;
        
        //1.checkmarkView
        DGMarkView *checkmarkView = [[DGMarkView alloc] initWithFrame:CGRectMake(self.bounds.size.width - (4.0 + 24.0),  4.0 , 24.0, 24.0)];
        checkmarkView.autoresizingMask = UIViewAutoresizingNone;
        
        checkmarkView.layer.shadowColor = [[UIColor grayColor] CGColor];
        checkmarkView.layer.shadowOffset = CGSizeMake(0, 0);
        checkmarkView.layer.shadowOpacity = 0.6;
        checkmarkView.layer.shadowRadius = 2.0;
        
        [self addSubview:checkmarkView];
        self.checkmarkView = checkmarkView;
    }
    return self;
}


@end


#pragma mark -
@interface DGSelectImgView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong,readwrite) DGCoverView *coverView;
@property (nonatomic, strong) UIImage *blankImage;

@end

@implementation DGSelectImgView

#pragma mark lazy load
- (UIImage *)blankImage {
    
    if (_blankImage == nil) {
        CGSize size = CGSizeMake(100.0, 100.0);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
        
        [[UIColor colorWithWhite:(240.0 / 255.0) alpha:1.0] setFill];
        UIRectFill(CGRectMake(0, 0, size.width, size.height));
        _blankImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    return _blankImage;
}

#pragma mark life circle
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

#pragma mark UI
-(void)setupSubviews {
    
    self.isSelected = NO;
    self.backgroundColor = [UIColor brownColor];
    
    //1.imageView
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:imageView];
    self.imageView = imageView;
    
    //2.coverView
    DGCoverView *coverView = [[DGCoverView alloc] initWithFrame:self.bounds];
    coverView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self addSubview:coverView];
    self.coverView = coverView;
}


#pragma mark setter

- (void)setAsset:(ALAsset *)asset {
    _asset = asset;
    
    CGImageRef thumbnailImageRef = [asset thumbnail];
    
    if (thumbnailImageRef) {
        self.imageView.image = [UIImage imageWithCGImage:thumbnailImageRef];
    } else {
        self.imageView.image = [self blankImage];
    }
}

- (void)setIsSelected:(BOOL)isSelected {
    
    _isSelected = isSelected;
    
    // Show/hide overlay view
    if (isSelected) {
        [self showCoverView];
    } else {
        [self hideCoverView];
    }
}



#pragma mark tool
- (void)showCoverView {
    
    if (!self.coverView.checkmarkView.isSelected) {
        self.coverView.checkmarkView.isSelected = YES;
        [self.coverView.checkmarkView setNeedsDisplay];
    }
    
}

- (void)hideCoverView {
    
    if (self.coverView.checkmarkView.isSelected) {
        self.coverView.checkmarkView.isSelected = NO;
        [self.coverView.checkmarkView setNeedsDisplay];
    }
}

@end
