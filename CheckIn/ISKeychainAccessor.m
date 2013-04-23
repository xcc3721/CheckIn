//
//  ISKeychainAccessor.m
//  CamCard
//
//  Created by S Q on 13-3-4.
//
//

#import "ISKeychainAccessor.h"

@interface ISKeychainAccessor()

@property (nonatomic, copy) NSString *serviceName;

@end

@implementation ISKeychainAccessor

- (void) dealloc
{
    [_serviceName release];
    [super dealloc];
}

- (id)  initWithServiceName:(NSString *) serviceName
{
    NSParameterAssert([serviceName length] != 0);
    self = [super init];
    if (self)
    {
        _serviceName = [serviceName copy];
    }
    return self;
}

- (NSString *) valueForName:(NSString *) name error:(NSError **)error
{
    return [self findValueFromKeychainUsingName:name error:error];
}

- (NSData *)dataForName:(NSString *)name error:(NSError **)error
{
    NSData *value = nil;
    OSStatus status = [self findValueFromKeychainUsingName:name returningData:&value returningItem:NULL];
    if (error && status != errSecSuccess)
    {
        *error = [NSError errorWithDomain:@"ISKeychainAccessor" code:status userInfo:nil];
    }
	return value;
}

- (BOOL) removeName:(NSString *) name error:(NSError **) error
{
    return [self removeValueFromKeychainUsingName:name error:error]; 
}

- (BOOL) addToKeychainUsingName:(NSString *)inName andData:(NSData *)data error:(NSError **)error
{
    @try
    {
        NSString *serverName = self.serviceName;
        NSString *securityDomain = self.serviceName;
        
        NSDictionary *searchDictionary = nil;
        NSDictionary *keychainItemAttributeDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                         (id)kSecClassInternetPassword, kSecClass,
                                                         securityDomain, kSecAttrSecurityDomain,
                                                         serverName, kSecAttrServer,
                                                         inName, kSecAttrAccount,
                                                         kSecAttrAuthenticationTypeDefault, kSecAttrAuthenticationType,
                                                         [NSNumber numberWithUnsignedLongLong:'oaut'], kSecAttrType,
                                                         data, kSecValueData,
                                                         nil];
        
        OSStatus status = [self findValueFromKeychainUsingName:inName returningValue:NULL returningItem:&searchDictionary];
        if (status == errSecSuccess)
        {
            NSMutableDictionary *updateDictionary = [keychainItemAttributeDictionary mutableCopy];
            [updateDictionary removeObjectForKey:(id)kSecClass];
            
            OSStatus updateStatus = SecItemUpdate((CFDictionaryRef)keychainItemAttributeDictionary, (CFDictionaryRef)updateDictionary);
            [updateDictionary release];
            if (updateStatus != errSecSuccess)
            {
                if (error)
                {
                    *error = [NSError errorWithDomain:@"ISKeychainAccessor" code:updateStatus userInfo:nil];
                }
                NSLog(@"failed with an errorcode:%d,when we add item[username:%@, servicename:%@, value:%@] to keychain", updateStatus, inName, serverName, data);
                return NO;
            }
            else
            {
                return YES;
            }
        }
        else
        {
            OSStatus success = SecItemAdd((CFDictionaryRef)keychainItemAttributeDictionary, NULL);
            if (success != errSecSuccess)
            {
                NSLog(@"failed with an errorcode:%d,when we add item[username:%@, servicename:%@, value:%@] to keychain", success, inName, serverName, data);
                if (error)
                {
                    *error = [NSError errorWithDomain:@"ISKeychainAccessor" code:success userInfo:nil];
                }
                return NO;
            }
            else
            {
                return YES;
            }
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@", exception);
        return NO;
    }
}

- (BOOL) addToKeychainUsingName:(NSString *) inName andValue:(NSString *) inValue error:(NSError **) error
{
    return [self addToKeychainUsingName:inName andData:[inValue dataUsingEncoding:NSUTF8StringEncoding] error:error];
}

