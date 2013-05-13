//
//  CIAppDelegate.h
//  CheckIn
//
//  Created by Erick on 13-4-22.
//  Copyright (c) 2013年 Erick. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CIAppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSMenu *statusMenu;
@property (assign) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSWindow *settingWindow;

@property (weak) IBOutlet NSTextField *xiamiUsernameField;
@property (weak) IBOutlet NSSecureTextField *xiamiPasswordField;


- (IBAction)loginXiami:(id)sender;
- (IBAction)setting:(id)sender;
- (IBAction)closeSetting:(id)sender;
- (IBAction)logout:(id)sender;

@end
