//
//  CIAccountManager.m
//  CheckIn
//
//  Created by Erick Xi on 4/23/13.
//  Copyright (c) 2013 Erick. All rights reserved.
//

#import "CIAccountManager.h"

static CIAccountManager *_defaultManager = nil;

@implementation CIAccountManager

+ (id)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _defaultManager = [[CIAccountManager alloc] init];
    });
    return _defaultManager;
}

- (NSString *)xiamiPassword
{
    return @"tbd";
}

- (NSString *)xiamiUsername
{
    return @"tbd";
}

@end
