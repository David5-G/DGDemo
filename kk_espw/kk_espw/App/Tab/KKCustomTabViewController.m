//
//  KKCustomViewController.m
//  kk_espw
//
//  Created by 景天 on 2019/7/10.
//  Copyright © 2019年 david. All rights reserved.
//

#import "KKCustomTabViewController.h"
#import "KKHomeVC.h"
#import "KKDiscoverVC.h"
#import "KKMineVC.h"
#import "KKConversationListController.h"
#import "BaseNavigationController.h"
#import "KKCreateCardView.h"
#import "KKMyCardService.h"
#import "KKCreateGameRoomController.h"
#import "KKHomeViewController.h"
@interface KKCustomTabViewController ()<AxcAE_TabBarDelegate>
@property (nonatomic, strong) KKCreateCardView *createCardView;
@end

@implementation KKCustomTabViewController

static NSInteger lastIdx = 0;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupTabNavi];
    }
    return self;
}

- (void)setupTabNavi {
    /// 解决从二级页面返回tarBarItem跳动的问题
    [[UITabBar appearance] setTranslucent:NO];
    self.tabBar.tintColor = KKES_COLOR_BLACK_TEXT;
    ///2.navi
    NSDictionary *textAttributes = @{NSFontAttributeName : Font(19), NSForegroundColorAttributeName : KKES_COLOR_BLACK_TEXT};
    /// title字体属性
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    /// 返回图标,文字的颜色
    [[UINavigationBar appearance] setTintColor:KKES_COLOR_BLACK_TEXT];
    UIImage *naviBackImage = [UIImage imageNamed:@"navi_back_gray"];
    [[UINavigationBar appearance] setBackIndicatorImage:naviBackImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:naviBackImage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewControllers];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[KKFont pingfangFontStyle:PFFontStyleMedium size:9]} forState:UIControlStateNormal];

    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[KKFont pingfangFontStyle:PFFontStyleMedium size:9]} forState:UIControlStateSelected];
}

- (void)addChildViewControllers{
    // 首页
    KKHomeViewController *homeVC = [[KKHomeViewController alloc] init];
//    KKHomeVC *homeVC = [[KKHomeVC alloc] init];
    
    // 发现
    KKDiscoverVC *discoverVC = [[KKDiscoverVC alloc] init];
    
    // 通讯录
    KKConversationListController *conversationListController = [[KKConversationListController alloc] init];
    conversationListController.view.backgroundColor = [UIColor whiteColor];
    
    // 我的
    KKMineVC *mineVC = [[KKMineVC alloc] init];
    
    NSArray <NSDictionary *>*VCArray =
    @[@{@"vc":homeVC,@"normalImg":@"tab_home_normal",@"selectImg":@"tab_home_select",@"itemTitle":@"首页"},
      @{@"vc":discoverVC,@"normalImg":@"tab_discover_normal",@"selectImg":@"tab_discover_select",@"itemTitle":@"发现"},
      @{@"vc":[UIViewController new],@"normalImg":@"",@"selectImg":@"",@"itemTitle":@" "},
  @{@"vc":conversationListController,@"normalImg":@"tab_news_normal",@"selectImg":@"tab_news_select",@"itemTitle":@"消息"},
      @{@"vc":mineVC,@"normalImg":@"tab_me_normal",@"selectImg":@"tab_me_select",@"itemTitle":@"我的"}];
    
    // 1.遍历这个集合
    // 1.1 设置一个保存构造器的数组
    NSMutableArray *tabBarConfs = @[].mutableCopy;
    // 1.2 设置一个保存VC的数组
    NSMutableArray *tabBarVCs = @[].mutableCopy;
    [VCArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AxcAE_TabBarConfigModel *model = [AxcAE_TabBarConfigModel new];
        model.itemTitle = [obj objectForKey:@"itemTitle"];
        model.selectImageName = [obj objectForKey:@"selectImg"];
        model.normalImageName = [obj objectForKey:@"normalImg"];
        model.selectColor = [UIColor blackColor];
        model.normalColor = RGB(162, 165, 165);
        
        if (idx == 2 ) {
            model.bulgeStyle = AxcAE_TabBarConfigBulgeStyleSquare;
            model.bulgeHeight = 15;
            model.itemLayoutStyle = AxcAE_TabBarItemLayoutStylePicture;
            model.titleLabel.font = [UIFont systemFontOfSize:40];
            model.normalColor = [UIColor whiteColor];
            model.selectColor = [UIColor whiteColor];
            model.componentMargin = UIEdgeInsetsMake(-25, 0, 0, 0 );
            model.selectImageName = @"tab_center";
            model.normalImageName = @"tab_center";
            model.itemSize = CGSizeMake([ccui getRH:63],[ccui getRH:73]);
        }
        UIViewController *vc = [obj objectForKey:@"vc"];
        [tabBarVCs addObject:[[BaseNavigationController alloc] initWithRootViewController:vc]];
        [tabBarConfs addObject:model];
    }];

    self.viewControllers = tabBarVCs;
    self.axcTabBar = [AxcAE_TabBar new] ;
    [self.axcTabBar setBackgroundImageView:[UIImageView new]];
    self.axcTabBar.tabBarConfig = tabBarConfs;
    self.axcTabBar.delegate = self;
    [self.tabBar addSubview:self.axcTabBar];
    [self addLayoutTabBar];
    
    /// 去掉tabbar的横线
    if(@available(iOS 13.0, *)) {
        UITabBarAppearance *tabbarAppearance = self.tabBar.standardAppearance;
        tabbarAppearance.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
        tabbarAppearance.shadowImage = [UIImage imageWithColor:[UIColor clearColor]];
        self.tabBar.standardAppearance = tabbarAppearance;
        
    }else{
        self.tabBar.backgroundImage = [UIImage imageWithColor:[UIColor clearColor]];
        self.tabBar.shadowImage = [UIImage imageWithColor:[UIColor clearColor]];
    }
    ///
    self.tabBar.layer.shadowColor = [UIColor grayColor].CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -3);
    self.tabBar.layer.shadowRadius = 2;
    self.tabBar.layer.shadowOpacity = 0.1;
}

- (void)axcAE_TabBar:(AxcAE_TabBar *)tabbar selectIndex:(NSInteger)index{
    if (index != 2) {
        [self setSelectedIndex:index];
        lastIdx = index;
    }
    else{
        [self.axcTabBar setSelectIndex:lastIdx WithAnimation:NO];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PUSH_CREATEGAME_VC object:nil];
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex{
    [super setSelectedIndex:selectedIndex];
    if(self.axcTabBar){
        self.axcTabBar.selectIndex = selectedIndex;
    }
}

- (void)addLayoutTabBar{
    // 使用重载viewDidLayoutSubviews实时计算坐标 （下边的 -viewDidLayoutSubviews 函数）
    // 能兼容转屏时的自动布局
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.axcTabBar.frame = self.tabBar.bounds;
    [self.axcTabBar viewDidLayoutItems];
}

@end
