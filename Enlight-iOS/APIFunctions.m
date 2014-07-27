//
//  APIFunctions.m
//  Enlight-iOS
//
//  Created by Kenneth Siu on 7/22/14.
//  Copyright (c) 2014 Enlight. All rights reserved.
//

#import "APIFunctions.h"

@implementation APIFunctions

#pragma mark Get Functions

//see who is controlling the fountain and how is in queue
+(NSData*) whoIsControlling:(NSString*)url {
    return [self queryNoBody:[NSString stringWithFormat:@"%@/control/query", url]];
}

//get all the states of the valves
+(NSData*) getValves:(NSString*)url {
    return [self queryNoBody:[NSString stringWithFormat:@"%@/valves", url]];
}

//get the state for a particular valve
+(NSData*) getValve:(NSString*)url withIDValve:(int)idValve {
    return [self queryNoBody:[NSString stringWithFormat:@"%@/valves/%d", url, idValve]];
}

//get the patterns of the fountain
+(NSData*) getPatterns:(NSString*)url {
    return [self queryNoBody:[NSString stringWithFormat:@"%@/patterns", url]];
}

#pragma mark Post functions

//request control of the fountain
+(NSData*) reqControl:(NSString*)url withAPI:(NSString*)apiStr {
    return [self queryWithBody:[NSString stringWithFormat:@"%@/control/request", url] withDictionary:@{ @"apikey": apiStr, @"requestedLength": [NSNumber numberWithInt:60]}];
}

//release control of the fountain
+(NSData*) relControl:(NSString*)url withAPI:(NSString*)apiStr {
    return [self queryWithBody:[NSString stringWithFormat:@"%@/control/release", url] withDictionary:@{ @"apikey": apiStr}];
}

+(NSData*) setValves:(NSString*)url withAPI:(NSString*)apiStr withBitmask:(int)bitInt {
    return [self queryWithBody:[NSString stringWithFormat:@"%@/valves", url] withDictionary:@{ @"apikey": apiStr, @"bitmask": [NSNumber numberWithInt:bitInt]}];
}

+(NSData*) setValve:(NSString*)url withAPI:(NSString*)apiStr withIDValve:(int)idValve setToOn:(BOOL)setOn {
    return [self queryWithBody:[NSString stringWithFormat:@"%@/valves/%d", url, idValve] withDictionary:@{ @"apikey": apiStr, @"spraying": [NSNumber numberWithBool:setOn]}];
}


+(NSData*) setPatterns:(NSString*)url withAPI:(NSString*)apiStr withIdPattern:(int)idPattern {
    return [self queryWithBody:[NSString stringWithFormat:@"%@/valves/%d", url, idPattern] withDictionary:@{ @"apikey": apiStr, @"setCurrent": [NSNumber numberWithBool:true]}];
}

#pragma mark Helper Functions

//query for get requests, insert url
+(NSData*) queryNoBody:(NSString*)urlString {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *urlSend = [NSURL URLWithString:urlString];
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:[[NSURLRequest alloc] initWithURL:urlSend] returningResponse:&urlResponse error:&requestError];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    return data;
}

//qery with body (POST requests)
+(NSData*) queryWithBody:(NSString*)urlString withDictionary:(NSDictionary*)dict {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *urlSend = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[urlSend standardizedURL]];
    [req setHTTPMethod:@"POST"];
    
    //set up string from dictionary
    NSArray *arrayKeys = [dict allKeys];
    NSString *dataString = @"{";
    for(int i = 0; i < [arrayKeys count]; i++) {
        id key = [arrayKeys objectAtIndex:i];
        id value = [dict objectForKey:key];
        NSString *newData =  [NSString stringWithFormat:@" \"%@\":\"%@\"", key, value];
        dataString = [dataString stringByAppendingString: newData];
        
        //if last object in array, append bracket, else append comma
        if(i == [arrayKeys count] - 1) {
            dataString = [dataString stringByAppendingString:@"}"];
        } else {
            dataString = [dataString stringByAppendingString:@","];
        }
    }
    
    //set reqest type
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    //set post data
    [req setHTTPBody:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse *urlResponse = nil;
    
    //do responses synchronously for now
    return [NSURLConnection sendSynchronousRequest:req returningResponse:&urlResponse error:nil];
}

@end