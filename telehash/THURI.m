//
//  THURI.m
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THURI.h"

#import "MF_Base32Additions.h"

uint16_t const THDefaultPort = 42424;

@implementation THURI

- (id)init {
	self = [super init];
	
	self.hashname = nil;
	self.paths = [NSMutableArray array];
	
	return self;
}

+ (THURI *)initWithLinkURI:(NSString *)link {
	THLogMethodCall
	
	NSURLComponents* URIComponents = [NSURLComponents componentsWithString:link];
	
	THURI* uri = [[THURI alloc] init];
	uri.hashname = [[THHashname alloc] init];
	
	if (![URIComponents.scheme isEqualToString:@"link"]) {
		THLogErrorTHessage(@"non-link uri specified");
		return nil;
	} else {
		THPath* path = [[THPath alloc] init];
		
		// TODO determine if host is an ipv6 representation
		path.type = @"udp4";
		path.ip = URIComponents.host;
		if (URIComponents.port) {
			path.port = [URIComponents.port intValue];
		} else {
			path.port = THDefaultPort;
		}
		
		// add udp4 to uri paths array
		[uri.paths addObject:path];
		
		
		path = [[THPath alloc] init];
		path.type = @"tcp4";
		path.ip = URIComponents.host;
		if (URIComponents.port) {
			path.port = [URIComponents.port intValue];
		} else {
			path.port = THDefaultPort;
		}
		
		// add tcp4 to uri paths array
		[uri.paths addObject:path];
		
		
		
		// determine query items that are usable
		for (NSURLQueryItem* item in URIComponents.queryItems) {
			if ([item.name containsString:@"cs"]) {
				unsigned char CSID = [E3X CSIDFromString:item.name];
				NSData* keyData = [NSData dataWithBase32String:item.value];
				
				if (CSID != 0x0 && keyData) {
					[uri.hashname.keys setObject:keyData forKey:[E3X CSIDString:CSID]];
				}
			}
			// TODO Path, CSK handling
		}
	}
	
	return uri;
}

@end
