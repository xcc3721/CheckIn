//
//  CIAppDelegate.m
//  CheckIn
//
//  Created by Erick on 13-4-22.
//  Copyright (c) 2013年 Erick. All rights reserved.
//

#import "CIAppDelegate.h"
#import "CIXiamiRequestMaker.h"
#import "NSArray+AFNetwork.h"
#import "CIAccountManager.h"

@interface CIAppDelegate ()

@property (nonatomic, retain) NSStatusItem *statusItem;

@end

@implementation CIAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    //    [self.statusItem setTitle:@"hehe"];
    //    [self.statusItem setHighlightMode:YES];
    //    [self.statusItem setMenu:self.statusMenu];
}

- (IBAction)loginXiami:(id)sender
{
    NSURLRequest *request = [[CIXiamiRequestMaker sharedInstance] loginRequest];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self refreshXiami];
         
         
     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", error);
     }];
    
    [operation start];
}

- (void) refreshXiami
{
    AFHTTPRequestOperation *refreshOperation = [[AFHTTPRequestOperation alloc] initWithRequest:[[CIXiamiRequestMaker sharedInstance] refreshXiamiRequest]];
    [refreshOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"%@", responseObject);
         
         
         
         [self dailyPoint];
         
     }
                                            failure:nil];
    [refreshOperation start];
    
}

- (void) dailyPoint
{
    NSArray *request = [[CIXiamiRequestMaker sharedInstance] dailyPointRequests];
    [request startOperationsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self signInXiami];
     }
                                failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
}

- (void) signInXiami
{
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[[CIXiamiRequestMaker sharedInstance] signinRequest]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSData *data = responseObject;
         NSString *string = [NSString stringWithUTF8String:data.bytes];
         NSAlert *alert = [NSAlert alertWithMessageText:@"Sign In" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"%@ day signin", string];
         [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
         
     }
                                     failure:nil];
    [operation start];
}

- (IBAction)setting:(id)sender
{
    [self.xiamiPasswordField setStringValue:[[CIAccountManager defaultManager] xiamiPassword]];
    [self.xiamiUsernameField setStringValue:[[CIAccountManager defaultManager] xiamiUsername]];
    [self.settingWindow makeKeyAndOrderFront:nil];
}

- (IBAction)closeSetting:(id)sender
{
    [self.settingWindow close];
    [[CIAccountManager defaultManager] setXiamiUsername:self.xiamiUsernameField.stringValue];
    [[CIAccountManager defaultManager] setXiamiPassword:self.xiamiPasswordField.stringValue];
}

- (IBAction)logout:(id)sender
{
    [@[[[CIXiamiRequestMaker sharedInstance] logoutRequest]] startOperationsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        NSLog(@"Logged out");
    }
                                                                                failure:
     ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"%@", error);
     }];
}
@end
