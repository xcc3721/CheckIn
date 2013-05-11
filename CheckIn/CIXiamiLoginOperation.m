//
//  CIXiamiLoginOperation.m
//  CheckIn
//
//  Created by Erick Xi on 4/23/13.
//  Copyright (c) 2013 Erick. All rights reserved.
//

#import "CIXiamiLoginOperation.h"
#import "CIXiamiRequestMaker.h"
#import "CIXiamiManager.h"

@interface CIXiamiLoginOperation ()

@property (nonatomic, copy) NSString *sessionCookie;

@end

@implementation CIXiamiLoginOperation

- (void)start
{
    [super start];
    
    NSURLRequest *sessionRequest = [[CIXiamiRequestMaker sharedInstance] sessionIdRequest];
    [NSURLConnection connectionWithRequest:sessionRequest delegate:self];
    [self waitForRequest];
    

    NSURLRequest *request = [[CIXiamiRequestMaker sharedInstance] loginRequest:self.sessionCookie];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    self.requestFinished = NO;
    
    [self waitForRequest];
    
    NSURLRequest *refreshRequest = [[CIXiamiRequestMaker sharedInstance] refreshXiamiRequest];
    self.requestFinished = NO;
    [NSURLConnection connectionWithRequest:refreshRequest delegate:self];
    
    [self waitForRequest];
    
    
    [self requestFinished];
    [self operationComplete];
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
        self.successHandler(self.sessionCookie);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *headerFields = [httpResponse allHeaderFields];
    NSString *cookie = headerFields[@"Set-Cookie"];
    if ([cookie length])
    {
        NSArray *cookieArray = [cookie componentsSeparatedByString:@";"];
        self.sessionCookie = cookieArray[0];
//        self.requestFinished = YES;
    }
    NSLog(@"%@", [httpResponse allHeaderFields]);
}

@end
