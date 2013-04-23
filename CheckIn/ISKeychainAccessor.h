//
//  ISKeychainAccessor.h
//  CamCard
//
//  Created by S Q on 13-3-4.
//
//

#import <Foundation/Foundation.h>

@interface ISKeychainAccessor : NSObject

- (id)  initWithServiceName:(NSString *) serviceName;

- (BOOL) addToKeychainUsingName:(NSString *) name andValue:(NSString *) value error:(NSError **) error;
- (BOOL) addToKeychainUsingName:(NSString *)inName andData:(NSData *)data error:(NSError **)error;

- (NSString *) valueForName:(NSString *) name error:(NSError **)error;
- (NSData *) dataForName:(NSString *) name error:(NSError **)error;

- (BOOL) removeName:(NSString *) name error:(NSError **) error;

@end
