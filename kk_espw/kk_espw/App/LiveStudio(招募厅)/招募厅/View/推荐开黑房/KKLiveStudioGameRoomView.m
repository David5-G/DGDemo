//
//  KKLiveStudioGameRoomView.m
//  kk_espw
//
//  Created by david on 2019/8/11.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioGameRoomView.h"
#import "KKLiveStudioGameRoomCollectionViewCell.h"

#define kLiveStudioGameRoomCollectionCell @"KKLiveStudioGameRoomCollectionViewCell"

@interface KKLiveStudioGameRoomView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) DGButton *recommendButton;
@property (nonatomic, copy) KKLiveStudioGameRoomConfigBlock   configBlock;
@property (nonatomic, copy) KKLiveStudioGameRoomSelectBlock selectBlock;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@end

@implementation KKLiveStudioGameRoomView

#pragma mark - lazy load
-(UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:self.flowLayout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.contentInset = UIEdgeInsetsMake(0, [ccui getRH:15], 0, [ccui getRH:15]);
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[KKLiveStudioGameRoomCollectionViewCell class] forCellWithReuseIdentifier:kLiveStudioGameRoomCollectionCell];
    }
    return _collectionView;
}


-(UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = [ccui getRH:10];
        _flowLayout.minimumInteritemSpacing = [ccui getRH:10];
        _flowLayout.itemSize = CGSizeMake([ccui getRH:163], [ccui getRH:85]);
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
    }
    return _flowLayout;
}

#pragma mark - life circle
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    
    return self;
}


#pragma mark - UI

-(void)setupUI {

    CGFloat leftSpace = [ccui getRH:14];
    //self.backgroundColor = UIColor.blueColor;
    
    //1. titleL
    DGLabel *titleL = [DGLabel labelWithText:@"推荐开黑房" fontSize:[ccui getRH:12] color:KKES_COLOR_BLACK_TEXT];
    [self addSubview:titleL];
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([ccui getRH:14]);
        make.left.mas_equalTo(leftSpace);
    }];
    
    //2.reminderLabel
    DGLabel *reminderL = [DGLabel labelWithText:@"暂无推荐开黑房" fontSize:[ccui getRH:12] color:KKES_COLOR_GRAY_TEXT];
    reminderL.textAlignment = NSTextAlignmentCenter;
    [self addSubview:reminderL];
    [reminderL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-[ccui getRH:20]);
    }];
    
    //3.collocationV
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(titleL.mas_bottom).mas_offset([ccui getRH:1]);
        make.bottom.mas_equalTo(-[ccui getRH:7]);
    }];
 
    //4.推荐btn
    DGButton *recommendBtn = [DGButton btnWithFontSize:[ccui getRH:11] title:@"添加开黑房" titleColor:UIColor.whiteColor bgColor:rgba(250, 206, 112, 1)];
    recommendBtn.layer.cornerRadius = [ccui getRH:5];
    recommendBtn.layer.masksToBounds = YES;
    self.recommendButton = recommendBtn;
    [self addSubview:recommendBtn];
    [recommendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([ccui getRH:7]);
        make.right.mas_equalTo(-leftSpace);
        make.width.mas_equalTo([ccui getRH:74]);
        make.height.mas_equalTo([ccui getRH:25]);
    }];
    
    WS(weakSelf);
    [recommendBtn addClickWithTimeInterval:0.5 block:^(DGButton *btn) {
        SS(strongSelf);
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(gameRoomViewDidClickRecommendButton:)]) {
            [strongSelf.delegate gameRoomViewDidClickRecommendButton:strongSelf];
        }
    }];
}


#pragma mark - tool
-(void)setConfigBlock:(KKLiveStudioGameRoomConfigBlock)configBlock selectBlock:(KKLiveStudioGameRoomSelectBlock)selectBlock {
    self.configBlock = configBlock;
    self.selectBlock = selectBlock;
}

- (id)modelAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataArray.count > indexPath.row ? self.dataArray[indexPath.row] : nil;
}


#pragma mark - delegate
#pragma mark  UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KKLiveStudioGameRoomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kLiveStudioGameRoomCollectionCell forIndexPath:indexPath];
    
    id model = [self modelAtIndexPath:indexPath];
    if(self.configBlock) {
        self.configBlock(cell, model,indexPath);
    }
    
    return cell;
}

#pragma mark UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id model = [self modelAtIndexPath:indexPath];
    if (self.selectBlock) {
        self.selectBlock(model, indexPath);
    }
}

#pragma mark UIScrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(gameRoomViewWillBeginDragging:)]) {
        [self.delegate gameRoomViewWillBeginDragging:self];
    }
}

#pragma mark - setter
-(void)setIsHostCheck:(BOOL)isHostCheck {
    _isHostCheck = isHostCheck;
    
    self.recommendButton.hidden = !isHostCheck;
}

-(void)setDataArray:(NSArray<id> *)dataArray {
    _dataArray = dataArray;
    
    //其他设置
    dispatch_main_async_safe(^{
        self.collectionView.hidden = dataArray.count<1;
    })
    
}

@end
