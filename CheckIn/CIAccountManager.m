//
//  CIAccountManager.m
//  CheckIn
//
//  Created by Erick Xi on 4/23/13.
//  Copyright (c) 2013 Erick. All rights reserved.
//

#import "CIAccountManager.h"
#import "ISKeychainAccessor.h"

static CIAccountManager *_defaultManager = nil;

NSString * const KeychainServiceKey = @"com.autosignin.service";
NSString * const XiamiPasswordKey = @"XiamiPasswordKey";
NSString * const XiamiUsernameKey = @"XiamiUsernameKey";

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
//    return @"6289794";
    ISKeychainAccessor *acc = [[ISKeychainAccessor alloc] initWithServiceName:KeychainServiceKey];
    NSString *result = [acc valueForName:XiamiPasswordKey error:nil];
    if (result == nil)
    {
        result = @"";
    }
    return result;
}

- (NSString *)xiamiUsername
{
    ISKeychainAccessor *acc = [[ISKeychainAccessor alloc] initWithServiceName:KeychainServiceKey];
    NSString *result = [acc valueForName:XiamiUsernameKey error:nil];
    if (result == nil)
    {
        result = @"";
    }
    return result;
}

- (void)setXiamiPassword:(NSString *)xiamiPassword
{
    [self willChangeValueForKey:@"xiamiPassword"];
    ISKeychainAccessor *acc = [[ISKeychainAccessor alloc] initWithServiceName:KeychainServiceKey];
    if (xiamiPassword)
    {
        [acc addToKeychainUsingName:XiamiPasswordKey andValue:xiamiPassword error:nil];
    }
    else
    {
        [acc removeName:XiamiPasswordKey error:nil];
    }

    [self didChangeValueForKey:@"xiamiPassword"];
}

- (void)setXiamiUsername:(NSString *)xiamiUsername
{
    [self willChangeValueForKey:@"xiamiUsername"];
    ISKeychainAccessor *acc = [[ISKeychainAccessor alloc] initWithServiceName:KeychainServiceKey];
    if (xiamiUsername)
    {
        [acc addToKeychainUsingName:XiamiUsernameKey andValue:xiamiUsername error:nil];
    }
    else
    {
        [acc removeName:XiamiUsernameKey error:nil];
    }
    
    [self didChangeValueForKey:@"xiamiUsername"];
}

@end
