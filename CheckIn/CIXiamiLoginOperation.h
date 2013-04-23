//
//  CIXiamiLoginOperation.h
//  CheckIn
//
//  Created by Erick Xi on 4/23/13.
//  Copyright (c) 2013 Erick. All rights reserved.
//

#import "CIOperation.h"

typedef void (^XiamiLoginSuccessHandler)(NSString *account);
typedef void (^XiamiLoginFailedHandler)(NSError *error, NSString *account);

@interface CIXiamiLoginOperation : CIOperation

@property (nonatomic, copy) XiamiLoginSuccessHandler successHandler;
@property (nonatomic, copy) XiamiLoginFailedHandler failedHandler;

@end
