//
//  CIOperationQueue.m
//  CheckIn
//
//  Created by Erick Xi on 4/23/13.
//  Copyright (c) 2013 Erick. All rights reserved.
//

#import "CIOperationQueue.h"

static CIOperationQueue *_sharedQueue = nil;

@implementation CIOperationQueue

+ (id)sharedQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _sharedQueue = [[CIOperationQueue alloc] init];
        [_sharedQueue setSuspended:NO];
    });
    return _sharedQueue;
}


@end
