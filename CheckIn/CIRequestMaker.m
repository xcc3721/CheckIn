//
//  CIRequestMaker.m
//  CheckIn
//
//  Created by Erick on 13-4-22.
//  Copyright (c) 2013年 Erick. All rights reserved.
//

#import "CIRequestMaker.h"

@implementation NSString (RequestMaker)

- (NSString *)messageLength
{
    return [NSString stringWithFormat:@"%d", (int)self.length];
}

@end

@implementation NSMutableURLRequest (RequestMaker)

- (void)setupMessageBody:(NSString *)bodyString
{
    [self setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    [self setValue:[bodyString messageLength] forHTTPHeaderField:@"Content-Length"];
}

- (void)addHTTPHeaderFields:(NSDictionary *)headerFields
{
    for (NSString *key in headerFields)
    {
        [self addValue:headerFields[key] forHTTPHeaderField:key];
    }
}

@end


@implementation CIRequestMaker

- (NSMutableURLRequest *)mutableURLRequestByGet
{    __autoreleasing NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    return request;
}

- (NSMutableURLRequest *)mutableURLRequestByPost
{
    __autoreleasing NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    return request;
}


@end
