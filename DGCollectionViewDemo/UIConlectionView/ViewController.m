//
//  ViewController.m
//  UIConlectionView
//
//  Created by jaki on 15/10/27.
//  Copyright © 2015年 jaki. All rights reserved.
//

#import "ViewController.h"
#import "My3DVC.h"
#import "My3dBallVC.h"
#import "MyWaterfallVC.h"
#import "MyCircleVC.h"

#define kCell @"resuseCell"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSArray *cellNameList;
@end

@implementation ViewController

#pragma mark - lazy load
- (NSArray *)cellNameList {
    if (!_cellNameList) {
        _cellNameList = @[@"3D",@"3D球形",@"瀑布流",@"环形"];
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


#pragma mark - UI
- (void)setupUI {
    self.navigationItem.title = @"demoList";
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    [self setupTableView];
}

- (void)setupTableView {
    UITableView *tableV = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView = tableV;
    tableV.delegate = self;
    tableV.dataSource = self;
    tableV.backgroundColor = UIColor.brownColor;
    
    [self.view addSubview:tableV];
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
    
    UIViewController *vc;
    if ([text isEqualToString:@"3D"]) {
        vc = [[My3DVC alloc]init];
    }else if ([text isEqualToString:@"3D球形"]){
        vc = [[My3dBallVC alloc]init];
    }else if ([text isEqualToString:@"瀑布流"]){
        vc = [[MyWaterfallVC alloc]init];
    }else if ([text isEqualToString:@"环形"]){
        vc = [[MyCircleVC alloc]init];
    }
    
    //3.跳转
    if (vc) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
