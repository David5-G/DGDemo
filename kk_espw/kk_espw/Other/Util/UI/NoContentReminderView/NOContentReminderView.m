//
//  NOContentReminderView.m
//  视频横幅test
//
//  Created by mac on 2017/3/17.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "NoContentReminderView.h"
@interface NoContentReminderView()
@property (nonatomic,strong) UIImage *image;
@property (nonatomic,assign) CGFloat imageTopY;
@property(nonatomic,strong)UILabel *textLab;
@property (nonatomic,strong) NSAttributedString *attributeString;
@end

@implementation NoContentReminderView

#pragma mark - life circle
+(instancetype)showReminderViewToView:(UIView *)toView imageTopY:(CGFloat)imageTopY image:(UIImage *)image remindWords:(NSAttributedString *)remindWords
{
    NoContentReminderView *reminderView = [[NoContentReminderView alloc] initWithFrame:toView.bounds imageTopY:imageTopY image:image remindWords:remindWords];
    [toView addSubview:reminderView];
    return reminderView;
}

-(instancetype)initWithFrame:(CGRect)frame imageTopY:(CGFloat)imageTopY image:(UIImage *)image remindWords:(NSAttributedString *)remindWords
{
    if (self = [super initWithFrame:frame]) {
        self.image = image;
        self.imageTopY = imageTopY;
        [self addViews];
        [self updateRemindWords:remindWords numberOfLines:0];
        self.userInteractionEnabled = NO;
    }
    
    return self;
}



#pragma mark - UI
-(void)addViews
{
    //1.image
    _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, _imageTopY,  [ccui getRH:584.0/3], [ccui getRH:417.0/3])];
    _imageV.image = _image;
    _imageV.contentMode = UIViewContentModeScaleAspectFit ;
    _imageV.center = CGPointMake(self.center.x, _imageV.center.y);
    [self addSubview:_imageV];
    
    //2.label
    self.textLab = [[UILabel alloc] initWithFrame:CGRectMake(0,_imageV.bottom+5,self.width,0)];
    self.textLab.numberOfLines = 0;
    self.textLab.textColor = RGB(153, 153, 153);
    self.textLab.font = [UIFont systemFontOfSize:14];
   [self addSubview:self.textLab];
}


-(void)updateRemindWords:(NSAttributedString *)remindWords numberOfLines:(NSInteger)numberOfLines
{
    self.textLab.numberOfLines = numberOfLines;
    self.attributeString = remindWords;
    NSMutableAttributedString *muAttri = [[NSMutableAttributedString alloc] initWithAttributedString:_attributeString];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    [muAttri addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, muAttri.length)];
    
    self.textLab.attributedText = muAttri;
    [self.textLab sizeToFit];
    self.textLab.center = CGPointMake(self.width/2, self.textLab.center.y);
}


@end
