//
//  THHashname.m
//  telehash
//
//  Created by Daniel Chote on 8/13/15.
//  Copyright (c) 2015 Daniel Chote. All rights reserved.
//

#import "THHashname.h"
#import "CryptoHashAdditions.h"
#import "MF_Base32Additions.h"

@interface THHashname()

@property NSString* hashnameCache;

@end

@implementation THHashname

- (id)init
{
	self = [super init];
	
	self.hashnameCache = nil;
	
	self.secrets = [NSMutableDictionary dictionary];
	self.keys = [NSMutableDictionary dictionary];
	
	return self;
}

- (NSString *)hashname
{
	// DEBUG: router hashname should match: dnnoqfhxvotbwu6hjsjtgbijjuc6heobdiqh32h7i3wk3oh6zkuq
	
	if (!self.hashnameCache) {
		NSMutableData* hashnameRollup = [[NSMutableData alloc] init];
		
		NSArray* sortedKeys = [[self.keys allKeys] sortedArrayUsingSelector: @selector(compare:)];
		for (NSString* key in sortedKeys) {
			// append the CSID and then hash
			unsigned char CSID = [E3X CSIDFromString:key];
			[hashnameRollup appendBytes:&CSID length:sizeof(unsigned char)];
			hashnameRollup = [NSMutableData dataWithData:[hashnameRollup sha256Hash]];
			
			// append the key to the prior hash and then hash
			[hashnameRollup appendData:[self.keys objectForKey:key]];
			hashnameRollup = [NSMutableData dataWithData:[hashnameRollup sha256Hash]];
		}
		
		if (hashnameRollup.length > 0) {
			// we got something, lets cache the base32 string
			self.hashnameCache = [hashnameRollup base32String];
			THLogDebugMessage(@"HASHNAME IS %@", self.hashnameCache);
		}
	}
	
	if (!self.hashnameCache) {
		THLogErrorTHessage(@"hashname rollup failed");
		return @"unknown";
	}
	
	return self.hashnameCache;
}

@end
