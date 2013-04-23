//
//  CIOperation.h
//  CheckIn
//
//  Created by Erick Xi on 4/23/13.
//  Copyright (c) 2013 Erick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIOperation : NSOperation <NSURLConnectionDataDelegate>

- (void) waitForRequest;
- (void) operationComplete;

@property (nonatomic, assign) BOOL hasStarted;
@property (nonatomic, assign) BOOL hasCompleted;
@property (nonatomic, assign) BOOL requestFinished;


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

@end
