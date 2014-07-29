//
//  APIFunctions.h
//  Enlight-iOS
//
//  Created by Kenneth Siu on 7/22/14.
//  Copyright (c) 2014 Enlight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIFunctions : NSObject

//Get Functions
+(NSURLRequest*) whoIsControlling:(NSString*)url;
+(NSURLRequest*) getValves:(NSString*)url;
+(NSURLRequest*) getValve:(NSString*)url withIDValve:(int)idValve;
+(NSURLRequest*) getPatterns:(NSString*)url;

//Post Functions
+(NSMutableURLRequest*) queryControl:(NSString*)url withAPI:(NSString*)apiStr withControllerID:(NSNumber*)controllerID;
+(NSMutableURLRequest*) reqControl:(NSString*)url withAPI:(NSString*)apiStr;
+(NSMutableURLRequest*) relControl:(NSString*)url withAPI:(NSString*)apiStr;
+(NSMutableURLRequest*) setValves:(NSString*)url withAPI:(NSString*)apiStr withBitmask:(int)bitInt;
+(NSMutableURLRequest*) setValve:(NSString*)url withAPI:(NSString*)apiStr withIDValve:(int)idValve setToOn:(BOOL)setOn;
+(NSMutableURLRequest*) setPatterns:(NSString*)url withAPI:(NSString*)apiStr withIdPattern:(int)idPattern;

@end