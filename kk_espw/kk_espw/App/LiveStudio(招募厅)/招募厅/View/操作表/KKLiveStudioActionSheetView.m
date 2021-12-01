//
//  KKLiveStudioActionSheetView.m
//  kk_espw
//
//  Created by david on 2019/7/24.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioActionSheetView.h"

@interface KKLiveStudioActionSheetView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation KKLiveStudioActionSheetView

#pragma mark - lazy load
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]init];
    }
    return _tableView;
}

#pragma mark - setter
-(void)setDataArray:(NSArray<NSString *> *)dataArray {
    _dataArray = [dataArray copy];
    
    //1.如果添加了tableView才刷新
    if (self.tableView.superview) {
        [self.tableView reloadData];
    }
}

#pragma mark - 重写父类方法
-(void)setupSubViewsForDisplayView:(UIView *)displayView {
    self.forbidTapHidden = YES;
    
    [displayView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-HOME_INDICATOR_HEIGHT);
    }];
}

#pragma mark - delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    NSString *cellId = @"cellId";
    NSInteger labelTag = 1233221;
    //1.获取cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {//获取重用失败,创建
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        //1.1 创建label
        DGLabel *label = [DGLabel labelWithText:@"" fontSize:[ccui getRH:17] color:KKES_COLOR_BLACK_TEXT];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = labelTag;
        [cell addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    
    //2.设置cell
    UILabel *label = [cell viewWithTag:labelTag];
    if (label) {
        label.text = self.dataArray[row];
        label.textColor = [label.text isEqualToString:@"取消"] ? KKES_COLOR_GRAY_TEXT : KKES_COLOR_BLACK_TEXT;
    }
    
    //添加灰色线条
    if(row < self.dataArray.count-1){
        [self addBottomGrayLineToView:cell];
    }
    
    //3.return
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    //1.移除
    [self hidePopView];
    
    //2.block
    NSString *title = self.dataArray[indexPath.row];
    if (self.selectBlock) {
        self.selectBlock(title);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight > 10 ? self.cellHeight : 44;
}

#pragma mark tool
-(void)addBottomGrayLineToView:(UIView *)view {
    CGFloat leftSpace = [ccui getRH:25];
    UIView *grayLine = [[UIView alloc]init];
    grayLine.backgroundColor = KKES_COLOR_GRAY_LINE;
    
    [view addSubview:grayLine];
    [grayLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(leftSpace);
        make.right.mas_equalTo(-leftSpace);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
}


@end
