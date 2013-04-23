//
//  CIAccountManager.h
//  CheckIn
//
//  Created by Erick Xi on 4/23/13.
//  Copyright (c) 2013 Erick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIAccountManager : NSObject

+ (id) defaultManager;

- (NSString *)xiamiUsername;
- (NSString *)xiamiPassword;

@end
