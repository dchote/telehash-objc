//
//  THMesh.m
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THMesh.h"

NSString* const THMeshStateChange = @"THMeshStateChange";



@implementation THMesh


- (id)init {
	if (self) {
		self.transportAssistant = [[THTransportAssistant alloc] init];
		
		self.transports = [NSMutableArray array];
		self.activeTransports = [NSMutableArray array];
		self.endpoints = [NSMutableDictionary dictionary];
		
		self.status = THMeshStatusStartup;
	}
	
	return self;
}


- (void)bootstrapWithConfig:(THMeshConfiguration *)config {
	THLogMethodCall
	
	self.config = config;
	
	[self evaluateTransports];
	self.transportAssistant.suppressNotifications = NO; // enable notifications to be generated
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityStateChange) name:THTransportReachabilityStateChanged object:nil];
	
	// do the reachability stuff
	[self.transportAssistant setupGlobalReachability];
}

- (void)evaluateTransports {
	// determine transports
	for (THTransport* transport in [self.transportAssistant getAllTransports]) {
		if (self.config.enabledTransportIDs == nil || [self.config.enabledTransportIDs containsObject:transport.identifier]) {
			
			if (![self.transports containsObject:transport]) {
				THLogDebugMessage(@"Adding transport %@ with properties %@ to active transport list.", transport.identifier, transport.info);
				[self.transports addObject:transport];
				transport.delegate = self;
			}
			
			// if we are restricting path types, inform transports
			if (self.config.enabledTransportPathTypes) {
				for (NSString* pathType in self.config.enabledTransportPathTypes) {
					if ([transport.supportedPathTypes containsObject:pathType]) {
						[transport.enabledPathTypes addObject:pathType];
					}
				}
			} else {
				transport.enabledPathTypes = [NSMutableArray arrayWithArray:transport.supportedPathTypes];
			}
			
			// initialize each transport type accordingly
			if ([transport isKindOfClass:[THTransportNetworkAdapter class]]) {
				[(THTransportNetworkAdapter*)transport bindToPort:self.config.networkListenPort];
				
				
			} else if ([transport isKindOfClass:[THTransportSerial class]]) {
				NSNumber* baudRate = [self.config.serialBaudRates valueForKey:transport.identifier];
				if (baudRate != nil) {
					[(THTransportSerial*)transport setBaudRate:baudRate];
					[(THTransportSerial*)transport openSerialPort];
				}
			}
		}
	}
}

- (void)shutdown {
	THLogMethodCall
	
	for (THTransport* transport in [self.transportAssistant getAllTransports]) {
		[transport shutdown];
	}
}


- (void)establishRouterLinks {
	// manually specified router links
	THEndpoint* routerEndpoint;
	
	for (NSString* uriString in self.config.routerLinks) {
		THURI* uri = [THURI initWithLinkURI:uriString];
		
		routerEndpoint = [THEndpoint endpointFromURI:uri withMesh:self];
		
		if (routerEndpoint.hashname && routerEndpoint.status != THEndpointStatusError) {
			THLogDebugMessage(@"Adding router endpoint with hashname %@ to mesh", routerEndpoint.hashname);
			[self.endpoints setObject:routerEndpoint forKey:routerEndpoint.hashname.hashname];
		} else {
			THLogErrorTHessage(@"Unable to add router with URI %@ to mesh", uriString);
		}
	}
	
	// bundled router json files
	NSString* bundleRoutersPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"routers"];
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSDirectoryEnumerator* dirEnumerator = [fileManager enumeratorAtPath:bundleRoutersPath];
	
	NSString *fileName;
	while ((fileName = [dirEnumerator nextObject])) {
		if ([[fileName pathExtension] isEqualToString: @"json"]) {
			NSString* routerFilePath = [bundleRoutersPath stringByAppendingPathComponent:fileName];
			
			routerEndpoint = [THEndpoint endpointFromFile:routerFilePath withMesh:self];
			
			if (routerEndpoint.hashname && routerEndpoint.status != THEndpointStatusError) {
				THLogDebugMessage(@"Adding router endpoint with hashname %@ to mesh", routerEndpoint.hashname);
				[self.endpoints setObject:routerEndpoint forKey:routerEndpoint.hashname.hashname];
				
				[[NSNotificationCenter defaultCenter] postNotificationName:THMeshStateChange object:self userInfo:nil];
			} else {
				THLogErrorTHessage(@"Unable to add router file %@ to mesh", fileName);
			}
		}
	}
}


- (void)reachabilityStateChange {
	THLogMethodCall
	[self evaluateTransports];
}


- (void)THTransportReady:(THTransport *)transport {
	THLogInfoMessage(@"transport %@ is ready", transport.identifier);
	
	if (transport.active && ![self.activeTransports containsObject:transport]) {
		[self.activeTransports addObject:transport];
	}
	
	if (self.activeTransports.count > 0 && self.status == THMeshStatusStartup) {
		self.status = THMeshStatusReady;
		
		if ([self.delegate respondsToSelector:@selector(THMeshReady:)]) {
			[self.delegate THMeshReady:self];
		}
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:THMeshStateChange object:self userInfo:nil];
}


- (void)THTransportError:(THTransport *)transport error:(NSError *)error {
	THLogWarningMessage(@"transport %@ had an error", transport.identifier);
	
	// TODO determine all transports down to set self.status = THMeshStatusError
	
	if ([self.delegate respondsToSelector:@selector(THMeshError:error:)]) {
		[self.delegate THMeshError:self error:error];
		[[NSNotificationCenter defaultCenter] postNotificationName:THMeshStateChange object:self userInfo:nil];

	}
	
	if ([self.activeTransports containsObject:transport]) {
		[self.activeTransports removeObject:transport];
	}
}

@end
