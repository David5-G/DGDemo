//
//  KKContactsHeaderView.m
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/15.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKContactsHeaderView.h"
#import "KKSearchBar.h"

@interface KKContactsHeaderView()<UISearchBarDelegate>

@property (nonatomic, strong) KKSearchBar *searchBar;
@property (nonatomic, strong) UIView *newsFriendsView;

@end

@implementation KKContactsHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _searchBar = [[KKSearchBar alloc] init];
    _searchBar.placeholder = @"搜索";
    _searchBar.delegate = self;
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTintColor:rgba(51, 51, 51, 1)];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:@"取消"];
    
    // 设置占位文字字体
    [_searchBar cleanOtherSubViews];
    [self addSubview:_searchBar];
    [_searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(15);
        make.right.equalTo(self).mas_offset(-15);
        make.top.equalTo(self);
        make.height.mas_equalTo(49);
    }];
    
    _newsFriendsView = [[UIView alloc] init];
    UITapGestureRecognizer *newsFriendsViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(newsFriendsViewDidTap:)];
    [_newsFriendsView addGestureRecognizer:newsFriendsViewTap];
    _newsFriendsView.userInteractionEnabled = YES;
    [self addSubview:_newsFriendsView];
    [_newsFriendsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.top.equalTo(self.searchBar.mas_bottom);
    }];
    
    UILabel *newsFriendsLabel = [[UILabel alloc] init];
    newsFriendsLabel.userInteractionEnabled = YES;
    newsFriendsLabel.text = @"新朋友";
    [_newsFriendsView addSubview:newsFriendsLabel];
    [newsFriendsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(15);
        make.bottom.equalTo(self).mas_offset(-30);
        make.height.mas_equalTo(15);
    }];
}

- (void)newsFriendsViewDidTap:(UITapGestureRecognizer *)tap {
    if (_delegate && [_delegate respondsToSelector:@selector(pushToNewsFriendsInterface)]) {
        [_delegate pushToNewsFriendsInterface];
    }
}

// MARK: - UISearchBarDelegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [_searchBar setShowsCancelButton:NO animated:YES];
    [_searchBar.textField resignFirstResponder];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

@end
