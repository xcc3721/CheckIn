//
//  CIAppDelegate.m
//  CheckIn
//
//  Created by Erick on 13-4-22.
//  Copyright (c) 2013年 Erick. All rights reserved.
//

#import "CIAppDelegate.h"
#import "CIXiamiManager.h"

@implementation CIAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)loginXiami:(id)sender
{
//    CIRequestMaker *maker = [[CIRequestMaker alloc] init];
//    NSURLRequest *request = [maker xiamiLoginRequest];
//    NSError *error = nil;
//    NSHTTPURLResponse *response = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSLog(@"%@", response);
//    NSLog(@"%@", error);
//    
//    NSString *dataString = [NSString stringWithUTF8String:[data bytes]];
//    NSLog(@"%@", dataString);
    [[CIXiamiManager defaultManager] login];
    
}

- (IBAction)checkinXiami:(id)sender
{
//    CIRequestMaker *maker = [[CIRequestMaker alloc] init];
//    NSURLRequest *request = [maker xiamiSigninRequest];
//    NSError *error = nil;
//    NSHTTPURLResponse *response = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSLog(@"%@", response);
//    NSLog(@"%@", error);
//    
//    NSString *dataString = [NSString stringWithUTF8String:[data bytes]];
//    NSLog(@"%@", dataString);
    
}

- (IBAction)printCookies:(id)sender
{
    [[CIXiamiManager defaultManager] xiamiCookie];
}
@end
