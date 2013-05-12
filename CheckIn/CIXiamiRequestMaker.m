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
    NSString *usernamePart = [NSString stringWithFormat:@"&email=%@", [[accountManager xiamiUsername] stringByCFAddingPercentEscapes]];
    NSString *passwordPart = [NSString stringWithFormat:@"&password=%@", [[accountManager xiamiPassword] stringByCFAddingPercentEscapes]];
    NSString *prefixPart = @"done=%2F";
    NSString *suffixPart = @"&submit=%E7%99%BB+%E5%BD%95&autologin=1";
    NSArray *contentArray = @[prefixPart, usernamePart, passwordPart, suffixPart];
    NSString *content = [contentArray componentsJoinedByString:@""];
    
    [urlRequest setupMessageBody:content];
    NSDictionary *httpHeader = @{
                                 @"X-Requested-With": @"XMLHttpRequest",
                                 @"Host":@"www.xiami.com"
                                 };
    [urlRequest addHTTPHeaderFields:httpHeader];
    return urlRequest;
}


- (NSURLRequest *)refreshXiamiRequest
{
    NSMutableURLRequest *urlRequest = [self mutableURLRequestByGet];
    [urlRequest setURL:[NSURL URLWithString:@"http://www.xiami.com"]];
    NSDictionary *header = @{
                             @"Referer": @"http://www.xiami.com/",
                             @"Host":@"www.xiami.com"
                             };
    [urlRequest addHTTPHeaderFields:header];
    return urlRequest;
}

- (NSURLRequest *)signinRequest
{
    NSMutableURLRequest *urlRequest = [self mutableURLRequestByPost];
    [urlRequest setURL:[NSURL URLWithString:@"http://www.xiami.com/task/signin"]];
    [urlRequest addValue:@"http://www.xiami.com/" forHTTPHeaderField:@"Referer"];
    return urlRequest;
}

- (NSURLRequest *)logoutRequest
{
    NSMutableURLRequest *urlRequest = [self mutableURLRequestByGet];
    [urlRequest setURL:[NSURL URLWithString:@"http://www.xiami.com/member/logout"]];
    NSDictionary *header = @{
                             @"Referer": @"http://www.xiami.com/",
                             @"Host":@"www.xiami.com"
                             };
    [urlRequest addHTTPHeaderFields:header];
    return urlRequest;
}

- (NSArray *)dailyPointRequests
{
    NSMutableURLRequest *taskRequest = [self mutableURLRequestByGet];
    [taskRequest setURL:[NSURL URLWithString:@"http://www.xiami.com/task/fetch-task?type=25&id=0"]];
    
    NSMutableURLRequest *allSongRequest = [self mutableURLRequestByGet];
    [allSongRequest setURL:[NSURL URLWithString:@"http://www.xiami.com/statclick/req/AllSongListPlay"]];
    NSDictionary *header = @{
                             @"Referer": @"http://www.xiami.com/?task",
                             @"Host":@"www.xiami.com"
                             };
    [allSongRequest addHTTPHeaderFields:header];
    
    NSMutableURLRequest *playListRequest = [self mutableURLRequestByGet];
    [playListRequest setURL:[NSURL URLWithString:@"http://www.xiami.com/song/playlist/id/1/type/9"]];
    NSDictionary *listHeader = @{
                             @"Referer": @"http://www.xiami.com/song/play?ids=/song/playlist-default",
                             @"Host":@"www.xiami.com"
                             };
    [playListRequest addHTTPHeaderFields:listHeader];
    
    NSMutableURLRequest *pointRequest = [self mutableURLRequestByGet];
    [pointRequest setURL:[NSURL URLWithString:@"http://www.xiami.com/task/gain/type/25/id/0"]];
    NSDictionary *pointHeader = @{
                                 @"Referer": @"http://www.xiami.com/song/play?ids=/song/playlist-default",
                                 @"Host":@"www.xiami.com"
                                 };
    [pointRequest addHTTPHeaderFields:pointHeader];
    
    return @[taskRequest, allSongRequest, playListRequest, pointRequest];
}

@end
