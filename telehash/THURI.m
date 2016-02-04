//
//  THURI.m
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THURI.h"

uint16_t const THDefaultPort = 42424;

@implementation THURI

- (id)init
{
	self = [super init];
	
	self.host = nil;
	self.port = THDefaultPort;
	
	self.hashname = nil;
	self.paths = [NSMutableArray array];
	
	return self;
}

+ (THURI *)initWithLinkURI:(NSString *)link
{
	THLogMethodCall
	
	NSURLComponents* URIComponents = [NSURLComponents componentsWithString:link];
	
	THURI* uri = [[THURI alloc] init];
	
	if (![URIComponents.scheme isEqualToString:@"link"]) {
		THLogErrorTHessage(@"non-link uri specified");
		return nil;
	} else {
		uri.host = URIComponents.host;
		uri.port = [URIComponents.port intValue];
		
		for (NSURLQueryItem* item in URIComponents.queryItems) {
			// TODO decode and handle item.values and insert values and build hashname object
		}
	}
	
	return uri;
}

@end
