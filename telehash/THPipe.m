//
//  THPipe.m
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THPipe.h"
#import "THTransport.h"

@implementation THPipe

- (id)init {
	self = [super init];
	
	self.type = nil;
	self.keepalive = 60;
	self.cloaked = NO;
	
	self.link = nil;
	self.transport = nil;
	
	self.status = THPipeStatusDown;
	
	self.lastInboundActivity = 0;
	self.lastOutboundActivity = 0;
	
	return self;
}

- (NSDictionary *)info {
	NSMutableDictionary* info = [NSMutableDictionary dictionary];
	
	[info setObject:self.path.description forKey:@"path"];
	[info setObject:self.type forKey:@"type"];
	[info setObject:[NSNumber numberWithUnsignedInteger:self.keepalive] forKey:@"keepalive"];
	[info setObject:[NSNumber numberWithBool:self.cloaked] forKey:@"cloaked"];
	
	[info setObject:[NSNumber numberWithInt:self.status] forKey:@"status"];

	[info setObject:[NSNumber numberWithUnsignedInteger:self.lastInboundActivity] forKey:@"lastInboundActivity"];
	[info setObject:[NSNumber numberWithUnsignedInteger:self.lastOutboundActivity] forKey:@"lastOutboundActivity"];
	
	[info setObject:self.transport.info forKey:@"transport"];
	
	return [NSDictionary dictionaryWithDictionary:info];
}


- (void)send:(NSData *)data {
	THLogErrorMessage(@"This method should not be called directly");
}

- (void)recieved:(NSData *)data {
	THLogErrorMessage(@"This method should not be called directly");
}

- (void)close {
	THLogErrorMessage(@"This method should not be called directly");
}

@end
