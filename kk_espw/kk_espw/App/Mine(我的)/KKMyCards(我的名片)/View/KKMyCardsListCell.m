//
//  KKMyCardsListCell.m
//  kk_espw
//
//  Created by 景天 on 2019/7/15.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKMyCardsListCell.h"
#import "KKCalculateTextWidthOrHeight.h"
#import "KKMessage.h"
#import "KKTag.h"
#import "KKCardTag.h"
#import "KKTagCollectionViewCell.h"
#import "JTCollectionViewLayout.h"
@interface KKMyCardsListCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *reliableLabel;
@property (nonatomic, strong) UILabel *dangradingLabel;
@property (nonatomic, strong) UILabel *arealabel;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) KKCardTag *modelCopy;
@property (nonatomic, strong) NSMutableArray *tagArray;
@end

@implementation KKMyCardsListCell
- (NSMutableArray *)tagArray {
    if (!_tagArray) {
        _tagArray = [NSMutableArray array];
    }
    return _tagArray;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        JTCollectionViewLayout * layout = [[JTCollectionViewLayout alloc] init];
        layout.rowCount = 2;
        layout.minimumLineSpacing = 15;
        layout.scrollDirection = ZZCollectionViewScrollDirectionHorizontal;
        
        _collectionView =
        [[UICollectionView alloc] initWithFrame:CGRectMake(RH(15), _arealabel.bottom + RH(5), _whiteView.width - RH(60), RH(46)) collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled = YES;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[KKTagCollectionViewCell class]
            forCellWithReuseIdentifier:@"KKTagCollectionViewCell"];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.bounces = YES;
    }
    return _collectionView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        [self setUI];
    }
    return self;
}

- (void)setUI {
    /// 1. 白色的V
    _whiteView = [[UIView alloc] initWithFrame:CGRectMake(RH(15), RH(5), SCREEN_WIDTH - RH(30), RH(117))];
    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.cornerRadius = 6;
    [self.contentView addSubview:_whiteView];
    /// 2. 昵称
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(RH(24), RH(19), self.frame.size.width - RH(48), RH(18))];
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:16];
    _nameLabel.text = @"夏天李白超级6";
    _nameLabel.textColor = KKES_COLOR_BLACK_TEXT;
    [_whiteView addSubview:_nameLabel];
    /// 3. 靠谱分
    _reliableLabel = [[UILabel alloc] initWithFrame:CGRectMake(_whiteView.width - RH(15 + 39), RH(22), RH(39), RH(15))];
    _reliableLabel.text = @"靠谱 99";
    _reliableLabel.layer.cornerRadius = RH(3);
    _reliableLabel.clipsToBounds = YES;
    _reliableLabel.textAlignment = NSTextAlignmentCenter;
    _reliableLabel.font = [KKFont kkFontStyle:KKFontStyleREEJIHonghuangLiMedium size:9];
    _reliableLabel.textColor = [UIColor whiteColor];
    _reliableLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:96/255.0 blue:96/255.0 alpha:1.0];
    [_whiteView addSubview:_reliableLabel];
    
    ///
    _dangradingLabel = [[UILabel alloc] initWithFrame:CGRectMake(RH(25), RH(47), RH(29), RH(17))];
    _dangradingLabel.text = @"钻石";
    _dangradingLabel.textColor = KKES_COLOR_GRAY_TEXT;
    _dangradingLabel.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:9];
    _dangradingLabel.layer.cornerRadius = RH(3);
    _dangradingLabel.textAlignment = NSTextAlignmentCenter;
    _dangradingLabel.layer.borderColor = KKES_COLOR_GRAY_TEXT.CGColor;
    _dangradingLabel.layer.borderWidth = 1;
    [_whiteView addSubview:_dangradingLabel];
    
    ///
    _arealabel = [[UILabel alloc] initWithFrame:CGRectMake(_dangradingLabel.right + RH(5), _dangradingLabel.top, RH(47), RH(17))];
    _arealabel.text = @"微信大区";
    _arealabel.textAlignment = NSTextAlignmentCenter;
    _arealabel.textColor = KKES_COLOR_GRAY_TEXT;
    _arealabel.font = [KKFont pingfangFontStyle:PFFontStyleSemibold size:9];
    _arealabel.layer.cornerRadius = RH(3);
    _arealabel.layer.borderColor = KKES_COLOR_GRAY_TEXT.CGColor;
    _arealabel.layer.borderWidth = 1;
    [_whiteView addSubview:_arealabel];
    WS(weakSelf)
    UIImageView *edit = [[UIImageView alloc] initWithFrame:CGRectMake(_whiteView.width - RH(41), _whiteView.height - RH(39), RH(41), RH(39))];
    edit.image = Img(@"edit_card");
    [_whiteView addSubview:edit];
    [edit addTapWithTimeInterval:0.2 tapBlock:^(UIView * _Nonnull view) {
        weakSelf.tapEditCardBlock(weakSelf.modelCopy);
    }];
    
    [_whiteView addSubview:self.collectionView];
}

#pragma mark - <UICollectionViewDelegate, UICollectionViewDataSource>
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    KKTag *tag = self.tagArray[indexPath.item];
    CGFloat tagW = [self getTagW:tag];
    CGFloat tagTextW = [self getTagTextW:tag];
    return CGSizeMake(tagW + tagTextW, RH(15));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.tagArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KKTagCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:@"KKTagCollectionViewCell"
                                            forIndexPath:indexPath];
    KKTag *tag = self.tagArray[indexPath.item];
    cell.tagModel = tag;
    return cell;
}

/// 获取Kangyawang
- (CGFloat)getTagW:(KKTag *)tag {
    /// 计算标签的宽度
    CGFloat w = 0;
    if ([tag.tagCode isEqualToString:@"YE_WANG"] || [tag.tagCode isEqualToString:@"KENG_HUO"] || [tag.tagCode isEqualToString:@"FA_WANG"]) {
        w = RH(25);
    }else if ([tag.tagCode isEqualToString:@"QUAN_NENG_FU_ZHU"]){
        w = RH(45);
    }else {
        w = RH(35);
    }
    return w;
}

/// 获取文字宽度
- (CGFloat)getTagTextW:(KKTag *)tag {
    return [KKCalculateTextWidthOrHeight getWidthWithAttributedText:[NSString stringWithFormat:@"%@", tag.evaluationNum] font:[KKFont pingfangFontStyle:PFFontStyleRegular size:9] height:RH(15)];
}

- (void)setModel:(KKCardTag *)model {
    [self.tagArray removeAllObjects];
    self.modelCopy = model;
    _nameLabel.text = model.nickName;
    _arealabel.text = [NSString stringWithFormat:@"%@大区", model.platformType.message];
    _dangradingLabel.text = model.rank.message;
    _reliableLabel.text = [NSString stringWithFormat:@"靠谱%@", model.reliableScore];
    
    [self.tagArray addObjectsFromArray:model.evaluationProfileIds];
    [self.collectionView reloadData];
}
@end
