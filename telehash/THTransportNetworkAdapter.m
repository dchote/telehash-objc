//
//  THTransportNetworkAdapter.m
//  telehash
//
//  Created by Daniel Chote on 8/15/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THTransportNetworkAdapter.h"

#import "THPipeNetworkAdapter.h"

@implementation THTransportNetworkAdapter {
	GCDAsyncUdpSocket* udpSocket;
	GCDAsyncSocket* tcpSocket;
}

- (id)init {
	self = [super init];

	if (self) {
		udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
		tcpSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
		
		self.type = @"networkadapter";
		
		self.supportedPathTypes = [NSArray arrayWithObjects:@"udp4", @"tcp4", @"udp6", @"tcp6", nil];
		
		self.pipes = [NSMutableArray array];
		
		self.IPv4Address = nil;
		self.IPv6Address = nil;
		
	}
	
	return self;
}

- (BOOL)hasIPAddress {
	if (self.IPv4Address || self.IPv6Address) {
		return YES;
	}
	
	return NO;
}

- (NSDictionary *)info {
	NSMutableDictionary* info = [NSMutableDictionary dictionaryWithDictionary:[super info]];
	
	if (self.interfaceType) {
		[info setObject:self.interfaceType forKey:@"interfaceType"];
	}
	
	if (self.IPv4Address) {
		[info setObject:self.IPv4Address forKey:@"IPv4Address"];
	}
	
	if (self.IPv4Netmask) {
		[info setObject:self.IPv4Netmask forKey:@"IPv4Netmask"];
	}
	
	if (self.IPv6Address) {
		[info setObject:self.IPv6Address forKey:@"IPv6Address"];
	}
	
	if (self.IPv6Netmask) {
		[info setObject:self.IPv6Netmask forKey:@"IPv6Netmask"];
	}
	
	if (self.udpListenPort) {
		[info setObject:[NSNumber numberWithUnsignedInt:self.udpListenPort] forKey:@"udpListenPort"];
	}
	
	if (self.tcpListenPort) {
		[info setObject:[NSNumber numberWithUnsignedInt:self.tcpListenPort] forKey:@"tcpListenPort"];
	}
		
	return [NSDictionary dictionaryWithDictionary:info];
}




- (void)bindToPort:(uint16_t)port {
	THLogMethodCall
	
	if (!self.active) {
		THLogNoticeMessage(@"transport %@ is inactive, not binding...", self.identifier);
		return;
	}
	
	NSError* bindError;
	NSError* listenError;
	
	if (udpSocket.localPort) {
		THLogNoticeMessage(@"transport %@ is already bound to port %d", self.identifier, udpSocket.localPort);
	} else {
		// UDP socket
		
		[udpSocket bindToPort:port interface:self.identifier error:&bindError];
		
		if (bindError != nil) {
			self.active = NO;
			self.status = THTransportStatusError;

			THLogErrorMessage(@"error binding udpSocket %@ %@", self.identifier, [bindError description]);
			
			if ([self.delegate respondsToSelector:@selector(THTransportError:error:)]) {
				[self.delegate THTransportError:self error:bindError];
			}
		}
		
		
		[udpSocket beginReceiving:&listenError];
		
		if (listenError != nil) {
			self.active = NO;
			self.status = THTransportStatusError;

			THLogErrorMessage(@"udpSocket %@ had error %@", self.identifier, [listenError description]);
			
			if ([self.delegate respondsToSelector:@selector(THTransportError:error:)]) {
				[self.delegate THTransportError:self error:listenError];
			}
		} else {
			self.udpListenPort = udpSocket.localPort;
			THLogInfoMessage(@"udpSocket %@ now listening on port %d", self.identifier, self.udpListenPort);
		}
	}
	
	
	
	// TCP socket
	if (tcpSocket.localPort) {
		THLogNoticeMessage(@"transport %@ is already bound to port %d", self.identifier, udpSocket.localPort);
	} else {
		
		// if port is specified, listen on that port, otherwise listen on the same port as udpSocket
		if (port > 0) {
			[tcpSocket acceptOnInterface:self.identifier port:port error:&listenError];
		} else {
			[tcpSocket acceptOnInterface:self.identifier port:self.udpListenPort error:&listenError];
		}
		
		if (listenError != nil) {
			self.active = NO;
			self.status = THTransportStatusError;
			
			THLogErrorMessage(@"tcpSocket %@ had error %@", self.identifier, [listenError description]);
			
			if ([self.delegate respondsToSelector:@selector(THTransportError:error:)]) {
				[self.delegate THTransportError:self error:listenError];
			}		
		} else {
			self.tcpListenPort = [tcpSocket localPort];
			THLogInfoMessage(@"tcpSocket %@ now listening on port %d", self.identifier, self.tcpListenPort);
		}
	}
	
	if (self.active && self.status == THTransportStatusStartup) {
		self.status = THTransportStatusReady;
		
		if ([self.delegate respondsToSelector:@selector(THTransportReady:)]) {
			[self.delegate performSelector:@selector(THTransportReady:) withObject:self afterDelay:THTransportInitDelay];
		}
	}
}

