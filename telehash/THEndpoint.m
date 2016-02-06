//
//  THEndpoint.m
//  telehash
//
//  Created by Daniel Chote on 8/15/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THEndpoint.h"
#import "THMesh.h"

@implementation THEndpoint

- (id)init {
	self = [super init];
	
	self.mesh = nil;
	self.remoteHashname = nil;
	self.establishedLink = nil;
	self.pipes = [NSMutableArray array];
	
	self.status = THEndpointStatusPending;
	
	return self;
}


+ (THEndpoint *)initWithMesh:(THMesh *)mesh {
	THLogMethodCall
	
	THEndpoint* endpoint = [[THEndpoint alloc] init];
	endpoint.mesh = mesh;
	
	return endpoint;
}

+ (THEndpoint *)endpointFromJSON:(NSData *)json withMesh:(THMesh *)mesh {
	THLogMethodCall
	
	THEndpoint* endpoint = [THEndpoint initWithMesh:mesh];
	
	// TODO JSON parsing logic here
	
	return endpoint;
}

+ (THEndpoint *)endpointFromURI:(THURI *)uri withMesh:(THMesh *)mesh {
	THLogMethodCall
	
	if (uri) {
		THEndpoint* endpoint = [THEndpoint initWithMesh:mesh];
		
		endpoint.remoteHashname = uri.hashname;
		[endpoint generatePipesFromPaths:uri.paths];
		
		return endpoint;
	}
	
	return nil;
}



- (void)generatePipesFromPaths:(NSArray *)paths {
	THLogMethodCall
	
	// TODO track already created pipes by URI key or something, so dont create duups
	
	for (THPath* path in paths) {
		for (THTransport* transport in self.mesh.activeTransports) {
			// check to see if the transport supports the path type
			if (transport.active && [transport.enabledPathTypes	containsObject:path.type]) {
				THPipe* pipe = [transport pipeFromPath:path];
				
				if (pipe && ![self.pipes containsObject:pipe]) {
					THLogDebugMessage(@"adding pipe %@ to endpoint %@", pipe.info, self.remoteHashname.hashname);
					[self.pipes addObject:pipe];
				}
			}
		}
	}
	
	
	// TODO notification of pipes ready
}

@end
