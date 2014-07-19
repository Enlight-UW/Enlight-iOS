//
//  CustomButton.h
//  Enlight-iOS
//
//  Created by Kenneth Siu on 7/19/14.
//  Copyright (c) 2014 Enlight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomButton : UIButton

@property UIBezierPath *path;

- (instancetype)initWithFrame:(CGRect)frame andPath:(UIBezierPath*) tPath;

@end
