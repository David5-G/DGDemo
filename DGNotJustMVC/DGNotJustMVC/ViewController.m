//
//  ViewController.m
//  DGNotJustMVC
//
//  Created by David.G on 2019/7/9.
//  Copyright © 2019 David.G. All rights reserved.
//

#import "ViewController.h"

#import "MvcVC.h"
#import "MvcOptimizeVC.h"
#import "MvpVC.h"
#import "MvvmVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"NotJustMVC";
    self.view.backgroundColor = UIColor.lightGrayColor;
    [self setupUI];
}


-(void)setupUI {
    
    //1.mvc
    UIButton *mvcBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 200, 200, 50)];
    mvcBtn.backgroundColor = UIColor.darkGrayColor;
    [mvcBtn setTitle:@"go to mvcVC" forState:UIControlStateNormal];
    [self.view addSubview:mvcBtn];
    [mvcBtn addTarget:self action:@selector(clickMvcButton) forControlEvents:UIControlEventTouchUpInside];
    
    //2.mvcOptimizeVC
    UIButton *mvcOptimizeBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 300, 200, 50)];
    mvcOptimizeBtn.backgroundColor = UIColor.darkGrayColor;
    [mvcOptimizeBtn setTitle:@"go to mvcOptimizeVC" forState:UIControlStateNormal];
    [self.view addSubview:mvcOptimizeBtn];
    [mvcOptimizeBtn addTarget:self action:@selector(clickMvcOptimizeBtn) forControlEvents:UIControlEventTouchUpInside];
    
    //3.mvp
    UIButton *mvpBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 400, 200, 50)];
    mvpBtn.backgroundColor = UIColor.darkGrayColor;
    [mvpBtn setTitle:@"go to mvpVC" forState:UIControlStateNormal];
    [self.view addSubview:mvpBtn];
    [mvpBtn addTarget:self action:@selector(clickMvpButton) forControlEvents:UIControlEventTouchUpInside];
    
    //4.mvvm
    UIButton *mvvmBtn = [[UIButton alloc]initWithFrame:CGRectMake(50, 500, 200, 50)];
    mvvmBtn.backgroundColor = UIColor.darkGrayColor;
    [mvvmBtn setTitle:@"go to mvvmVC" forState:UIControlStateNormal];
    [self.view addSubview:mvvmBtn];
    [mvvmBtn addTarget:self action:@selector(clickMvvmButton) forControlEvents:UIControlEventTouchUpInside];
}



-(void)clickMvcButton{
    MvcVC *vc = [[MvcVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)clickMvcOptimizeBtn{
    MvcOptimizeVC *vc = [[MvcOptimizeVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}



-(void)clickMvpButton{
    MvpVC *vc = [[MvpVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)clickMvvmButton{
    MvvmVC *vc = [[MvvmVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
