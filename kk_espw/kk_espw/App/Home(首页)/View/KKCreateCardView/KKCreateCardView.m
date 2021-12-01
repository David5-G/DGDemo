//
//  KKCreateCardView.m
//  kk_espw
//
//  Created by 景天 on 2019/7/11.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKCreateCardView.h"
#import "KKCreateCardsCell.h"
#import "TPKeyboardAvoidingScrollView.h"


@interface KKCreateCardView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) CC_Button *weChatButton;
@property (nonatomic, strong) CC_Button *qqButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) TPKeyboardAvoidingScrollView *scrollView;

@end

@implementation KKCreateCardView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:frame];
        [self addSubview:_scrollView];
        
        _dataArray = @[@"青铜", @"白银", @"黄金", @"铂金", @"钻石", @"星耀", @"王者"];
        
        self.backgroundColor = rgba(0, 0, 0, 0.4);
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - [ccui getRH:385 + HOME_INDICATOR_HEIGHT + 5], SCREEN_WIDTH - [ccui getRH:20], [ccui getRH:385])];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.layer.cornerRadius = 10;
        [_scrollView addSubview:_whiteView];
        
        UILabel *des = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _whiteView.width, 60)];
        des.textColor = KKES_COLOR_BLACK_TEXT;
        des.text = @"请设置你的名片";
        des.textAlignment = NSTextAlignmentCenter;
        des.font = [ccui getRFS:18];
        [_whiteView addSubview:des];
        
        UILabel *area = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:26], [ccui getRH:63], [ccui getRH:32], [ccui getRH:13])];
        area.textColor = KKES_COLOR_BLACK_TEXT;
        area.text = @"大区:";
        area.textAlignment = NSTextAlignmentCenter;
        area.font = [ccui getRFS:14];
        [_whiteView addSubview:area];
        
        _weChatButton = [CC_Button buttonWithType:UIButtonTypeCustom];
        _weChatButton.frame = CGRectMake([ccui getRH:21], area.bottom + [ccui getRH:12], [ccui getRH:49], [ccui getRH:27]);
        _weChatButton.layer.cornerRadius = [ccui getRH:13.5];
        _weChatButton.backgroundColor = [UIColor colorWithRed:236/255.0 green:193/255.0 blue:101/255.0 alpha:1.0];
        [_weChatButton setTitle:@"微信" forState:UIControlStateNormal];
        _weChatButton.titleLabel.font = [ccui getRFS:12];
        [_whiteView addSubview:_weChatButton];
        _weChatButton.cs_acceptEventInterval = 0.1;
        [_weChatButton addTarget:self action:@selector(weChatButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    
        _qqButton = [CC_Button buttonWithType:UIButtonTypeCustom];
        _qqButton.frame = CGRectMake(_weChatButton.right + [ccui getRH:17], _weChatButton.top, [ccui getRH:49], [ccui getRH:27]);
        _qqButton.layer.cornerRadius = [ccui getRH:13.5];
        _qqButton.backgroundColor = RGB(238, 238, 238);
        [_qqButton setTitleColor:KKES_COLOR_GRAY_TEXT forState:UIControlStateNormal];
        [_qqButton setTitle:@"QQ" forState:UIControlStateNormal];
        _qqButton.titleLabel.font = [ccui getRFS:12];
        [_whiteView addSubview:_qqButton];
        _qqButton.cs_acceptEventInterval = 0.1;
        [_qqButton addTarget:self action:@selector(qqButtonTap:) forControlEvents:UIControlEventTouchUpInside];

        UILabel *danGradingLabel = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:26], [ccui getRH:136], [ccui getRH:32], [ccui getRH:13])];
        danGradingLabel.textColor = KKES_COLOR_BLACK_TEXT;
        danGradingLabel.text = @"段位:";
        danGradingLabel.textAlignment = NSTextAlignmentCenter;
        danGradingLabel.font = [ccui getRFS:14];
        [_whiteView addSubview:danGradingLabel];
        
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        self.collectionView =
        [[UICollectionView alloc] initWithFrame:CGRectMake([ccui getRH:10], [ccui getRH:13] + danGradingLabel.bottom, _whiteView.width - [ccui getRH:20], [ccui getRH:75]) collectionViewLayout:flowLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.scrollEnabled = YES;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[KKCreateCardsCell class]
                forCellWithReuseIdentifier:@"KKCreateCardsCell"];
        [_whiteView addSubview:self.collectionView];
        self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        self.collectionView.bounces = YES;
        
        ///
        UILabel *nickName = [[UILabel alloc] initWithFrame:CGRectMake([ccui getRH:26], [ccui getRH:262], [ccui getRH:60], [ccui getRH:13])];
        nickName.text = @"游戏昵称:";
        nickName.textColor = KKES_COLOR_BLACK_TEXT;
        nickName.font = [ccui getRFS:14];
        [_whiteView addSubview:nickName];
        
        ///
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake([ccui getRH:8] + nickName.right, [ccui getRH:252], [ccui getRH:240], [ccui getRH:35])];
        bgView.backgroundColor = RGB(238, 238, 238);
        [_whiteView addSubview:bgView];
        
        ///
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, bgView.width, bgView.height)];
        textField.backgroundColor = [UIColor clearColor];
        [bgView addSubview:textField];
        
        ///
        CC_Button *sureButton = [CC_Button buttonWithType:UIButtonTypeCustom];
        sureButton.frame = CGRectMake([ccui getRH:21], bgView.bottom + [ccui getRH:28], [ccui getRH:313], [ccui getRH:45]);
        [_whiteView addSubview:sureButton];
        [sureButton addTarget:self action:@selector(sureButtonAction) forControlEvents:UIControlEventTouchUpInside];
        sureButton.backgroundColor = KKES_COLOR_MAIN_YELLOW;
        [sureButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    return self;
}

- (void)weChatButtonTap:(UIButton *)obj {
    _weChatButton.backgroundColor = KKES_COLOR_MAIN_YELLOW;
    [_weChatButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _qqButton.backgroundColor = RGB(238, 238, 238);
    [_qqButton setTitleColor:KKES_COLOR_GRAY_TEXT forState:UIControlStateNormal];
}

- (void)qqButtonTap:(UIButton *)obj {
    _qqButton.backgroundColor = KKES_COLOR_MAIN_YELLOW;
    [_qqButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _weChatButton.backgroundColor = RGB(238, 238, 238);
    [_weChatButton setTitleColor:KKES_COLOR_GRAY_TEXT forState:UIControlStateNormal];
}

- (void)sureButtonAction {
    [self removeFromSuperview];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([ccui getRH:49], [ccui getRH:27]);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    flowLayout.minimumInteritemSpacing = 10;
    flowLayout.minimumLineSpacing = 10;
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KKCreateCardsCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"KKCreateCardsCell"
                                              forIndexPath:indexPath];
    cell.title.text = _dataArray[indexPath.item];
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    KKCreateCardsCell *cell = (KKCreateCardsCell *)[collectionView cellForItemAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    KKCreateCardsCell *cell = (KKCreateCardsCell *)[collectionView cellForItemAtIndexPath:indexPath];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}
@end
