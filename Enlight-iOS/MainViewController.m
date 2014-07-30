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
#import "TabViewController.h"

//fade in define
#define FADE_IN_TIME 3

@interface MainViewController ()
@end

@implementation MainViewController {
    CAShapeLayer *tempShape;
    CGPoint prevPoint;
}

@synthesize dispView, reqContButton, buttonForShapeArray, pan, updateValveTime, hasControl, contFountainLabel, queue, loadingReqCont;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //super view
    TabViewController *superView = (TabViewController*)[self navigationController];
    
    self.title = @"Control Fountain";
    
    //set up queue for asynchronous calls to the API
    queue = [[NSOperationQueue alloc] init];
    
    //set a timer to constantly update the fountain
    updateValveTime = [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(updateFounatinValves:) userInfo:nil repeats:YES];
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //initialize array
    buttonForShapeArray = [[NSMutableArray alloc] init];
    
    //initialize the fountain view
    dispView = [[FountainDisplayView alloc] initWithFrame:CGRectMake(0, [[superView navigationBar] frame].size.height + (([self.view frame].size.height - [[superView navigationBar] frame].size.height) / 20), [self.view frame].size.width, [self.view frame].size.width)];
    
    [self.view addSubview:dispView];
    
    //now add button on the bottom to request control
    reqContButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    float fontSize = [[UIScreen mainScreen] bounds].size.height / 25;
    
    float buttonHeight = [dispView frame].origin.y + [dispView frame].size.height;
    
    buttonHeight += [superView tabBar].frame.origin.y;
    buttonHeight /= 2;
    buttonHeight -= fontSize / 2;
    
    [reqContButton setTitle:@"Request Control" forState:UIControlStateNormal];
    reqContButton.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    reqContButton.alpha = 0.0f;
    
    //fade in uibutton
    [UIView animateWithDuration:FADE_IN_TIME animations:^{
        reqContButton.alpha = 1.0f;
    }];
    
    //set target to request control
    [reqContButton addTarget:self action:@selector(reqControl:) forControlEvents:UIControlEventTouchDown];
    
    [reqContButton sizeToFit];
    
    
    [reqContButton setFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width / 2) - ([reqContButton frame].size.width / 2), buttonHeight, [reqContButton frame].size.width, fontSize)];
    
    [self.view addSubview:reqContButton];
    
    //control fountain uilabel
    contFountainLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [reqContButton frame].origin.y, self.view.frame.size.width, [reqContButton frame].size.height)];
    
    [contFountainLabel setTextAlignment:NSTextAlignmentCenter];
    
    contFountainLabel.font = [UIFont systemFontOfSize:fontSize];
    [contFountainLabel setHidden:YES];
    [self.view addSubview:contFountainLabel];
    
    //activity indicator set up
    loadingReqCont = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    loadingReqCont.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2, [contFountainLabel frame].origin.y + ([contFountainLabel frame].size.height / 2));
    [loadingReqCont setHidesWhenStopped:YES];
    [self.view addSubview:loadingReqCont];
    
    //enable pan gesture recognizer
    pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRec:)];
    
    self.view.gestureRecognizers = @[pan];
}

#pragma mark Control Valves View
-(IBAction)reqControl:(UIButton*)sender {
    //request control of the fountain
    NSMutableURLRequest *req = [APIFunctions reqControl:[SecretKeys getURL] withAPI:[SecretKeys getAPIKey]];
    
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //if there is an error, return
        if(error) {
            return;
        }
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if (!(dict && [(NSString*)[dict objectForKey:@"success"] isEqualToString:@"true"])) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self showAlert:@"Error Requesting Control"];
            }];
        }
        
        //if dictionary is null, return error
        if(!dict) {
            return;
        }
        
        //request control of the fountain
        NSNumber *controllerID = [dict objectForKey:@"controllerID"];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //start timer to check for position
            [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkPosition:) userInfo:controllerID repeats:YES];
            
            [reqContButton setHidden:YES];
            [contFountainLabel setHidden:NO];
            [loadingReqCont startAnimating];
        }];
    }];
}

