//
//  MyCircleVC.m
//  UIConlectionView
//
//  Created by David.G on 2020/3/6.
//  Copyright © 2020 jaki. All rights reserved.
//

#import "MyCircleVC.h"
#import "MyCircleLayout.h"

@interface MyCircleVC ()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation MyCircleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    MyCircleLayout * layout = [[MyCircleLayout alloc]init];
    UICollectionView * collect  = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
    collect.delegate=self;
    collect.dataSource=self;
    
    [collect registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [self.view addSubview:collect];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 10;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    cell.layer.masksToBounds = YES;
    cell.layer.cornerRadius = 25;
    cell.backgroundColor = [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1];
    return cell;
}
@end
