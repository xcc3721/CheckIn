//
//  CIRequestMaker.h
//  CheckIn
//
//  Created by Erick on 13-4-22.
//  Copyright (c) 2013年 Erick. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSString (RequestMaker)

- (NSString *)messageLength;
@end


@interface NSMutableURLRequest (RequestMaker)

- (void)setupMessageBody:(NSString *)bodyString;
- (void)addHTTPHeaderFields:(NSDictionary *)headerFields;
@end



@interface CIRequestMaker : NSObject

- (NSMutableURLRequest *) mutableURLRequestByPost;
- (NSMutableURLRequest *) mutableURLRequestByGet;

@end
