//
//  THEndpoint.m
//  telehash
//
//  Created by Daniel Chote on 8/15/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THEndpoint.h"

@implementation THEndpoint

- (id)init
{
	self = [super init];
	
	self.localHashname = nil;
	self.remoteHashname = nil;
	self.establishedLink = nil;
	self.pipes = [NSMutableArray array];
	
	return self;
}

+ (THEndpoint *)initWithLocalHashname:(THHashname *)localHashname
{
	THLogMethodCall
	
	THEndpoint* endpoint = [[THEndpoint alloc] init];
	endpoint.localHashname = localHashname;
	
	return endpoint;
}

+ (THEndpoint *)endpointFromJSON:(NSData *)json withLocalHashname:(THHashname *)localHashname
{
	THLogMethodCall
	
	THEndpoint* endpoint = [THEndpoint initWithLocalHashname:localHashname];
	
	// TODO JSON parsing logic here
	
	return endpoint;
}

+ (THEndpoint *)endpointFromURI:(NSURL *)uri withLocalHashname:(THHashname *)localHashname
{
	THLogMethodCall
	
	THEndpoint* endpoint = [THEndpoint initWithLocalHashname:localHashname];
	
	// TODO URI parsing logic here
	
	return endpoint;
}

@end
