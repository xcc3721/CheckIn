//
//  CIAppDelegate.h
//  CheckIn
//
//  Created by Erick on 13-4-22.
//  Copyright (c) 2013年 Erick. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CIAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
- (IBAction)loginXiami:(id)sender;
- (IBAction)checkinXiami:(id)sender;
- (IBAction)printCookies:(id)sender;

@end
