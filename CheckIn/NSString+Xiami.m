//
//  NSString+Xiami.m
//  CheckIn
//
//  Created by Erick Xi on 5/29/13.
//  Copyright (c) 2013 Erick. All rights reserved.
//

#import "NSString+Xiami.h"

@implementation NSString (Xiami)

- (void)parseLikeSong:(void (^)(NSString *songID, NSString *songName, NSString *songLink, NSString *artistName, NSString *artistLink, NSString *rank))handler
{
    NSString *songID = [self matchedSubStringWithPattern:@"(?<=<input type=\"checkbox\" name=\"recommendids\" value=\")\\d*"];
    NSString *songName = [self matchedSubStringWithPattern:@"(?<=<td class=\"song_name\"><a title=\").*(?=\" href)"];
    NSString *songLink = [self matchedSubStringWithPattern:[NSString stringWithFormat:@"(?<=<a title=\"%@\" href=\").*(?=\">)", [NSRegularExpression escapedPatternForString:songName]]];
    NSString *artistLink = [self matchedSubStringWithPattern:@"(?<=<a class=\"artist_name\" href=\").*(?=\" title)"];
    NSString *artistName = [self matchedSubStringWithPattern:[NSString stringWithFormat:@"(?<=<a class=\"artist_name\" href=\"%@\" title=\").*(?=\">)", [NSRegularExpression escapedPatternForString:artistLink]]];
    NSString *rank = [self matchedSubStringWithPattern:@"(?<=name=\"grade\" class=\"grade_v\" value=\")\\d*(?=\">)"];
    if (handler)
    {
        handler(songID, songName, songLink, artistName, artistLink, rank);
    }
}

- (NSString *)matchedSubStringWithPattern:(NSString *)pattern
{
    NSRegularExpression *reg = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    __block NSString *string = nil;
    [reg enumerateMatchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, [self length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
     {
         string = [self substringWithRange:result.range];
         *stop = YES;
     }];
    return string;
}

@end
