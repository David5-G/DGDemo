//
//  KKAddCardBottomView.m
//  kk_espw
//
//  Created by 景天 on 2019/7/16.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKAddCardBottomView.h"
#import "KKAddBottomViewCollectionViewCell.h"
#import "KKMessage.h"
@interface KKAddCardBottomView ()<UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *locArray;
@property (nonatomic, strong) NSMutableArray *selectArray;
@end

@implementation KKAddCardBottomView

#pragma mark - Init
- (NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView =
        [[UICollectionView alloc] initWithFrame:CGRectMake(RH(10), RH(74) + _tf.bottom, SCREEN_WIDTH - RH(20), RH(20)) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[KKAddBottomViewCollectionViewCell class]
                forCellWithReuseIdentifier:@"KKAddBottomViewCollectionViewCell"];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.bounces = YES;
        _collectionView.allowsMultipleSelection = YES;
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dataArray = @[@"上路", @"中路", @"下路", @"辅助", @"打野"];
        _locArray = @[@"TOP", @"MID", @"ADC", @"SUP", @"JUG"];

        self.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, RH(18), RH(60), RH(14))];
        label.text = @"服务器";
        label.font = RF(15);
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = KKES_COLOR_BLACK_TEXT;
        [self addSubview:label];
        
        _tf = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - RH(90 + 18), RH(19), RH(90), RH(13))];
        _tf.font = RF(14);
        _tf.adjustsFontSizeToFitWidth = YES;
        _tf.delegate = self;
        _tf.textColor = KKES_COLOR_BLACK_TEXT;
        NSAttributedString *atStr = [[NSAttributedString alloc]initWithString:@"请填写所在区" attributes:@{NSForegroundColorAttributeName : KKES_COLOR_GRAY_TEXT}];
        _tf.attributedPlaceholder = atStr;
       
        _tf.textAlignment = NSTextAlignmentRight;
        _tf.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_tf];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(RH(25), RH(49), SCREEN_WIDTH - RH(25), RH(1))];
        line.backgroundColor = RGB(245, 245, 245);
        [self addSubview:line];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(15, RH(18) + line.bottom, RH(70), RH(14))];
        label2.text = @"擅长位置";
        label2.font = RF(15);
        label2.textColor = KKES_COLOR_BLACK_TEXT;
        [self addSubview:label2];
        /// 描述 最多三项
        UILabel *desL = New(UILabel);
        desL.left = label2.right;
        desL.top = label2.top;
        desL.size = CGSizeMake(100, RH(13));
        desL.textAlignment = NSTextAlignmentLeft;
        desL.textColor = KKES_COLOR_GRAY_TEXT;
        desL.font = [KKFont pingfangFontStyle:PFFontStyleRegular size:13];
        desL.text = @"(最多选三项)";
        [self addSubview:desL];
        
        
        [self addSubview:self.collectionView];
        
        UIView *whiteV = New(UIView);
        whiteV.top = self.collectionView.bottom + RH(20);
        whiteV.left = 0;
        whiteV.size = CGSizeMake(SCREEN_WIDTH, RH(90));
        whiteV.backgroundColor = KKES_COLOR_BG;
        [self addSubview:whiteV];
        
        CC_Button *commitButton = [CC_Button buttonWithType:UIButtonTypeCustom];
        commitButton.top = RH(44);
        commitButton.left = RH(25);
        commitButton.size = CGSizeMake(SCREEN_WIDTH - RH(50), RH(45));
        [commitButton setTitle:@"确定" forState:UIControlStateNormal];
        commitButton.backgroundColor = KKES_COLOR_MAIN_YELLOW;
        commitButton.layer.cornerRadius = RH(6);
        WS(weakSelf)
        [commitButton addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
            [weakSelf toCommit];
        }];
        [whiteV addSubview:commitButton];
    }
    return self;
}

#pragma mark - Action
- (void)toCommit {
    if (self.locSelectBlock) {
        self.locSelectBlock(self.selectArray);
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.inputAreaStrBlock) {
        self.inputAreaStrBlock(textField.text);
    }
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((SCREEN_WIDTH - RH(20)) / 5 - 2, RH(20));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)collectionViewLayout;
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    return UIEdgeInsetsMake(1, 1, 1, 1);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KKAddBottomViewCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"KKAddBottomViewCollectionViewCell"
                                              forIndexPath:indexPath];
    [cell.titleButton setTitle:_dataArray[indexPath.item] forState:UIControlStateNormal];
    /// [@"TOP", @"MID", @"ADC", @"SUP", @"JUG"]
    NSString *posStr = _dataArray[indexPath.item];
    if ([posStr isEqualToString:@"上路"]) {
        posStr = @"TOP";
    }else if ([posStr isEqualToString:@"中路"]) {
        posStr = @"MID";
    }else if([posStr isEqualToString:@"下路"]) {
        posStr = @"ADC";
    }else if([posStr isEqualToString:@"辅助"]) {
        posStr = @"SUP";
    }else if([posStr isEqualToString:@"打野"]) {
        posStr = @"JUG";
    }
    BOOL isSelected = NO;
    for (NSString *selStr in self.selectArray) {
        if ([selStr isEqualToString:posStr]) {
            cell.selected = YES;
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.item inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            isSelected = YES;
        }
    }
    if (isSelected == NO) {
        cell.selected = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    /// 顺序是: 上 中 下 辅 野
    [self.selectArray addObject:_locArray[indexPath.item]];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([[collectionView indexPathsForSelectedItems] containsObject:indexPath]) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        [self.selectArray removeObject:_locArray[indexPath.item]];
        return NO;
    }
    [self.selectArray addObject:_locArray[indexPath.item]];
    if (self.selectArray.count > 3){
        [CC_Notice show:@"最多选三项"];
        [self.selectArray removeObject:_locArray[indexPath.item]];
        return NO;
    }else {
        [self.selectArray removeObject:_locArray[indexPath.item]];
        return YES;
    }
}

- (void)setPreferLocations:(NSMutableArray *)preferLocations {
    [self.selectArray removeAllObjects];
    NSMutableArray *t = [NSMutableArray array];
    for (int i = 0; i < preferLocations.count; i ++) {
        KKMessage *m = preferLocations[i];
        [t addObject:m.name];
    }
    [self.selectArray addObjectsFromArray:t];
    [self.collectionView reloadData];
}
@end
