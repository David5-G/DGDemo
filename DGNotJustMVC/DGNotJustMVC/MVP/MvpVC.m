//
//  MvpVC.m
//  DGNotJustMVC
//
//  Created by David.G on 2019/7/9.
//  Copyright © 2019 David.G. All rights reserved.
//

#import "MvpVC.h"
//view
#import "MvpTableViewCell.h"
//model
#import "DGModel.h"
//tool
#import "DGDataMgr.h"
#import "DGDataSource.h"
#import "Presenter.h"

#define kCellReuseId @"cellResueId"

@interface MvpVC ()<MvpDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic,strong) DGDataSource *ds;
@property (nonatomic,strong) Presenter *pt;

@end

@implementation MvpVC


#pragma mark - lazy load

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[MvpTableViewCell class] forCellReuseIdentifier:kCellReuseId];
    }
    return _tableView;
}


#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"mvpVC";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}


#pragma mark - UI
-(void)setupUI {
    
    //1.设置presenter
    self.pt = [[Presenter alloc]init];
    self.pt.delegate = self;
    
    //2.创建DGDataSource实例对象
    __weak typeof(self) weakSelf = self;
    self.ds = [[DGDataSource alloc]initWithIdentifier:kCellReuseId configBlock:^(MvpTableViewCell *cell, DGModel *model, NSIndexPath * _Nonnull indexPath) {
        
        cell.nameLabel.text = model.name;
        cell.num = [model.num intValue];
        cell.delegate = weakSelf.pt;
        cell.indexPath = indexPath;
        
    } selectBlock:^(NSIndexPath * _Nonnull indexPath) {
        NSLog(@"mvpVC --- 点击了第%ld行cell", (long)indexPath.row);
    }];
    
    //设置modelArray数据源
    self.ds.modelArray = self.pt.modelArray;
    
    //3.设置tableView
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self.ds;
    self.tableView.delegate = self.ds;
}

#pragma mark - delegate
#pragma mark MvpDelegate
-(void)refreshUI {
    self.ds.modelArray = self.pt.modelArray;
    [self.tableView reloadData];
}


@end
