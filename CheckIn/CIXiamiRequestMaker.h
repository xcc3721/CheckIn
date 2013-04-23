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

- (NSURLRequest *) loginRequest;
- (NSURLRequest *) checkinRequest;

@end
