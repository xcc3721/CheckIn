//
//  CIXiamiRequestMaker.m
//  CheckIn
//
//  Created by Erick Xi on 4/23/13.
//  Copyright (c) 2013 Erick. All rights reserved.
//

#import "CIXiamiRequestMaker.h"
#import "CIAccountManager.h"

static CIXiamiRequestMaker *_sharedInstance = nil;

@implementation CIXiamiRequestMaker

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^
    {
        _sharedInstance = [[CIXiamiRequestMaker alloc] init];
    });
    return _sharedInstance;
}

- (NSURLRequest *)loginRequest
{
    NSMutableURLRequest *urlRequest = [self mutableURLRequestByPost];
    [urlRequest setURL:[NSURL URLWithString:@"http://www.xiami.com/member/login"]];
    CIAccountManager *accountManager = [CIAccountManager defaultManager];
    NSString *usernamePart = [NSString stringWithFormat:@"&email=%@", [[accountManager xiamiUsername] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *passwordPart = [NSString stringWithFormat:@"&password=%@", [[accountManager xiamiPassword] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *prefixPart = @"done=%2F";
    NSString *suffixPart = @"&submit=%E7%99%BB+%E5%BD%95";
    NSArray *contentArray = @[prefixPart, usernamePart, passwordPart, suffixPart];
    NSString *content = [contentArray componentsJoinedByString:@""];
    
    [urlRequest setupMessageBody:content];
    NSDictionary *httpHeader = @{
                                 @"Accept": @"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                                 @"Accept-Charset":@"GBK,utf-8;q=0.7,*;q=0.3",
                                 @"Accept-Encoding":@"gzip,deflate,sdch",
                                 @"Accept-Language":@"zh-CN,zh;q=0.8",
                                 @"Cache-Control":@"max-age=0",
                                 @"Connection":@"keep-alive",
                                 @"Content-Type":@"application/x-www-form-urlencoded",
                                 @"Host":@"www.xiami.com",
                                 @"Origin":@"http://www.xiami.com",
                                 @"Referer":@"http://www.xiami.com/",
                                 @"User-Agent":@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17"
                                 };
    [urlRequest addHTTPHeaderFields:httpHeader];
    return urlRequest;
}

- (NSURLRequest *)checkinRequest
{
    NSMutableURLRequest *urlRequest = [self mutableURLRequestByPost];
    [urlRequest setURL:[NSURL URLWithString:@"http://www.xiami.com/task/signin"]];
    [urlRequest setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [urlRequest setValue:@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1312.57 Safari/537.17" forHTTPHeaderField:@"User-Agent"];
    return urlRequest;
}


@end
