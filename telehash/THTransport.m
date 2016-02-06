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
		self.type = @"unknown";
		self.MTU = 1500;
		self.supportedPathTypes = [NSArray array];
		self.enabledPathTypes = [NSMutableArray array];
	}
	
	return self;
}

- (void)shutdown {
	THLogErrorTHessage(@"class did not implement shutdown method");
}

- (NSString *)addressDescription {
	
	NSString* addressDescription = @"";
	
	for (THPath* path in self.paths) {
		addressDescription = [addressDescription stringByAppendingFormat:@"%@ ", path.description];
	}
	
	return [addressDescription stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSDictionary *)info {
	NSMutableDictionary* info = [NSMutableDictionary dictionary];
	
	[info setObject:[NSNumber numberWithBool:self.active] forKey:@"active"];
	[info setObject:[NSNumber numberWithInt:self.MTU] forKey:@"MTU"];
	[info setObject:self.type forKey:@"type"];
	[info setObject:self.identifier forKey:@"identifier"];
	[info setObject:self.name forKey:@"name"];
	[info setObject:self.addressDescription forKey:@"addressDescription"];
	
	[info setObject:self.paths forKey:@"paths"];
	
	return [NSDictionary dictionaryWithDictionary:info];
}

- (NSArray *)paths {
	THLogErrorTHessage(@"This method should not be called directly");
	return nil;
}

- (THPipe *)pipeFromPath:(THPath *)path {
	THLogErrorTHessage(@"This method should not be called directly");
	return nil;
}

@end
