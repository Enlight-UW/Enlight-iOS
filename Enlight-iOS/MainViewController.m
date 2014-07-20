//
//  MainViewController.m
//  Enlight-iOS
//
//  Created by Kenneth Siu on 7/15/14.
//  Copyright (c) 2014 Enlight. All rights reserved.
//

#import "MainViewController.h"

#define REQ_CONT_BUTTON_PADDING 50
#define REQ_CONT_BUTTON_WIDTH 50

@interface MainViewController ()
@end

@implementation MainViewController
@synthesize dispView, reqContButton, buttonForShapeArray;

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
        
        UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:((CAShapeLayer*)[dispView.shapeArray objectAtIndex:i]).path];
        
        CustomButton *button = [[CustomButton alloc] initWithFrame:dispView.frame andPath:path];
        
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [buttonForShapeArray addObject:button];
        [self.view addSubview:button];
    }
}

//used to update fountain states
-(IBAction) updateFounatinValves:(id)sender {
    
}

//function called when valve is pressed
-(IBAction)buttonPressed:(UIButton*)sender {
    //find index
    int index = (int)[buttonForShapeArray indexOfObject:sender];
    
    //use this index to fill the path
    CAShapeLayer *shape = [dispView.shapeArray objectAtIndex:index];
    
    if(shape.fillColor == [UIColor clearColor].CGColor) {
        shape.fillColor = [UIColor redColor].CGColor;
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
