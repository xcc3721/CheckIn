//
//  ISKeychainAccessor+Array.m
//  ISRecognition
//
//  Created by Erick Xi on 3/15/13.
//  Copyright (c) 2013 Intsig. All rights reserved.
//

#import "ISKeychainAccessor+Array.h"

@implementation ISKeychainAccessor (Array)

- (BOOL)addToKeychainUsingName:(NSString *)name andArray:(NSArray *)array error:(NSError **)error
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:array];
    return [self addToKeychainUsingName:name andData:data error:error];
}


- (NSArray *)arrayForName:(NSString *)name error:(NSError **)error
{
    NSData *data = [self dataForName:name error:error];
    if ([data isKindOfClass:[NSData class]])
    {
        @try {
            return (NSArray *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
        }
        @catch (NSException *exception)
        {
            NSLog(@"%@", exception);
            return nil;
        }
        @finally {
            
        }
        
    }
    return nil;
}

- (BOOL)addToKeychainUsingName:(NSString *)name andNumber:(NSUInteger)number error:(NSError **)error
{
    NSData *data = [NSData dataWithBytes:&number length:sizeof(number)];
    return [self addToKeychainUsingName:name andData:data error:error];
}

- (NSUInteger)numberForName:(NSString *)name error:(NSError **)error
{
    NSUInteger number = 0;
    NSData *data = [self dataForName:name error:error];
    if ([data isKindOfClass:[NSData class]])
    {
        [data getBytes:&number length:sizeof(number)];
        return number;
    }
    return 0;
}

@end
