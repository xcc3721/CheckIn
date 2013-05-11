//
//  CIXiamiLogoutOperation.m
//  CheckIn
//
//  Created by Erick on 13-4-25.
//  Copyright (c) 2013年 Erick. All rights reserved.
//

#import "CIXiamiLogoutOperation.h"
#import "CIXiamiRequestMaker.h"

@implementation CIXiamiLogoutOperation

-(void)start
{
    [super start];
    NSURLRequest *request = [[CIXiamiRequestMaker sharedInstance] logoutRequest:self.additionCookie];
    
    [self requestFinished];
    [self operationComplete];
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [super connection:connection didReceiveData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [super connection:connection didFailWithError:error];
    
}

@end
