//
//  FountainDisplayView.m
//  Enlight-iOS
//
//  Created by Kenneth Siu on 7/18/14.
//  Copyright (c) 2014 Enlight. All rights reserved.
//

#import "FountainDisplayView.h"

#define OFFSET_FROM_CENTER 10

#define pi 3.14159265359

#define   DEGREES_TO_RADIANS(degrees)  ((pi * degrees)/ 180)

#define NUM_VALVES 24

@implementation FountainDisplayView
@synthesize shapeArray, buttonForShapeArray;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor whiteColor]];
        
        //initialize shape array
        shapeArray = [[NSMutableArray alloc] initWithCapacity:NUM_VALVES];
        buttonForShapeArray = [[NSMutableArray alloc] initWithCapacity:NUM_VALVES];
        
        float innerRad = self.frame.size.width / 4;
        float outerRad = self.frame.size.width / 2 - OFFSET_FROM_CENTER;
        
        float padding = (270 - 90) / (NUM_VALVES / 2);
        float startAngle = 90;
        
        //make the two half circles
        for(int i = 0; i < NUM_VALVES; i++) {
            
            //flip the circle when drawing other side of the circle
            if(i == NUM_VALVES / 2) {
                startAngle = 90 + 180;
            }
            
            //draw the circles
            UIBezierPath *path = nil;
            if(i >= NUM_VALVES / 2) {
                path = [self drawCircleSectionWithStartAngle:startAngle + padding endAngle:startAngle withOffset:OFFSET_FROM_CENTER isClockwise:NO innerRadius:innerRad outerRadius:outerRad];
            } else {
                path = [self drawCircleSectionWithStartAngle:startAngle endAngle:startAngle + padding withOffset: (-1) * OFFSET_FROM_CENTER isClockwise:YES innerRadius:innerRad outerRadius:outerRad];
            }
            
            //add the padding to it
            startAngle += padding;
            
            //create the layer so that it can be added to UI
            CAShapeLayer *halfCircle = [CAShapeLayer layer];
            
            halfCircle.path = path.CGPath;
            
            
            halfCircle.fillColor = [UIColor clearColor].CGColor;
            halfCircle.strokeColor = [UIColor blackColor].CGColor;
            halfCircle.lineWidth = 3;
            
            [shapeArray addObject:halfCircle];
            
            //add button
            CustomButton *button = [[CustomButton alloc] initWithFrame:self.frame andPath:path];
            
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [buttonForShapeArray addObject:button];
            
            //add to UI
            [self.layer addSublayer:halfCircle];
            [self addSubview:button];
        }
    }
    return self;
}

-(IBAction)buttonPressed:(UIButton*)sender {
    //find index
    int index = (int)[buttonForShapeArray indexOfObject:sender];
    
    //use this index to fill the path
    CAShapeLayer *shape = [shapeArray objectAtIndex:index];
    
    if(shape.fillColor == [UIColor clearColor].CGColor) {
        shape.fillColor = [UIColor redColor].CGColor;
    } else {
        shape.fillColor = [UIColor clearColor].CGColor;
    }
}

//draws a particular circle section based off of a start and end radius (will use the defines)
-(UIBezierPath*) drawCircleSectionWithStartAngle:(float)sAngle endAngle:(float)eAngle withOffset:(float) offset isClockwise:(BOOL)clockwise innerRadius:(float)innerRadius outerRadius:(float)outerRadius {
    
    CGPoint center = CGPointMake((self.frame.size.width / 2) + offset, self.frame.size.height / 2);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:innerRadius startAngle:DEGREES_TO_RADIANS(sAngle) endAngle:DEGREES_TO_RADIANS(eAngle) clockwise:clockwise];
    
    //add the next arc
    [path addArcWithCenter:center radius:outerRadius startAngle:DEGREES_TO_RADIANS(eAngle) endAngle:DEGREES_TO_RADIANS(sAngle) clockwise:!clockwise];
    
    //now add the final arc by closing the path
    [path closePath];
    
    return path;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
