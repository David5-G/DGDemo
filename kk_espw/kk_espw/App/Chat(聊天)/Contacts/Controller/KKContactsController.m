//
//  KKContactsController.m
//  kk_espw
//
//  Created by 罗礼豪 on 2019/7/11.
//  Copyright © 2019 david. All rights reserved.
//

#import "KKContactsController.h"
#import "KKContactsCell.h"
#import "KKContactsNewFriendsCell.h"
#import "KKNewFriendsController.h"
#import "KKContactsService.h"
#import "KKContactsSearchResultController.h"

static NSString *contactsCellId = @"contactsCellId";
static NSString *contactsNewFriendsCellId = @"contactsNewFriendsCellId";

@interface KKContactsController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSArray <NSArray *>*_contactsArr;
    NSArray *_searchResultContactsArr;
    NSArray *_contactsIndexLetterArr;//索引字母
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UISearchController *displayer;
@end

@implementation KKContactsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNaviBarWithType:DGNavigationBarTypeWhite];
    [self setNaviBarTitle:@"通讯录"];
    
    [self setupViews];
    [self requestData];
}

- (void)setupViews {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, STATUSBAR_ADD_NAVIGATIONBARHEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUSBAR_ADD_NAVIGATIONBARHEIGHT)];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[KKContactsCell class] forCellReuseIdentifier:contactsCellId];
    [_tableView registerClass:[KKContactsNewFriendsCell class] forCellReuseIdentifier:contactsNewFriendsCellId];

    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _tableView.sectionIndexColor = [UIColor blackColor];
    
    KKContactsSearchResultController *searchResultVC = [[KKContactsSearchResultController alloc] init];
    self.displayer = [[UISearchController alloc] initWithSearchResultsController:searchResultVC];
    self.displayer.searchResultsUpdater = searchResultVC;
    self.displayer.searchBar.tintColor = rgba(102, 102, 102, 102);
    self.displayer.searchBar.barTintColor = [UIColor groupTableViewBackgroundColor];
    self.displayer.searchBar.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    _tableView.tableHeaderView = self.displayer.searchBar;
}

-(void)requestData
{
    [KKContactsService requestMyContacts:^(NSArray *contacts,NSArray *indexArr) {
        self->_contactsArr = contacts;
        self->_contactsIndexLetterArr = indexArr;
        [self.tableView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _contactsArr.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    
    section = section-1;
    return _contactsArr[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = 0;
    if (indexPath.section == 0) {
        KKContactsNewFriendsCell *contactsNewFreindsCell = [tableView dequeueReusableCellWithIdentifier:contactsNewFriendsCellId forIndexPath:indexPath];
        contactsNewFreindsCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return contactsNewFreindsCell;
    }
    
    section = indexPath.section-1;
    KKContactsCell *contactsCell = [tableView dequeueReusableCellWithIdentifier:contactsCellId forIndexPath:indexPath];
    [contactsCell loadModel:_contactsArr[section][indexPath.row]];
    return contactsCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger section = 0;
    if (indexPath.section == 0) {
        KKNewFriendsController *newFriendsController = [[KKNewFriendsController alloc] init];
        [self.navigationController pushViewController:newFriendsController animated:YES];
    }else{
        section = section-1;
        _contactsArr[section][indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ccui getRH:62];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    }
    section = section-1;
    return _contactsIndexLetterArr[section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return [ccui getRH:30];
}

#pragma 索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return _contactsIndexLetterArr;
}
//点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index+1;
}
@end
