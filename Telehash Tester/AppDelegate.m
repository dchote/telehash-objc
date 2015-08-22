//
//  AppDelegate.m
//  Telehash Tester
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "AppDelegate.h"
#import "DebugController.h"

@implementation AppDelegate {
	DebugController* debugController;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	THLogMethodCall
	
	logger = [[THLog alloc] initWithLoggedEventTypes:[NSArray arrayWithObject:THLAllEvents] classNames:[NSArray arrayWithObject:THLAllClasses]];
	debugController = [DebugController sharedController];

	THLogInfoMessage(@"We are starting up");
	
	
	THMeshConfiguration* config = [[THMeshConfiguration alloc] init];
	// Only enable certain transports
	// config.enabledTransportIDs = [NSArray arrayWithObjects:@"en0", @"en1", nil];
	
	// network listen port (udp/tcp*)
	config.networkListenPort = 42424;
	
	// serial port X at baud rate Y
	//[config.serialBaudRates setValue:@11500 forKey:@"/dev/ttyS0"];
	
	
	
	mesh = [[THMesh alloc] init];
	mesh.delegate = self;
	
	[mesh bootstrapWithConfig:config];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	if (mesh) {
		[mesh shutdown];
	}
}

- (void)THMeshReady:(THMesh*)mesh {
	THLogInfoMessage(@"Mesh is ready...");
	[debugController showWindow:self];
}


- (void)THMeshError:(THMesh*)mesh error:(NSError*)error {
	
}


@end
