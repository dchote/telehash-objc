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
	
	self.logger = [[THLog alloc] initWithLoggedEventTypes:[NSArray arrayWithObject:THLAllEvents] classNames:[NSArray arrayWithObject:THLAllClasses]];
	debugController = [DebugController sharedController];
	THLogInfoMessage(@"We are starting up");
	
	
	THMeshConfiguration* config = [[THMeshConfiguration alloc] init];
	// Only enable certain transports
	// config.enabledTransportIDs = [NSArray arrayWithObjects:@"en0", @"en1", nil];
	
	// Only enable certain path types
	config.enabledTransportPathTypes = [NSArray arrayWithObjects:@"udp4", nil];
	
	
	// network listen port (udp/tcp*)
	//config.networkListenPort = 42424;
	
	// serial port X at baud rate Y
	//[config.serialBaudRates setValue:@11500 forKey:@"/dev/ttyS0"];
	
	// telehash router link test
	// router hashname: dnnoqfhxvotbwu6hjsjtgbijjuc6heobdiqh32h7i3wk3oh6zkuq
	//[config.routerLinks addObject:@"link://172.20.0.203:41797?cs1a=am4nohyyofgfxtv63ljghkmtfwq6fwwbki&cs2a=gcbacirqbudaskugjcdpodibaeaqkaadqiaq6abqqiaquaucaeaqbugc5exov22ismazaseoqo624vwl5qxjjlmerbt5sstdccygc3negfjmqinyaxrp6sgwlcldacay67qhtd7c4gcg7ye2azuu3h5vwwfmxjpwplpd4vtpwjfw4nuu6ppc66feoj3fizyongfg5dhjb6fmbjdnrboxuvszh322ta53tzvfbufhplsgn7rivgywp2kzczqs3zblyst35yifvux4mwzrcpwt4h6zd4jmqzulmbfqdw5odkocfoxlqiickb3fikcyyucom2pfuhmf5w2xogtf5ef4hc77j2qg3535ffhhbhpeommlzjabaxfjgrsri5ilahfdtxzfjezgcpdbbjy5lvgm35qdcbttnrofktc5qrnovbfvwziigq7d5fgmtdjn4u7zrpgwe2qnat7w2jycamaqaai&cs3a=7bmkxdqsxorkfrf7dq5dnnxdl4aaeyyv7ghnk5pqchldkh5r3v5a"];
	
	self.mesh = [[THMesh alloc] init];
	self.mesh.delegate = self;
	
	// weak assignment of mesh within debugController
	debugController.mesh = self.mesh;
	
	[self.mesh bootstrapWithConfig:config];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	if (self.mesh) {
		[self.mesh shutdown];
	}
}

- (void)THMeshReady:(THMesh *)mesh {
	THLogInfoMessage(@"Mesh is ready...");
	[debugController showWindow:self];
	
	[mesh performSelector:@selector(establishRouterLinks) withObject:nil afterDelay:2];
}


- (void)THMeshError:(THMesh *)mesh error:(NSError *)error {
	
}


@end
