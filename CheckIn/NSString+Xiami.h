//
//  NSString+Xiami.h
//  CheckIn
//
//  Created by Erick Xi on 5/29/13.
//  Copyright (c) 2013 Erick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Xiami)

- (void) parseLikeSong:(void (^)(NSString *songID, NSString *songName, NSString *songLink, NSString *artistName, NSString *artistLink, NSString *rank))handler;
- (NSString *)matchedSubStringWithPattern:(NSString *)pattern;
@end
