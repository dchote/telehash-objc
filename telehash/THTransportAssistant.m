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

NSString* const THTransportStateRefreshRequest = @"THTransportStateRefreshRequest";
NSString* const THTransportStateChangedNotification = @"THTransportStateChangedNotification";

@implementation THTransportAssistant

- (id)init {
	if (self) {
		self.allTransports = [NSMutableDictionary dictionary];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getAllTransports) name:THTransportStateRefreshRequest object:nil];
	}
	
	return self;
}


+ (THHostType)determineHostType:(NSString *)host {
	// strip off any IPv6 wrapping
	host = [[host componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"]["]] componentsJoinedByString:@""];
	
	const char* utf8 = [host UTF8String];
	
	// Check valid IPv4.
	struct in_addr dst;
	int success = inet_pton(AF_INET, utf8, &(dst.s_addr));
	
	if (success == 1) {
		return THHostIPv4Address;
	} else {
		// Check valid IPv6.
		struct in6_addr dst6;
		success = inet_pton(AF_INET6, utf8, &dst6);
		
		if (success == 1) {
			return THHostIPv6Address;
		}
	}
	
	return THHostHostname;
}

- (NSArray *)getAllTransports {
	THLogMethodCall
	
	BOOL suppressNotifications; // only fire notifications when we already know about the transport

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
			
			if (networkAdapter == NULL) {
				suppressNotifications = YES;
				networkAdapter = [[THTransportNetworkAdapter alloc] init];
				networkAdapter.identifier = identifier;
				networkAdapter.name = [NSString stringWithUTF8String:temp_addr->ifa_name];
			} else {
				suppressNotifications = NO;
			}

			
			char tmp[256];
			memset(tmp, 0, sizeof(tmp));
			
			if (temp_addr->ifa_addr->sa_family == AF_INET) {
				
				inet_ntop(AF_INET, &((struct sockaddr_in*)temp_addr->ifa_addr)->sin_addr, tmp, sizeof(tmp));
				NSString* oldIPv4Address = networkAdapter.IPv4Address;
				networkAdapter.IPv4Address = [NSString stringWithUTF8String:tmp];
				
				if (!suppressNotifications && [oldIPv4Address isNotEqualTo:networkAdapter.IPv4Address]) {
					[[NSNotificationCenter defaultCenter] postNotificationName:THTransportStateChangedNotification
																		object:networkAdapter
																	  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"oldIPv4Address", oldIPv4Address, @"IPv4Address", networkAdapter.IPv4Address, nil]];
				}
				
				inet_ntop(AF_INET, &((struct sockaddr_in*)temp_addr->ifa_netmask)->sin_addr, tmp, sizeof(tmp));
				networkAdapter.IPv4Netmask = [NSString stringWithUTF8String:tmp];
				
			} else if (temp_addr->ifa_addr->sa_family == AF_INET6) {
				
				inet_ntop(AF_INET6, &((struct sockaddr_in6*)temp_addr->ifa_addr)->sin6_addr, tmp, sizeof(tmp));
				NSString* oldIPv6Address = networkAdapter.IPv6Address;
				networkAdapter.IPv6Address = [NSString stringWithUTF8String:tmp];
				
				if (!suppressNotifications && [oldIPv6Address isNotEqualTo:networkAdapter.IPv6Address]) {
					[[NSNotificationCenter defaultCenter] postNotificationName:THTransportStateChangedNotification
																		object:networkAdapter
																	  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"oldIPv6Address", oldIPv6Address, @"IPv6Address", networkAdapter.IPv6Address, nil]];
				}
				
				inet_ntop(AF_INET6, &((struct sockaddr_in6*)temp_addr->ifa_netmask)->sin6_addr, tmp, sizeof(tmp));
				networkAdapter.IPv6Netmask = [NSString stringWithUTF8String:tmp];
				
				
			}
			
			
			BOOL wasActive = networkAdapter.active;
			if ((temp_addr->ifa_flags & (IFF_UP|IFF_RUNNING)) != 0 && [networkAdapter hasIPAddress]) {
				networkAdapter.active = YES;
			} else {
				networkAdapter.active = NO;
			}
			
			if (!suppressNotifications && wasActive != networkAdapter.active) {
				[[NSNotificationCenter defaultCenter] postNotificationName:THTransportStateChangedNotification
																	object:networkAdapter
																  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"wasActive", [NSNumber numberWithInt:wasActive], @"active", [NSNumber numberWithInt:networkAdapter.active], nil]];
			}
			
			[self.allTransports setObject:networkAdapter forKey:networkAdapter.identifier];

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
			
				[self.allTransports setObject:networkAdapter forKey:networkAdapter.identifier];
			} else {
				THLogDebugMessage(@"Interface %@ found via SCNetworkInterface but not getifaddrs(), ignoring...", identifier);
			}
		}
	}
	
#endif
	
	// Serial Ports
	// TODO, should I use IOBluetoothRFCOMM specifically for bluetooth, as it has (BluetoothRFCOMMMTU)getMTU
	
	ORSSerialPortManager* serialPortManager = [ORSSerialPortManager sharedSerialPortManager];
	for (ORSSerialPort* port in serialPortManager.availablePorts) {
		THTransportSerial* serialPort = [[THTransportSerial alloc] init];
		serialPort.identifier = port.path;
		serialPort.name = port.name;
		serialPort.MTU = 256;
		[serialPort setSerialPort:port];
		
		[self.allTransports setObject:serialPort forKey:serialPort.identifier];
	}
	
	
	// Multipeer Connectivity
	// TODO - More research needed in to how to structure this
	
	
	return [self.allTransports allValues];
}
@end
