//
//  JTAppDelegate.h
//  messagesicqhelper
//
//  Created by Jan-Gerd Tenberge on 23.10.13.
//  Copyright (c) 2013 Jan-Gerd Tenberge. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JTAppDelegate : NSObject <NSApplicationDelegate> {
    NSURL *settingsLocation;
    NSDictionary *accounts;
    NSMutableDictionary *settings;
}

@property (assign) IBOutlet NSWindow *window;

- (IBAction)setAccountSettings:(id)sender;

@end
