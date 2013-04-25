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
    [request addValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17" forHTTPHeaderField:@"User-Agent"];
    return request;
}

- (NSMutableURLRequest *)mutableURLRequestByPost
{
    __autoreleasing NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17" forHTTPHeaderField:@"User-Agent"];
    return request;
}


@end
