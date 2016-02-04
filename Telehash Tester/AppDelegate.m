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
	//config.networkListenPort = 42424;
	
	// serial port X at baud rate Y
	//[config.serialBaudRates setValue:@11500 forKey:@"/dev/ttyS0"];
	
	// telehash router link test
	[config.routerLinks addObject:@"link://172.20.0.203:47637?cs1a=am4nohyyofgfxtv63ljghkmtfwq6fwwbki&cs2a=gcbacirqbudaskugjcdpodibaeaqkaadqiaq6abqqiaquaucaeaqbugc5exov22ismazaseoqo624vwl5qxjjlmerbt5sstdccygc3negfjmqinyaxrp6sgwlcldacay67qhtd7c4gcg7ye2azuu3h5vwwfmxjpwplpd4vtpwjfw4nuu6ppc66feoj3fizyongfg5dhjb6fmbjdnrboxuvszh322ta53tzvfbufhplsgn7rivgywp2kzczqs3zblyst35yifvux4mwzrcpwt4h6zd4jmqzulmbfqdw5odkocfoxlqiickb3fikcyyucom2pfuhmf5w2xogtf5ef4hc77j2qg3535ffhhbhpeommlzjabaxfjgrsri5ilahfdtxzfjezgcpdbbjy5lvgm35qdcbttnrofktc5qrnovbfvwziigq7d5fgmtdjn4u7zrpgwe2qnat7w2jycamaqaai&cs3a=7bmkxdqsxorkfrf7dq5dnnxdl4aaeyyv7ghnk5pqchldkh5r3v5a"];
	
	
	mesh = [[THMesh alloc] init];
	mesh.delegate = self;
	
	// weak assignment of mesh within debugController
	debugController.mesh = mesh;
	
	[mesh bootstrapWithConfig:config];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	if (mesh) {
		[mesh shutdown];
	}
}

- (void)THMeshReady:(THMesh *)mesh {
	THLogInfoMessage(@"Mesh is ready...");
	[debugController showWindow:self];
}


- (void)THMeshError:(THMesh *)mesh error:(NSError *)error {
	
}


@end
