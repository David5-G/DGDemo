//
//  MvcVC.m
//  DGNotJustMVC
//
//  Created by David.G on 2019/7/9.
//  Copyright © 2019 David.G. All rights reserved.
//

#import "MvcVC.h"
//view
#import "MvcTableViewCell.h"
//tool
#import "DGDataMgr.h"
//thd
#import <MJExtension/MJExtension.h>

#define kCellReuseId @"cellResueId"

@interface MvcVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation MvcVC

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
        [_tableView registerClass:[MvcTableViewCell class] forCellReuseIdentifier:kCellReuseId];
    }
    return _tableView;
}


#pragma mark - life circle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"mvcVC";
    self.view.backgroundColor = [UIColor whiteColor];
 
    [self loadData];
    [self setupUI];
}


#pragma mark - UI
-(void)setupUI {
    
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

#pragma mark - delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MvcTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellReuseId forIndexPath:indexPath];
    DGModel *model = self.dataArray[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"mvcVC --- 点击了第%ld行cell",indexPath.row);
}

#pragma mark - 加载数据
- (void)loadData{
    
    NSArray *temArray = [DGDataMgr loadDataA];
    NSArray *modelArr = [DGModel mj_objectArrayWithKeyValuesArray:temArray];
    [self.dataArray addObjectsFromArray:modelArr];
}



@end