#pragma mark - -- private method --
- (NSString *) findValueFromKeychainUsingName:(NSString *) inName error:(NSError **) error
{
    NSString *value = nil;
    OSStatus status = [self findValueFromKeychainUsingName:inName returningValue:&value returningItem:NULL];
    if (error && status != errSecSuccess)
    {
        *error = [NSError errorWithDomain:@"ISKeychainAccessor" code:status userInfo:nil];
    }
	return value;
}

- (BOOL) removeValueFromKeychainUsingName:(NSString *) inName error:(NSError **) error
{
	NSString *serverName = self.serviceName;
	NSString *securityDomain = self.serviceName;
    
	NSMutableDictionary *searchDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:	(id)kSecClassInternetPassword, (id)kSecClass,
                                             securityDomain, (id)kSecAttrSecurityDomain,
                                             serverName, (id)kSecAttrServer,
                                             inName, (id)kSecAttrAccount,
                                             nil];
	
	OSStatus success = SecItemDelete((CFDictionaryRef)searchDictionary);
    if (success != errSecSuccess)
    {
        NSLog(@"delete item[username:%@, servicename:%@] in keychain failed with an errorcode:%d", inName, serverName, success);
        if (error)
        {
            *error = [NSError errorWithDomain:@"ISKeychainAccessor" code:success userInfo:nil];
        }
        return NO;
    }
    else
    {
        return YES;
    }
}

- (OSStatus) findValueFromKeychainUsingName:(NSString *) inName returningData:(NSData **) returningValue returningItem:(NSDictionary **) outKeychainItemRef
{
    
	NSString *serverName = self.serviceName;
	NSString *securityDomain = self.serviceName;
	NSDictionary *attributesDictionary = nil;
	NSData *foundValue = nil;
	OSStatus status = noErr;
	
	NSMutableDictionary *searchDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:(id)kSecClassInternetPassword, (id)kSecClass,
                                             securityDomain, (id)kSecAttrSecurityDomain,
                                             serverName, (id)kSecAttrServer,
                                             inName, (id)kSecAttrAccount,
                                             (id)kSecMatchLimitOne, (id)kSecMatchLimit,
                                             (id)kCFBooleanTrue, (id)kSecReturnData,
                                             (id)kCFBooleanTrue, (id)kSecReturnAttributes,
                                             (id)kCFBooleanTrue, (id)kSecReturnPersistentRef,
											 nil];
    
	status = SecItemCopyMatching((CFDictionaryRef)searchDictionary, (CFTypeRef *)&attributesDictionary);
    if ([attributesDictionary objectForKey:(id)kSecValueData])
    {
        foundValue = [[[attributesDictionary objectForKey:(id)kSecValueData] retain] autorelease];
    }
	
    
    if (status != errSecSuccess)
    {
        NSLog(@"find value with username[%@] and servicename[%@] in keychain failed with an errorcode:%d", inName, serverName, status);
    }
    
    if (outKeychainItemRef)
    {
		*outKeychainItemRef = [attributesDictionary autorelease];
	}
    else
    {
        // release the object inside.
        [attributesDictionary release];
    }
    
    if (returningValue)
    {
        *returningValue = foundValue;
    }
    
    return status;
}

- (OSStatus) findValueFromKeychainUsingName:(NSString *) inName returningValue:(NSString **) returningValue returningItem:(NSDictionary **) outKeychainItemRef
{
    NSString *foundPassword = nil;
    NSData *foundValue = nil;
	OSStatus status = [self findValueFromKeychainUsingName:inName returningData:&foundValue returningItem:outKeychainItemRef];
	if (status == noErr && foundValue)
    {
		foundPassword = [[NSString alloc] initWithData:foundValue encoding:NSUTF8StringEncoding];
	}
    

    if (returningValue)
    {
        *returningValue = foundPassword;
    }
	return status;
}

@end
