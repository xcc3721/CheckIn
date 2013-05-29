//
//  NSArray+AFNetwork.m
//  CheckIn
//
//  Created by Erick on 13-5-12.
//  Copyright (c) 2013年 Erick. All rights reserved.
//

#import "NSArray+AFNetwork.h"
#import "AFNetworking.h"

@implementation NSArray (AFNetwork)

- (void)startOperationsWithSuccess:(void (^)(AFHTTPRequestOperation *, id))success
                           failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    if ([self count] == 0)
    {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Invalid array" userInfo:nil];
    }
    for (id obj in self)
    {
        if (![obj isKindOfClass:[NSURLRequest class]])
        {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Invalid array" userInfo:nil];
        }
    }
    
    AFHTTPRequestOperation *first = [self operationWithIndex:0 WithSuccess:success failure:failure];
    [first start];
}

- (AFHTTPRequestOperation *) operationWithIndex:(NSUInteger)index
                                    WithSuccess:(void (^)(AFHTTPRequestOperation *, id))success
                                        failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    if (index >= [self count] - 1)
    {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:self[index]];
        [operation setCompletionBlockWithSuccess:success
                                         failure:failure];
        return operation;
    }
    else
    {
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:self[index]];
        AFHTTPRequestOperation *nextOp = [self operationWithIndex:index+1 WithSuccess:success failure:failure];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            if (success)
            {
                success(operation, responseObject);
            }
            [nextOp start];
        }
                                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"%@ failed with error:[%@]", operation, error);
            if (failure)
            {
                failure(operation, error);
            }
            [nextOp start];
        }];
        return op;
    }
}

@end
