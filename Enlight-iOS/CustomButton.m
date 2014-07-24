//
//  CustomButton.m
//  Enlight-iOS
//
//  Created by Kenneth Siu on 7/19/14.
//  Copyright (c) 2014 Enlight. All rights reserved.
//

#import "CustomButton.h"

@implementation CustomButton
@synthesize path;

- (instancetype)initWithFrame:(CGRect)frame andPath:(UIBezierPath*) tPath {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        path = tPath;
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([path containsPoint:point]) {
        return self;
    } else {
        return nil;
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}


@end
