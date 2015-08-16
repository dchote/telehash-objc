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
		THLogDebugMessage(@"transport %@", [transport description]);
	}
	
	
}

- (void)shutdown {
	
}


- (void)transportStateChange:(THTransport*)transport
{
	
}
@end
