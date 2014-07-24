//
//  APIFunctions.m
//  Enlight-iOS
//
//  Created by Kenneth Siu on 7/22/14.
//  Copyright (c) 2014 Enlight. All rights reserved.
//

#import "APIFunctions.h"

@implementation APIFunctions

//see who is controlling the fountain and how is in queue
+(NSData*) whoIsControlling:(NSString*)url {
    return [self queryNoBody:[NSString stringWithFormat:@"%@/control/query/", url]];
}

//request control of the fountain
+(NSData*) reqControl:(NSString*)url {
    return [self queryNoBody:[NSString stringWithFormat:@"%@/control/request/", url]];
}

//release control of the fountain
+(NSData*) relControl:(NSString*)url {
    return [self queryNoBody:[NSString stringWithFormat:@"%@/control/release/", url]];
}

//get all the states of the valves
+(NSData*) getValves:(NSString*)url {
    return [self queryNoBody:[NSString stringWithFormat:@"%@/valves/", url]];
}

//get the state for a particular valve
+(NSData*) getValve:(NSString*)url withInt:(int)idValve {
    return [self queryNoBody:[NSString stringWithFormat:@"%@/valves/%d", url, idValve]];
}

//get the patterns of the fountain
+(NSData*) getPatterns:(NSString*)url {
    return [self queryNoBody:[NSString stringWithFormat:@"%@/patterns/", url]];
}

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
+(void) queryWithBody:(NSString*)urlString withDictionary:(NSDictionary*)dict {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    NSURL *urlSend = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[urlSend standardizedURL]];
    [req setHTTPMethod:@"POST"];
    
    //set up string from dictionary
    NSString *dataString = [[NSString alloc] init];
    for(id key in dict) {
        id value = [dict objectForKey:key];
        NSString *newData =  [NSString stringWithFormat:@"&%@=%@", key, value];
        dataString = [dataString stringByAppendingString: newData];
    }
    
    //set reqest type
    [req setValue:@"application/x-www-form-urlencoded;charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    
    //set post data
    [req setHTTPBody:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    
    if(conn) {
        NSLog(@"Connection Successful");
    } else {
        NSLog(@"Connection could not be made");
    }
}

@end
