//
//  MainViewController.m
//  Enlight-iOS
//
//  Created by Kenneth Siu on 7/15/14.
//  Copyright (c) 2014 Enlight. All rights reserved.
//

#import "MainViewController.h"
#import "Constants.h"
#import "APIFunctions.h"
#import "SecretKeys.h"

//request control button defines
#define REQ_CONT_BUTTON_PADDING 30
#define REQ_CONT_BUTTON_WIDTH 200
#define REQ_CONT_BUTTON_FONT 25

//enlight title defines
#define TITLE_LABEL_PADDING 30
#define TITLE_LABEL_HEIGHT 40

//fade in define
#define FADE_IN_TIME 3

@interface MainViewController ()
@end

@implementation MainViewController {
    CAShapeLayer *tempShape;
    CGPoint prevPoint;
}

@synthesize dispView, reqContButton, buttonForShapeArray, enlightTitle, pan, updateValveTime, hasControl, contFountainLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //set a timer to constantly update the fountain
    updateValveTime = [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(updateFounatinValves:) userInfo:nil repeats:YES];
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //initialize array
    buttonForShapeArray = [[NSMutableArray alloc] init];
    
    //initialize the fountain view
    dispView = [[FountainDisplayView alloc] initWithFrame:CGRectMake(0, [self.view frame].size.height / 4, [self.view frame].size.width, [self.view frame].size.height / 2)];
    
    [self.view addSubview:dispView];
    
    //add buttons for the valves
//    for(int i = 0; i < [dispView.shapeArray count]; i++) {
//        
//        //grab the custom frame for the button, used to detect when button is hit
//        UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:((CAShapeLayer*)[dispView.shapeArray objectAtIndex:i]).path];
//        
//        CustomButton *button = [[CustomButton alloc] initWithFrame:dispView.frame andPath:path];
//        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
//        
//        [buttonForShapeArray addObject:button];
//        [self.view addSubview:button];
//    }
    
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
    }];
    
    //set target to request control
    [reqContButton addTarget:self action:@selector(reqControl:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:reqContButton];
    
    //control fountain uilabel
    contFountainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - (REQ_CONT_BUTTON_PADDING * 2), self.view.frame.size.width, REQ_CONT_BUTTON_PADDING)];
    
    [contFountainLabel setTextAlignment:NSTextAlignmentCenter];
    
    contFountainLabel.font = [UIFont systemFontOfSize:REQ_CONT_BUTTON_FONT];
    [contFountainLabel setHidden:YES];
    [self.view addSubview:contFountainLabel];
    
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
    }];
    
    [self.view addSubview:enlightTitle];
    
    //enable pan gesture recognizer
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRec:)];
    
    self.view.gestureRecognizers = @[pan];
}

#pragma mark Control Valves View
-(IBAction)reqControl:(UIButton*)sender {
    //request control of the fountain
    NSDictionary* dict = [self checkQueuePosition];
    NSNumber *num = [dict objectForKey:@"queuePosition"];
    NSNumber *controllerID = [dict objectForKey:@"controllerID"];
    
    [reqContButton setHidden:YES];
    [contFountainLabel setHidden:NO];
    
    //if queue position does not equal 0, set timer off to keep checking position
    if([num intValue] != 0) {
        [self setTextForPosition:num];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkPosition:) userInfo:controllerID repeats:YES];
    } else {
        //else start the controlling of the valves
        [self setInControl];
    }
}

-(IBAction)checkPosition:(NSTimer*)sender {
    NSData *data = [APIFunctions whoIsControlling:[SecretKeys getURL]];
    
    NSError *error;
    
    NSArray *arrayOfDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    //if it did not work, just return from the timer
    if(!arrayOfDict) {
        return;
    }
    
    for(int i = 0; i < [arrayOfDict count]; i++) {
        NSDictionary *dict = [arrayOfDict objectAtIndex:i];
        
        if([[dict objectForKey:@"controllerID"] isEqualToNumber:sender.userInfo]) {
            
            NSNumber *num = [dict objectForKey:@"queuePosition"];
            
            if([num intValue] != 0) {
                [self setTextForPosition:num];
            } else {
                //cancel timer
                [sender invalidate];
                sender = nil;
                [self setInControl];
            }
            
            return;
        }
        
    }

}

