//
//  KKLiveStudioForbidWordUserListView.m
//  kk_espw
//
//  Created by david on 2019/7/25.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKLiveStudioForbidWordUserListView.h"
#import "KKLiveStudioForbidWordUserCell.h"

#define kCellIdStr @"KKLiveStudioForbidWordUserCell"

@interface KKLiveStudioForbidWordUserListView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, readwrite) UITableView *tableView;
@property (nonatomic, strong) NoContentReminderView *notDateView;
@property (nonatomic, copy) KKLiveStudioConfigBlock configBlock;
@property (nonatomic, copy) KKLiveStudioSelectBlock selectBlock;
@end

@implementation KKLiveStudioForbidWordUserListView

#pragma mark - lazy load
- (NoContentReminderView *)notDateView{
    if (!_notDateView) {
        NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] init];
        attribute = [CC_AttributedStr getOrigAttStr:attribute appendStr:@"暂时没有数据哦~" withColor:[UIColor grayColor]];
        _notDateView = [[NoContentReminderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-2*[ccui getRH:10], [ccui getRH:450]) imageTopY:[ccui getRH:80] image:Img(@"data_is_null") remindWords:attribute];
    }
    return _notDateView;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [[UIView alloc]init];
        [_tableView registerClass:[KKLiveStudioForbidWordUserCell class] forCellReuseIdentifier:kCellIdStr];
        
    }
    return _tableView;
}

#pragma mark - life circle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
}

#pragma mark - tool
-(void)setConfigBlock:(KKLiveStudioConfigBlock)configBlock selectBlock:(KKLiveStudioSelectBlock)selectBlock {
    self.configBlock = configBlock;
    self.selectBlock = selectBlock;
}

- (id)modelAtIndexPath:(NSIndexPath *)indexPath {
    return self.dataArray.count > indexPath.row ? self.dataArray[indexPath.row] : nil;
}


#pragma mark - delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KKLiveStudioForbidWordUserCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdStr forIndexPath:indexPath];
    
    id model = [self modelAtIndexPath:indexPath];
    if(self.configBlock) {
        self.configBlock(cell, model,indexPath);
    }
    
    //添加灰色线条
    //    if(row < self.dataArray.count-1){
    //        [self addBottomGrayLineToView:cell];
    //    }
    
    //3.return
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    id model = [self modelAtIndexPath:indexPath];
    if (self.selectBlock) {
        self.selectBlock(model, indexPath);
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ccui getRH:72];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.dataArray.count > 0 ) {
        return nil;
    }else{
        return self.notDateView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.dataArray.count > 0 ) {
        return 0;
    }else{
        return self.notDateView.height;
    }
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
