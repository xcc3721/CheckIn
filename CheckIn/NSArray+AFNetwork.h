//
//  NSArray+AFNetwork.h
//  CheckIn
//
//  Created by Erick on 13-5-12.
//  Copyright (c) 2013年 Erick. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AFHTTPRequestOperation;

@interface NSArray (AFNetwork)

- (void) startOperationsWithSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