- (void) setTextForPosition:(NSNumber*) pos {
    [contFountainLabel setText:[NSString stringWithFormat:@"Your position in queue: %d", [pos intValue]]];
}

-(NSDictionary*) checkQueuePosition {
    //request control of the fountain
    NSData *data = [APIFunctions reqControl:[SecretKeys getURL] withAPI:[SecretKeys getAPIKey]];
    
    NSError *error;
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if (!(dict && [(NSString*)[dict objectForKey:@"success"] isEqualToString:@"true"])) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error Requesting Control" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    
    return dict;
}

-(void) setInControl {
    hasControl = YES;
    [contFountainLabel setText:@"You are now in control!"];
}

#pragma mark Update Fountain Valves
//used to update fountain states
-(IBAction) updateFounatinValves:(id)sender {
    //see what the fountain states are
    NSData *data = [APIFunctions getValves:[SecretKeys getURL]];
    
    NSError *error;
    
    //parse nsdata to NSDictionary
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    if(jsonArray) {
        for(NSDictionary *dict in (NSArray*)jsonArray) {
            //get the id of it
            NSNumber *index = (NSNumber*)[dict objectForKey:@"0"];
            
            NSNumber *isSpraying = (NSNumber*)[dict objectForKey:@"spraying"];
            
            CAShapeLayer *shape = [dispView.shapeArray objectAtIndex:[index intValue] - 1];
            
            //now use the index and set the shape
            if([isSpraying boolValue]) {
                [self setShapeColor:shape isOn:YES];
            } else {
                [self setShapeColor:shape isOn:NO];
            }
            
        }
    }
    
    
}

#pragma mark Gesture Recognizers
//gesture recognizers
- (IBAction)panRec:(UIPanGestureRecognizer*)gesture {
    
    CGPoint point = [gesture locationInView:dispView];
    [self setShapes:point];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[[event allTouches] anyObject] locationInView:dispView];
    tempShape = nil;
    [self setShapes:point];
}

-(void) setShapes : (CGPoint) point {
    if(!hasControl) {
        return;
    }
    
    //see if it is in a path
    for(int i = 0; i < [dispView.shapeArray count]; i++) {
        CAShapeLayer *shape = (CAShapeLayer*)[dispView.shapeArray objectAtIndex:i];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:shape.path];
        
        if((![shape isEqual:tempShape] || ![self wasInAShape:prevPoint]) && [path containsPoint:point]) {
            tempShape = shape;
            
            if(shape.fillColor == [UIColor clearColor].CGColor) {
                [self setShapeColor:shape isOn:YES];
            } else {
                [self setShapeColor:shape isOn:NO];
            }
        }
    }
    
    prevPoint = point;
}

//set fill color
-(void) setShapeColor:(CAShapeLayer*)shape isOn:(BOOL)isOn {
    if(isOn) {
        shape.fillColor = [UIColor colorWithRed:((float)((wiscRed & 0xFF0000) >> 16))/255.0 green:((float)((wiscRed & 0xFF00) >> 8))/255.0 blue:((float)(wiscRed & 0xFF))/255.0 alpha:1.0].CGColor;
    } else {
        shape.fillColor = [UIColor clearColor].CGColor;
    }
}

-(BOOL) wasInAShape : (CGPoint) point {
    for(int i = 0; i < [dispView.shapeArray count]; i++) {
        CAShapeLayer *shape = (CAShapeLayer*)[dispView.shapeArray objectAtIndex:i];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithCGPath:shape.path];
        
        if([path containsPoint:point]) {
            return YES;
        }
    }
    
    return NO;
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
