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
	
	// determine transports
	for (THTransport* transport in [self.transportAssistant getAllTransports]) {
		if (config.enabledTransportIDs == nil || [config.enabledTransportIDs containsObject:transport.identifier]) {
			THLogDebugMessage(@"Adding transport %@ with properties %@ to active transport list.", transport.identifier, [transport description]);
			[self.transports addObject:transport];
			
			transport.delegate = self;
			
			// initialize each transport type accordingly
			if ([transport isKindOfClass:[THTransportNetworkAdapter class]]) {
				[(THTransportNetworkAdapter*)transport bindToPort:config.networkListenPort];
				
				
			} else if ([transport isKindOfClass:[THTransportSerial class]]) {
				NSNumber* baudRate = [config.serialBaudRates valueForKey:transport.identifier];
				if (baudRate != nil) {
					[(THTransportSerial*)transport setBaudRate:baudRate];
					[(THTransportSerial*)transport openSerialPort];
				}
				
				
			}
		}
	}
	
	for (NSString* uriString in self.config.routerLinks) {
		THURI* uri = [THURI initWithLinkURI:uriString];
		
		THEndpoint* routerEndpoint = [THEndpoint endpointFromURI:uri withLocalHashname:self.localHashname];
		
		if (routerEndpoint.remoteHashname && routerEndpoint.status != THEndpointStatusError) {
			THLogDebugMessage(@"Adding router endpoint with hashname %@ to mesh", routerEndpoint.remoteHashname.hashname);
			[self.endpoints setObject:routerEndpoint forKey:routerEndpoint.remoteHashname.hashname];
		} else {
			THLogErrorTHessage(@"Unable to add router with URI %@ to mesh", uriString);
		}
	}
	
	
}

- (void)shutdown {
	THLogMethodCall
	
	for (THTransport* transport in [self.transportAssistant getAllTransports]) {
		[transport shutdown];
	}
}





- (void)THTransportReady:(THTransport *)transport {
	THLogInfoMessage(@"transport %@ is now ready", transport.identifier);
	
	if (![self.activeTransports containsObject:transport]) {
		[self.activeTransports addObject:transport];
	}
	
	if (self.status == THMeshStatusStartup) {
		self.status = THMeshStatusReady;
		
		if ([self.delegate respondsToSelector:@selector(THMeshReady:)]) {
			[self.delegate THMeshReady:self];
		}
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:THMeshStateChange object:self userInfo:nil];

	// TODO send router handshake
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
