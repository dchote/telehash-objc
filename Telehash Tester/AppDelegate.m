//
//  AppDelegate.m
//  Telehash Tester
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	mesh = [[THMesh alloc] init];
	[mesh bootstrap];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

- (void)ready {
	NSLog(@"about fucking time");
}

- (void)error:(NSError*)error {
	
}

@end
