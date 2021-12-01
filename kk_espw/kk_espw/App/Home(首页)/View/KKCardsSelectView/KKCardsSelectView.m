//
//  KKCardsSelectView.m
//  kk_espw
//
//  Created by 景天 on 2019/7/11.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKCardsSelectView.h"
#import "KKCardsSelectCell.h"

@interface KKCardsSelectView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *whiteView;
@end

@implementation KKCardsSelectView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = rgba(0, 0, 0, 0.4);
        _whiteView = [[UIView alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT - [ccui getRH:320 + HOME_INDICATOR_HEIGHT + 5], SCREEN_WIDTH - [ccui getRH:20], [ccui getRH:320])];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.layer.cornerRadius = 10;
        [self addSubview:_whiteView];
        
        UILabel *des = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _whiteView.width, 60)];
        des.textColor = KKES_COLOR_BLACK_TEXT;
        des.text = @"选择加入局名片";
        des.textAlignment = NSTextAlignmentCenter;
        des.font = [ccui getRFS:18];
        [_whiteView addSubview:des];
        
        [_whiteView addSubview:self.tableView];
    }
    return self;
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake([ccui getRH:15], [ccui getRH:60], _whiteView.width - [ccui getRH:30], _whiteView.height - 65) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorColor = [UIColor whiteColor];
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        
        [_tableView registerClass:[KKCardsSelectCell class] forCellReuseIdentifier:@"KKCardsSelectCell"];
    }
    return _tableView;
}

#pragma mark - UITableViewDataSource, UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ccui getRH:60];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKCardsSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KKCardsSelectCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}


@end
