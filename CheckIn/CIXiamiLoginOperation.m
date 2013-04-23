//
//  CIXiamiLoginOperation.m
//  CheckIn
//
//  Created by Erick Xi on 4/23/13.
//  Copyright (c) 2013 Erick. All rights reserved.
//

#import "CIXiamiLoginOperation.h"
#import "CIXiamiRequestMaker.h"

@implementation CIXiamiLoginOperation

- (void)start
{
    [super start];
    NSURLRequest *request = [[CIXiamiRequestMaker sharedInstance] loginRequest];
    [NSURLConnection connectionWithRequest:request delegate:self];
    [self waitForRequest];
    [self requestFinished];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [super connection:connection didFailWithError:error];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [super connection:connection didReceiveData:data];
    NSString *string = [NSString stringWithUTF8String:[data bytes]];
    NSLog(@"%@", string);
    if (self.successHandler)
    {
        self.successHandler(@"");
    }
}

@end
