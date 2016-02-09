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

NSString* const THTransportReachabilityStateChanged = @"THTransportReachabilityStateChanged";




static void reachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void* info) {
	[[NSNotificationCenter defaultCenter] postNotificationName:THTransportReachabilityStateChanged object:nil];
}

@implementation THTransportAssistant {
	SCNetworkReachabilityRef reachabilityRef;
}

- (id)init {
	if (self) {
		self.allTransports = [NSMutableDictionary dictionary];
		self.suppressNotifications = YES;
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTransportState) name:THTransportStateRefreshRequest object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logTransportStateChange:) name:THTransportStateChangedNotification object:nil];
	}
	
	return self;
}

- (void)dealloc {
	if (reachabilityRef) {
		SCNetworkReachabilityUnscheduleFromRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
		CFRelease(reachabilityRef);
	}
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

- (void)refreshTransportState {
	[self getAllTransports];
}

- (NSArray *)getAllTransports {
	THLogMethodCall
	
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
				networkAdapter = [[THTransportNetworkAdapter alloc] init];
				networkAdapter.identifier = identifier;
				networkAdapter.name = [NSString stringWithUTF8String:temp_addr->ifa_name];
			}

			
			char tmp[256];
			memset(tmp, 0, sizeof(tmp));
			
			if (temp_addr->ifa_addr->sa_family == AF_INET) {
				
				inet_ntop(AF_INET, &((struct sockaddr_in*)temp_addr->ifa_addr)->sin_addr, tmp, sizeof(tmp));
				NSString* oldIPv4Address = networkAdapter.IPv4Address;
				networkAdapter.IPv4Address = [NSString stringWithUTF8String:tmp];
				
				if (!self.suppressNotifications && [oldIPv4Address isNotEqualTo:networkAdapter.IPv4Address]) {
					[[NSNotificationCenter defaultCenter] postNotificationName:THTransportStateChangedNotification
																		object:networkAdapter
																	  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"oldIPv4Address", oldIPv4Address, @"IPv4Address", networkAdapter.IPv4Address, nil]];
				}
				
				inet_ntop(AF_INET, &((struct sockaddr_in*)temp_addr->ifa_netmask)->sin_addr, tmp, sizeof(tmp));
				networkAdapter.IPv4Netmask = [NSString stringWithUTF8String:tmp];
				
			} else if (temp_addr->ifa_addr->sa_family == AF_INET6) {
				
				inet_ntop(AF_INET6, &((struct sockaddr_in6*)temp_addr->ifa_addr)->sin6_addr, tmp, sizeof(tmp));
				NSString* oldIPv6Address = networkAdapter.IPv6Address;
				NSString* newIPv6Address = [NSString stringWithUTF8String:tmp];
				
				if (![newIPv6Address containsString:@"fe80"]) { // we dont care about link-local addresses
					networkAdapter.IPv6Address = newIPv6Address;
					
					if (!self.suppressNotifications && [oldIPv6Address isNotEqualTo:networkAdapter.IPv6Address]) {
						[[NSNotificationCenter defaultCenter] postNotificationName:THTransportStateChangedNotification
																			object:networkAdapter
																		  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"oldIPv6Address", oldIPv6Address, @"IPv6Address", networkAdapter.IPv6Address, nil]];
					}
					
					inet_ntop(AF_INET6, &((struct sockaddr_in6*)temp_addr->ifa_netmask)->sin6_addr, tmp, sizeof(tmp));
					networkAdapter.IPv6Netmask = [NSString stringWithUTF8String:tmp];
				}
			}
			
			
			BOOL oldActive = networkAdapter.active;
			if ((temp_addr->ifa_flags & IFF_RUNNING) == IFF_RUNNING && [networkAdapter hasIPAddress]) {
				networkAdapter.active = YES;
			} else {
				networkAdapter.active = NO;
			}
			
			if (!self.suppressNotifications && oldActive != networkAdapter.active) {
				[[NSNotificationCenter defaultCenter] postNotificationName:THTransportStateChangedNotification
																	object:networkAdapter
																  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"oldActive", [NSNumber numberWithInt:oldActive], @"active", [NSNumber numberWithInt:networkAdapter.active], nil]];
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
	// TODO, should I use IOBluetoothRFCOMM? it has (BluetoothRFCOMMMTU)getMTU
	
	ORSSerialPortManager* serialPortManager = [ORSSerialPortManager sharedSerialPortManager];
	for (ORSSerialPort* port in serialPortManager.availablePorts) {
		THTransportSerial* serialPort = [self.allTransports objectForKey:port.path];
		
		if (serialPort == NULL) {
			serialPort = [[THTransportSerial alloc] init];
			serialPort.identifier = port.path;
			serialPort.name = port.name;
			serialPort.MTU = 256;
			
			[self.allTransports setObject:serialPort forKey:serialPort.identifier];
		}
		
		[serialPort setSerialPort:port];
	}
	
	
	// Multipeer Connectivity
	// TODO - More research needed in to how to structure this
	
	
	return [self.allTransports allValues];
}

- (void)setupGlobalReachability {
	THLogMethodCall
	
	// NOTE: we may need to setup reachability on each of the interface IPs as well as the global... Global should be ok, we shall see...
	
	if (reachabilityRef) {
		// already instantiated
		return;
	}
	
	struct sockaddr_in addr = {sizeof(addr), AF_INET, 0, {htonl(INADDR_ANY)}, {0}};
	
	SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&addr);
	
	if (reachability != NULL) {
		reachabilityRef = reachability;
		
		SCNetworkReachabilityContext context = {0, (__bridge void *)(self), NULL, NULL, NULL};
		
		if (SCNetworkReachabilitySetCallback(reachabilityRef, reachabilityCallback, &context)) {
			if (SCNetworkReachabilityScheduleWithRunLoop(reachabilityRef, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode)) {
				THLogInfoMessage(@"reachability callback set and scheduled on runloop");
				
				SCNetworkReachabilityFlags flags;
    
				if (SCNetworkReachabilityGetFlags(reachabilityRef, &flags)) {
					THLogDebugMessage(@"reachability status: %c %c%c%c%c%c%c%c",
						  (flags & kSCNetworkReachabilityFlagsReachable)            ? 'R' : '-',
						  (flags & kSCNetworkReachabilityFlagsTransientConnection)  ? 't' : '-',
						  (flags & kSCNetworkReachabilityFlagsConnectionRequired)   ? 'c' : '-',
						  (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic)  ? 'C' : '-',
						  (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
						  (flags & kSCNetworkReachabilityFlagsConnectionOnDemand)   ? 'D' : '-',
						  (flags & kSCNetworkReachabilityFlagsIsLocalAddress)       ? 'l' : '-',
						  (flags & kSCNetworkReachabilityFlagsIsDirect)             ? 'd' : '-'
						  );
				}
				
				return;
			}
		}
		
	} else {
		CFRelease(reachability);
	}
	
	THLogErrorTHessage(@"unable to setup reachability");
}

- (void)logTransportStateChange:(NSNotification *)aNotification {
	THTransport* transport = (THTransport *)aNotification.object;
	THLogNoticeMessage(@"transport state change for %@ %@", transport.identifier, [aNotification userInfo]);
}

@end