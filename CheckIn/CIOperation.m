//
//  CIOperation.m
//  CheckIn
//
//  Created by Erick Xi on 4/23/13.
//  Copyright (c) 2013 Erick. All rights reserved.
//

#import "CIOperation.h"

@implementation CIOperation

- (id)init
{
    self = [super init];
    if (self)
    {
        _hasCompleted = NO;
        _hasStarted = NO;
        _requestFinished = NO;
    }
    return self;
}

- (void)start
{
    if ([self isCancelled] || [self isFinished])
    {
        return;
    }
    [self willChangeValueForKey:@"isExecuting"];
    self.hasStarted = YES;
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)waitForRequest
{
    while (!self.requestFinished)
    {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate distantFuture]];
    }
}


- (void)operationComplete
{
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    self.hasCompleted = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}


- (BOOL)isExecuting
{
    return self.hasStarted && !self.hasCompleted;
}

- (BOOL)isFinished
{
    return self.hasStarted && self.hasCompleted;
}


#pragma mark URLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.requestFinished = YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    self.requestFinished = YES;
}

@end
