//
//  ViewController.m
//  DGDemo
//
//  Created by david on 2018/10/17.
//  Copyright © 2018 david. All rights reserved.
//

#import "ViewController.h"
#import "UIScannerDemoVC.h"



#define kCell @"resuseCell"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *cellNameList;
@end

@implementation ViewController

#pragma mark - lazy load
- (NSArray *)cellNameList {
    if (!_cellNameList) {
        _cellNameList = @[@"Scanner",@"HitTest"];
    }
    return _cellNameList;
}

#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - network request

#pragma mark - UI
- (void)setupUI {
    self.navigationController.view.backgroundColor = UIColor.redColor;
    self.view.backgroundColor = UIColor.lightGrayColor;
    [self setupTableView];
}

- (void)setupTableView {
    UITableView *tableV = [[UITableView alloc]init];
    self.tableView = tableV;
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.backgroundColor = UIColor.brownColor;
    
    [self.view addSubview:tableV];
    CGFloat topSpace = iPhoneX ? 88.0 : 64.0;
    CGFloat bottomSpace = iPhoneX ? 34.0 : 0;
    [tableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(topSpace);
        make.bottom.mas_equalTo(-bottomSpace);
    }];
}


#pragma mark - tableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellNameList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCell];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCell];
    }
    cell.textLabel.text = self.cellNameList[indexPath.row];
    
    return cell;
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
   //1.获取cell的text
    NSString *text = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    //2.匹配text,赋值vc
    UIViewController *vc;
    if ([text isEqual:@"Scanner"]) {
        vc = [[UIScannerDemoVC alloc]init];
    }
    
    //3.跳转
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
