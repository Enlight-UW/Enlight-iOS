//
//  TabViewController.m
//  Enlight-iOS
//
//  Created by Kenneth Siu on 7/28/14.
//  Copyright (c) 2014 Enlight. All rights reserved.
//

#import "TabViewController.h"

#define NAV_BAR_HEIGHT 44.0f

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
    UIImage *contEmpty = [UIImage imageNamed:@"Cont_Empty.png"];
    UIImage *contFull = [UIImage imageNamed:@"Cont_Filled.png"];
    
    mainVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Control" image:contEmpty selectedImage:contFull
                         ]
    ;
    
    //add main view controller
    [viewContArray addObject:mainVC];
    [tabBarItemsArray addObject:mainVC.tabBarItem];
    
    //use temporary tab bar controller to get the frame of a tab bar
    UITabBarController *tempCont = [[UITabBarController alloc] init];
    
    //set up tab bar
    tabBar = [[UITabBar alloc] initWithFrame:[[tempCont tabBar] frame]];
    
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
