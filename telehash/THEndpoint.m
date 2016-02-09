//
//  THEndpoint.m
//  telehash
//
//  Created by Daniel Chote on 8/15/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THEndpoint.h"
#import "THMesh.h"

#import "MF_Base32Additions.h"


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

+ (THEndpoint *)endpointFromFile:(NSString *)filePath withMesh:(THMesh *)mesh {
	THLogInfoMessage(@"loading json file %@", filePath);
	
	// TODO load json file
	NSData* json = [NSData dataWithContentsOfFile:filePath];
	
	THEndpoint* endpoint = [THEndpoint endpointFromJSON:json withMesh:mesh];
	
	return endpoint;
}

+ (THEndpoint *)endpointFromJSON:(NSData *)json withMesh:(THMesh *)mesh {
	THLogMethodCall
	
	THEndpoint* endpoint = [THEndpoint initWithMesh:mesh];

	if (json.length > 0) {
		NSError* error;
		NSMutableDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:json options:0 error:&error];
		
		if (error) {
			THLogErrorTHessage(@"json decode error: %@", [error localizedDescription]);
		} else if (jsonDictionary) {
			THHashname* hashname = [[THHashname alloc] init];
			
			NSDictionary* keys = [jsonDictionary objectForKey:@"keys"];
			[keys enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
				unsigned char CSID = [E3X CSIDFromString:(NSString *)key];
				NSData* keyData = [NSData dataWithBase32String:(NSString *)obj];
				
				if (CSID != 0x0 && keyData) {
					[hashname.keys setObject:keyData forKey:[E3X CSIDString:CSID]];
				}
			}];
			
			if (hashname.keys.count > 0) {
				endpoint.remoteHashname = hashname;
			}
			
			NSMutableArray* endpointPaths = [NSMutableArray array];
			NSArray* paths = [jsonDictionary objectForKey:@"paths"];
			for (NSDictionary* path in paths) {
				THPath* endpointPath = [[THPath alloc] init];
				endpointPath.ip = [path objectForKey:@"ip"];
				endpointPath.port = [[path objectForKey:@"port"] unsignedIntegerValue];
				endpointPath.type = [path objectForKey:@"type"];
				
				[endpointPaths addObject:endpointPath];
			}
			
			if (endpointPaths.count > 0) {
				[endpoint generatePipesFromPaths:endpointPaths];
			}
			
		}
	}
	
	return endpoint;
}

+ (THEndpoint *)endpointFromURI:(THURI *)uri withMesh:(THMesh *)mesh {
	THLogMethodCall
	
	if (uri) {
		THEndpoint* endpoint = [THEndpoint initWithMesh:mesh];
		
		if (uri.hashname) {
			endpoint.remoteHashname = uri.hashname;
		}
		
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
