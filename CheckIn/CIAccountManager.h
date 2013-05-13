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

//- (NSString *)xiamiUsername;
//- (NSString *)xiamiPassword;

@property (nonatomic, copy) NSString *xiamiUsername;
@property (nonatomic, copy) NSString *xiamiPassword;

@end
