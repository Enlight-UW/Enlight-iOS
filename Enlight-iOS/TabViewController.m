//
//  TabViewController.m
//  Enlight-iOS
//
//  Created by Kenneth Siu on 7/28/14.
//  Copyright (c) 2014 Enlight. All rights reserved.
//

#import "TabViewController.h"

#define NAV_BAR_HEIGHT 44.0f
#define TAB_BAR_HEIGHT 56.0f

@interface TabViewController ()

@end

@implementation TabViewController

@synthesize tabBar, viewContArray, tabBarItemsArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //initialize array
    viewContArray = [[NSMutableArray alloc] init];
    tabBarItemsArray = [[NSMutableArray alloc] init];
    
    //set up main view controller
    MainViewController *mainVC = [[MainViewController alloc] init];
    mainVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Control" image:nil tag:0];
    
    //add main view controller
    [viewContArray addObject:mainVC];
    [tabBarItemsArray addObject:mainVC.tabBarItem];
    
    //set up tab bar
    tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height - TAB_BAR_HEIGHT, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    
    //set delegate as self
    tabBar.delegate = self;
    [self.view addSubview:tabBar];
    
    [self setViewControllers:@[mainVC]];
    [tabBar setItems:tabBarItemsArray];
    
    //set the tab bar to be the main VC
    [tabBar setSelectedItem:[tabBar.items objectAtIndex:0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end