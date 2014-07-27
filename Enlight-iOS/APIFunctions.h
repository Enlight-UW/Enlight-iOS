//
//  APIFunctions.h
//  Enlight-iOS
//
//  Created by Kenneth Siu on 7/22/14.
//  Copyright (c) 2014 Enlight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIFunctions : NSObject

+(NSData*) whoIsControlling:(NSString*)url;
+(NSData*) getValves:(NSString*)url;
+(NSData*) getValve:(NSString*)url withIDValve:(int)idValve;
+(NSData*) getPatterns:(NSString*)url;
+(NSData*) reqControl:(NSString*)url withAPI:(NSString*)apiStr;
+(NSData*) relControl:(NSString*)url withAPI:(NSString*)apiStr;
+(NSData*) setValves:(NSString*)url withAPI:(NSString*)apiStr withBitmask:(int)bitInt;
+(NSData*) setValve:(NSString*)url withAPI:(NSString*)apiStr withIDValve:(int)idValve setToOn:(BOOL)setOn;
+(NSData*) setPatterns:(NSString*)url withAPI:(NSString*)apiStr withIdPattern:(int)idPattern;

@end
