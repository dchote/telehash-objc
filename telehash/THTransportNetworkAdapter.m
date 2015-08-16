//
//  THTransportNetworkAdapter.m
//  telehash
//
//  Created by Daniel Chote on 8/15/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THTransportNetworkAdapter.h"

@implementation THTransportNetworkAdapter

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

@end
