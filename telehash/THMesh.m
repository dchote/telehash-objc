//
//  THMesh.m
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THMesh.h"

@implementation THMesh

+ (id)initWithConfig:(THMeshConfiguration*)config {
	THMesh* mesh = [[THMesh alloc] init];
	
	[mesh bootstrapWithConfig:config];
	
	return mesh;
}

- (id)init {
	if (self) {
		self.transportAssistant = [[THTransportAssistant alloc] init];
		self.transports = [NSMutableArray array];
	}
	
	return self;
}


- (void)bootstrapWithConfig:(THMeshConfiguration*)config {
	self.config = config;
	
	// determine transports
	for (THTransport* transport in [self.transportAssistant getAllTransports]) {
		if (config.enabledTransportIDs == nil || [config.enabledTransportIDs containsObject:transport.identifier]) {
			THLogDebugMessage(@"Adding transport %@ with properties %@ to active transport list.", transport.identifier, [transport description]);
			[self.transports addObject:transport];
			
			// initialize each transport type accordingly
			if ([transport isKindOfClass:[THTransportNetworkAdapter class]]) {
				[(THTransportNetworkAdapter*)transport bindToPort:config.listenPort];
			}
		}
	}
	
	
}

- (void)shutdown {
	
}





- (void)THTransportReady:(THTransport*)transport {
	THLogInfoMessage(@"transport %@ is now ready", transport.identifier);
	
}


- (void)THTransportError:(THTransport*)transport error:(NSError*)error {
	THLogWarningMessage(@"transport %@ had an error", transport.identifier);
}

@end
