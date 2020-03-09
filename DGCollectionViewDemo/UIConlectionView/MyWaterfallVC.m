//
//  MyWaterfallVC.m
//  UIConlectionView
//
//  Created by David.G on 2020/3/6.
//  Copyright © 2020 jaki. All rights reserved.
//

#import "MyWaterfallVC.h"
#import "MyWaterFlowLayout.h"

@interface MyWaterfallVC ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end

@implementation MyWaterfallVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyWaterFlowLayout * layout = [[MyWaterFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemCount=100;
    UICollectionView * collect  = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    collect.delegate=self;
    collect.dataSource=self;
    
    [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    
    [self.view addSubview:collect];
}


#pragma mark - delegate

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 100;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    return cell;
}

@end
