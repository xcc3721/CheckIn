//
//  CIXiamiManager.m
//  CheckIn
//
//  Created by Erick Xi on 4/23/13.
//  Copyright (c) 2013 Erick. All rights reserved.
//

#import "CIXiamiManager.h"
#import "CIOperationQueue.h"
#import "CIXiamiLoginOperation.h"

static CIXiamiManager *_defaultManager = nil;

@implementation CIXiamiManager

+ (id)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _defaultManager = [[CIXiamiManager alloc] init];
    });
    return _defaultManager;
}

- (void)xiamiCookie
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies)
    {
        NSLog(@"name: '%@'\n",   [cookie name]);
        NSLog(@"value: '%@'\n",  [cookie value]);
        NSLog(@"domain: '%@'\n", [cookie domain]);
        NSLog(@"path: '%@'\n",   [cookie path]);
        NSLog(@"-------------------------------");
    }
}

- (void)login
{
    CIXiamiLoginOperation *loginOperation = [[CIXiamiLoginOperation alloc] init];
    [loginOperation setSuccessHandler:^ (NSString *account)
    {
        NSLog(@"%@", account);
    }];
    [[CIOperationQueue sharedQueue] addOperation:loginOperation];
}

@end
