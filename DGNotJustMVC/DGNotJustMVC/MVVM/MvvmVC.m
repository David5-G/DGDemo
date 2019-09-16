//
//  MvvmVC.m
//  DGNotJustMVC
//
//  Created by David.G on 2019/7/9.
//  Copyright © 2019 David.G. All rights reserved.
//

#import "MvvmVC.h"
//view
#import "MvvmTableViewCell.h"
//viewModel
#import "MvvmViewModel.h"
//model
#import "DGModel.h"
//tool
#import "DGDataSource.h"
#define kCellReuseId @"cellResueId"

@interface MvvmVC ()<MvvmTableViewCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) DGDataSource *ds;
@property (nonatomic,strong) MvvmViewModel *viewModel;
@end

@implementation MvvmVC

#pragma mark - lazy load
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[MvvmTableViewCell class] forCellReuseIdentifier:kCellReuseId];
    }
    return _tableView;
}


#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"mvvmVC";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}


#pragma mark - UI
-(void)setupUI {
    
    __weak typeof(self) weakSelf = self;
    
    //1.设置viewModel
    self.viewModel = [[MvvmViewModel alloc]init];
    [self.viewModel setBlockWithSuccess:^(NSArray *dataArr) {
        
        ///绑定 block(data) --> UI
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.ds.modelArray = dataArr;
        [strongSelf.tableView reloadData];
        
    } fail:^(id  _Nonnull data) {
        NSLog(@"mvvmVC --- 获取数据失败");
    }];
    
    //2.创建DGDataSource实例对象
    self.ds = [[DGDataSource alloc]initWithIdentifier:kCellReuseId configBlock:^(MvvmTableViewCell *cell, DGModel *model, NSIndexPath * _Nonnull indexPath) {
        
        cell.nameLabel.text = model.name;
        cell.num = [model.num intValue];
        cell.delegate = weakSelf;
        
    } selectBlock:^(NSIndexPath * _Nonnull indexPath) {
        NSLog(@"mvvmVC --- 点击了第%ld行cell", (long)indexPath.row);
    }];
    
    //3.设置tableView
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self.ds;
    self.tableView.delegate = self.ds;
    
    
    //4.loadData
    [self.viewModel loadData];
}


#pragma mark - delegate
-(void)didClickAddSubBtn:(MvvmTableViewCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    //过滤
    if(indexPath == nil){ return; }
    
    ///UI发生变化,发出一个信号给viewModel,viewModel去改变数据
    //1.查看升级/降级
    int num = [cell.numLabel.text intValue];
    NSString *nameStr = cell.nameLabel.text;
    //1.1升级
    if ([nameStr containsString:@"A"] && num > 19) {
        self.viewModel.grade = @"B";
        return ;//升降级后 数据就重置了, 无需改数据了
    }
    
    //1.2降级级
    if ([nameStr containsString:@"B"] && num < 1) {
        self.viewModel.grade = @"A";
        return ;//升降级后 数据就重置了, 无需改数据了
    }
    
    //2.改数据
    if (indexPath) {
        [self.viewModel numChanged:cell.numLabel.text atIndexPath:indexPath];
    }
}

@end
