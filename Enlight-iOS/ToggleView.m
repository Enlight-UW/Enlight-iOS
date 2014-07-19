//
//  ToggleView.m
//  Enlight-iOS
//
//  Created by Kenneth Siu on 7/18/14.
//  Copyright (c) 2014 Enlight. All rights reserved.
//

#import "ToggleView.h"

#define NUM_SWITCHES 24
#define SPACE_BETWEEN_LABEL_SWITCH 5
#define LABEL_WIDTH 20
#define LABEL_HEIGHT 15

@interface ToggleView()
@property CGFloat heightPadding;
@property CGFloat widthPadding;
@end

@implementation ToggleView

@synthesize switchArray, labelSwitchArray;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initSwitches];
    }
    return self;
}

- (void) initSwitches {
    //initialize a view
    [self setBackgroundColor:[UIColor whiteColor]];
    
    //initialize the dynamic padding
    _heightPadding = ((self.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height) / (NUM_SWITCHES / 2));
    
    _widthPadding = (self.frame.size.width - [[UISwitch alloc] init].frame.size.width);
    
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
        
        [self  addSubview:tempSwitch];
        
        //now initialize the label
        UILabel *tempLabel = [[UILabel alloc] initWithFrame:CGRectMake(tempLabelWidth, tempHeight + (tempSwitch.frame.size.height / 2) - (LABEL_HEIGHT / 2), LABEL_WIDTH, LABEL_HEIGHT)];
        [tempLabel setText:[NSString stringWithFormat:@"%i", i + 1]];
        
        [labelSwitchArray addObject:tempLabel];
        
        [self addSubview:tempLabel];
        
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
