//
//  CIRequestMaker.m
//  CheckIn
//
//  Created by Erick on 13-4-22.
//  Copyright (c) 2013年 Erick. All rights reserved.
//

#import "CIRequestMaker.h"
NSString * const CIUserAgentString = @"Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.58 Safari/537.22";

@implementation NSString (RequestMaker)

- (NSString *)messageLength
{
    return [NSString stringWithFormat:@"%d", (int)self.length];
}

- (NSString *)stringByCFAddingPercentEscapes
{
    __autoreleasing NSString *encodedValue = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                                    nil,
                                                                                                                    (CFStringRef)self,
                                                                                                                    NULL,
                                                                                                                    (CFStringRef)@"!@$&()=+~`;':,/?",
                                                                                                                    kCFStringEncodingUTF8));
    return encodedValue;
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
    [request addValue:CIUserAgentString forHTTPHeaderField:@"User-Agent"];
    return request;
}

- (NSMutableURLRequest *)mutableURLRequestByPost
{
    __autoreleasing NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request addValue:CIUserAgentString forHTTPHeaderField:@"User-Agent"];
    return request;
}


@end
