//
//  MvvmViewModel.m
//  DGNotJustMVC
//
//  Created by David.G on 2019/7/10.
//  Copyright © 2019 David.G. All rights reserved.
//

#import "MvvmViewModel.h"
//model
#import "DGModel.h"
//tool
#import "DGDataMgr.h"
//thd
#import <MJExtension/MJExtension.h>
#import <ReactiveObjC.h>


/**
 * MVVM 双向绑定
 * ① model -- > UI    方法: block 逆向传值      如:MvvmVC的successBlock设置74-80行
 * ② UI --- > model   方法: 响应式(给一个信号)    如:MvvmVC的self.viewModel.grade=;
 */

/**
 * 本例子用3中方式接收响应
 * ① KVO
 * ② setter
 * ③ RAC
 */

@interface MvvmViewModel ()
@property (nonatomic,strong) NSMutableArray *modelArray;

@end

@implementation MvvmViewModel
#pragma mark - lazy load
-(NSMutableArray *)modelArray {
    if (!_modelArray) {
        _modelArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _modelArray;
}

#pragma mark - life circle
-(instancetype)init {
    self = [super init];
    if (self) {
        //① KVO
        [self addObserver:self forKeyPath:@"grade" options:NSKeyValueObservingOptionNew context:nil];
        
        //③ RAC
        /*
        __weak typeof(self) weakSelf = self;
        [RACObserve(self, grade) subscribeNext:^(id  _Nullable x) {
            __strong typeof(weakSelf) strongSelf = self;
            [strongSelf loadData:x];
        }];
         */
        
    }
    return self;
}

-(void)dealloc {
    [self removeObserver:self forKeyPath:@"grade"];
}

#pragma mark - 业务处理
-(NSString *)nameStrForIndexPath:(NSIndexPath *)indexPath {
    //1.防越界
    if (indexPath.row >= self.modelArray.count) {  return @""; }
    
    //2.model
    DGModel *model = self.modelArray[indexPath.row];
    NSString *nameStr = model.name;
    if ([nameStr containsString:@"魔抗"]) {
        return nameStr;
    }else {
        return [nameStr stringByAppendingString:@"*"];
    }
    
}


#pragma mark - data
#pragma mark load
-(void)loadData {
    //1.加载数据
    [self loadData:@"A"];
}

-(void)loadData:(NSString *)grade {
    
    //1.加载数据
    NSArray *temArray ;
    if ([grade isEqualToString:@"A"]) {
        temArray = [DGDataMgr loadDataA];
    }else if ([grade isEqualToString:@"B"]){
        temArray = [DGDataMgr loadDataB];
    }
    
    //2.模拟请求失败
    if(temArray.count < 1){
        if(self.failBlock){
            self.failBlock(@"加载失败");
        }
        return;
    }
    
    //3.请求成功
    NSArray *modelArr = [DGModel mj_objectArrayWithKeyValuesArray:temArray];
    [self.modelArray removeAllObjects];
    [self.modelArray addObjectsFromArray:modelArr];
    __weak typeof(self) weakSelf = self;
    if (self.successBlock) {
        self.successBlock(weakSelf.modelArray);
    }
}


#pragma mark change
-(void)numChanged:(NSString *)numStr atIndexPath:(NSIndexPath *)indexPath {
    
    //1.防越界
    if (indexPath.row >= self.modelArray.count) {  return; }
    
    //2.获取并改变model
    DGModel *model = self.modelArray[indexPath.row];
    model.num = numStr;
}


#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    //1.获取新值
    NSString *newGrade = change[NSKeyValueChangeNewKey];
    NSLog(@"MvvmViewMOdel --- newGrad:%@",newGrade);
    
    @synchronized (self) {
        [self loadData:newGrade];
    }
}

#pragma mark - setter
//①
//-(void)setGrade:(NSString *)grade {
//    @synchronized (self) {
//        [self loadData:grade];
//    }
//}



@end