-(IBAction)checkPosition:(NSTimer*)sender {
    NSNumber *controllerID = (NSNumber*)sender.userInfo;
    
    NSMutableURLRequest *req = [APIFunctions queryControl:[SecretKeys getURL] withAPI:[SecretKeys getAPIKey] withControllerID:controllerID];
    
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        //if it did not work, just return from the timer
        if(!dict) {
            return;
        }
        
        //check position in queue
        NSNumber *successful = [dict objectForKey:@"success"];
        if([successful boolValue]) {
            //check queue position
            NSNumber *queuePos = [dict objectForKey:@"trueQueuePosition"];
            
            //if queue position is 0, allow user to control the fountain
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [loadingReqCont stopAnimating];
                if([queuePos intValue] == 0) {
                    [self setInControl];
                } else {
                    [self setTextForPosition:queuePos];
                }
            }];
            
        }
        
    }];
}

- (void) setTextForPosition:(NSNumber*) pos {
    [contFountainLabel setText:[NSString stringWithFormat:@"Your position in queue: %d", [pos intValue]]];
}

-(void) setInControl {
    hasControl = YES;
    [contFountainLabel setText:@"You are now in control!"];
    
    //invalidate the updating timer so that user can see changes that they make
    [updateValveTime invalidate];
    updateValveTime = nil;
    
    
}

#pragma mark Update Fountain Valves
//used to update fountain states
-(IBAction) updateFounatinValves:(id)sender {
    //see what the fountain states are
    NSURLRequest *req = [APIFunctions getValves:[SecretKeys getURL]];
    
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        //if there is an error, return
        if(error) {
            return;
        }
        
        //parse nsdata to NSDictionary
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        if(jsonArray) {
            for(NSDictionary *dict in (NSArray*)jsonArray) {
                //get the id of it
                NSNumber *index = (NSNumber*)[dict objectForKey:@"0"];
                
                NSNumber *isSpraying = (NSNumber*)[dict objectForKey:@"spraying"];
                
                CAShapeLayer *shape = [dispView.shapeArray objectAtIndex:[index intValue] - 1];
                
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    //go to main thread for UI
                    if([isSpraying boolValue]) {
                        [self setShapeColor:shape isOn:YES];
                    } else {
                        [self setShapeColor:shape isOn:NO];
                    }
                }];
            }
        }
    }];
}

#pragma mark Gesture Recognizers
//gesture recognizers
- (IBAction)panRec:(UIPanGestureRecognizer*)gesture {
    if(!hasControl) {
        return;
    }
    
    CGPoint point = [gesture locationInView:dispView];
    [self setShapes:point];
    
    if(gesture.state == UIGestureRecognizerStateEnded) {
        //now call the bitmask since we now know that all states have been set
        //get bitmask of the fountain
        NSMutableURLRequest *req = [APIFunctions setValves:[SecretKeys getURL] withAPI:[SecretKeys getAPIKey] withBitmask:[self getBitmask]];
        
        [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            if(error) {
                //show error message and return
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self showAlert:[error debugDescription]];
                }];
                return;
            }
            
            //parse data
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            if(dict) {
                NSNumber *successful = [dict objectForKey:@"success"];
                if(![successful boolValue]) {
                    [self showAlert:@"Error Setting Valve States"];
                }
            }
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!hasControl) {
        return;
    }
    
    CGPoint point = [[[event allTouches] anyObject] locationInView:dispView];
    tempShape = nil;
    [self setShapes:point];
}

#pragma mark Set Shapes
-(void) setShapes : (CGPoint) point {
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

#pragma mark Helper Functions
//show alert view
-(void) showAlert:(NSString*)title {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }];
}

-(int) getBitmask {
    int mask = 0;
    for(int i = 0; i < [dispView.shapeArray count]; i++) {
        CAShapeLayer *shape = (CAShapeLayer*)[dispView.shapeArray objectAtIndex:i];
        
        //if that valve has been set
        if(!(shape.fillColor == [UIColor clearColor].CGColor)) {
            mask += pow(2, i);
        }
    }
    return mask;
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
