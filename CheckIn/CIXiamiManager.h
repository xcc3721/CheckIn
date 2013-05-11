//
//  CIXiamiManager.h
//  CheckIn
//
//  Created by Erick Xi on 4/23/13.
//  Copyright (c) 2013 Erick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIXiamiManager : NSObject

+ (id)defaultManager;


- (NSString *)memberAuthInCookie;
- (BOOL)removeCookie;

- (void)login;
- (void)checkin;
- (void)logout;

@end
