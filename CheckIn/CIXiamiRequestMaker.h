//
//  CIXiamiRequestMaker.h
//  CheckIn
//
//  Created by Erick Xi on 4/23/13.
//  Copyright (c) 2013 Erick. All rights reserved.
//

#import "CIRequestMaker.h"

@interface CIXiamiRequestMaker : CIRequestMaker

+ (id)sharedInstance;

- (NSURLRequest *) sessionIdRequest;
- (NSURLRequest *) loginRequest:(NSString *)cookie;
- (NSURLRequest *) checkinRequest:(NSString *)cookie;
- (NSURLRequest *) refreshXiamiRequest;
- (NSURLRequest *) logoutRequest:(NSString *)cookie;

@end
