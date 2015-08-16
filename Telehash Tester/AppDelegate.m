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
	logger = [[THLog alloc] initWithLoggedEventTypes:[NSArray arrayWithObject:THLAllEvents] classNames:[NSArray arrayWithObject:THLAllClasses]];
	
	THLogInfoMessage(@"We are starting up");
	
	THMeshConfiguration* config = [[THMeshConfiguration alloc] init];
	
	mesh = [THMesh initWithConfig:config];
	
	
	
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	if (mesh) {
		[mesh shutdown];
	}
}

- (void)ready {
	THLogInfoMessage(@"Mesh is ready");
}

- (void)error:(NSError*)error {
	
}

@end
