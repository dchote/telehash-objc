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
	uri.hashname = [[THHashname alloc] init];
	
	if (![URIComponents.scheme isEqualToString:@"link"]) {
		THLogErrorTHessage(@"non-link uri specified");
		return nil;
	} else {
		uri.host = URIComponents.host;
		
		if (URIComponents.port) {
			uri.port = [URIComponents.port intValue];
		}
		
		for (NSURLQueryItem* item in URIComponents.queryItems) {
			if ([item.name containsString:@"cs"]) {
				unsigned char CSID = [E3X CSIDFromString:item.name];
				NSData* key = [NSData dataWithBase32String:item.value];
				
				if (CSID != 0x0 && key) {
					[uri.hashname.keys setObject:key forKey:[E3X CSIDString:CSID]];
				}
			}
		}
	}
	
	return uri;
}

@end
