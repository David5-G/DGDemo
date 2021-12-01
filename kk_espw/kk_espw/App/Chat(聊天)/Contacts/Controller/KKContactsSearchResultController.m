//
//  KKContactsSearchResultControllerViewController.m
//  kk_espw
//
//  Created by 阿杜 on 2019/7/18.
//  Copyright © 2019 david. All rights reserved.
//

#define contactsSearchResultCellId @"contactsSearchResultCellId"

#import "KKContactsSearchResultController.h"
#import "KKContactsCell.h"

@interface KKContactsSearchResultController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation KKContactsSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate =self;
    self.tableView.dataSource = self;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contactsSearchResultArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KKContactsCell *contactsCell = [tableView dequeueReusableCellWithIdentifier:contactsSearchResultCellId forIndexPath:indexPath];
    [contactsCell loadModel:_contactsSearchResultArr[indexPath.row]];
    return contactsCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [ccui getRH:62];
}


#pragma mark upadteSearch
- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    
}


@end
