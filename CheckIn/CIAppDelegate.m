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
#import "NSString+Xiami.h"
#import "CHCSVParser.h"

@interface CIAppDelegate ()

@property (nonatomic, retain) NSStatusItem *statusItem;
@property (nonatomic, copy) NSString *uid;

@end

@implementation CIAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    //    [self.statusItem setTitle:@"hehe"];
    //    [self.statusItem setHighlightMode:YES];
    //    [self.statusItem setMenu:self.statusMenu];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(likeSongs:) name:@"NextUser" object:nil];
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
         //         NSLog(@"%@", responseObject);
         NSString *html = [[NSString alloc] initWithBytes:[responseObject bytes] length:[responseObject length] encoding:NSUTF8StringEncoding];
         NSScanner *scanner = [NSScanner scannerWithString:html];
         [scanner scanUpToString:@"var myUid = parseInt('" intoString:nil];
         [scanner scanString:@"var myUid = parseInt('" intoString:nil];
         NSString *uid = nil;
         [scanner scanUpToString:@"'" intoString:&uid];
         self.uid = uid;
         
         
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

- (void)parseLike:(NSInteger)sum
{
    NSLog(@"sum %ld", sum);
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.csv", [[CIAccountManager defaultManager] xiamiUid]]];
    CHCSVWriter *writer = [[CHCSVWriter alloc] initForWritingToCSVFile:path];
    [writer writeLineOfFields:@[@"SongID", @"SongName", @"SongLink", @"ArtistName", @"ArtistLink", @"Rank"]];
    
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 1; i <= sum; i++)
    {
        [array addObject:[[CIXiamiRequestMaker sharedInstance] likesRequest:[[CIAccountManager defaultManager] xiamiUid] page:i]];
    }
    
    __block NSInteger counter = 0;
    
    [array startOperationsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSScanner *scanner = [NSScanner scannerWithString:operation.responseString];
         [scanner scanUpToString:@" id=\"lib_song_" intoString:nil];
         NSString *temp = nil;
         NSMutableArray *stringArray = [NSMutableArray array];
         [scanner setScanLocation:scanner.scanLocation+1];
         while ([scanner scanUpToString:@" id=\"lib_song_" intoString:&temp])
         {
             [stringArray addObject:temp];
             if (![scanner isAtEnd])
             {
                 scanner.scanLocation += 1;
             }
             
         }
         
         for (NSString *like in stringArray)
         {
             [like parseLikeSong:^(NSString *songID, NSString *songName, NSString *songLink, NSString *artistName, NSString *artistLink, NSString *rank)
              {
                  [writer writeLineOfFields:@[songID, songName, songLink, artistName, artistLink, rank]];
              }];
         }
         
         if (counter == array.count - 1)
         {
             [writer closeStream];
             [[NSNotificationCenter defaultCenter] postNotificationName:@"NextUser" object:nil];
         }
         counter++;
     }
                              failure:
     ^(AFHTTPRequestOperation *operation, NSError *error)
     {
         
     }];
}

- (IBAction)likeSongs:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [[CIAccountManager defaultManager] increaseUid];
                       [self.progressLabel setStringValue:[[CIAccountManager defaultManager] xiamiUid]];
                   });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^
                   {
//                       while (YES)
                       {
                           NSLog(@"%@", [[CIAccountManager defaultManager] xiamiUid]);
                           [@[[[CIXiamiRequestMaker sharedInstance] likePageRequest:[[CIAccountManager defaultManager] xiamiUid]]] startOperationsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
                            {
                                NSString *pageSum = [operation.responseString matchedSubStringWithPattern:@"(?<=class=\"p_num\">)\\d*(?=</a> <a class=\"p_redirect_l\")"];
                                if ([pageSum length])
                                {
                                    [self parseLike:pageSum.integerValue];
                                }
                                else
                                {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"NextUser" object:nil];
                                }

                                
                            }
                                                                                                                                                      failure:nil];
                       }
                       
                   });
    
    
}
@end
