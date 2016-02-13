//
//  THLink.m
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THLink.h"

#import "THMesh.h"
#import "THEndpoint.h"
#import "THPath.h"
#import "THTransport.h"


@implementation THLink

- (id)init {
	self = [super init];
	
	self.endpoint = nil;
	
	self.status = THLinkStatusPending;
	
	self.pipes = [NSMutableArray array];
	
	self.lastInboundActivity = 0;
	self.lastOutboundActivity = 0;
	
	return self;
}

+ (THLink *)initWithEndpoint:(THEndpoint *)endpoint {
	THLogMethodCall
	
	THLink* link = [[THLink alloc] init];
	link.endpoint = endpoint;
	
	return link;
}


- (void)generatePipesFromPaths:(NSArray *)paths {
	THLogMethodCall
	
	// TODO track already created pipes by URI key or something, so dont create duups
	
	for (THPath* path in paths) {
		for (THTransport* transport in self.endpoint.mesh.activeTransports) {
			// check to see if the transport supports the path type
			if (transport.active && [transport.enabledPathTypes	containsObject:path.type]) {
				THPipe* pipe = [transport pipeFromPath:path];
				
				if (pipe && ![self.pipes containsObject:pipe]) {
					THLogDebugMessage(@"adding pipe %@ to endpoint %@", pipe.info, self.endpoint.hashname);
					[self.pipes addObject:pipe];
				}
			}
		}
	}
	
	
	// TODO notification of pipes ready
}


- (void)establish {
	THLogMethodCall
	
	if (self.status == THLinkStatusEstablishing) {
		THLogWarningMessage(@"link is currently establishing");
		return;
	}
	
	if (self.status != THLinkStatusConnected) {
		// TODO actual connection establishment
		
		
		
	} else {
		[self sync];
	}
}

- (void)sync {
	THLogMethodCall
	
	
}

- (void)handshake {
	THLogMethodCall
	
	
}

@end
