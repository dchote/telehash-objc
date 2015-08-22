//
//  THMesh.m
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THMesh.h"

@implementation THMesh


- (id)init {
	if (self) {
		self.transportAssistant = [[THTransportAssistant alloc] init];
		self.transports = [NSMutableArray array];
		self.status = THMeshStatusStartup;
	}
	
	return self;
}


- (void)bootstrapWithConfig:(THMeshConfiguration*)config {
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
	
	
}

- (void)shutdown {
	THLogMethodCall
	
	for (THTransport* transport in [self.transportAssistant getAllTransports]) {
		[transport shutdown];
	}
}





- (void)THTransportReady:(THTransport*)transport {
	THLogInfoMessage(@"transport %@ is now ready", transport.identifier);
	
	if (self.status == THMeshStatusStartup) {
		self.status = THMeshStatusReady;
		
		if ([self.delegate respondsToSelector:@selector(THMeshReady:)]) {
			[self.delegate THMeshReady:self];
		}
	}
	
	
	// TODO send router handshake
}


- (void)THTransportError:(THTransport*)transport error:(NSError*)error {
	THLogWarningMessage(@"transport %@ had an error", transport.identifier);
	
	// TODO determine all transports down to set self.status = THMeshStatusError
	
	if ([self.delegate respondsToSelector:@selector(THMeshError:error:)]) {
		[self.delegate THMeshError:self error:error];
	}
}

@end
