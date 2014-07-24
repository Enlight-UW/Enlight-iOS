//
//  MainViewController.m
//  Enlight-iOS
//
//  Created by Kenneth Siu on 7/15/14.
//  Copyright (c) 2014 Enlight. All rights reserved.
//

#import "MainViewController.h"
#import "Constants.h"

//request control button defines
#define REQ_CONT_BUTTON_PADDING 50
#define REQ_CONT_BUTTON_WIDTH 200
#define REQ_CONT_BUTTON_FONT 25

//enlight title defines
#define TITLE_LABEL_PADDING 50
#define TITLE_LABEL_HEIGHT 40

//fade in define
#define FADE_IN_TIME 3

@interface MainViewController ()
@end

@implementation MainViewController {
}

@synthesize dispView, reqContButton, buttonForShapeArray, enlightTitle;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set a timer to constantly update the fountain
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(updateFounatinValves:) userInfo:nil repeats:YES];
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //initialize array
    buttonForShapeArray = [[NSMutableArray alloc] init];
    
    //initialize the fountain view
    dispView = [[FountainDisplayView alloc] initWithFrame:CGRectMake(0, [self.view frame].size.height / 4, [self.view frame].size.width, [self.view frame].size.height / 2)];
    
    [self.view addSubview:dispView];
    
    //add buttons for the valves
    for(int i = 0; i < [dispView.shapeArray count]; i++) {
        
        //grab the custom frame for the button, used to detect when button is hit
        UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:((CAShapeLayer*)[dispView.shapeArray objectAtIndex:i]).path];
        
        CustomButton *button = [[CustomButton alloc] initWithFrame:dispView.frame andPath:path];
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonForShapeArray addObject:button];
        [self.view addSubview:button];
    }
    
    //now add button on the bottom to request control
    reqContButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [reqContButton setFrame:CGRectMake((self.view.frame.size.width / 2) - (REQ_CONT_BUTTON_WIDTH / 2), self.view.frame.size.height - (REQ_CONT_BUTTON_PADDING * 2), REQ_CONT_BUTTON_WIDTH, REQ_CONT_BUTTON_PADDING)];
    
    [reqContButton setTitle:@"Request Control" forState:UIControlStateNormal];
    reqContButton.titleLabel.font = [UIFont systemFontOfSize:REQ_CONT_BUTTON_FONT];
    reqContButton.alpha = 0.0f;
    
    //fade in uibutton
    [UIView animateWithDuration:FADE_IN_TIME animations:^{
        reqContButton.alpha = 1.0f;
    } completion:^(BOOL finished) {
        NSLog(@"finished transition");
    }];
    
    [self.view addSubview:reqContButton];
    
    //add fountain title
    enlightTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, TITLE_LABEL_PADDING, self.view.bounds.size.width, TITLE_LABEL_HEIGHT + 10)];
    enlightTitle.textAlignment = NSTextAlignmentCenter;
    [enlightTitle setFont:[UIFont systemFontOfSize:TITLE_LABEL_HEIGHT]];
    enlightTitle.alpha = 0.0f;
    [enlightTitle setText:@"Enlight Fountain"];
    
    //fade in the title
    [UIView animateWithDuration:FADE_IN_TIME animations:^{
        enlightTitle.alpha = 1.0f;
    } completion:^(BOOL finished) {
        NSLog(@"finished transition");
    }];
    
    [self.view addSubview:enlightTitle];
    
}

//used to update fountain states
-(IBAction) updateFounatinValves:(id)sender {
    
}

//function called when valve is pressed
-(IBAction)buttonPressed:(CustomButton*)sender {
    //find index
    int index = (int)[buttonForShapeArray indexOfObject:sender];
    
    //use this index to fill the path
    CAShapeLayer *shape = [dispView.shapeArray objectAtIndex:index];
    
    if(shape.fillColor == [UIColor clearColor].CGColor) {
        shape.fillColor = [UIColor colorWithRed:((float)((wiscRed & 0xFF0000) >> 16))/255.0 green:((float)((wiscRed & 0xFF00) >> 8))/255.0 blue:((float)(wiscRed & 0xFF))/255.0 alpha:1.0].CGColor;
    } else {
        shape.fillColor = [UIColor clearColor].CGColor;
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
