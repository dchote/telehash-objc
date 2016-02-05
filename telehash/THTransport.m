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

NSInteger const THTransportInitDelay = 1;
NSInteger const THTransportTimeout = 30;

@implementation THTransport

- (id)init {
	if (self) {
		self.active = NO;
		self.MTU = 1500;
		self.addressDescription = @"";
		
		self.supportedPathTypes = [NSArray array];
	}
	
	return self;
}

- (void)shutdown {
	THLogErrorTHessage(@"class did not implement shutdown method");
}

- (NSDictionary *)description {
	NSMutableDictionary* description = [NSMutableDictionary dictionary];
	
	[description setObject:[NSNumber numberWithInt:self.active] forKey:@"active"];
	[description setObject:[NSNumber numberWithInt:self.MTU] forKey:@"MTU"];
	[description setObject:[self class] forKey:@"type"];
	[description setObject:self.identifier forKey:@"identifier"];
	[description setObject:self.name forKey:@"name"];
	[description setObject:self.addressDescription forKey:@"addressDescription"];
	
	return [NSDictionary dictionaryWithDictionary:description];
}

- (THPipe *)pipeFromPath:(THPath *)path
{
	THLogErrorTHessage(@"This method should not be called directly");
	return nil;
}
@end
