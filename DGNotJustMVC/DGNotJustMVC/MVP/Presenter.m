//
//  Presenter.m
//  DGNotJustMVC
//
//  Created by David.G on 2019/7/10.
//  Copyright © 2019 David.G. All rights reserved.
//

#import "Presenter.h"
#import <UIKit/UIKit.h>
//model
#import "DGModel.h"
//tool
#import "DGDataMgr.h"
//thd
#import <MJExtension/MJExtension.h>

@implementation Presenter

#pragma mark - lazy load
- (NSMutableArray *)modelArray{
    if (!_modelArray) {
        _modelArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _modelArray;
}


#pragma mark - life circle
- (instancetype)init{
    if (self = [super init]) {
        [self loadData];
    }
    return self;
}

#pragma mark - MvpDelegate
- (void)didClickAddBtnWithNum:(NSString *)num indexPath:(NSIndexPath *)indexPath{
    
    //1.防越界
    if (indexPath.row >= self.modelArray.count) {  return; }
    
    //2.获取并改变model
    DGModel *model = self.modelArray[indexPath.row];
    model.num = num;
    
    //3.特定情况改变 数据源
    //3.1 升级
    if ([num intValue] > 19 && [model.name containsString:@"A"]) {
        
        //3.1.1 更改数据源
        NSArray *temArray = [DGDataMgr loadDataB];
        [self.modelArray removeAllObjects];
        [self.modelArray addObjectsFromArray:[DGModel mj_objectArrayWithKeyValuesArray:temArray]];
        
        //3.1.2 调代理方法 刷新UI
        if (self.delegate && [self.delegate respondsToSelector:@selector(refreshUI)]) {
            [self.delegate refreshUI];
        }
    }
    
    //3.2 降级
    if ([num intValue] < 1 && [model.name containsString:@"B"]) {
        
        //3.2.1 更改数据源
        NSArray *temArray = [DGDataMgr loadDataA];
        [self.modelArray removeAllObjects];
        [self.modelArray addObjectsFromArray:[DGModel mj_objectArrayWithKeyValuesArray:temArray]];
        
        //3.2.2 调代理方法 刷新UI
        if (self.delegate && [self.delegate respondsToSelector:@selector(refreshUI)]) {
            [self.delegate refreshUI];
        }
    }
    
}


#pragma mark - 加载数据
- (void)loadData{
    
    NSArray *temArray = [DGDataMgr loadDataA];
    NSArray *modelArr = [DGModel mj_objectArrayWithKeyValuesArray:temArray];
    [self.modelArray removeAllObjects];
    [self.modelArray addObjectsFromArray:modelArr];
}

@end
