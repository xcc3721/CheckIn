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
#import "CIXiamiCheckinOperation.h"

@interface CIXiamiManager ()

@property (nonatomic, copy) NSString *sessionCookie;

@end

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

- (NSString *)memberAuthInCookie
{
    NSString *memberAuth = nil;
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    NSMutableArray *xiamiCookies = [NSMutableArray array];
    for (NSHTTPCookie *cookie in cookies)
    {
        if ([[cookie domain] rangeOfString:@"xiami.com" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [xiamiCookies addObject:[NSString stringWithFormat:@"%@=%@", [cookie name], [cookie value]]];
        }
    }
    memberAuth = [xiamiCookies componentsJoinedByString:@"; "];
    return memberAuth;
}

- (BOOL)removeCookie
{
    BOOL result = NO;
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies)
    {
        if ([[cookie domain] rangeOfString:@"xiami.com" options:NSCaseInsensitiveSearch].location != NSNotFound)
        {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            result = YES;
        }
    }
    return result;
}

- (void)login
{
    CIXiamiLoginOperation *loginOperation = [[CIXiamiLoginOperation alloc] init];
    [loginOperation setSuccessHandler:^ (NSString *sessionCookie)
    {
        self.sessionCookie = sessionCookie;
    }];
    [[CIOperationQueue sharedQueue] addOperation:loginOperation];
}

- (void)checkin
{
    CIXiamiCheckinOperation *checkinOperation = [[CIXiamiCheckinOperation alloc] init];
    NSMutableString *additionCookie = [NSMutableString stringWithString:self.sessionCookie];
    if ([self memberAuthInCookie])
    {
        [additionCookie appendFormat:@"; %@", [self memberAuthInCookie]];
    }
    checkinOperation.additionCookie = additionCookie;
    [[CIOperationQueue sharedQueue] addOperation:checkinOperation];
    
}

- (void)logout
{
    
}

@end
