//
//  THPath.m
//  telehash
//
//  Created by Daniel Chote on 2/3/16.
//  Copyright © 2016 Daniel Chote. All rights reserved.
//

#import "THPath.h"
#import "THTransportAssistant.h"

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
	if (self.ip) {
		if ([THTransportAssistant determineHostType:self.ip] == THHostIPv4Address) {
			return [NSString stringWithFormat:@"%@:%@:%d", self.type, self.ip, self.port];
		} else {
			return [NSString stringWithFormat:@"%@:[%@]:%d", self.type, self.ip, self.port];
		}
	}
	return nil;
}

- (NSString *)description {
	return self.uriString;
}

@end