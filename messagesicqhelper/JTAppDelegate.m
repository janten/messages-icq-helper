//
//  JTAppDelegate.m
//  messagesicqhelper
//
//  Created by Jan-Gerd Tenberge on 23.10.13.
//  Copyright (c) 2013 Jan-Gerd Tenberge. All rights reserved.
//

#import "JTAppDelegate.h"

@implementation JTAppDelegate

- (void)awakeFromNib {
    settingsLocation = [NSURL fileURLWithPath:@"~/Library/Preferences/com.apple.iChat.AIM.plist".stringByExpandingTildeInPath];
    settings = [NSMutableDictionary dictionaryWithContentsOfURL:settingsLocation];
    accounts = settings[@"Accounts"];
}

- (IBAction)setAccountSettings:(id)sender {
    NSURL *lockfileLocation = [NSURL fileURLWithPath:@"~/Library/Preferences/com.apple.iChat.AIM.plist.lockfile".stringByExpandingTildeInPath];

    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:lockfileLocation.path]) {
        NSLog(@"Lockfile exists. Removing.");
        [fileManager removeItemAtURL:lockfileLocation error:&error];
        [self checkForError:error];
    }

    int updated = 0;
    if (settings != nil) {
        NSLog(@"Found settings. Patching.");
        NSLog(@"Found %lu account(s).", accounts.count);
        
        for (NSString *accountName in accounts) {
            NSLog(@"Account: %@", accountName);
            NSMutableDictionary *account = accounts[accountName];
            Boolean plainTextEnforced = [account[@"ForceICQPlainText"] boolValue];
            NSLog(@"Plaintext enforced: %i", plainTextEnforced);
            if (!plainTextEnforced) {
                account[@"ForceICQPlainText"] = @YES;
                updated++;
            }
        }
        
        [settings writeToURL:settingsLocation atomically:YES];
    }

    NSLog(@"Done.");
    
    NSAlert *finished = [NSAlert alertWithMessageText:@"Your ICQ accounts have been set up. Please restart Messages.app." defaultButton:@"Quit" alternateButton:@"" otherButton:@"" informativeTextWithFormat:@"%d of your %lu accounts where updated.", updated, (unsigned long)accounts.count];
    [finished beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
        [[NSApplication sharedApplication] terminate:self];
    }];
}

- (void)checkForError:(NSError *)error {
    if (error != nil) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode) {
            [[NSApplication sharedApplication] terminate:self];
        }];
    }
}

@end
