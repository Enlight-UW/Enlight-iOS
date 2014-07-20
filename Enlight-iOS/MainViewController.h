//
//  MainViewController.h
//  Enlight-iOS
//
//  Created by Kenneth Siu on 7/15/14.
//  Copyright (c) 2014 Enlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FountainDisplayView.h"
#import "CustomButton.h"


@interface MainViewController : UIViewController

//view of the fountain itself
@property FountainDisplayView *dispView;


//request control of the fountain
@property UIButton *reqContButton;

@property NSMutableArray *buttonForShapeArray;

@end
