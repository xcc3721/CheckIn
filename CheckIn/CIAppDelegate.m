//
//  CIAppDelegate.m
//  CheckIn
//
//  Created by Erick on 13-4-22.
//  Copyright (c) 2013年 Erick. All rights reserved.
//

#import "CIAppDelegate.h"
#import "CIXiamiManager.h"

@interface CIAppDelegate ()

@property (nonatomic, retain) NSStatusItem *statusItem;

@end

@implementation CIAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setTitle:@"hehe"];
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setMenu:self.statusMenu];
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
    [[CIXiamiManager defaultManager] checkin];
    
}

- (IBAction)printCookies:(id)sender
{
//    [[CIXiamiManager defaultManager] xiamiCookie];
    NSLog(@"%d", [[CIXiamiManager defaultManager] removeCookie]);

}
@end
