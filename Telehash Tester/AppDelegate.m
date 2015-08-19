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
	//config.enabledTransportIDs = [NSArray arrayWithObjects:@"en0", @"en1", nil];
	config.listenPort = 42424;
	
	mesh = [THMesh initWithConfig:config];
	
	
	
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	if (mesh) {
		[mesh shutdown];
	}
}

- (void)THMeshReady:(THMesh*)mesh {
	THLogInfoMessage(@"Mesh is ready");
}


- (void)THMeshError:(THMesh*)mesh error:(NSError*)error {
	
}


@end
