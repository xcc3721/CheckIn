//
//  ISKeychainAccessor+Array.h
//  ISRecognition
//
//  Created by Erick Xi on 3/15/13.
//  Copyright (c) 2013 Intsig. All rights reserved.
//

#import "ISKeychainAccessor.h"

@interface ISKeychainAccessor (Array)

- (BOOL) addToKeychainUsingName:(NSString *) name andArray:(NSArray *) array error:(NSError **) error;
- (NSArray *) arrayForName:(NSString *) name error:(NSError **)error;

- (BOOL) addToKeychainUsingName:(NSString *)name andNumber:(NSUInteger)number error:(NSError **)error;
- (NSUInteger) numberForName:(NSString *) name error:(NSError **)error;

@end
