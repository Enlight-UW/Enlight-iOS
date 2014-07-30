//
//  TabViewController.h
//  Enlight-iOS
//
//  Created by Kenneth Siu on 7/28/14.
//  Copyright (c) 2014 Enlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface TabViewController : UINavigationController <UITabBarDelegate>;

//tab bar
@property UITabBar *tabBar;

//array of all the view controllers
@property NSMutableArray *viewContArray;
@property NSMutableArray *tabBarItemsArray;
@property float tabBarHeight;

@end
