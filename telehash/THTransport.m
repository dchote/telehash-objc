//
//  THTransport.m
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THTransport.h"
#import "THTransportNetworkAdapter.h"
#import "THTransportSerial.h"
#import "THTransportMultipeerConnectivity.h"

@implementation THTransport

- (id)init {
	if (self) {
		self.MTU = 1500;
	}
	
	return self;
}

- (NSDictionary*)description {
	NSMutableDictionary* description = [NSMutableDictionary dictionary];
	
	[description setObject:[self class] forKey:@"type"];
	[description setObject:self.identifier forKey:@"identifier"];
	[description setObject:self.name forKey:@"name"];
	
	return [NSDictionary dictionaryWithDictionary:description];
}
@end
