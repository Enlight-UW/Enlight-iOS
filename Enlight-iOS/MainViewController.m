//
//  MainViewController.m
//  Enlight-iOS
//
//  Created by Kenneth Siu on 7/15/14.
//  Copyright (c) 2014 Enlight. All rights reserved.
//

#import "MainViewController.h"

#define NUM_SWITCHES 24
#define SPACE_BETWEEN_LABEL_SWITCH 5
#define LABEL_WIDTH 20
#define LABEL_HEIGHT 15

@interface MainViewController ()
@property CGFloat heightPadding;
@property CGFloat widthPadding;
@end

@implementation MainViewController

@synthesize switchArray, labelSwitchArray;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //initialize a view
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //initialize the dynamic padding
    _heightPadding = ((self.view.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height) / (NUM_SWITCHES / 2));
    
    _widthPadding = (self.view.frame.size.width - [[UISwitch alloc] init].frame.size.width);
    
    //initialize the arrays
    switchArray = [[NSMutableArray alloc] initWithCapacity:NUM_SWITCHES];
    labelSwitchArray = [[NSMutableArray alloc] initWithCapacity:NUM_SWITCHES];
    
    //initialize the toggles with labels
    CGFloat tempWidth = 0;
    CGFloat tempHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    
    CGFloat tempLabelWidth = 0;
    
    for(int i = 0; i < NUM_SWITCHES; i++) {
        
        //set the width based off of the first or second column
        if (i >= (NUM_SWITCHES / 2)) {
            tempWidth = _widthPadding;
        } else {
            tempWidth = 0;
        }
        
        //reset height when moving to the next column
        if(i == (NUM_SWITCHES / 2)) {
            tempHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        }
        
        //set width and height for labels
        if(tempWidth == 0) {
            tempLabelWidth = [[UISwitch alloc] init].frame.size.width + SPACE_BETWEEN_LABEL_SWITCH;
        } else {
            tempLabelWidth = tempWidth - SPACE_BETWEEN_LABEL_SWITCH - LABEL_WIDTH;
        }
        
        //initialize switch and add to subview
        UISwitch *tempSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(tempWidth, tempHeight, 0, 0)];
        
        //add selector
        [tempSwitch addTarget:self action:@selector(switchPressed:) forControlEvents:UIControlEventValueChanged];
        
        [switchArray addObject:tempSwitch];
        
        [self.view addSubview:tempSwitch];
        
        //now initialize the label
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(tempLabelWidth, tempHeight + (tempSwitch.frame.size.height / 2) - (LABEL_HEIGHT / 2), LABEL_WIDTH, LABEL_HEIGHT)];
        [tempLabel setText:[NSString stringWithFormat:@"%i", i + 1]];
        
        [labelSwitchArray addObject:tempLabel];
        
        [self.view addSubview:tempLabel];
        
        //add padding to the height
        tempHeight += _heightPadding;
    }
    
}

- (IBAction)switchPressed:(id)sender {
    //sender is UISwitch
    UISwitch *tempSwitch = (UISwitch*) sender;
    
    //check the index of switch
    int i = (int) [switchArray indexOfObject:tempSwitch];
    
    //then grab label and change its color
    UILabel *tempLabel = [labelSwitchArray objectAtIndex:i];
    if(tempSwitch.isOn) {
        tempLabel.textColor = [UIColor redColor];
    } else {
        tempLabel.textColor = [UIColor blackColor];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
