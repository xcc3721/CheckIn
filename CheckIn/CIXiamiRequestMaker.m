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

- (NSURLRequest *)loginRequest:(NSString *)cookie
{
    NSMutableURLRequest *urlRequest = [self mutableURLRequestByPost];
    [urlRequest setURL:[NSURL URLWithString:@"http://www.xiami.com/member/login"]];
    CIAccountManager *accountManager = [CIAccountManager defaultManager];
    NSString *usernamePart = [NSString stringWithFormat:@"&email=%@", [[accountManager xiamiUsername] stringByCFAddingPercentEscapes]];
    NSString *passwordPart = [NSString stringWithFormat:@"&password=%@", [[accountManager xiamiPassword] stringByCFAddingPercentEscapes]];
    NSString *prefixPart = @"done=%2F";
    NSString *suffixPart = @"&submit=%E7%99%BB+%E5%BD%95&autologin=1";
    NSArray *contentArray = @[prefixPart, usernamePart, passwordPart, suffixPart];
    NSString *content = [contentArray componentsJoinedByString:@""];
    [urlRequest addValue:[cookie stringByAppendingString:@"; __utma=251084815.1421577405.1366771482.1366771482.1366771482.1; __utmb=251084815.1.10.1366771482; __utmc=251084815; __utmz=251084815.1366771482.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)"] forHTTPHeaderField:@"Cookie"];
    
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
                                 };
    [urlRequest addHTTPHeaderFields:httpHeader];
    return urlRequest;
}

- (NSURLRequest *)checkinRequest:(NSString *)cookie
{
    NSMutableURLRequest *urlRequest = [self mutableURLRequestByPost];
    [urlRequest setURL:[NSURL URLWithString:@"http://www.xiami.com/task/signin"]];
    [urlRequest setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    [urlRequest addValue:[cookie stringByAppendingString:@"; __utma=251084815.1421577405.1366771482.1366771482.1366771482.1; __utmb=251084815.1.10.1366771482; __utmc=251084815; __utmz=251084815.1366771482.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)"] forHTTPHeaderField:@"Cookie"];
    return urlRequest;
}

- (NSURLRequest *)sessionIdRequest
{
    NSMutableURLRequest *urlRequest = [self mutableURLRequestByGet];
    [urlRequest setURL:[NSURL URLWithString:@"http://www.xiami.com/coop/checkcode"]];
    return urlRequest;
}

- (NSURLRequest *)refreshXiamiRequest
{
    NSMutableURLRequest *urlRequest = [self mutableURLRequestByGet];
    [urlRequest setURL:[NSURL URLWithString:@"http://www.xiami.com"]];
    NSDictionary *header = @{
                             @"Referer": @"http://www.xiami.com/",
                             @"Accept-Encoding": @"gzip,deflate,sdch",
                             @"Accept-Language": @"zh-CN,zh;q=0.8",
                             @"Accept-Charset": @"GBK,utf-8;q=0.7,*;q=0.3",
                             @"Host": @"www.xiami.com",
                             @"Connection": @"keep-alive",
                             @"Cache-Control": @"max-age=0",
                             @"Accept": @"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                             };
    [urlRequest addHTTPHeaderFields:header];
    return urlRequest;
}


- (NSURLRequest *)logoutRequest:(NSString *)cookie
{
    NSMutableURLRequest *urlRequest = [self mutableURLRequestByGet];
    [urlRequest setURL:[NSURL URLWithString:@"http://www.xiami.com/member/logout"]];
    [urlRequest setValue:cookie forHTTPHeaderField:@"Cookie"];
    NSDictionary *header = @{
                             @"Referer": @"http://www.xiami.com/",
                             @"Accept-Encoding": @"gzip,deflate,sdch",
                             @"Accept-Language": @"zh-CN,zh;q=0.8",
                             @"Accept-Charset": @"GBK,utf-8;q=0.7,*;q=0.3",
                             @"Host": @"www.xiami.com",
                             @"Connection": @"keep-alive",
                             @"Cache-Control": @"max-age=0",
                             @"Accept": @"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
                             };
    [urlRequest addHTTPHeaderFields:header];
    return urlRequest;
}
@end