- (void)shutdown {
	THLogMethodCall
	
	[udpSocket closeAfterSending];
}

- (NSArray *)paths {
	NSMutableArray* paths = [NSMutableArray array];
	
	THPath* path;

	if ([self.enabledPathTypes containsObject:@"udp4"] && self.udpListenPort > 0 && self.IPv4Address) {
		path = [[THPath alloc] init];
		path.type = @"udp4";
		path.ip = self.IPv4Address;
		path.port = self.udpListenPort;
		[paths addObject:path];
	}
	
	if ([self.enabledPathTypes containsObject:@"udp6"] && self.udpListenPort > 0 && self.IPv6Address) {
		path = [[THPath alloc] init];
		path.type = @"udp6";
		path.ip = self.IPv6Address;
		path.port = self.udpListenPort;
		[paths addObject:path];
	}
	
	if ([self.enabledPathTypes containsObject:@"tcp4"] && self.tcpListenPort > 0 && self.IPv4Address) {
		path = [[THPath alloc] init];
		path.type = @"tcp4";
		path.ip = self.IPv4Address;
		path.port = self.tcpListenPort;
		[paths addObject:path];
	}
	
	if ([self.enabledPathTypes containsObject:@"tcp6"] && self.udpListenPort > 0 && self.IPv6Address) {
		path = [[THPath alloc] init];
		path.type = @"tcp6";
		path.ip = self.IPv6Address;
		path.port = self.tcpListenPort;
		[paths addObject:path];
	}
	
	return paths;
}

- (THPipe *)pipeFromPath:(THPath *)path {
	THLogMethodCall
	
	if ([self.supportedPathTypes containsObject:path.type]) {
		THPipeNetworkAdapter* pipe = [[THPipeNetworkAdapter alloc] init];
		
		pipe.path = path;
		pipe.type = [self.type stringByAppendingFormat:@".%@", path.type];
		pipe.transport = self;
		
		// TODO some sort of notification for cleanup of old/dead pipes within a transport
		[self.pipes addObject:pipe];
		
		return pipe;
	}
	
	THLogErrorMessage(@"transport with identifier %@ does not support path type %@", self.identifier, path.type);
	return nil;
}








// UDP socket
- (void)udpSend:(NSData *)data ip:(NSString *)ip port:(uint16_t)port {
	THLogMethodCall // TODO just for debug, remove later
	
	[udpSocket sendData:data toHost:ip port:port withTimeout:-1 tag:0];
}





- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext {
	THLogMethodCall
	
	NSString* ip;
	uint16_t port;
	[GCDAsyncUdpSocket getHost:&ip port:&port fromAddress:address];
	
	for (THPipe* pipe in self.pipes) {
		// match pipe to source
		if ([pipe.path.ip isEqualToString:ip] && pipe.path.port == port) {
			[pipe recieved:data];
			return;
		}
	}
	
	// TODO pipe doesnt exist, implement new endpoint logic
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didConnectToAddress:(NSData *)address {
	THLogMethodCall
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotConnect:(NSError *)error {
	THLogMethodCall
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
	THLogMethodCall
}


- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
	THLogMethodCall
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error {
	THLogMethodCall
}


// TCP socket

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
	
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
	
}

@end
