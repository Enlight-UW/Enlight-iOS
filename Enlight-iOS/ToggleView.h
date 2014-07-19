//
//  ToggleView.h
//  Enlight-iOS
//
//  Created by Kenneth Siu on 7/18/14.
//  Copyright (c) 2014 Enlight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToggleView : UIView


//will contain all the switches when setting the fountain
@property NSMutableArray *switchArray;

//contains all the labels for the switches
@property NSMutableArray *labelSwitchArray;

- (void) initSwitches;
@end
