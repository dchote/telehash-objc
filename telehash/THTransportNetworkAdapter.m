//
//  THTransportNetworkAdapter.m
//  telehash
//
//  Created by Daniel Chote on 8/15/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THTransportNetworkAdapter.h"

@implementation THTransportNetworkAdapter {
	GCDAsyncUdpSocket* udpSocket;
}

- (id)init {
	if (self) {
		udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	}
	
	return self;
}

- (BOOL)hasIPAddress {
	if (self.IPv4Address || self.IPv6Address) {
		return YES;
	}
	
	return NO;
}

- (NSDictionary*)description {
	NSMutableDictionary* description = [NSMutableDictionary dictionaryWithDictionary:[super description]];
	
	if (self.interfaceType) {
		[description setObject:self.interfaceType forKey:@"interfaceType"];

	}
	
	if (self.IPv4Address) {
		[description setObject:self.IPv4Address forKey:@"IPv4Address"];
	}
	
	if (self.IPv4Netmask) {
		[description setObject:self.IPv4Netmask forKey:@"IPv4Netmask"];
	}
	
	if (self.IPv6Address) {
		[description setObject:self.IPv6Address forKey:@"IPv6Address"];
	}
	
	if (self.IPv6Netmask) {
		[description setObject:self.IPv6Netmask forKey:@"IPv6Netmask"];
	}
	
	return [NSDictionary dictionaryWithDictionary:description];
}


- (void)bindToPort:(uint16_t)port {
	if (!self.active) {
		return;
	}
	
	NSError* bindError;
	[udpSocket bindToPort:port interface:self.identifier error:&bindError];
	
	if (bindError != nil) {
		THLogErrorTHessage(@"error binding udpSocket %@ %@", self.identifier, [bindError description]);
		
		if ([self.delegate respondsToSelector:@selector(THTransportError:error:)]) {
			[self.delegate THTransportError:self error:bindError];
		}
	}
	
	
	NSError* listenError;
	[udpSocket beginReceiving:&listenError];
	
	if (listenError != nil) {
		THLogErrorTHessage(@"udpSocket %@ had error %@", self.identifier, [listenError description]);
		
		if ([self.delegate respondsToSelector:@selector(THTransportError:error:)]) {
			[self.delegate THTransportError:self error:listenError];
		}
	} else {
		THLogInfoMessage(@"udpSocket %@ now listening on port %d", self.identifier, udpSocket.localPort);
	}
}







-(void)udpSocket:(GCDAsyncUdpSocket*)sock didReceiveData:(NSData*)data fromAddress:(NSData*)address withFilterContext:(id)filterContext {
	
}

-(void)udpSocket:(GCDAsyncUdpSocket*)sock didSendDataWithTag:(long)tag {
	
}

@end
