//
//  MvcOptimizeVC.m
//  DGNotJustMVC
//
//  Created by David.G on 2019/7/9.
//  Copyright © 2019 David.G. All rights reserved.
//

#import "MvcOptimizeVC.h"
//view
#import "MvcOptimizeTableViewCell.h"
//model
#import "DGModel.h"
//tool
#import "DGDataMgr.h"
#import "DGDataSource.h"
//thd
#import <MJExtension/MJExtension.h>

#define kCellReuseId @"cellResueId"

@interface MvcOptimizeVC ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic,strong) DGDataSource *ds;

@end

@implementation MvcOptimizeVC

#pragma mark - lazy load
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithCapacity:10];
    }
    return _dataArray;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[MvcOptimizeTableViewCell class] forCellReuseIdentifier:kCellReuseId];
    }
    return _tableView;
}


#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"mvcOptimizeVC";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self loadData];
    [self setupUI];
}


#pragma mark - UI
-(void)setupUI {
    //1.创建DGDataSource实例对象
    self.ds = [[DGDataSource alloc]initWithIdentifier:kCellReuseId configBlock:^(MvcOptimizeTableViewCell *cell, DGModel *model, NSIndexPath * _Nonnull indexPath) {
        
        cell.nameLabel.text = model.name;
        cell.num = [model.num intValue];
        
    } selectBlock:^(NSIndexPath * _Nonnull indexPath) {
        NSLog(@"mvcOptimizeVC --- 点击了第%ld行cell", (long)indexPath.row);
    }];
    //设置modelArray数据源
    self.ds.modelArray = self.dataArray;
    
    //2.设置tableView
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self.ds;
    self.tableView.delegate = self.ds;
}


#pragma mark - 加载数据
- (void)loadData{
    
    NSArray *temArray = [DGDataMgr loadDataA];
    NSArray *modelArr = [DGModel mj_objectArrayWithKeyValuesArray:temArray];
    [self.dataArray addObjectsFromArray:modelArr];
}

@end
