//
//  CIXiamiCheckinOperation.m
//  CheckIn
//
//  Created by Erick Xi on 4/24/13.
//  Copyright (c) 2013 Erick. All rights reserved.
//

#import "CIXiamiCheckinOperation.h"
#import "CIXiamiRequestMaker.h"

@implementation CIXiamiCheckinOperation

-(void)start
{
    [super start];

    NSURLRequest *request = [[CIXiamiRequestMaker sharedInstance] checkinRequest:self.additionCookie];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [self waitForRequest];
    [self operationComplete];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [super connection:connection didFailWithError:error];
    
    
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [super connection:connection didReceiveData:data];
    
    NSString *dataString = [NSString stringWithUTF8String:[data bytes]];
    NSLog(@"%@", dataString);
}

@end
