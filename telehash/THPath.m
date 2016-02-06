//
//  THPath.m
//  telehash
//
//  Created by Daniel Chote on 2/3/16.
//  Copyright © 2016 Daniel Chote. All rights reserved.
//

#import "THPath.h"

@implementation THPath


- (NSDictionary *)info {
	NSMutableDictionary* info = [NSMutableDictionary dictionary];
	
	[info setObject:self.type forKey:@"type"];
	[info setObject:self.ip forKey:@"ip"];
	[info setObject:[NSNumber numberWithUnsignedInteger:self.port] forKey:@"port"];
	
	if (self.url) {
		[info setObject:self.url forKey:@"url"];
	}
	
	return [NSDictionary dictionaryWithDictionary:info];
}

- (NSString *)uriString {
	return [NSString stringWithFormat:@"%@:%@:%d", self.type, self.ip, self.port];
}

- (NSString *)description {
	return self.uriString;
}

@end