//
//  THTransportAssistant.m
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THTransportAssistant.h"
#include "TargetConditionals.h"

#import <ifaddrs.h>
#import <sys/socket.h>
#import <arpa/inet.h>
#import <net/ethernet.h>
#import <net/if_dl.h>
#import <net/if.h>

@implementation THTransportAssistant

- (id)init {
	if (self) {
		self.allTransports = [NSMutableDictionary dictionary];
	}
	
	return self;
}


- (NSArray*)getAllTransports {
	NSMutableArray* transports = [NSMutableArray array];


	// Network adapters

	struct ifaddrs *interfaces = NULL;
	struct ifaddrs *temp_addr = NULL;
	
	int success = 0;

	success = getifaddrs(&interfaces);
	if (success == 0) {
		temp_addr = interfaces;
		while (temp_addr != NULL) {
			NSString* identifier = [NSString stringWithUTF8String:temp_addr->ifa_name];
			THTransportNetworkAdapter* networkAdapter = [self.allTransports objectForKey:identifier];
			
			BOOL isNew = NO;
			if (networkAdapter == NULL) {
				isNew = YES;

				networkAdapter = [[THTransportNetworkAdapter alloc] init];
				networkAdapter.identifier = identifier;
				networkAdapter.name = [NSString stringWithUTF8String:temp_addr->ifa_name];
			}

			
			char tmp[256];
			memset(tmp, 0, sizeof(tmp));
			
			if (temp_addr->ifa_addr->sa_family == AF_INET) {
				inet_ntop(AF_INET, &((struct sockaddr_in*)temp_addr->ifa_addr)->sin_addr, tmp, sizeof(tmp));
				networkAdapter.IPv4Address = [NSString stringWithUTF8String:tmp];
				inet_ntop(AF_INET, &((struct sockaddr_in*)temp_addr->ifa_netmask)->sin_addr, tmp, sizeof(tmp));
				networkAdapter.IPv4Netmask = [NSString stringWithUTF8String:tmp];
			} else if (temp_addr->ifa_addr->sa_family == AF_INET6) {
				inet_ntop(AF_INET6, &((struct sockaddr_in6*)temp_addr->ifa_addr)->sin6_addr, tmp, sizeof(tmp));
				networkAdapter.IPv6Address = [NSString stringWithUTF8String:tmp];
				inet_ntop(AF_INET6, &((struct sockaddr_in6*)temp_addr->ifa_netmask)->sin6_addr, tmp, sizeof(tmp));
				networkAdapter.IPv6Netmask = [NSString stringWithUTF8String:tmp];
			}
			
			if ((temp_addr->ifa_flags & IFF_UP) == IFF_UP) {
				networkAdapter.active = YES;
			}
			
			[self.allTransports setObject:networkAdapter forKey:identifier];
			
			if (isNew) {
				[transports addObject:networkAdapter];
			}

			temp_addr = temp_addr->ifa_next;
		}
	}
	
	freeifaddrs(interfaces);
	
#if TARGET_OS_MAC
	// Can we get any extra info about our interfaces on OSX?
	
	NSArray* osxInterfaces = CFBridgingRelease(SCNetworkInterfaceCopyAll());
	
	NSEnumerator* enumerator = [osxInterfaces objectEnumerator];
	SCNetworkInterfaceRef interface;
	
	while ((interface = CFBridgingRetain([enumerator nextObject]))) {
		NSString* hardwareAddress = CFBridgingRelease(SCNetworkInterfaceGetHardwareAddressString(interface));
		NSString* identifier = CFBridgingRelease(SCNetworkInterfaceGetBSDName(interface));

		if (hardwareAddress != nil && identifier != nil) {
			
			THTransportNetworkAdapter* networkAdapter = [self.allTransports objectForKey:identifier];
			
			if (networkAdapter != NULL) {
				networkAdapter.name = CFBridgingRelease(SCNetworkInterfaceGetLocalizedDisplayName(interface));
				networkAdapter.interfaceType = CFBridgingRelease(SCNetworkInterfaceGetInterfaceType(interface));
				
				int cur, min, max;
				if (SCNetworkInterfaceCopyMTU(interface, &cur, &min, &max)) {
					networkAdapter.MTU = cur;
				}
			
				[self.allTransports setObject:networkAdapter forKey:identifier];
			} else {
				THLogDebugMessage(@"Interface %@ found via SCNetworkInterface but not getifaddrs(), ignoring...", identifier);
			}
		}
	}
	
#endif
	
	// Serial Ports
	
	// Multipeer Connectivity
	
	return [NSArray arrayWithArray:transports];
}
@end
